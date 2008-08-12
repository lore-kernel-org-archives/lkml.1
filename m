Return-Path: <linux-kernel-owner+w=401wt.eu-S1753618AbYHLU74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618AbYHLU74 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 16:59:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbYHLU7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 16:59:47 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39609 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbYHLU7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 16:59:46 -0400
Date: Tue, 12 Aug 2008 21:59:43 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] readdir mess
Message-ID: <20080812205943.GX28946@ZenIV.linux.org.uk>
References: <20080812062241.GQ28946@ZenIV.linux.org.uk> <87ej4u9nf5.fsf@devron.myhome.or.jp> <alpine.LFD.1.10.0808121009370.3462@nehalem.linux-foundation.org> <87proe81c1.fsf@devron.myhome.or.jp> <alpine.LFD.1.10.0808121303510.3462@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0808121303510.3462@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2008 at 01:05:43PM -0700, Linus Torvalds wrote:
> 
> 
> On Wed, 13 Aug 2008, OGAWA Hirofumi wrote:
> > 
> > However, there are some similar stuff: ->st_size, ->st_nlink and
> > ->st_ino in stat() (cp_old_stat()). Maybe EOVERFLOW is the reason for
> > consistency...
> 
> .. I actually had an old binary that triggered that case (actually, it was 
> O_LARGEFILE in open()), and didn't work as a result. I only needed to run 
> it once, so I literally hacked up a once-time-use kernel that just removed 
> the EOVERFLOW in open.
> 
> So no, I'm not a fan of EOVERFLOW at all. Not in readdir(), not really 
> anywhere else. 

Um...  Here it would happen only on attempt to return an entry for file
that really has an inumber not fitting into the field; what would you
do in such case?  open() on a huge file is a different story, since you
would get a valid opened file and that'd be it; the logics in case of
open() is, IIRC, "I guess your binary is old, so it'll probably do other
things that would really have to trigger -EOVERFLOW; better bail out right
now".  In this case, though, you either generate an error or get wrong
values silently stored in userland struct (wrapped around inumber).
