Return-Path: <linux-kernel-owner+w=401wt.eu-S1758754AbYCZLU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758754AbYCZLU5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 07:20:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751172AbYCZLUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 07:20:49 -0400
Received: from smtp-out.google.com ([216.239.33.17]:44156 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbYCZLUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 07:20:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=Ds6DXIgh4c03MO3gRXRXWFXmVCFuNx/JJJJ1eH2l8kv1Y7SgC0U4ExOSWQgn/hjIM
	pKyXbfGr/YKahXWlsq6Og==
Message-ID: <6599ad830803260420v236127cfydd8cf828fcce65bb@mail.gmail.com>
Date: Wed, 26 Mar 2008 04:20:35 -0700
From: "Paul Menage" <menage@google.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [RFC][-mm] Memory controller add mm->owner
Cc: linux-mm@kvack.org, "Hugh Dickins" <hugh@veritas.com>,
       "Sudhir Kumar" <skumar@linux.vnet.ibm.com>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp,
       "David Rientjes" <rientjes@google.com>,
       "Pavel Emelianov" <xemul@openvz.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <47EA2592.7090600@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080324140142.28786.97267.sendpatchset@localhost.localdomain>
	 <6599ad830803240803s5160101bi2bf68b36085f777f@mail.gmail.com>
	 <47E7D51E.4050304@linux.vnet.ibm.com>
	 <6599ad830803240934g2a70d904m1ca5548f8644c906@mail.gmail.com>
	 <47E7E5D0.9020904@linux.vnet.ibm.com>
	 <6599ad830803241046l61e2965t52fd28e165d5df7a@mail.gmail.com>
	 <47E8E4F3.6090604@linux.vnet.ibm.com>
	 <47EA2592.7090600@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2008 at 3:29 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>  >>
>  >> - in the worst case, it's not going to be worse than doing a
>  >> for_each_thread() loop
>  >>
>
>  This will have to be the common case, since you never know what combination of
>  clone calls did CLONE_VM and what did CLONE_THREAD. At exit time, we need to pay
>  a for_each_process() overhead.

I'm not convinced of this. All we have to do is find some other
process p where p->mm == current->mm and make it the new owner.
Exactly what sequence of clone() calls was used to cause the sharing
isn't really relevant. I really think that a suitable candidate will
be found amongst your children or your first sibling in 99.9% of those
cases where more than one process is using an mm.

The actual sequence would have to go something like:

static inline bool need_new_owner(struct mm_struct *mm) {
  return (mm && mm->owner == current && atomic_read(&mm->users) > 1);
}
static inline void try_give_mm_ownership(
    struct task_struct *task,
    struct mm_struct *mm) {
  if (task->mm != mm) return;
  task_lock(task);
  if (task->mm == mm) {
    mm->owner = task;
  }
  task_unlock(task);
}

struct mm_struct *mm = current->mm;
task_lock(current);
current->mm = NULL;
task_unlock(current);

/* First try my children */
if (need_new_owner(mm)) {
  for_each_child(current, c) {
    try_give_mm_ownership(c);
    if (!need_new_owner(mm)) break;
  }
}

/* Then try my siblings */
if (need_new_owner(mm)) {
  for_each_child(current->real_parent, c) {
    try_give_mm_ownership(c);
    if (!need_new_owner(mm)) break;
  }
}

if (need_new_owner(mm)) {
  /* We'll almost never get here */
  for_each_process(p) {
    try_give_mm_ownership(p);
    if (!need_new_owner(mm)) break;
  }
}

Paul
