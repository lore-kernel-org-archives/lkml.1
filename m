Return-Path: <linux-kernel-owner+w=401wt.eu-S1758059AbXJHAkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059AbXJHAkA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 20:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752443AbXJHAjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 20:39:54 -0400
Received: from mail8.sea5.speakeasy.net ([69.17.117.10]:60587 "EHLO
	mail8.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbXJHAjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 20:39:53 -0400
Date: Sun, 7 Oct 2007 17:39:52 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell4.speakeasy.net
To: Ingo Molnar <mingo@elte.hu>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       Linux Kernel Mailing list <linux-kernel@vger.kernel.org>,
       Linux and Kernel Video <video4linux-list@redhat.com>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: .23-rc9, V4L, make randconfig build failure
In-Reply-To: <20071006095635.GA2066@elte.hu>
Message-ID: <Pine.LNX.4.58.0710071650310.2362@shell4.speakeasy.net>
References: <20071006095635.GA2066@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Oct 2007, Ingo Molnar wrote:
> FYI, just found this V4L build failure in -rc9:
>
>  drivers/built-in.o: In function `saa7146_unregister_device':
>  : undefined reference to `video_unregister_device'
>  drivers/built-in.o: In function `saa7146_register_device':
>  : undefined reference to `video_device_alloc'
>  drivers/built-in.o: In function `saa7146_register_device':
>  : undefined reference to `video_device_release'
>  [ ... etc ... ]
>
> this is caused by the attached config:
>
>   CONFIG_VIDEO_BUF=m
>   CONFIG_VIDEO_BUF_DVB=m

video_unregister_device, etc.  are from CONFIG_VIDEO_DEV, not
COFIG_VIDEO_BUF.  VIDEO_SAA7146_VV does need VIDEO_BUF, but that's not
what's causing the undefined references above.  I do not think
VIDEO_BUF_DVB is needed by VIDEO_SAA7146 or VIDEO_SAA7146_VV, but some
others drivers which use saa7146 do need it.

> combined with:
>
>   CONFIG_VIDEO_SAA7146=y
>   CONFIG_VIDEO_SAA7146_VV=y
>
> so it seems like a drivers/video/Kconfig bug - this combination should
> not be possible.

The config has these two settings:

CONFIG_VIDEO_SAA7146_VV=y
CONFIG_VIDEO_DEV=m

VIDEO_SAA7146_VV _does_ depend on VIDEO_DEV.  The Kconfig file does not
allow for this setting, yet your config has it.  The reason is because some
other drivers select VIDEO_SAA7146_VV.

I think the fundamental problem here is the way Kconfig handles "select"
operations.  If one turns on an option that selects another, then the
selected option will always be turned on, even if *its dependencies are not
satisfied*.

That is what has happened here.  Something has selected VIDEO_SAA7146_VV=y,
when its dependency on VIDEO_DEV should not allow it.

IMHO, the real solution here is that Kconfig should recursively follow
select operations either up or down the stack.

One way to do it, would be if FOO selects BAR, then FOO also selects
everything that BAR depends on.

Another way, would be that if FOO selects BAR, then FOO also depends on
everything BAR depends on.

It appears the way this is handled now, is to do the second method manually
in the Kconfig file.  In this case, anything which selects VIDEO_SAA7146_VV
needs to depend on VIDEO_DEV and anything else VIDEO_SAA7146_VV depends on.

Now, most of the things that select VIDEO_SAA7146_VV try to do this, but it
doesn't work because of another issue "tristate to bool promotion", which
has caused problems before:  http://lkml.org/lkml/2007/6/23/244

config DVB_AV7110
	tristate
	depends on VIDEO_V4L1
	select VIDEO_SAA7146_VV

config VIDEO_V4L1
	bool
	depends on VIDEO_DEV

config VIDEO_DEV
	tristate

In this case AV7110 depends on V4L1, which depends on VIDEO_DEV.  So AV7110
should recursively gain a dependency on VIDEO_DEV.  But because V4L1 is a
bool, it's possible to set VIDEO_DEV=m and VIDEO_V4L1=y, which then allows
DVB_AV7110=y.  So now we have DVB_AV7110=y and VIDEO_DEV=m, which shouldn't
be allowed.

I wonder if an easy solution to this, would be to allow bools to take the
value of 1 aka 'm'?
