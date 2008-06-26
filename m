Return-Path: <linux-kernel-owner+w=401wt.eu-S1756246AbYFZWe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246AbYFZWe4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 18:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752897AbYFZWep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 18:34:45 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:59321 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbYFZWen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 18:34:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@seznam.cz
Subject: Re: [PATCH 58/60] microblaze_v4: sys_microblaze.c
Date: Fri, 27 Jun 2008 00:34:23 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, linuxppc-dev@ozlabs.org,
       vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk, hpa@zytor.com,
       Michal Simek <monstr@monstr.eu>
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz> <200806261748.30698.arnd@arndb.de> <4863E8F2.5080608@seznam.cz>
In-Reply-To: <4863E8F2.5080608@seznam.cz>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806270034.24455.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/aVnhQNosrqsWqZHGBiEdVef8VH2+xmt7Eghy
 Jx2p1VZjoLwas6doKEksFZ1GOfCY+WTb3DO2o1XH4JoiSSXw6L
 7HsTujqUJXkOZ/OiVgdSw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 June 2008, Michal Simek wrote:
> 
> >> +
> >> +/*
> >> + * sys_ipc() is the de-multiplexer for the SysV IPC calls..
> >> + *
> >> + * This is really horribly ugly.
> >> + */
> > 
> > If it's so horribly ugly, don't do it this way ;-)
> 
> :-) this is not my part of code. I'll remove it with syscall changes.

Yes, I was aware of that. I believe the comment was initially done in
order to prevent people from copying it to new architectures, but it
never worked.

> >> +int
> >> +sys_ipc(uint call, int first, int second, int third, void *ptr, long fifth)
> >> +{
> >> +	int version, ret;
> >> +
> >> +	version = call >> 16; /* hack for backward compatibility */
> >> +	call &= 0xffff;
> > 
> > Backwards compatibility with what?
> 
> I don't know.
> John: I suppose this is your comment.

No, it was a trick question, this is also copied from i386. It was meant
for the iBCS2 compatibility layer that provides support for running
Unix binaries from the late 80s, but never quite made it into the Linux
kernel.

> >> +unsigned long sys_mmap2(unsigned long addr, size_t len,
> >> +			unsigned long prot, unsigned long flags,
> >> +			unsigned long fd, unsigned long pgoff)
> >> +{
> >> +	return do_mmap2(addr, len, prot, flags, fd, pgoff);
> >> +}
> >> +
> >> +unsigned long sys_mmap(unsigned long addr, size_t len,
> >> +			unsigned long prot, unsigned long flags,
> >> +			unsigned long fd, off_t offset)
> >> +{
> >> +	int err = -EINVAL;
> >> +
> >> +	if (offset & ~PAGE_MASK) {
> >> +		printk(KERN_INFO "no pagemask in mmap\r\n");
> >> +		goto out;
> >> +	}
> >> +
> >> +	err = do_mmap2(addr, len, prot, flags, fd, offset >> PAGE_SHIFT);
> >> +out:
> >> +	return err;
> >> +}
> > 
> > Which mmap is uClibc really using? I suppose you only need mmap2, even for
> > compatibility with any binary ever built for microblaze.
> 
> I don't know. Microblaze should be compiled with uClibc and glibc. In case you
> need mmap2 for uClibc and mmap for glibc it is ok.

I looked at uClibc again and found that you probably need both for compatibility
and functionality, same as for other calls that can take either an off_t or
a loff_t. Only if you changed the libc/sysdeps/linux/microblaze/mmap.c code,
you could get rid of sys_mmap(). I don't think you need to worry about glibc
at this point, because as I understand it the old port is broken anyway
and it's easier to do a new microblaze glibc port from scratch than trying
to update it to the latest glibc version...

	Arnd <><
