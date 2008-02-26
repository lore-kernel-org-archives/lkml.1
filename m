Return-Path: <linux-kernel-owner+w=401wt.eu-S932339AbYBZWYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932339AbYBZWYy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 17:24:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764518AbYBZWXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 17:23:35 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:24013 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762911AbYBZWXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 17:23:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=fNg+N5uwp194hD4Xs0XJpRxDqYra57ZHOfWwZ8/K5OlF8QcZGD6RP1GVAU4Yfs3aSpHeIfWdy8EN9QUa9AWXSxrSDKugSGbyuq39UX8Yt3U58PYiGTO2w3+Xebav5ZbhsLPS5ZDqVOCllIxeCgxEKtDeb4mERNVtMRJ4XCzHUZM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: IDE cdrom problem with PLEXTOR DVDR PX-608AL
Date: Tue, 26 Feb 2008 21:48:21 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Brad Rosser <brad.rosser@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <426a98560802232138q41d45d52ta515f1b791e937f4@mail.gmail.com> <426a98560802260032p61a81811i6b18c5f5b828ce56@mail.gmail.com> <20080226174630.GB5497@gollum.tnic>
In-Reply-To: <20080226174630.GB5497@gollum.tnic>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802262148.23158.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Tuesday 26 February 2008, Borislav Petkov wrote:
> On Tue, Feb 26, 2008 at 06:32:41PM +1000, Brad Rosser wrote:
> Hi Brad,
> 
> > Hello Boris, Bart,
> > 
> > On Tue, Feb 26, 2008 at 12:45 AM, Borislav Petkov
> > <petkovbb@googlemail.com> wrote:
> > >
> > > On Mon, Feb 25, 2008 at 03:57:06PM +1000, Brad Rosser wrote:
> > > >
> > > > ... it would suggest the option 'hda=noprobe' was entered correctly?
> > >
> > >  ok, let's try something else: change the line "#if 0" to "#if 1" at the
> > >  beginning of kernel/params.c, it looks like:
> > >
> > >  #if 0
> > >  #define DEBUGP printk
> > >  #else
> > >  #define DEBUGP(fmt, a...)
> > >  #endif
> > >
> > >  rebuild your kernel, and reboot with it. Then, please send me that boot log to
> > >  see whether the kernel command line is being received from the boot loader and
> > >  what exactly is getting parsed. Thanks.
> > 
> > Boris,  I've done that; the output is in attached file dmesg.debug.out.
> 
> it seems that your boot loader is not supplying the kernel with the boot params
> properly as can be seen from the excerpt below:
> 
> ...
> Kernel command line: BOOT_IMAGE=linux_2.6.25rc2 ro root=900 md=0,/dev/sda5,/dev/sdb5 hda=noprobe
> Parsing ARGS: BOOT_IMAGE=linux_2.6.25rc2 ro root=900 md=0,/dev/sda5,/dev/sdb5 hda=noprobe
> Unknown argument: calling c03670ce
> Unknown argument: calling c03670ce
> Unknown argument: calling c03670ce
> Unknown argument: calling c03670ce
> md: Will configure md0 (super-block) from /dev/sda5,/dev/sdb5, below.
> Unknown argument: calling c03670ce
> ...
> 
> and, as a result, the probing of hda still takes place.
> 
> > It looks to me that the kernel still found the IDE DVD drive (hda) ...
> > in addition
> > to the system messages when the system was up I found the ide_cd_mod
> > module loaded on top of 'cdrom' as normal.
> > 
> > >  Please see whether you can apply the patch Bart just sent and if that still gets
> > >  mangled and cannot be applied, consider making those changes to ide-cd.c by hand
> > >  - after all, there are only several lines that need to be changed so it won't
> > >  take that long.
> > 
> > Bart, I was able to apply that patch file you attached with no problems, and the
> > behaviour of the patched kernel changed as follows:
> > 
> > - no more 'confused' messages, nor the rush of other critical messages
> > that accompanied a system hang on one out of four tests yesterday.
> > 
> > - However, a new message that popped up twice; once after a few seconds
> > of network activity, and then about 15-20 seconds afterwards:
> > 
> > hda: ide_cd_check_ireason: wrong transfer direction!
> > hda: ide_cd_check_ireason: wrong transfer direction!
> 
> Bart, can we assume here that some of the nic interrupts somehow get handled by
> ide-cd or something gets mixed up there?

I'm aware of one potential deficiency with shared PCI IRQs:

disable_irq()+enable_irq() usage in ide_do_request() (can be fixed by not
starting the new request from ide_intr() and instead waiting for block layer
to do it) but it doesn't seem to be related...

Besides ide-cd shouldn't get the control if the device is still BUSY...

[ I find it weird that all previous error messages contained ireason == 0x01
  while "wrong transfer direction" is triggered by ireason == 0x00/0x02 ? ]

> > - also, I'm pretty sure that performance of both network and DVD drive suffered.
> > 
> > As to the last ... my new PC, on which I'm doing all this testing, has a gigabit
> > Realtek NIC.  It's hooked up via null UTP cable to my older machine which has
> > a 100Mb/s card.  ethtool shows that they both auto-negotiate to run at 100Mb/s
> > full duplex.  When I run my network test (pumping through /dev/zero across ssh
> > from the old machine to the new) the network stats tell me that I'm getting
> > 10MB/s out of the link, which is what I would expect.
> > 
> > With the patched 2.6.25-rc2 kernel running with no activity reading the DVD
> > but the network going flat out (on the old PC's end) I noted that I was only
> > getting only 8.0 or 8.1 MB/sec, rather than the 10 MB/sec I've seen in the other
> > tests..  There was no other network traffic or cpu load on the machine(s).

Is there any background process polling DVD drive?  haldeamon?

If so please stop it and see if it helps.

> > Then, when I mounted a DVD disc and did a 'wc /mnt/*' of its contents
> > an iostat showed me that I was getting only about 6MB/sec out of the DVD
> > drive, which is less than I'd expect.  As soon as I killed the network send
> > iostat's report zoomed up to roughly 10MB/sec.  So it seemed to me that,
> > in addition to the 'wrong direction' messages, I was losing some performance
> > on both the NIC and the DVD drive.

Thanks for testing it.  I merged the patch since it is an improvement over the
old behavior and it is easier to look for full fix with it applied.

Bart
