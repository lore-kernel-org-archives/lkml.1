Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702Ab0BDHlI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 02:41:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57455 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754651Ab0BDHlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 02:41:05 -0500
Date: Thu, 4 Feb 2010 18:40:57 +1100
From: Nick Piggin <npiggin@suse.de>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH][RFC] %pd - for printing dentry name
Message-ID: <20100204074057.GA13318@laptop>
References: <20100201222511.GA12882@ZenIV.linux.org.uk>
 <alpine.LFD.2.00.1002011431490.3664@localhost.localdomain>
 <20100201231847.GC12882@ZenIV.linux.org.uk>
 <alpine.LFD.2.00.1002012018400.3664@localhost.localdomain>
 <20100202050037.GE12882@ZenIV.linux.org.uk>
 <20100202063631.GB6175@laptop>
 <20100204060237.GD30031@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100204060237.GD30031@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 04, 2010 at 06:02:37AM +0000, Al Viro wrote:
> On Tue, Feb 02, 2010 at 05:36:31PM +1100, Nick Piggin wrote:
> 
> > I ended up having to use a seqlock to do name comparison without locks
> > (and without holding references for that matter, just RCU).  However
> > name comparison is obviously a lot more critical because you can't
> > ignore races, so you might be able to do something simpler.
> 
> Umm...  Your ->d_seq, you mean?  IIRC, that stuff landed too close to
> do_filp_open() queue back then *and* had potential headache from hell
> with vfsmount side of that business.
> 
> I've reread it now.  Comments:

OK. It's at the end of a big patch series and the path walk stuff
was proof of concept quality at best. In particular I was hoping
for a better way to share code.

That said, we can move pieces around if you are interested to
cherry pick things. I should rediff and resend the series.

> 	* mntput() is blocking.  When refcount goes to 0, we get
> dput() on root, possibly followed by actual fs shutdown.  Very
> much not an RCU fodder, even though most of the calls will be OK.
> We can do a variant that would do atomic_dec_and_bail() instead ;-)
> I.e. decrement atomically if greater than 1, bail out otherwise.

Good point. atomic_dec_and_bail seems like it would work nicely.


> 	* why do you bail out on LOOKUP_PARENT?  For that matter, why
> do you do that so late?

Ah no good reason. Probably I was just trying to get some basic
testable cases working. I indeed hope to handle more cases and
bail out more gracefully (ie. attempt to resume walking from
last successful lookup rather than start the entire path again).


> 	* how does that interact with d_materialise_unique()?  Sure,
> you bail out on NFS anyway, but it's still not nice to leave relying just
> on that.

Yeah it does need some more thinking about these cases. In fact,
it's even missing a lot of basic rcu_assign_pointer / rcu_deref
cases that are needed if we are to make lookups totally lock free.

For harder cases, I'm hoping we can get away with using ->d_seq
to avoid thinking too hard about ordering.

Like I said, it's very much "known buggy" / proof of concept stage.
But if you're happy with the basic idea, then I'm keen to get to
work on it.

Do you have opinions on the rest of the vfs scalability series?


> 	* why can we access dentry->d_inode->i_op contents?  Or dentry->d_op
> one, for that matter...

Good point. Require an rcu_barrier in unregister_filesystem I guess.

 
> BTW, I'd love to take the entire "last component" part of link_path_walk()
> out into a separate function and away from link_path_walk(), leaving
> basically just the LOOKUP_PARENT case in there.  Price: trailing symlinks
> need to be handled by an iterative loop in do_follow_link().  And
> that actually ends up an improvement both in stack depth and in overall
> code cleanup.  Nothing like the horrors in do_filp_open(), TYVM (said
> horrors had mostly gone away in #untested, BTW, and I'm going to move
> that series to for-next shortly).  However, we are still several prereqs
> away from link_path_walk() split, so that'll have to wait a bit.  In
> any case, LOOKUP_PARENT is very much worth the first-class treatment...

I'll have to take a look at what you're doing.

Thanks,
Nick

