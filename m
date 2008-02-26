Return-Path: <linux-kernel-owner+w=401wt.eu-S1764014AbYBZRqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764014AbYBZRqu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 12:46:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762520AbYBZRqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 12:46:39 -0500
Received: from ag-out-0708.google.com ([72.14.246.240]:25149 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762470AbYBZRqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 12:46:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent:from;
        b=Zjs0X7MmwvekOTNbgnLUJVbeBcK7SvMkETXwVCbK7/LCI8HJM/GEnHCuhsWASMZdiRv9Dt6yaFL5arSbbRRaAviJEw+tzCBNLLbhiMqQFjTylJPduSlHUAQhlhe1Kvo/4sWB59nv7n+8tb/X3gpNQdogK85p4u4GGm8hgY5OHuo=
Date: Tue, 26 Feb 2008 18:46:30 +0100
To: Brad Rosser <brad.rosser@gmail.com>
Cc: bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: IDE cdrom problem with PLEXTOR DVDR PX-608AL
Message-ID: <20080226174630.GB5497@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com, Brad Rosser <brad.rosser@gmail.com>,
	bzolnier@gmail.com, linux-ide@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <426a98560802232138q41d45d52ta515f1b791e937f4@mail.gmail.com> <20080224173451.GB11998@gollum.tnic> <426a98560802241758j7a9be21m5eecc120ada804e4@mail.gmail.com> <20080225053404.GA3816@gollum.tnic> <426a98560802242157j61294ba6i2aaa9cce4d836a7b@mail.gmail.com> <20080225144519.GB3816@gollum.tnic> <426a98560802260032p61a81811i6b18c5f5b828ce56@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <426a98560802260032p61a81811i6b18c5f5b828ce56@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 06:32:41PM +1000, Brad Rosser wrote:
Hi Brad,

> Hello Boris, Bart,
> 
> On Tue, Feb 26, 2008 at 12:45 AM, Borislav Petkov
> <petkovbb@googlemail.com> wrote:
> >
> > On Mon, Feb 25, 2008 at 03:57:06PM +1000, Brad Rosser wrote:
> > >
> > > ... it would suggest the option 'hda=noprobe' was entered correctly?
> >
> >  ok, let's try something else: change the line "#if 0" to "#if 1" at the
> >  beginning of kernel/params.c, it looks like:
> >
> >  #if 0
> >  #define DEBUGP printk
> >  #else
> >  #define DEBUGP(fmt, a...)
> >  #endif
> >
> >  rebuild your kernel, and reboot with it. Then, please send me that boot log to
> >  see whether the kernel command line is being received from the boot loader and
> >  what exactly is getting parsed. Thanks.
> 
> Boris,  I've done that; the output is in attached file dmesg.debug.out.

it seems that your boot loader is not supplying the kernel with the boot params
properly as can be seen from the excerpt below:

...
Kernel command line: BOOT_IMAGE=linux_2.6.25rc2 ro root=900 md=0,/dev/sda5,/dev/sdb5 hda=noprobe
Parsing ARGS: BOOT_IMAGE=linux_2.6.25rc2 ro root=900 md=0,/dev/sda5,/dev/sdb5 hda=noprobe
Unknown argument: calling c03670ce
Unknown argument: calling c03670ce
Unknown argument: calling c03670ce
Unknown argument: calling c03670ce
md: Will configure md0 (super-block) from /dev/sda5,/dev/sdb5, below.
Unknown argument: calling c03670ce
...

and, as a result, the probing of hda still takes place.

> It looks to me that the kernel still found the IDE DVD drive (hda) ...
> in addition
> to the system messages when the system was up I found the ide_cd_mod
> module loaded on top of 'cdrom' as normal.
> 
> >  Please see whether you can apply the patch Bart just sent and if that still gets
> >  mangled and cannot be applied, consider making those changes to ide-cd.c by hand
> >  - after all, there are only several lines that need to be changed so it won't
> >  take that long.
> 
> Bart, I was able to apply that patch file you attached with no problems, and the
> behaviour of the patched kernel changed as follows:
> 
> - no more 'confused' messages, nor the rush of other critical messages
> that accompanied a system hang on one out of four tests yesterday.
> 
> - However, a new message that popped up twice; once after a few seconds
> of network activity, and then about 15-20 seconds afterwards:
> 
> hda: ide_cd_check_ireason: wrong transfer direction!
> hda: ide_cd_check_ireason: wrong transfer direction!

Bart, can we assume here that some of the nic interrupts somehow get handled by
ide-cd or something gets mixed up there?

> - also, I'm pretty sure that performance of both network and DVD drive suffered.
> 
> As to the last ... my new PC, on which I'm doing all this testing, has a gigabit
> Realtek NIC.  It's hooked up via null UTP cable to my older machine which has
> a 100Mb/s card.  ethtool shows that they both auto-negotiate to run at 100Mb/s
> full duplex.  When I run my network test (pumping through /dev/zero across ssh
> from the old machine to the new) the network stats tell me that I'm getting
> 10MB/s out of the link, which is what I would expect.
> 
> With the patched 2.6.25-rc2 kernel running with no activity reading the DVD
> but the network going flat out (on the old PC's end) I noted that I was only
> getting only 8.0 or 8.1 MB/sec, rather than the 10 MB/sec I've seen in the other
> tests..  There was no other network traffic or cpu load on the machine(s).
> 
> Then, when I mounted a DVD disc and did a 'wc /mnt/*' of its contents
> an iostat showed me that I was getting only about 6MB/sec out of the DVD
> drive, which is less than I'd expect.  As soon as I killed the network send
> iostat's report zoomed up to roughly 10MB/sec.  So it seemed to me that,
> in addition to the 'wrong direction' messages, I was losing some performance
> on both the NIC and the DVD drive.


-- 
Regards/Gruﬂ,
    Boris.
