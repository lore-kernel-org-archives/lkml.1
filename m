Return-Path: <linux-kernel-owner+w=401wt.eu-S1755889AbYGPAwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889AbYGPAwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 20:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753085AbYGPAwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 20:52:00 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:49843 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751921AbYGPAwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 20:52:00 -0400
Date: Tue, 15 Jul 2008 20:51:33 -0400
From: Theodore Tso <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: david@lang.hm, Marcel Holtmann <marcel@holtmann.org>,
       David Woodhouse <dwmw2@infradead.org>, Frans Pop <elendil@planet.nl>,
       jeff@garzik.org, arjan@infradead.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
	in-kernel, use it in more drivers.
Message-ID: <20080716005133.GK8185@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>, david@lang.hm,
	Marcel Holtmann <marcel@holtmann.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Frans Pop <elendil@planet.nl>, jeff@garzik.org, arjan@infradead.org,
	akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
	linux-kernel@vger.kernel.org
References: <1216149637.27242.65.camel@violet.holtmann.net> <alpine.LFD.1.10.0807151223290.3351@woody.linux-foundation.org> <1216150616.27455.377.camel@shinybook.infradead.org> <alpine.LFD.1.10.0807151244320.3351@woody.linux-foundation.org> <1216151640.27242.90.camel@violet.holtmann.net> <alpine.LFD.1.10.0807151301130.2867@woody.linux-foundation.org> <alpine.DEB.1.10.0807151426021.16109@asgard.lang.hm> <alpine.LFD.1.10.0807151436400.2867@woody.linux-foundation.org> <alpine.DEB.1.10.0807151503310.16109@asgard.lang.hm> <alpine.LFD.1.10.0807151631260.2867@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807151631260.2867@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 04:42:52PM -0700, Linus Torvalds wrote:
> On Tue, 15 Jul 2008, david@lang.hm wrote:
> >
> > becouse the tools that wrote the initrd already put the modules in. I don't
> > maintain those tools, they came with the distro. we're just asking to not
> > require those tools to be updated immediatly.
> 
> But mkinitrd (which is the _only_ thing that people tend to use to write 
> initrd's - is there even anything else) has already been doing this for 
> years, as has been pointed out several times.

Actually, there is also mkinitramfs (which is what Debian and Ubuntu
use), and Yaird (Yet Another mkinitrd).  Also, the distro's tend to
heavily customize mkinitrd in general, so there is no guarantee that
just because two distro's use some tool that happens to be named
mkinitrd that the two tools have much in common with each other....

This is highly unfortunate, and I've often argued that we probably
would have been better off if we had included an mkinitrd tool as part
of the kernel sources to make life easier instead of having every
single distro do their own thing; it would also make it easier to run
a newer kernel on an older enterprise distro --- I remember the pain
trying to make a 2.6.16 kernel boot on a RHEL4 base system two years
ago; I don't want to even think about what would happen with something
more modern at this point.

> If it's literally just an issue of an mkinitrd that is too damn old, why 
> don't we just make that test at kernel build time. *EXACTLY* the same way 
> we test for compilers that are too old, and refuse to build with them?

For one reason, because there's more than one mkinitrd.  FC9 ships
with mkinitrd 6.0.52; OpenSuSE ships with mkinitrd 2.1, and the
sources don't look even vaguely similar to one another.  For example,
Red Hat's mkinitrd uses nash, which is a maddingly useless shell that
made it near-impossible to debug why a 2.6.16 kernel wasn't booting on
a RHEL-4 system on a LS-21 blade.  OpenSuSE's mkinitrd ships with
bash, and Debian/Ubuntu will give you a busybox shell, which makes
life *much* easier to debug when you're trying to figure out why your
latest bleeding edge kernel isn't able to mount the root partition out
of initrd.

						- Ted

P.S.  For bonus points, it would be nice if initrd's included fsck,
since it then it would be possible to safely fsck the root partition
and not require a reboot if the root partition was modified.  But
given that every single distro seems to ship their own initrd, not to
mention their own init scripts, it's hard to try to push for this sort
of change.  The amount of distro-specific engineering work probably
makes it not worth it.
