Return-Path: <linux-kernel-owner+w=401wt.eu-S1756003AbYGDEhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003AbYGDEhu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 00:37:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbYGDEhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 00:37:39 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:34812 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbYGDEhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 00:37:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=D2tL9CKC5R3tiGmVnOBE4rwz4AQOTGMQR9hejTLzg7lBqVuCGJNoEbBdsk+u3gFIzQ
         3kUx88wdu4aoF3rSrwsUH2wMWfM4jSN1qH2+cqTVIDNXklDKyY+HqtKEVsu6e8v9pdnS
         nOGkIuG2i4XCd8ACSP8zOZ+ijABtmB323W74Q=
Message-ID: <486DA8DA.4070601@gmail.com>
Date: Fri, 04 Jul 2008 13:36:42 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: =?ISO-8859-15?Q?Mathieu_B=E9rard?= <Mathieu.Berard@crans.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Jeff Garzik <jeff@garzik.org>
Subject: Re: 2.6.25 to 2.6.26-rc8 regression  (related to ahci and acpi _GTF)
References: <4869FB3C.4060509@crans.org> <200807011614.21491.rjw@sisk.pl> <486AEE29.2010506@gmail.com> <486B4490.7080904@crans.org>
In-Reply-To: <486B4490.7080904@crans.org>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/mixed;
 boundary="------------000206040509040606090109"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000206040509040606090109
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit

Mathieu Bérard wrote:
> Tejun Heo a écrit :
>> Rafael J. Wysocki wrote:
>>   
>>> [Adding CCs.]
>>>
>>> On Tuesday, 1 of July 2008, Mathieu Bérard wrote:
>>>     
>>>> Hi,
>>>> I have a laptop with an ICH6M SATA Controller and a Hitachi hard drive.
>>>> While it worked well using the ahci module and Linux 2.6.25, 
>>>> it get randomly 'stuck' for several seconds to several minutes with 2.6.26-rc8.
>>>> Successive errors progressively reduce the ATA link speed.
>>>>
>>>> Passing the libata.noacpi parameter is an effective workaround.
>>>>
>>>> Please note that it's not the first time i have this kind of issue, see:
>>>> http://marc.info/?l=linux-ide&m=117305595312399&w=2
>>>> This was found to be a bad interaction between my _GTF taskfile, which enable the
>>>> "Enable Device-Initiated Interface Power State Transitions" feature, and NCQ.
>>>> The driver was later NCQ blacklisted to correct the problem.
>>>>       
>> Can you please post the result of "hdparm -I /dev/sda" and full kernel
>> boot log?  0xca is not a NCQ command so the it's not related to NCQ at
>> all.  It seems we'll need to filter out DIPM commands from _GTF.
>>
>>   
> Hi,
> hdparm and dmesg output attached.
> 
> I was not expecting anything related to NCQ as my drive is blacklisted,
> I was just mentioning previous issue with that hardware.
> 
> Do you know what has changed in this version that is now causing failure
> with DIPM ?  I could bisect to try to find out, but this will be painful
> as the
> device hang may only appears after several minutes of disk activity.

Can you please test the attached patch?

-- 
tejun

--------------000206040509040606090109
Content-Type: text/x-patch;
 name="filter-dipm.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="filter-dipm.patch"

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index 3ff8b14..abea74b 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -29,14 +29,16 @@
 enum {
 	ATA_ACPI_FILTER_SETXFER	= 1 << 0,
 	ATA_ACPI_FILTER_LOCK	= 1 << 1,
+	ATA_ACPI_FILTER_DIPM	= 1 << 2,
 
 	ATA_ACPI_FILTER_DEFAULT	= ATA_ACPI_FILTER_SETXFER |
-				  ATA_ACPI_FILTER_LOCK,
+				  ATA_ACPI_FILTER_LOCK |
+				  ATA_ACPI_FILTER_DIPM,
 };
 
 static unsigned int ata_acpi_gtf_filter = ATA_ACPI_FILTER_DEFAULT;
 module_param_named(acpi_gtf_filter, ata_acpi_gtf_filter, int, 0644);
-MODULE_PARM_DESC(acpi_gtf_filter, "filter mask for ACPI _GTF commands, set to filter out (0x1=set xfermode, 0x2=lock/freeze lock)");
+MODULE_PARM_DESC(acpi_gtf_filter, "filter mask for ACPI _GTF commands, set to filter out (0x1=set xfermode, 0x2=lock/freeze lock, 0x4=DIPM)");
 
 #define NO_PORT_MULT		0xffff
 #define SATA_ADR(root, pmp)	(((root) << 16) | (pmp))
@@ -690,6 +692,14 @@ static int ata_acpi_filter_tf(const struct ata_taskfile *tf,
 			return 1;
 	}
 
+	if (ata_acpi_gtf_filter & ATA_ACPI_FILTER_DIPM) {
+		/* inhibit enabling DIPM */
+		if (tf->command == ATA_CMD_SET_FEATURES &&
+		    tf->feature == SETFEATURES_SATA_ENABLE &&
+		    tf->nsect == SATA_DIPM)
+			return 1;
+	}
+
 	return 0;
 }
 

--------------000206040509040606090109--
