Return-Path: <linux-kernel-owner+w=401wt.eu-S1751878AbYGFEF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878AbYGFEF2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 00:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750710AbYGFEFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 00:05:21 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36338 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696AbYGFEFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 00:05:20 -0400
Date: Sun, 6 Jul 2008 05:05:19 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Frans Pop <elendil@planet.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] parport/ppdev: fix registration of sysctl entries
Message-ID: <20080706040519.GZ28946@ZenIV.linux.org.uk>
References: <20080705131924.GA2083@joi> <20080705235148.GW28946@ZenIV.linux.org.uk> <20080706001148.GX28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080706001148.GX28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 06, 2008 at 01:11:48AM +0100, Al Viro wrote:
> On Sun, Jul 06, 2008 at 12:51:48AM +0100, Al Viro wrote:
> 
> > I don't believe that it's right.  Note that if you *do* race there, you
> > are fucked regardless of sysctls - ppdev.c::register_device() racing
> > with itself will do tons of fun things all by itself (starting with two
> > threads allocating different pdev and both setting pp->pdev).
> > 
> > IOW, *if* that's what we are hitting here, you've only papered over the
> > visible symptom.
> 
> BTW, with your patch you'll have 100% reproducible double registration if
> you do PPCLAIM/PPRELEASE/PPCLAIN on one file descriptor.

FWIW, here's what's going on in ppdev:
	a) we *are* allowed to create several pardevice over the same
port, one per each open().  Each is essentially a parport scheduling
entity.  So far, so good.
	b) creation is actually delayed until an ioclt (PPCLAIM).  That
appears to be a result of shitty API (another ioctl (PPEXCL) instead of
just using O_EXCL at open() time, as any normal driver would).  In any
case, it's badly racy - two tasks doing PPCLAIM on the same struct file
(e.g. one had opened it, then called fork(), then both child and parent
had called ioctl(fd, PPCLAIM, 0)) can race, leading to rather nasty
effects.  Check for delayed registration + register_device() call should
be atomic.  That's solvable by a mutex.
	c) *HOWEVER*, all races aside, we have a genuinely fscked up
API.  Each of these parport scheduling entities has a parameter - timeslice.
That parameter is exposed as sysctl.  And we definitely want these per-open,
not per-port.  And we get everything for the same port mapped to the same
sysctl.

