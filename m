Return-Path: <linux-kernel-owner+w=401wt.eu-S1757720AbZGCPwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757720AbZGCPwz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 11:52:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755020AbZGCPws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 11:52:48 -0400
Received: from smtp-out.google.com ([216.239.45.13]:37064 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756173AbZGCPwr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 11:52:47 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=RAGhqla4VtkG3vDUHGTk+mOa/sbY9kA6WC5e2TUUrKito3yfoqJQiSl6YujpH4gQR
	Ms3WOhknj+sOqow6C8k8A==
MIME-Version: 1.0
In-Reply-To: <20090703145441.f526793f.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090702231814.3969.44308.stgit@menage.mtv.corp.google.com>
	 <20090702232620.3969.16680.stgit@menage.mtv.corp.google.com>
	 <20090702164649.303c4952.akpm@linux-foundation.org>
	 <2f86c2480907021731h13e0bb95q94f06829eded9aa6@mail.gmail.com>
	 <20090702175341.fd2e26d5.akpm@linux-foundation.org>
	 <6599ad830907021808o6f3bb51eh324e4bf13544d83e@mail.gmail.com>
	 <20090702183004.1e3f4315.akpm@linux-foundation.org>
	 <20090703145441.f526793f.kamezawa.hiroyu@jp.fujitsu.com>
Date: Fri, 3 Jul 2009 08:52:46 -0700
Message-ID: <6599ad830907030852p2cd667e3m353d68448e0cdc6a@mail.gmail.com>
Subject: Re: [PATCH 1/2] Adds a read-only "procs" file similar to "tasks" that 
	shows only unique tgids
From: Paul Menage <menage@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Blum <bblum@google.com>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, lizf@cn.fujitzu.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 2, 2009 at 10:54 PM, KAMEZAWA
Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
> Why we can't do what readdir(/proc) does ? I'm sorry I misunderstand.
> Following is an easy example.
>
>
> 0. at open, inilialize f_pos to 0. f_pos is used as "pid"
>   remember "css_set with hole" as template in f_private?(or somewhere) at open
>   ...like this.
> --
>   struct cgroupfs_root *root = cgrp->root;
>   struct cgroup *template = kzalloc(sizeof(void*) * CGROUP_SUBSYS_COUNT);
>
>   for (i = 0; i < CGROUP_SUBSYS_COUNT; i++)
>        if (root->subsys_bits & (1UL << i))
>                template[i] =  cgrp->subsys[i];
> --
>
>
> 1. at read(), find task_struct of "pid" in f_pos.
> 2. look up task_struct of "pid" and compare with f_private
> --
>   struct cgroup *template = f_private;
>
>   for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
>        if (!template[i])
>                contiue;
>        if (template[i] != task_subsys_state(task, i))
>                break;
>   }
>   if (i == CGROUP_SUBSYS_COUNT)
>        print task;

The problem with this is that the time taken to scan a single cgroup
is linear in the total number of threads in the system, so if you have
a lot of threads and a lot of cgroups (even if most of the threads are
concentrated in a single cgroup) the time taken to scan all the tasks
files in O(N^2) in the number of threads in the system. The current
scheme is linear in the number of threads in a cgroup, so looking at
all cgroups is linear in the number of threads in the system. (This
O(N^2) problem is something that we've actually observed as an
overhead on some busy systems at Google).

Paul
