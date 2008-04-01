Return-Path: <linux-kernel-owner+w=401wt.eu-S1754085AbYDAGQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbYDAGQr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 02:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751648AbYDAGQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 02:16:38 -0400
Received: from smtp-out.google.com ([216.239.33.17]:7097 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbYDAGQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 02:16:37 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=bZeTXPZBN1cJwcHXJfYecfyJkTRV3o1Ldmts+XvuRiDpi8hL6YIJf6stBK5SV2vUN
	26yQfrd/0UG+Bw3e+itQw==
Message-ID: <6599ad830803312316m17f9e6f1mf7f068c0314a789e@mail.gmail.com>
Date: Mon, 31 Mar 2008 23:16:19 -0700
From: "Paul Menage" <menage@google.com>
To: "Balbir Singh" <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC][-mm] Add an owner to the mm_struct (v3)
Cc: "Pavel Emelianov" <xemul@openvz.org>, "Hugh Dickins" <hugh@veritas.com>,
       "Sudhir Kumar" <skumar@linux.vnet.ibm.com>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       "David Rientjes" <rientjes@google.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080401054324.829.4517.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080401054324.829.4517.sendpatchset@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2008 at 10:43 PM, Balbir Singh
<balbir@linux.vnet.ibm.com> wrote:
>  -static struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p)
>  +struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p)
>   {
>         return container_of(task_subsys_state(p, mem_cgroup_subsys_id),
>                                 struct mem_cgroup, css);
>   }

This should probably be inlined in the header file if it's needed
outside this file.
>  +static inline void mm_fork_init_owner(struct task_struct *p)
>  +{
>  +}

I think this is stale.

>  +
>  +void mm_update_next_owner(struct mm_struct *mm)
>  +{
>  +       struct task_struct *c, *g, *p = current;
>  +
>  +       /*
>  +        * This routine should not be called for init_task
>  +        */
>  +       BUG_ON(p == p->parent);

I think (as you mentioned earlier) that we need an RCU critical
section in this function, in order for the tasklist traversal to be
safe.

Maybe also BUG_ON(p != mm->owner) ?

>  +       list_for_each_entry(c, &p->children, sibling) {
>  +               if (c->mm && (c->mm == mm))

Since mm != NULL, no need to test for c->mm since if it's NULL then c->mm != mm

>  +assign_new_owner:
>  +       BUG_ON(c == p);
>  +       task_lock(c);
>  +       if (c->mm != mm) {
>  +               task_unlock(c);
>  +               goto retry;
>  +       }
>  +       mm->owner = c;

Here we'll want to call vm_cgroup_update_mm_owner(), to adjust the
accounting. (Or if in future we end up with more than a couple of
subsystems that want notification at this time, we'll want to call
cgroup_update_mm_owner() and have it call any interested subsystems.

Paul
