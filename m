Return-Path: <linux-kernel-owner+w=401wt.eu-S933042AbXBLGoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933042AbXBLGoz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 01:44:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933044AbXBLGoz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 01:44:55 -0500
Received: from wx-out-0506.google.com ([66.249.82.233]:58702 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933042AbXBLGoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 01:44:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type;
        b=RRlfEhM6brC+ej6HaTkceNcKjqp4l0NaSzpDmaVzyHP63cgk3+TPdLjxPT6axKLlU2NfeG9+LBouahlV7UX5TIb85ywfxxCKt6MQoCQzFNRLvg20/dEEznIosfMjR/KDJhuihaDGpTxsWaek42QJuAfS0duZtJFZp1OLe6/ox1A=
Message-ID: <45CFBA90.4090201@gmail.com>
Date: Sun, 11 Feb 2007 16:53:36 -0800
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: rol@as2917.net
CC: "'Alan'" <alan@lxorguk.ukuu.org.uk>, "'Robert Hancock'" <hancockr@shaw.ca>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
Subject: Re: AHCI - remove probing of ata2
References: <010a01c74dc5$d41af120$2101a8c0@donald>
In-Reply-To: <010a01c74dc5$d41af120$2101a8c0@donald>
Content-Type: multipart/mixed;
 boundary="------------090601050209040705090301"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090601050209040705090301
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello, Paul.

Paul Rolland wrote:
>>> This looks like the problems that hopefully the patches 
>> from Tejun and
>>> from Mark Lord cured (the delay after reset and the task file clear)
>> Any chance I can find this patch(es) and try them ?
>>  
>>>> Also, I've seen a :
>>>>
>>>> ata1: Spurious SDB FIS during NCQ issue=0x0 SAct=0x7ff8001f
>>>> FIS=004040a1:00040000
>>>>
>>>> What's this ? Is it really bad or just a warning ???
>>> It's one Tejun stuck logging in for in order to investigate further.
>> OK, will wait a little bit ;)

You have a Maxtor connected to that port, right?  That's caused by 
firmware bug.  Future kernels will consider that condition as protocol 
violation and blacklist the drive such that NCQ is not used on it.  I 
think it can be dangerous on rare corner/error cases but there hasn't 
been any actual report of problems caused by that, so no need to worry 
about it too much.  If it bothers you, you can turn NCQ off using sysfs 
node.  Take a look at FAQ section of http://linux-ata.org

> In the meantime, I've been trying 2.6.20-rc7.
> Things are not better, except that the ata2 probing failing results in
> no /dev/sdd being allocated, thus it changes all the naming afterwards.

Slightly OT, but it's generally a good idea to use LABELs to access 
filesystems.  With so many ports and EH dynamics including hotplug, it's 
much more difficult to keep device names persistent and remember them.

> So, 2.6.20-rc7 results are :
>  - ata2 probing still very long and delaying boot a lot,

That's sil4726's config device acting weird.  When reset as a normal 
device (not PMP device), sil4726 acts as a normal ATA device which is 
used to configure how the chip behaves.  Unfortunately, the emulation 
seems to contain some flaws and cause lots of delays as you've seen. 
I'm attaching a patch to clear TF before IDENTIFY which fixes similar 
IDENTIFY failures on buggy ATAPI devices.

>  - Jmicron PATA still not working, and doesn't even detect the DVD-ROM on
>    the port.

This problem is likely to be fixed by clearing TF before IDENTIFY.

So, please test the attached patch and report the result.

-- 
tejun

--------------090601050209040705090301
Content-Type: text/x-patch;
 name="clear-TF-before-IDENTIFY.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="clear-TF-before-IDENTIFY.patch"

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 667acd2..d6fcf0a 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1478,7 +1478,16 @@ int ata_dev_read_id(struct ata_device *dev, unsigned int *p_class,
 	}
 
 	tf.protocol = ATA_PROT_PIO;
-	tf.flags |= ATA_TFLAG_POLLING; /* for polling presence detection */
+
+	/* Some devices choke if TF registers contain garbage.  Make
+	 * sure those are properly initialized.
+	 */
+	tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
+
+	/* Device presence detection is unreliable on some
+	 * controllers.  Always poll IDENTIFY if available.
+	 */
+	tf.flags |= ATA_TFLAG_POLLING;
 
 	err_mask = ata_exec_internal(dev, &tf, NULL, DMA_FROM_DEVICE,
 				     id, sizeof(id[0]) * ATA_ID_WORDS);

--------------090601050209040705090301--

