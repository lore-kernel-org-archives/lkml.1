Return-Path: <linux-kernel-owner+w=401wt.eu-S1755915AbZLINhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915AbZLINhq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 08:37:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755880AbZLINhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 08:37:45 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44861 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755878AbZLINho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 08:37:44 -0500
Subject: Re: [RFC][PATCHSET] mremap/mmap mess
From: Peter Zijlstra <peterz@infradead.org>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, David Miller <davem@davemloft.net>,
       Ollie Wild <aaw@google.com>, Rik van Riel <riel@redhat.com>,
       viro@ftp.linux.org.uk, linux-arch@vger.kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0912091242010.26035@sister.anvils>
References: <20091208060701.GM14381@ZenIV.linux.org.uk>
	 <Pine.LNX.4.64.0912081142280.31223@sister.anvils>
	 <Pine.LNX.4.64.0912081254500.3365@sister.anvils>
	 <20091208.130802.25121122.davem@davemloft.net>
	 <20091208220638.GN14381@ZenIV.linux.org.uk>
	 <Pine.LNX.4.64.0912091041250.23659@sister.anvils>
	 <1260361302.5489.372.camel@laptop>
	 <Pine.LNX.4.64.0912091242010.26035@sister.anvils>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Dec 2009 14:37:42 +0100
Message-ID: <1260365863.5489.540.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-09 at 13:12 +0000, Hugh Dickins wrote:
> On Wed, 9 Dec 2009, Peter Zijlstra wrote:

> > /me ponders.. doesn't the binfmt engine cruft need the args in place in
> > order to execute?
> 
> Hardly looked, Al will be more up to date with all the grisly details.
> 
> The "binfmt engine cruft" being search_binary_handler()?  I think the
> args have to be "ready to go" before that, but that's different from
> the new mm actually being used as an mm before that.  It used not to
> be used early, but from 2.6.23 on it is used early, via get_user_pages.

Yeah, explicitly the fn() call in there which will mostly land you
load_elf_binary(). After that I loose track.

> > That is, IIRC the problem is that you need to have the argc/env in place
> > for the binfmt engine thing, and need to have ran the binfmt engine
> > thing before you know the personality.
> 
> It is a problem that personality is discovered late in the sequence,
> and that is a considerable part of what Al is up against.
> 
> > 
> > As to your idea, if that were feasible we could do without the copy and
> > simply steal the pages directly from the old mm.
> 
> Perhaps, but I think that would lead to a gradual accumulation
> of more and more pages pinned in memory by scattered references.

Well, IF the binfmt stuff can deal with the arrays being in the old mm
then it doesn't need to pin them I think, but I really don't know how
all this binfmt stuff works.

Reading fs/binfmt_elf.c:load_elf_binary() it looks like there might be a
spot where the personality is know and we still have the old mm around,
maybe we can hook in there -- we'd need to visit all binfmt though..

If we can make the binfmt stuff pass the correct location to
flush_old_exec() we could do the copy there.

> I Cc'ed you really because I wasn't much involved in the variable
> length arg discussions, and don't remember how important swappability
> was viewed at the time.  It is a significant feature of what you and
> Ollie ended up with, so I'm guessing it was then viewed as essential.
> That would be my view.
> 
> But now it's suggested that the TLB+cache effects of using an mm there
> are counter-productive, and better to forget swappability: well, I want
> to keep it, and Al is making a brave effort to hold on to it, but I'm
> wary of the weirdness involved.

Right, the swappability is key, without that you can easily run the
kernel into the ground if you don't have a limit on the argv/env arrays.
And not having a limit was the whole point.



