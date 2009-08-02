Return-Path: <linux-kernel-owner+w=401wt.eu-S1752656AbZHBOD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656AbZHBOD1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 10:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752353AbZHBOD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 10:03:27 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:47571 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbZHBOD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 10:03:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=oN3SaDHTtCt5sORUKptOga4AUvmpA7SX+2jqTXt4Femg32U1vYAV1NwAVB6hL9DPrb
         3k/UCm8ivf7fJ9rpVXZ/izh0XxPndE+Iu27mCMXOkvV1dHjzLRiczM6brHtHunVInnnv
         s7Wt50IZcWsuLVMrKNHGQtzpWJo3Pn/hI6O+A=
Message-ID: <4A759CAB.9010002@gmail.com>
Date: Sun, 02 Aug 2009 16:03:23 +0200
From: Artur Skawina <art.08.09@gmail.com>
User-Agent: Thunderbird 2.0.0.22pre (X11/20090422)
MIME-Version: 1.0
To: "Lev A. Melnikovsky" <melnikovsky@mail.ru>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: reading errors on JMicron JM20337 USB-SATA
References: <alpine.LFD.2.00.0908020135100.15267@nev.ubzr>
In-Reply-To: <alpine.LFD.2.00.0908020135100.15267@nev.ubzr>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lev A. Melnikovsky wrote:
> I have read through a year old thread on "JMicron JM20337 USB-SATA data
> corruption bugfix" and it seems here's another aspect of the same
> problem. The SATA disk has genuine errors (bad sectors, just in case: I
> am not going to use it but to recover some data from it). Unfortunately
> when a bad block is read no error is returned, instead a caller is
> blocked indefinitely (until the USB cable is removed). The system log is
> filled with repetitive
> 
> sd 3:0:0:0: [sdf] Sense Key : 0x0 [current]
> sd 3:0:0:0: [sdf] ASC=0x0 ASCQ=0x0

yes, jmicron bridges do not report errors properly and just stall pretty
much indefinitely; found out the hard way, when a disk started to develop
bad blocks. took a bit of time to figure out as there were no i/o errors
reported at all. At least all the patches from back then have been merged
and the kernel can better cope w/ the situation (it used to be a lot worse);
plus modern smartctl will let you see the smart attributes (-d usbjmicron),
making it easier to check if the disk really is failing.

What did work for my case was to copy the data from the disk and every
time the process stalled turn off power to the sata drive for a few seconds
(leaving the bridge connected). The bridge in most cases recovered and a bit
more data got off the drive.

This was what saved that controller, because by the time i realized the
disk went bad, it was not possible to even mount the fs using another sata
controller due to all the i/o errors. With the above process i was able to
recover ~95% of the data.
Summary: Wouldn't want to use the bridge for any kind of unattended data
transfer, it's more of a data recovery device...

artur
