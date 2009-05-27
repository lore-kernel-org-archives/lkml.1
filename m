Return-Path: <linux-kernel-owner+w=401wt.eu-S1758949AbZE0AQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758949AbZE0AQc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 20:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756389AbZE0AQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 20:16:14 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:60190 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756796AbZE0AQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 20:16:12 -0400
Date: Tue, 26 May 2009 17:16:13 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: jmorris@namei.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TOMOYO: Add garbage collector support. (v2)
Message-ID: <20090527001613.GE7006@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090503215615.GA1368@ucw.cz> <200905041524.GGH52160.FFFVMSJOOLtHOQ@I-love.SAKURA.ne.jp> <200905062116.HCI09807.VOFFHFSMOLOtQJ@I-love.SAKURA.ne.jp> <200905142108.JIF10080.OOFHJVFtOSQMFL@I-love.SAKURA.ne.jp> <alpine.LRH.2.00.0905151146320.5937@tundra.namei.org> <200905162107.HCE17153.HLSFMtOOFVFOJQ@I-love.SAKURA.ne.jp> <200905250037.n4P0bFwe057503@www262.sakura.ne.jp> <200905250039.n4P0dSIE058041@www262.sakura.ne.jp> <200905250041.n4P0fVCT058575@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905250041.n4P0fVCT058575@www262.sakura.ne.jp>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 25, 2009 at 09:41:31AM +0900, Tetsuo Handa wrote:
> ------- Forwarded Message
>  From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
>  To: serue@us.ibm.com, jmorris@namei.org
>  Cc: haradats@nttdata.co.jp, takedakn@nttdata.co.jp
>  Subject: Re: [PATCH] TOMOYO: Add garbage collector support. (v2)
>  Date: Sat, 23 May 2009 11:05:24 +0900
> 
> Thank you for reviewing.
> 
> Serge E. Hallyn wrote:
> > So yes, you might be able to get more review of your patch
> > if you split it up into:
> > 
> > 	1. move allocations outside of semaphore
> > 	2. add proper refcounting
> > 	3. get rid of ->is_deleted
> 
> I'm ready to post part (1).
> 
>  security/tomoyo/common.c   |   80 ++++++---------------
>  security/tomoyo/common.h   |    2 
>  security/tomoyo/domain.c   |   97 ++++++++++++-------------
>  security/tomoyo/file.c     |  133 ++++++++++++++++++-----------------
>  security/tomoyo/realpath.c |  169 ++++++++++++++-------------------------------
>  security/tomoyo/realpath.h |    7 -
>  6 files changed, 200 insertions(+), 288 deletions(-)
> 
> http://svn.sourceforge.jp/cgi-bin/viewcvs.cgi/trunk/2.2.x/tomoyo-lsm/patches/tomoyo-move-sleeping-operations-to-outside-semaphore.patch?view=markup&revision=2579&root=tomoyo
> 
> But I think I won't get rid of ->is_deleted. Reasons are shown below.
> 
> > However, the way you went about it here is weird too.  The big
> > cookie list that pins items, instead of refcounts, is very un-linuxy.
> > Is there a reason why you can't use more of a read-copy-update
> > approach?  Keep a refcount on the objects, get rid of ->is_deleted,
> > remove the objects from their list instead of setting is_deleted
> > (so that after one rcu cycle no new readers can come in and increment
> > the refcount), wait an rcu cycle, and then free if refcount is 0?
> 
> All items are linked using "struct list_head".
> TOMOYO uses "struct tomoyo_io_buffer" with three "struct list_head" members
> named ->read_var1 / ->read_var2 / ->write_var1 for handling read()/write() via
> securityfs interface. These members act as cookies.
> 
> Within a single read() request, it is possible to protect the list by using
> down_read(). But an administrator won't read out all items in a single read()
> request. Therefore, TOMOYO stores the item which is scheduled to be accessed on
> next read() request into ->read_var1 and ->read_var2 .
> 
> Similar situation for write() request. An administrator won't write all items
> in a single write() request. Therefore, TOMOYO stores the item which is
> accessed on next write() request into ->write_var1 .
> 
> The ->read_var1 / ->read_var2 / ->write_var1 act as cookies.
> 
> Yes, I can add a refcounter to all items which is only used for remembering
> whether an item is stored in ->read_var1 / ->read_var2 / ->write_var1 or not.
> 
> When the item which ->read_var1 / ->read_var2 / ->write_var1 refer changes,
> we have to decrement the refcount of the object pointed by old ->read_var1 /
> ->read_var2 / ->write_var1 and increment the refcount of the object pointed by
> new ->read_var1 / ->read_var2 / ->write_var1 before releasing the lock.
> 
> I pinned the address of "struct list_head" into the cookie list so that I don't
> need to increment/decrement of an item's refcounter while guaranteeing that the
> item pointed by the cookie list shall remain valid after up_read()/up_write().
> 
> > where tomoyo_used_by_cookie then walks every cookie, meaning every
> > tomoyo object, seems hugely expensive to me.  I know it's only at
> > policy load, but...
> The cookie list approach will save memory compared to the refcounter approach
> because the number of cookies in the cookie list will be smaller than
> the number of items in all lists except the cookie list.
> 
> Even if we defer releasing memory of a deleted item, we can't remove an
> item from the list when an administrator deleted the item.
> Removing from the list (i.e. list_del()) will modify ->next and ->prev pointer
> of the item. If the item was scheduled to be accessed on next read() request,
> TOMOYO will crash by dereferencing ->next pointer of the item.

The list_del_rcu() primitive is designed for removing elements from
lists that have concurrent readers, and it therefore avoids changing the
->next pointer.  That said, I don't immediately see whether or not there
is some other reason you need to keep it on the list.  And do you need
the ->prev pointer to stay valid?  If not, you might be able to use it
in place of the ->is_deleted flag.

> Use of RCU does not help here because we need to keep the item valid as long as
> the item is referred by ->read_var1 or ->read_var2 or ->write_var1 .

You would indeed need some way of tracking those references.  One
approach is to make the RCU callback check to see if any of them
reference the to-be-deleted object, reposting itself if so.  This
approach assumes that such a reference is short-lived, of course.

If the ->read_var1 and other references are long-lived, could you
post an RCU callback when the last such reference was removed?

> The ->is_deleted flag is needed for skipping an item in read() request
> because TOMOYO can't modify ->next and ->prev pointer of an item when that item
> is scheduled to be accessed on next read() request.
> 
> My opinion is that the refcounter approach might replace the cookie list
> approach, but the refcounter approach can't get rid of ->is_deleted flag.

Some RCU algorithms do use something similar to the ->is_deleted flag.

							Thanx, Paul

> > >   (2) Should TOMOYO have GC support?
> > 
> > Well if your only audience is meant to be tiny embedded systems which
> > will never update policy, then heck maybe not.  But it certainly is
> > weird not to.
> 
> The non-LSM version of TOMOYO is "GC support free" but saves a lot of memory
> by using "singly linked list", "read lock free", "refcounter free" approach.
> 
> Maybe we should add a refcounter to all items and avoid the cookie list.
> In that case, we can allow users to determine via the kernel config whether
> TOMOYO supports GC or not. If GC support is not chosen via the kernel config,
> TOMOYO can save memory by using "singly linked list", "read lock free",
> "refcounter free" approach.
> 
> ------- End of Forwarded Message
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
