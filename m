Return-Path: <linux-kernel-owner+w=401wt.eu-S1755274AbYK1Lnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274AbYK1Lnj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 06:43:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340AbYK1Lna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 06:43:30 -0500
Received: from moutng.kundenserver.de ([212.227.126.177]:52100 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498AbYK1Ln3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 06:43:29 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Keith Packard <keithp@keithp.com>, Alan Cox <alan@redhat.com>
Subject: Re: [PATCH] usb/serial: Add compat_ioctl pass-through
Date: Fri, 28 Nov 2008 12:43:02 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
References: <1227774576-5503-1-git-send-email-keithp@keithp.com> <200811271531.18498.arnd@arndb.de> <1227810424.4277.55.camel@aiko.keithp.com>
In-Reply-To: <1227810424.4277.55.camel@aiko.keithp.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811281243.02841.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/aLD+Ge+Nw9nh59nVvbN8bRoGRLqdeRl0IB27
 8i5ycjEuRTRpoVXy/z7hEtQwYsMgum739Kj0q1rREbvRS4/hlp
 hg3kZpHS2KhqriKNO8bKA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 November 2008, Keith Packard wrote:
> On Thu, 2008-11-27 at 15:31 +0100, Arnd Bergmann wrote:
>
> > You should probably define compat_ioctl to return an int as well
> > so that it becomes possible to use the same function for both eventually.
> 
> The existing tty layer compat_ioctl is defined to return long; is that
> also wrong?

Yes, this was a slight mistake that got introduced when file_operations->
compat_ioctl first appeared with a long return value. It doesn't really
hurt, but new compat_ioctl functions should just return the 'int' that
gets sent back to user space.

> > Then again, we can also drop the file argument, which is entirely unused
> > in all the usb-serial ioctls.
> 
> I'm not sure it's worth the effort; if some future usb serial ioctl
> needs the argument, we'd end up changing every existing driver back. I
> assume there are some serial devices for which the file is relevant
> during ioctl.

I've just checked all tty device drivers. The only one using the file
pointer in ->ioctl, ->tiocmget and ->tiocmset is serial_core, which
passes it to tty_hung_up_p(). That could easily be changed to check
(tty->flags & TTY_HUPPED) AFAICT.

Maybe Alan can comment on this. I think the code would become cleaner
if we dropped the file argument to these three functions throughout
the tty layer, but it's probably not worth the pain to change themm
call.

> > Maybe the best way for now is to make the new compat_ioctl be
> > int compat_ioctl(struct tty_struct, unsigned int cmd, unsigned long arg);
> > and leave the old ioctl as it is. When we get around to pushing the
> > BKL down into ->ioctl, we can change the prototype at the same time
> > to warn potential out-of-tree drivers.
> 
> Let's figure out what the right compat_ioctl interface is first and
> worry about fixing the existing ioctl interface later.

ok.

	Arnd <><
