Return-Path: <linux-kernel-owner+w=401wt.eu-S1758627AbZFOMYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758627AbZFOMYt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 08:24:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756835AbZFOMYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 08:24:40 -0400
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:15309 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755763AbZFOMYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 08:24:39 -0400
X-Trace: 215074821/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.113.131/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.113.131
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnECAA3aNUpPRXGD/2dsb2JhbAAI1AaEDQU
X-IronPort-AV: E=Sophos;i="4.42,222,1243810800"; 
   d="scan'208";a="215074821"
Date: Mon, 15 Jun 2009 13:23:38 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Izik Eidus <ieidus@redhat.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] ksm: write protect pages from inside ksm
In-Reply-To: <20090615035749.6f8236cc@woof.tlv.redhat.com>
Message-ID: <Pine.LNX.4.64.0906151300160.21984@sister.anvils>
References: <1244843100-4128-1-git-send-email-ieidus@redhat.com>
 <Pine.LNX.4.64.0906142217270.6369@sister.anvils> <4A3576C3.2040500@redhat.com>
 <4A358DA7.2080305@redhat.com> <4A35903A.3090508@redhat.com>
 <20090615035749.6f8236cc@woof.tlv.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Jun 2009, Izik Eidus wrote:
> On Mon, 15 Jun 2009 03:05:14 +0300 Izik Eidus <ieidus@redhat.com> wrote:
> > >>
> > >> Sure, let me check it.
> > >> (You do have Andrea patch that fix the "used after free slab
> > >> entries" ?)

I do, yes, and the other fix he posted at the same time.

> > >
> > > How fast is it crush opps to you?, I compiled it and ran it here on 
> > > 2.6.30-rc4-mm1 with:
> > > "Enable SLQB debugging support" and "SLQB debugging on by default,
> > > and it run and merge (i am using qemu processes to run virtual
> > > machines to merge the pages between them)

I suspect too much of your testing has been on the sensible use of KSM,
not enough on foolish abuse of it!

> > >
> > > ("SLQB debugging on by defaul" mean i dont have to add boot
> > > pareameter right?)

That's right.  (I never switch it on by default in the .config,
just love that we can switch it on by boot option when needed.)

> > OK, bug on my side, just got that oppss, will try to fix and send
> > patch.

Thanks a lot for getting there so quickly.

> Ok, below is ugly fix for the opss..

Right, for several reasons* not a patch we'd like to include in the
end, but enough to show that indeed fixes the problems I was seeing:
well caught.

[* We don't want to serialize everyone on a global lock there.  You
could make it a little better using atomic_dec_and_lock(), but still
unpleasant.  And that placing of the list_del() is bad for swapping:
I ended up using list_del_init() there, and restoring the check after
calling set_mm_exe_file().  But never mind, I've a better fix.]

> 
> From 3be1ad5a9f990113e8849fa1e74c4e74066af131 Mon Sep 17 00:00:00 2001
> From: Izik Eidus <ieidus@redhat.com>
> Date: Mon, 15 Jun 2009 03:52:05 +0300
> Subject: [PATCH] ksm: madvise-rfc: really ugly fix for the oppss bug.
> 
> This patch is just so it can run without to crush with the madvise rfc patch.
> 
> True fix for this i think is adding another list for ksm inside the mm struct.
> In the meanwhile i will try to think about other way how to fix this bug.

I'm already working with a separate list for KSM inside the mm struct
(prefer not to be mixing these two things up), but I don't see how that
helps.

> 
> Hugh, i hope at least now you will be able to run it without it will crush to
> you.

Yes, thanks, and helped me to think of a better fix (I hope!) below...

> 
> Signed-off-by: Izik Eidus <ieidus@redhat.com>
> ---
>  kernel/fork.c |   11 ++++++-----
>  1 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/fork.c b/kernel/fork.c
> index e5ef58c..771b89a 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -484,17 +484,18 @@ void mmput(struct mm_struct *mm)
>  {
>  	might_sleep();
>  
> +	spin_lock(&mmlist_lock);
>  	if (atomic_dec_and_test(&mm->mm_users)) {
> +		if (!list_empty(&mm->mmlist))
> +			list_del(&mm->mmlist);
> +		spin_unlock(&mmlist_lock);
>  		exit_aio(mm);
>  		exit_mmap(mm);
>  		set_mm_exe_file(mm, NULL);
> -		if (!list_empty(&mm->mmlist)) {
> -			spin_lock(&mmlist_lock);
> -			list_del(&mm->mmlist);
> -			spin_unlock(&mmlist_lock);
> -		}
>  		put_swap_token(mm);
>  		mmdrop(mm);
> +	} else {
> +		spin_unlock(&mmlist_lock);
>  	}
>  }
>  EXPORT_SYMBOL_GPL(mmput);

I believe you can restore mmput() to how it was: patch below appears
to fix it from the get_next_mmlist() end, using atomic_inc_not_zero() -
swapoff's try_to_unuse() has to use that on mm_users too.  But please
check and test it carefully, I'd usually want to test a lot more myself
before sending out.

And, hey, this very same patch appears to fix the other issue I mentioned,
that I wasn't yet seeing any merging (within a single mm): I think your
mm_users 1 test was badly placed before (whether or not we already have
an mm_slot makes a big difference to the meaning of mm_users 1).

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>

--- ksm_madvise/mm/ksm.c	2009-06-14 11:15:33.000000000 +0100
+++ linux/mm/ksm.c	2009-06-15 12:49:12.000000000 +0100
@@ -1137,7 +1137,6 @@ static void insert_to_mm_slots_hash(stru
 	bucket = &mm_slots_hash[((unsigned long)mm / sizeof (struct mm_struct))
 				% nmm_slots_hash];
 	mm_slot->mm = mm;
-	atomic_inc(&mm_slot->mm->mm_users);
 	INIT_LIST_HEAD(&mm_slot->rmap_list);
 	hlist_add_head(&mm_slot->link, bucket);
 }
@@ -1253,21 +1252,21 @@ static struct mm_slot *get_next_mmlist(s
 		if (test_bit(MMF_VM_MERGEABLE, &mm->flags) ||
 		    test_bit(MMF_VM_MERGEALL, &mm->flags)) {
 			mm_slot = get_mm_slot(mm);
-			if (unlikely(atomic_read(&mm->mm_users) == 1)) {
-				if (mm_slot)
+			if (mm_slot) {
+				if (atomic_read(&mm->mm_users) == 1) {
 					mm_slot->touched = 0;
-			} else {
-				if (!mm_slot) {
-					insert_to_mm_slots_hash(mm,
-							     pre_alloc_mm_slot);
-					*used_pre_alloc = 1;
-					mm_slot = pre_alloc_mm_slot;
+					goto next;
 				}
-				mm_slot->touched = 1;
-				return mm_slot;
-			}
+			} else if (atomic_inc_not_zero(&mm->mm_users)) {
+				insert_to_mm_slots_hash(mm, pre_alloc_mm_slot);
+				*used_pre_alloc = 1;
+				mm_slot = pre_alloc_mm_slot;
+			} else
+				goto next;
+			mm_slot->touched = 1;
+			return mm_slot;
 		}
-
+next:
 		cur = cur->next;
 	}
 	return NULL;
