Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759525AbYLQIyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759525AbYLQIyW (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 03:54:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752572AbYLQIyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 03:54:13 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:34148 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbYLQIyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 03:54:12 -0500
Date: Wed, 17 Dec 2008 09:55:39 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: jdike@addtoit.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] get rid of the last symlink in uml build
Message-ID: <20081217085539.GA4152@uranus.ravnborg.org>
References: <20081217061250.GX28946@ZenIV.linux.org.uk> <20081217072620.GA3551@uranus.ravnborg.org> <20081217083734.GA28946@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081217083734.GA28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 08:37:34AM +0000, Al Viro wrote:
> On Wed, Dec 17, 2008 at 08:26:20AM +0100, Sam Ravnborg wrote:
> > On Wed, Dec 17, 2008 at 06:12:50AM +0000, Al Viro wrote:
> > > 	We need to make asm-offsets.h contents visible for objects built
> > > with userland headers.  Instead of creating a symlink, just have the
> > > file with equivalent include (relative to location of header) created
> > > once.
> > > 
> > > 	That kills the last symlink used in arch/um builds.  Have fun...
> > 
> > great!
> > Soon we have no more symlinks generated for a kernel build.
> > um used to be the worst of all but you have fixed it all up now.
> > 
> > Minor comment below.
> 
> > > -archprepare: $(ARCH_DIR)/include/shared/user_constants.h
> > > -prepare: $(ARCH_DIR)/include/shared/kern_constants.h
> > > +archprepare: $(SHARED_HEADERS)/user_constants.h
> > > +prepare: $(SHARED_HEADERS)/kern_constants.h
> > 
> > arch Makefiles should rely solely on the archprepare target.
> > That cleanup could come later as it is independent from
> > the purpose of this patch.
> 
> Actually, taking both to archprepare would work fine.  kern_constants.h
> used to be generated in very interesting ways before it became a copy
> of asm-offsets.h and that's what lead to this mess.
> 
> These days we can safely take the rudiments out.  Note that asm-offsets.h
> generation doesn't care about that file, be it a symlink or #include "....",
> for obvious reasons and neither does generation of user_constants.h.
> 
> The only remaining constraints are
> 	* asm-offsets.s needs user_constants.h already created.

This is guaranteed by:

    archprepare: $(SHARED_HEADERS)/user_constants.h

as everything dependent on archprepare are completed before we start
building asm-offsets.h


> 	* we want kern_constants.h available during the build itself (i.e.
> at the same kind of places where asm-offsets.h could be used).

This is guaranteed by:

    archprepare: $(SHARED_HEADERS)/kern_constants.h

because we complete all *prepare targets before we start the actual kernel build.

But I guess you already had analysed this and therefore knew this.

> AFAICS, having archprepare depend on user_constants.h and kern_constants.h
> would do just fine.  Note that we don't care how these two are ordered;
> it's asm-offsets.h that can't be created without user_constants.h.

Agreed.

Previously we had some race issues in the arch Makefile when they used
the prepare target and they were workaround in various ways.
This was why we introduced archprepare in the first place IIRC.
And I also recall that um was starnge but this is all cleaned up now - good.

	Sam
