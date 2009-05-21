Return-Path: <linux-kernel-owner+w=401wt.eu-S1754858AbZEUOzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858AbZEUOzT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 10:55:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753738AbZEUOzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 10:55:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42873 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752828AbZEUOzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 10:55:07 -0400
Subject: Re: [PATCH mmotm] fsnotify: don't slow everything down
From: Eric Paris <eparis@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Hugh Dickins <hugh@veritas.com>, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20090521094613.GT8633@ZenIV.linux.org.uk>
References: <Pine.LNX.4.64.0905171445290.18657@blonde.anvils>
	 <1242574698.5212.35.camel@dhcp231-142.rdu.redhat.com>
	 <20090521094613.GT8633@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Thu, 21 May 2009 10:54:59 -0400
Message-Id: <1242917699.2827.159.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-21 at 10:46 +0100, Al Viro wrote:
> On Sun, May 17, 2009 at 11:38:17AM -0400, Eric Paris wrote:
> 
> > If people feel strongly I can come up with a system to reuse the inotify
> > flag now....  I planned on dropping the old inotify flag in a couple
> > releases when I finally evict inotify entirely, it would be a
> > performance hit, but I have a feeling a minimal one.  In any case, when
> > I push these patches along I'll probably move the new flag rather than
> > _COOKIE since long term they won't be 'together'
> > 
> > Acked-by: Eric Paris <eparis@redhat.com>
> 
> OK...  After the last round of review (going by what's in mmotm):
> 	* it got much better; at least the lifetime rules for generic
> structures are sane now and locking seems to be OK.
> 	* fsnotify() has too many arguments ;-/  It might actually be
> worth splitting into for-inode/for-file/etc. cases, and to hell with
> code duplication.  Note that adding for-dentry variant would take care
> of the file_name argument, so in any case it might be a good idea to
> add FSNOTIFY_EVENT_FROM_DENTRY, turning itself into ..._INODE and getting
> d_name, even if you don't go for splitting that sucker.

I'll poke it later.

> 	In any case, that's a separate patch and it might not be an
> improvement.
> 	* inotify should_send_event - no need to bother with refcounting,
> AFAICS, since the decision can be made before dropping i_lock.  BTW,
> bool x; ..... x = foo ? true : false;  is spelled x = foo.  That's what
> conversion to _Bool does, by definition, and kernel-side bool *is* _Bool.

Fixed the ? true : false.  Can't really do away with refcnt'ing since
that's the only way to find it unless I embed fsnotify implementation
information into inotify, which I'm not willing to do just to avoid an
atomic_inc and dec.  I did however drop the locking around event->mask
after thinking about it, the lock protects writers but in this case, I
don't care if I get ->mask right before or after or even during a
change.  Either we send or we don't, no big deal.  Between this function
call and the actual queuing of the event what userspace wants can change
and we'd end up with the wrong answer then.  That's all fine and safe.

> 	* inotify_handle_event() - um... why will ->wd we'd got from the
> event we'd found and dropped survive through a bunch of blocking allocations?
> With no locks held...

It was safe, but wrong.  ->wd after that point is just an int sent to
userspace, kernel doesn't use it for anything.  But I did make a change
to hold the mark until after the event is in the queue.  This fix means
that IN_IGNORED for this ->wd can't get in the queue before this event.

> 	* #10 and #11 might be worth merging.  Sure, you have them prior to
> inotify conversion, but...

I split them for easy review.  I'll probably just leave them split.  On
a bisect you'll have a working system, just possible the have in use
inodes after umount if you land between them.  Not something I'm worried
about.

> 	* the stuff added in #9 looks odd.  Your queue is a FIFO; what happens
> if I run into overflow, add overflow event into the end, remove some, drive
> q_len down to something tolerable, then add more, then run into overflow again?
> AFAICS, you get the same event queued twice for the same group, in the same
> queue, with different priv.  Then you get ->free_event_priv() called on
> flush_notify() for it.  Granted, that'll happen twice, so natural use of
> get_priv_from_event() in the method instance will allow to DTRT, but that's
> 	a) asking for trouble
> 	b) at least needs to be commented.
> Why not pass the damn pointer to priv to the method instead?  I'm not sure
> where you are going with that stuff, but it would seem to make more sense...
> AFAICS, the only current user (inotify) is OK *and* you are probably going
> to add the next user yourself, so it can be changed later, but...

I don't plan to use this at all in my next notification interface.  It's
really just their to support inotify.

I take it that you are suggesting I pass the priv pointer directly to
group->ops->free_event_priv().  I certainly could and it might be better
to keep the locking and list manipulation inside fsnotify code rather
than burying it in inotify code.

I think I'm also going to not attach private data to the overflow event.
It isn't needed or useful there.  Means I need to change my tests for
when priv was attached, but that's ok.

> Overall: the only serious question I have right now is about ->wd in
> inotify_handle_event().  Modulo that it's OK for -next; modulo that
> and testing for regressions (*including* overhead ones)... I can live
> with that going into mainline, provided that you are going to maintain
> fs/notify/ afterwards.

I'll make these last changes and push a tree to try to get it into
-next.

-Eric

