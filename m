Return-Path: <linux-kernel-owner+w=401wt.eu-S1752109AbZGBQzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109AbZGBQzs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 12:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751209AbZGBQzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 12:55:39 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45901 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751117AbZGBQzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 12:55:38 -0400
Date: Thu, 2 Jul 2009 17:56:27 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: tridge@samba.org
Cc: Pavel Machek <pavel@ucw.cz>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       john.lanza@linux.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
Message-ID: <20090702175627.580bdebc@lxorguk.ukuu.org.uk>
In-Reply-To: <19020.43585.375900.217202@samba.org>
References: <19013.8005.541836.436991@samba.org>
	<20090630063102.GB1351@ucw.cz>
	<19019.16217.291678.588673@samba.org>
	<20090701123141.402c17d2@lxorguk.ukuu.org.uk>
	<19019.25035.244941.352337@samba.org>
	<20090701143844.07728fdf@lxorguk.ukuu.org.uk>
	<19019.27736.647500.497114@samba.org>
	<20090701154151.7f45abad@lxorguk.ukuu.org.uk>
	<19020.12748.348370.708306@samba.org>
	<20090702113200.39a15f21@lxorguk.ukuu.org.uk>
	<19020.43585.375900.217202@samba.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> but it seems fairly basic to me that if a patch is likely to be in use
> by the majority of Linux users (via distros/vendors) that having it in
> the upstream kernel makes sense. 
> 
> If I'm wrong and a large proportion of distros/vendors won't want this
> patch then of course the argument falls down, and in that case it

It's an open list so they can speak their minds here....

> would seem perfectly reasonable for the upstream kernel not to have
> it, or for it to be inactive by default.

You said yourself that the vendors would prefer to simply remove the code
which means they will carry the "unpatch" anyway.

> Other OSes (eg. Windows) don't tend to distinguish between FAT and
> VFAT. It is just a FAT filesystem with a varying range of features. On
> Linux we've chosen one particular set of features and labelled that
> VFAT, then we've chosen a different set of features and labelled it
> 'MSDOS'. Within what we have labelled as VFAT we have some existing
> runtime options that select different varients. I would have liked to
> do the 'dualnames' patch as a runtime option, but that doesn't satisfy
> the legal requirements.

That I don't believe for one minute providing the dualnames option (or -t
vfat) does not work in the non VFAT case.

That is

CONFIG_VFAT_DUALNAMES = y
	mount -t vfat		works
	mount -o dualnames=1    works
	mount -o tridgefat	works (gives you dualnames = 0)

CONFIG_VFAT_DUALNAMES = n
	mount -t vfat		fails
	mount -t vfat,-o dualnames=0 maybe works
	mount-o tridgefat	works

I can believe that shipping code supporting vfat dualnames and not using
the option at runtime would be a problem IFF the patent is shown to be
valid and software patents are valid in the USA. Thus for the problem
space you are worried about it needs to be compiled out. Given the GPL
says I can ask for the source to match the binaries I'm very very sure
any worried distro would go further and never ship that source either -
its lower risk/lower hassle.

Question for the lawyers: If the option is runtime but the case of
concern cannot be selected (viz support is not even compiled in is that a
problem. If not then -o dualnames= makes life much easier)

I have no problem with the idea of a compile time option for not doing
true VFAT so certain US people can provide it. I don't howeve believe
anyone will use it because they either

a) think it is a problem and have US issues in which case they will
remove the code entirely as that is the lowest risk option and with
little other internal inconvenience

b) they don't think it is a problem (the vast array of non-US
distributions from Ubuntu to Red Flag) and don't select it.

> end users think about the intricacies of what FAT filesystem options
> they want. Most systems just auto-mount removable media these days

That is precisely why it needs to not mount as vfat

> with whatever options the distro vendors choose (or via HAL rules).
> 
> Thus I don't think the "end user expectation" is a strong argument for
> making this an entirely new filesystem.

Its a name not a file system. As simple as

#ifdef CONFIG_FOO
	register vfat
#else
	register lfat
#endif


To my mind we need to be careful of three things

- Harming the kernel to work around a potentially country specific
  unproven problem for the benefit of a few big corporations only
- Getting into situations where big companies behind closed doors make
  unaccountable decisions about a project they do not own
- Setting trends for country specific fixups. There are a lot of
  countries and if we keep the US happy we have to keep China happy and
  so it goes on. Big corporations employ armies of specialists for these
  purposes and make the gain from it. The community doesn't so it should
  no more carry the pain of it than of long term stable releases and
  supporting five year old vendor kernels

So IMHO

	Put dualnames in by all means - but don't pretend it makes any
	difference on the QA front or concerned vendors would set the
	option - they won't, they'll go further.

	Don't make the non dualnames mode "vfat", it's not, and the very
	fact users are casual about assuming vfat/fat/windows compatible
	is why it is so important. (As an analogy most end users don't
	know that a 'CD' is specified by a pile of specs, they don't
	care. But they most definitely care if their CD won't play on
	everything).

And a question: Is there a trivial way to make tridge fat differentiable
from vfat/fat without Windows noticing. That way HAL can preserve the
type settings given a kernel that supports it.

