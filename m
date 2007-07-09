Return-Path: <linux-kernel-owner+w=401wt.eu-S1754469AbXGIQUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469AbXGIQUH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 12:20:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753967AbXGIQTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 12:19:55 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:44628 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740AbXGIQTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 12:19:55 -0400
To: pavel@ucw.cz
CC: miklos@szeredi.hu, oliver@neukum.org, paulus@samba.org,
       stern@rowland.harvard.edu, johannes@sipsolutions.net, rjw@sisk.pl,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       mjg59@srcf.ucam.org, benh@kernel.crashing.org
In-reply-to: <20070707233315.GB3820@elf.ucw.cz> (message from Pavel Machek on
	Sun, 8 Jul 2007 01:33:15 +0200)
Subject: Re: malicious filesystems (was Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway)
References: <Pine.LNX.4.44L0.0707041045150.25704-100000@netrider.rowland.org> <18060.14856.824473.325660@cargo.ozlabs.ibm.com> <200707050858.03638.oliver@neukum.org> <E1I6MWb-0008Tq-00@dorka.pomaz.szeredi.hu> <20070705091801.GB3084@elf.ucw.cz> <E1I6NgZ-0000F6-00@dorka.pomaz.szeredi.hu> <20070705115400.GF3984@ucw.cz> <E1I6Q73-0000Xi-00@dorka.pomaz.szeredi.hu> <20070707121729.GC3111@elf.ucw.cz> <E1I7H6v-0006pf-00@dorka.pomaz.szeredi.hu> <20070707233315.GB3820@elf.ucw.cz>
Message-Id: <E1I7vx0-0002Fn-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 09 Jul 2007 18:19:02 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > We can just wait for all fuse requests to be serviced before
> > > proceeding further with freeze, right?
> > 
> > Right.  Nice way to slow down or stop the suspend with an unprivileged
> > process.  Avoiding that sort of DoS is one of the design goals of
> > fuse.
> 
> So you want me to handle _malicious_ filesystems now?
> 
> That should be easy... :-). You already have nasty deadlocks in FUSE,
> and you solve them by "root can echo 1 > abort"... so allow me the
> same possibility.
> 
> We can tell fused we are freezing, and if all the requests are not
> serviced within, say, 30 seconds, we call the filesystem malicious and
> do echo 1 > abort.
> 
> Not ideal, but neither is allowing malicious filesystems in the first
> place...

Actually there's also a non-malicious case in which waiting for
requests to finish won't work: when one fuse filesystem is accessing
another.

Since we are blocking new fuse requests, that might block a fuse
daemon, which in turn makes it impossible to finish the pending
request.

And this is not at all theoretical, I know that encfs is used over
various other fuse filesystems like sshfs or ntfs-3g.

Yeah, stacking userspace filesystems could be done entirely in
userspace, and I'm actually working on that (with fuse-2.7.0 already
supporting some basic stacking).

But the point is, that the "wait for fuse to quiescence" hack would
not work in todays environment.

Miklos
