Return-Path: <linux-kernel-owner+w=401wt.eu-S935810AbZLHGG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935810AbZLHGG6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 01:06:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935778AbZLHGG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 01:06:57 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:58318 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935648AbZLHGG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 01:06:56 -0500
Date: Tue, 8 Dec 2009 06:07:01 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Al Viro <viro@ftp.linux.org.uk>, linux-arch@vger.kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCHSET] mremap/mmap mess
Message-ID: <20091208060701.GM14381@ZenIV.linux.org.uk>
References: <E1NGzzu-0008RH-T2@ZenIV.linux.org.uk> <20091207035857.GF14381@ZenIV.linux.org.uk> <Pine.LNX.4.64.0912071710540.14445@sister.anvils> <20091207193048.GI14381@ZenIV.linux.org.uk> <Pine.LNX.4.64.0912071953490.24794@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0912071953490.24794@sister.anvils>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 07, 2009 at 08:05:05PM +0000, Hugh Dickins wrote:

> mm/nommu.c is all about duplicating stuff with variations:
> unsatisfactory, but no reason to go do it differently here.
> Yes, I'll want to revert the util.c mods, but you don't need
> to do so now.

OK...  BTW, I think I see how to get rid of the worst of expand_stack()
mess.  Note that conceptually the nastiest part is execve() - there
we have no task_struct matching the mm we are accessing.  But let's
take a look at what execve() is doing:
	* we create a new mm
	* we create a kinda-sorta vma at STACK_TOP_MAX
	* we push argv/envp into it via get_user_pages(), populating
page tables for new mm as we go
	* we set personality
	* we possibly relocate it down
And all of that - to avoid the limit on number of pages caused by fixed-sized
array in bprm.

First of all, that implictly assumes that this relocation downwards is
rare.  And so it is on amd64 and alpha.  However, sparc64 and ppc64
have nearly 100% 32bit userland.  That got to hurt and if the situation
with s390 is anywhere near that, they *really* hurt - we have variable
depth of page table tree there and forcing it up is Not Nice(tm).

Why do we want user_get_pages(), anyway?  It's not that we lacked an
easy way to do large arrays, especially since the use is purely sequential.
Even a linked list of vmalloc'ed pages would do just fine (i.e. start with
static array in bprm, keep the pointer to last filled entry + number of
entries left before the next allocation; use the last pointer in array
for finding the next page-sized chunk).

What do we lose if we go that way?  Inserting all these pages into mm
at once shouldn't be slower.  Memory overhead is not really an issue
(one page per 511 or 1023 pages of argv).  Am I missing something?

The benefit, AFAICS, is that we get rid of the mess with forced high
address use, get *sane* get_user_pages() (we always have matching
task_struct with the right personality, so we can avoid massive PITA
for doing checks right) and we get unified mmu/nommu code in fs/exec.c
out of that.

If you see serious problems I've missed, please tell.  Otherwise I'm
going to hack up a prototype and post it here...
