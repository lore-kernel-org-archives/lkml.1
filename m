Return-Path: <linux-kernel-owner+w=401wt.eu-S1759987AbYDBA2I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759987AbYDBA2I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 20:28:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757132AbYDBA14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 20:27:56 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33373 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757016AbYDBA1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 20:27:55 -0400
Date: Wed, 2 Apr 2008 09:31:57 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Paul Menage <menage@google.com>, Pavel Emelianov <xemul@openvz.org>,
       Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][-mm] Add an owner to the mm_struct (v4)
Message-Id: <20080402093157.e445acfb.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080401124312.23664.64616.sendpatchset@localhost.localdomain>
References: <20080401124312.23664.64616.sendpatchset@localhost.localdomain>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 01 Apr 2008 18:13:12 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> +	/*
> +	 * Search in the children
> +	 */
> +	list_for_each_entry(c, &p->children, sibling) {
> +		if (c->mm == mm)
> +			goto assign_new_owner;
> +	}
> +
This finds new owner when "current" is multi-threaded and
"current" called pthread_create(), right ?

> +	/*
> +	 * Search in the siblings
> +	 */
> +	list_for_each_entry(c, &p->parent->children, sibling) {
> +		if (c->mm == mm)
> +			goto assign_new_owner;
> +	}
> +
This finds new owner when "current" is multi-threaded and
"current" is just a child (means it doesn't call pthread_create()) ?


> +	/*
> +	 * Search through everything else. We should not get
> +	 * here often
> +	 */
> +	do_each_thread(g, c) {
> +		if (c->mm == mm)
> +			goto assign_new_owner;
> +	} while_each_thread(g, c);

Doing above in synchronized manner seems too heavy.
When this happen ? or Can this be done in lazy "on-demand" manner ?

+assign_new_owner:
+	rcu_read_unlock();
+	BUG_ON(c == p);
+	task_lock(c);
+	if (c->mm != mm) {
+		task_unlock(c);
+		goto retry;
+	}
+	cgroup_mm_owner_callbacks(mm->owner, c);
+	mm->owner = c;
+	task_unlock(c);
+}
Why rcu_read_unlock() before changing owner ? Is it safe ?

Thanks,
-Kame

