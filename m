Return-Path: <linux-kernel-owner+w=401wt.eu-S1752488AbYI1OTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488AbYI1OTR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 10:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751183AbYI1OTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 10:19:04 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49026 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbYI1OTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 10:19:03 -0400
Date: Sun, 28 Sep 2008 15:18:56 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, ebiederm@xmission.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.27-rc7-sha1: EIP at proc_sys_compare+0x36/0x50
Message-ID: <20080928141856.GG28946@ZenIV.linux.org.uk>
References: <20080926152031.GA30831@x200.localdomain> <alpine.LFD.1.10.0809260838120.3265@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0809260838120.3265@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2008 at 08:47:51AM -0700, Linus Torvalds wrote:

> and as far as I can tell, there is nothing to say that a /proc inode 
> cannot be a negative dentry. Sure, we try to get rid of them, but during a 
> parallel lookup, we will have added the dentry with a NULL inode in the 
> other lookup.
> 
> So assuming that you have an inode at that point seems to be utter crap.
> 
> Now, the whole _function_ is utter crap and should probably be dropped, 
> but whatever. That's just another sysctl insanity. In the meantime, 
> something like this does look appropriate, no?
> 
> Al, did I miss something?

The real underlying bug, whatever it is.  If this sucker ever becomes
negative, we have a big problem.  Where _could_ that happen?  Remember,
we do not allow ->rmdir() and ->unlink() to succeed there.  So d_delete()
callers in namei.c are out of question.  We also never do d_add() with
NULL inode in there.  We _might_ be doing a bogus d_rehash() on a negative
/prooc/sys/<something> dentry that had never been hashed to start with
somewhere in generic code, but... I don't see where that could happen.
vfs_rename_dir() with negative new_dentry would have to get it from
something and that would have to be ->lookup().  And that sucker returns
ERR_PTR() or a positive dentry in all cases here.  d_splice_alias() is not
used there at all; d_move_locked() would scream bloody murder if dentry
it's rehashing is negative.  d_materialize_unique() and d_add_unique()
are not used.  So just WTF is creating this sucker?

IOW, your patch will probably be enough to stop the visible problem, but
I would dearly like to understand what's really causing it.  It appears to
be a refcounting breakage somewhere and we have *another* bug report that
smells like that - it seems like we sometimes end up with negative dentry
on alias list of an inode (outside of /proc/sys, AFAICT).  Something really
fishy is going on...
