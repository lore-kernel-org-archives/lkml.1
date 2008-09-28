Return-Path: <linux-kernel-owner+w=401wt.eu-S1753320AbYI1T2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbYI1T2n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 15:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752341AbYI1T2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 15:28:35 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:56893 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbYI1T2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 15:28:34 -0400
Date: Sun, 28 Sep 2008 20:28:16 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, ebiederm@xmission.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.27-rc7-sha1: EIP at proc_sys_compare+0x36/0x50
In-Reply-To: <20080928141856.GG28946@ZenIV.linux.org.uk>
Message-ID: <Pine.LNX.4.64.0809282011020.1967@blonde.site>
References: <20080926152031.GA30831@x200.localdomain>
 <alpine.LFD.1.10.0809260838120.3265@nehalem.linux-foundation.org>
 <20080928141856.GG28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Sep 2008, Al Viro wrote:
> On Fri, Sep 26, 2008 at 08:47:51AM -0700, Linus Torvalds wrote:
> 
> > and as far as I can tell, there is nothing to say that a /proc inode 
> > cannot be a negative dentry. Sure, we try to get rid of them, but during a 
> > parallel lookup, we will have added the dentry with a NULL inode in the 
> > other lookup.
> > 
> > So assuming that you have an inode at that point seems to be utter crap.
> > 
> > Now, the whole _function_ is utter crap and should probably be dropped, 
> > but whatever. That's just another sysctl insanity. In the meantime, 
> > something like this does look appropriate, no?
> > 
> > Al, did I miss something?
> 
> The real underlying bug, whatever it is.  If this sucker ever becomes
> negative, we have a big problem.  Where _could_ that happen?  Remember,
> we do not allow ->rmdir() and ->unlink() to succeed there.  So d_delete()
> callers in namei.c are out of question.  We also never do d_add() with
> NULL inode in there.  We _might_ be doing a bogus d_rehash() on a negative
> /prooc/sys/<something> dentry that had never been hashed to start with
> somewhere in generic code, but... I don't see where that could happen.
> vfs_rename_dir() with negative new_dentry would have to get it from
> something and that would have to be ->lookup().  And that sucker returns
> ERR_PTR() or a positive dentry in all cases here.  d_splice_alias() is not
> used there at all; d_move_locked() would scream bloody murder if dentry
> it's rehashing is negative.  d_materialize_unique() and d_add_unique()
> are not used.  So just WTF is creating this sucker?
> 
> IOW, your patch will probably be enough to stop the visible problem, but
> I would dearly like to understand what's really causing it.  It appears to
> be a refcounting breakage somewhere and we have *another* bug report that
> smells like that - it seems like we sometimes end up with negative dentry
> on alias list of an inode (outside of /proc/sys, AFAICT).  Something really
> fishy is going on...

I got a couple of earlier instances of this on powerpc
http://lkml.org/lkml/2008/8/14/289
but saw nothing more of it, so asked Al to forget about it.

But today I've got it again, this time on x86_64, with kdb in
(but not serial console), similar kernel builds with swapping
loads as before.  Though with Andrew's latest mmotm, so some
details different from 2.6.27-rc, and could be an mmotm bug.

The dentry in question (it's for /proc/sys/kernel/ngroups_max)
looks as if the __d_drop and d_kill of prune_one_dentry() came
in on one cpu just after __d_lookup() had found the entry on
parent's hashlist, just before it acquired dentry->d_lock.

That's plausible, isn't it, and would account for the rarity,
and would say Linus's patch is good?

Do ask me for any details you'd like out of the dentry.

Hugh
