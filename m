Return-Path: <linux-kernel-owner+w=401wt.eu-S1753283AbZJEG3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283AbZJEG3h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 02:29:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbZJEG3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 02:29:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19504 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752648AbZJEG3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 02:29:36 -0400
Message-ID: <4AC99292.5060502@redhat.com>
Date: Mon, 05 Oct 2009 14:30:42 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090719)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: linux-kernel@vger.kernel.org, Brian Behlendorf <behlendorf1@llnl.gov>,
       Ben Woodard <bwoodard@llnl.gov>, Stable Team <stable@kernel.org>,
       akpm@linux-foundation.org
Subject: Re: [Patch] rwsem: fix rwsem_is_locked() bug
References: <20090930032138.3919.72085.sendpatchset@localhost.localdomain> <9705.1254400470@redhat.com>
In-Reply-To: <9705.1254400470@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> 
> Your patch would probably be better as:
> 
> -	woken = 0;
> +	woken = ++sem->activity;
> 	while (waiter->flags & RWSEM_WAITING_FOR_READ) {
> 		struct list_head *next = waiter->list.next;
> 
> 		list_del(&waiter->list);
> 		tsk = waiter->task;
> 		smp_mb();
> 		waiter->task = NULL;
> 		wake_up_process(tsk);
> 		put_task_struct(tsk);
> 		woken++;
> 		if (list_empty(&sem->wait_list))
> 			break;
> 		waiter = list_entry(next, struct rwsem_waiter, list);
> 	}
> 
> -	sem->activity += woken;
> +	sem->activity = woken;

FYI, this seems wrong, probably even worse than what it is now.
I tried this change, it breaks portmap.

