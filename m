Return-Path: <linux-kernel-owner+w=401wt.eu-S1758071AbZFAN1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758071AbZFAN1m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 09:27:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757043AbZFAN1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 09:27:34 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:62513 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753557AbZFAN1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 09:27:33 -0400
To: serue@us.ibm.com
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TOMOYO: Add garbage collector support. (v2)
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <alpine.LRH.2.00.0905151146320.5937@tundra.namei.org>
	<200905162107.HCE17153.HLSFMtOOFVFOJQ@I-love.SAKURA.ne.jp>
	<200905250037.n4P0bFwe057503@www262.sakura.ne.jp>
	<200905250039.n4P0dSIE058041@www262.sakura.ne.jp>
	<200905250041.n4P0fVCT058575@www262.sakura.ne.jp>
In-Reply-To: <200905250041.n4P0fVCT058575@www262.sakura.ne.jp>
Message-Id: <200906012227.FDE64040.MVQLOStOHFOFFJ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Mon, 1 Jun 2009 22:27:30 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Serge E. Hallyn wrote:
> So yes, you might be able to get more review of your patch
> if you split it up into:
> 
> 	1. move allocations outside of semaphore
> 	2. add proper refcounting
> 	3. get rid of ->is_deleted

I'm ready to post part (1) and part (2).
But I'm not sure whether part (3) is worth to implement or not.

If we don't use is_deleted flag, we will need two "struct list_head"s,
one is for readers and writers, the other is for GC.

struct something {
	struct {
		struct list_head list;
		atomic_t users;
	} entry;
	int data;
	bool is_deleted;
} *p;

If we remove p from the list using list_del() (or list_del_rcu()) instead of
setting p->is_deleted to true, we have to somehow remember the element pointed
by p so that that element is reachable from the GC's list.
We can't wait for p->entry.users to become 0 inside writer function (which is
called only when modifying lists). Only GC function (which is called
repeatedly) can check whether p->entry.users == 0 or not because the element
pointed by p is long-lived. We need to remember the location of the element
pointed by p .

We can allocate memory when adding p to GC's list, but allocating memory at
list_del() (or list_del_rcu()) time could fail. It is not a good thing that
removing an element from the reader's list fails because of -ENOMEM. We already
have a way (i.e. is_deleted flag) to avoid -ENOMEM.

We can add another "struct list_head" to each element which is used by GC.
But that approach consumes more memory than is_deleted flag.

Regards.
