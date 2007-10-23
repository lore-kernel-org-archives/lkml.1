Return-Path: <linux-kernel-owner+w=401wt.eu-S1755493AbXJWX1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493AbXJWX1w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 19:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753236AbXJWX1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 19:27:44 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:57304 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021AbXJWX1n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 19:27:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=r0FcsDkc1Ik31rQAXS3522CS0x9XAhrFmlyJBwHzVSf4G6MRnu10Qo6CZz1vNLWoHHdrF0ImHcA9Ima1gnPOYG6PBL/ccmDaIPfEUdYWKys9DcCCH53cZaqA2q4cc/NARtsEk+/jyiq5e6TlSF+FSFK+W/stZJ8oT8gnPpXQpzM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: nick@ukfsn.org
Subject: Re: New CD/DVD drive - 80-wire cable detection failure
Date: Wed, 24 Oct 2007 01:33:08 +0200
User-Agent: KMail/1.9.7
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <200710181832.42906.nick@ukfsn.org> <200710201037.31283.nick@ukfsn.org> <200710201322.57178.nick@ukfsn.org>
In-Reply-To: <200710201322.57178.nick@ukfsn.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200710240133.08425.bzolnier@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Saturday 20 October 2007, Nick Warne wrote:
> Hi all,
> 
> SOLVED!
> 
> On Saturday 20 October 2007 10:37:31 Nick Warne wrote:
> > On Friday 19 October 2007 23:28:21 Bartlomiej Zolnierkiewicz wrote:
> > > On Saturday 20 October 2007, Nick Warne wrote:
> > > > On Friday 19 October 2007 22:44:27 Bartlomiej Zolnierkiewicz wrote:
> > > >
> > > > hdparm -I
> > >
> > > It should have been hdparm --Istdout (sorry, once again).
> >
> > hdparm --Istdout /dev/hdd

Thanks, the identify block looks quite "interesting".

85c0 0000 0000 0000 0000 0000 0000 0000
0000 0000 2020 2020 2020 2020 2020 2020
2020 2020 2020 2020 0000 0000 0000 5342
3030 2020 2020 5453 5354 636f 7270 2043
4444 5644 5720 5348 2d53 3230 324a 2020
2020 2020 2020 2020 2020 2020 2020 0000
0000 0b00 0000 0200 0200 0006 0000 0000
0000 0000 0000 0000 0000 0000 0000 0007
0003 0078 0078 017f 0078 0000 0000 0000
0000 00f8 0210 0000 0000 0000 0000 0000
00f8 0210 0210 0000 0000 0000 0000 0000
041f 0000 8005 3200 005b 2000 0000 0000
[...]

word 93 is 0x2000

bit 0x4000 is not set despite the fact that ATA spec (>= ATA-5) requires
it to be set (the device claims ATA/ATAPI-3/4/5/6/7 compatiblity, a bit too
optimistic since it looks like the firmware was based on ATA/ATAPI-4 spec)

bit 0x2000 is set which would indicate that the 80-wires cable is
correctly detected by the device

=> the device/firmware pair is a good candidate for ivb_list[]

There seems to be a new firmware (SB01) for this device:
http://www.samsungodd.com/Lib/popup/Download.asp?path=FW_FWDownload&fname=200710011656260232_SH-S202J_%20SB01.exe

It would be useful to know whether it has the same problem...

> I built a new kernel today 2.6.23.1, and looked very closely at kernel 
> options.
> 
> Setting:
> 
> CONFIG_IDEDMA_IVB
> 
> did the trick!

We want kernel to automatically detect problematic hardware and apply
needed workarounds, _without_ the need for manual user intervention.

[ + CONFIG_IDEDMA_IVB is gone 2.6.24 (but "idex=ata66" is still there) ]

> hdd: TSSTcorp CDDVDW SH-S202J, ATAPI CD/DVD-ROM drive
> hdd: selected mode 0x44
> hdd: ATAPI 48X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache, UDMA(66)
> 
> Thank you all for looking at this non-issue.  Sorry for the noise!!!

Definitely not the noise, quite the contrary (valuable input). :)

Could you try this patch?

[PATCH] ide: add SH-S202J to ivb_list[]

>From the report by Nick Warne.

Cc: Nick Warne <nick@ukfsn.org>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-iops.c |    3 +++
 1 file changed, 3 insertions(+)

Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -582,9 +582,12 @@ EXPORT_SYMBOL_GPL(ide_in_drive_list);
 /*
  * Early UDMA66 devices don't set bit14 to 1, only bit13 is valid.
  * We list them here and depend on the device side cable detection for them.
+ *
+ * Some optical devices with the buggy firmwares have the same problem.
  */
 static const struct drive_list_entry ivb_list[] = {
 	{ "QUANTUM FIREBALLlct10 05"	, "A03.0900"	},
+	{ "TSSTcorp CDDVDW SH-S202J"	, "SB00"	},
 	{ NULL				, NULL		}
 };
 
