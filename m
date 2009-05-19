Return-Path: <linux-kernel-owner+w=401wt.eu-S1754622AbZEST0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbZEST0c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 15:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753573AbZEST0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 15:26:24 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:59854 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226AbZEST0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 15:26:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=BgzUVpg2z+0nHk0MniK6BwoeAQVgmwjXwtGMlDhf4Knq3Jge/4kVaA9xDLhMnfjvks
         XT2QLeV8SWHm+yIdQ+oG2YteR3fwVFmg2WBYXIfYWDWhi3lu6UkH0RxliBptcfgbjeoX
         m8ACR/7sjM+Spjdsek2Hj2t1v8hKi4Mx/o+0c=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Martin Lottermoser <Martin.Lottermoser@t-online.de>
Subject: Re: PATA DMA problem leading to kernel panic on reading movie DVDs
Date: Tue, 19 May 2009 21:30:59 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-next-20090518-05332-g0707b5a; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <20090517091224.GA8280@wanza.invalid> <200905191719.35543.bzolnier@gmail.com> <20090519182928.GA8172@wanza.invalid>
In-Reply-To: <20090519182928.GA8172@wanza.invalid>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200905192131.00168.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 May 2009 20:29:28 Martin Lottermoser wrote:
> Hello,
> 
> On Tue, May 19, 2009 at 05:19:35PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > Subject: [PATCH] ide: fix 40-wire cable detection for TSST SH-S202* ATAPI devices
> 
> I'm sorry, but that also generated a panic, looking identical to the
> behaviour as for the unpatched 2.6.30-rc6.
> 
> After booting the patched kernel, the syslog file showed:
> 
>   hdc: UDMA/66 mode selected
> 
> "hdparm -I" reported that the drive was set to "udma4". On accessing the DVD,
> the kernel panicked. Here's the main output from netconsole:
> 
>   hdc: cdrom_decode_status: error=0x40 <3>{ LastFailedSense=0x04 }
>   ide: failed opcode was: unknown
>   hdc: DMA disabled
>   ------------[ cut here ]------------
>   kernel BUG at drivers/ide/ide-io.c:872!
>   invalid opcode: 0000 [#1]
>   last sysfs file: /sys/devices/pci0000:00/0000:00:1f.1/ide1/1.0/block/hdc/size
> 
> After booting the kernel and before doing the test I had checked with
> "uname -a" that this really was the newly compiled kernel. After reboot I
> checked that ide-iops.o existed and had a modification time later than the
> moment I applied your patch. Also, the new vmlinuz is 64 bytes shorter than
> the unpatched one. Therefore I don't think I made some silly mistake which
> led to the patch being ignored.

You didn't.  I did.

Incremental patch fixing it:

diff -u b/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
--- b/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -255,7 +255,7 @@
 	if (ivb) {
 		const char *model = (char *)&id[ATA_ID_PROD];
 
-		if (strcmp("TSSTcorp CDDVDW SH-S202", model) == 0) {
+		if (strstr("TSSTcorp CDDVDW SH-S202", model)) {
 			/*
 			 * These ATAPI devices always report 80c cable
 			 * so we have to depend on the host in this case.


> The offer for testing patches remains open :-).

We will get there. ;-)

I've reproduced the problem and I'm testing the fix currently...

Thanks,
Bart
