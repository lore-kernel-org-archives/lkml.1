Return-Path: <linux-kernel-owner+w=401wt.eu-S1753731AbYI3ISQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731AbYI3ISQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 04:18:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbYI3IR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 04:17:59 -0400
Received: from el-out-1112.google.com ([209.85.162.180]:39280 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbYI3IR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 04:17:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=s+wvy5Cwqi4nZmchHNKK6xmY6WL90yFjm2GBdQzinGEeSEXaNkpnqtRM0OhLj2VSAS
         cGSR2SJLIWLCLiPvrx73EtTLgMx4ZHSj0xhKpbREQuUzqwvod3IVRFr1d0Uy7aWYeegk
         1ea+A+L3I8hajhwPBhjZxMk0+HXMK2j0jq9Ns=
Message-ID: <806dafc20809300117u2806e37bx986b54543862f358@mail.gmail.com>
Date: Tue, 30 Sep 2008 04:17:53 -0400
From: "Monty Montgomery" <monty@xiph.org>
To: "Geert Uytterhoeven" <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [regression] CD-DA delay needed after insertion (http://bugzilla.kernel.org/show_bug.cgi?id=10974)
Cc: "James Bottomley" <James.Bottomley@hansenpartnership.com>,
       linux-scsi@vger.kernel.org,
       "Linux Kernel Development" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0809171701330.21347@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0806131352360.2141@vixen.sonytel.be>
	 <1213540781.3517.18.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0806161659440.30122@vixen.sonytel.be>
	 <1213648258.3420.12.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0806171530340.22840@vixen.sonytel.be>
	 <1214605634.3394.91.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0806301120570.10868@vixen.sonytel.be>
	 <1214841102.3381.5.camel@localhost.localdomain>
	 <1214925487.3316.12.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0809171701330.21347@vixen.sonytel.be>
X-Google-Sender-Auth: 09ebca43de31881a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2008 at 11:05 AM, Geert Uytterhoeven
<Geert.Uytterhoeven@sonycom.com> wrote:

>> The problem is I don't think the new behaviour is a regression.
>> cdparanoia requested O_NONBLOCK ... it's a bit counter to this if we
>> wait for the drive to become ready.

O_NONBLOCK has nothing to do with the drive being ready.  It means not
to wait to open a device locked or in use exclusively by another
process. It does not affect command processing (at least not the way
cdparanoia is doing it).  If a drive isn't ready, it returns a sense
key of 'not ready' and the SGIO layer doesn't filter that in any way.
SGIO itself never waits or takes any special action on 'not ready', it
merely passes through the comand termination status.

Note that 'not ready' is not the same as 'no medium'.  One means the
drive is digesting a new disc, the other means there is no dics (or
the tray is open).  Some drives do in fact return 'empty' until a new
disc is completely loaded after tray close.  These drives are in
violation of spec (but the alternative is to ignore the empty status
and retry forever, which means there's no recovering from ejecting a
disc mid-operation, which was also reported as a bug).  On the other
hand, I've never come across any ATAPI drive that 100% faithfully
implements the command spec.  All vendors take *substantial*
liberties.

> I confirmed (using strace) that my cdparanoia also opens /dev/scd0 with
> O_NONBLOCK.
>
> After applying the patch below to cdparanoia, the problem goes away.
>
> --- cdparanoia-3.10.0+debian/interface/scan_devices.c.orig      2008-05-16 06:25:24.000000000 +0200
> +++ cdparanoia-3.10.0+debian/interface/scan_devices.c   2008-09-17 16:36:14.000000000 +0200
> @@ -608,7 +608,7 @@
>
>   if(specialized_device) {
>     if(use_sgio)
> -      i_fd=open(specialized_device,O_RDWR|O_NONBLOCK);
> +      i_fd=open(specialized_device,O_RDONLY);

This change means you can only run one cdparanoia per computer as the
device autoscan code will now block on an in-use drive.
Also, you're a few releases behind.  10.0 was misreporting drive
status due to a stupid bug; god only knows what happened in SGIO as
the error code never got passed up.  10.2 corrects the problem (as
well as a few other major bugs).  Current SVN will be 10.3 in a few
more days.

If the same thing is still happening with 10.2 and the same patch
still fixes it, then I definitely have some head scratching [and
kernel perusal] to do.

Also, the SCSI and block layers tend to not be entirely in sync
behaviorwise despite exposing what appears to be a uniform SGIO
interface (it's actually two completely seperate interfaces that try
to look identical).  I'd not rule out kernel bugs, it wouldn't be the
first (or only the tenth) that cdparanoia has exposed :-(

>     else
>       i_fd=open(specialized_device,O_RDONLY|O_NONBLOCK);
>   }
>
> Note that I had to change `O_RDWR' to `O_RDONLY', else you get the error -EROFS
> (read only file system) when opening /dev/scd0 (music CDs are read-only).

It has nothing to do with the CD being read only.  Device permissions
are overloaded in SGIO to act as a two-tier permissions filter to
seperate  'harmless' and 'potentially harmful' commands. You have to
have write permission on the device to do things like MODE SET, which
some drives require (eg, Plextor) or to use the short-DMA detection
hack to cover for low-level device drivers that don't bother to
implement the residue flag.  You can blame Jens for this one.

Monty
