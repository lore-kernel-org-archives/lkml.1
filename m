Return-Path: <linux-kernel-owner+w=401wt.eu-S1754074AbYHLVy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbYHLVy4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 17:54:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751583AbYHLVyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 17:54:45 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57899 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbYHLVyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 17:54:44 -0400
Date: Tue, 12 Aug 2008 22:54:41 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] readdir mess
Message-ID: <20080812215441.GY28946@ZenIV.linux.org.uk>
References: <20080812062241.GQ28946@ZenIV.linux.org.uk> <87ej4u9nf5.fsf@devron.myhome.or.jp> <alpine.LFD.1.10.0808121009370.3462@nehalem.linux-foundation.org> <87proe81c1.fsf@devron.myhome.or.jp> <alpine.LFD.1.10.0808121303510.3462@nehalem.linux-foundation.org> <20080812205943.GX28946@ZenIV.linux.org.uk> <alpine.LFD.1.10.0808121415390.3462@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0808121415390.3462@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2008 at 02:24:04PM -0700, Linus Torvalds wrote:

> On Tue, 12 Aug 2008, Al Viro wrote:
> > 
> > Um...  Here it would happen only on attempt to return an entry for file
> > that really has an inumber not fitting into the field; what would you
> > do in such case?
> 
> You'd truncate the inode number. What's the big deal? Inode numbers aren't 
> that important - they're just about the _least_ important part of the data 
> returned for a readdir. 

Tell that to tar(1) ;-)
 
> But I also think that we're not in a transition period any more, and as a 
> result the annoyance part is just annoying an doesn't help find and fix 
> problems any more, it just makes legacy binaries not work even if they 
> could otherwise work fine (and _maybe_ have problems).
> 
> So something that made sense five years ago may not make sense any more, 
> is what I'm saying. These days, if somebody runs legacy binaries, they do 
> it because of archeology reasons or similar..

I suspect that SUS specifies that crap in some cases, but I honestly do not
remember.  For large offsets, that is.  Large inode numbers are more recent
and hit relatively few filesystems.  OTOH, I suspect that most of getdents()
call sites are in libc anyway...

Anyway, the point for getdents() is simply that we *do* return an error; it's
just that it ends up with -EINVAL instead of -EOVERFLOW, and that's simply
bogus - we should either truncate silently or return the right value.  The
code definitely intends to do the latter and fucks up.
