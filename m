Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755Ab0BCWzK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 17:55:10 -0500
Received: from cantor.suse.de ([195.135.220.2]:51344 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756402Ab0BCWzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 17:55:05 -0500
From: Lubos Lunak <l.lunak@suse.cz>
To: David Rientjes <rientjes@google.com>
Subject: Re: Improving OOM killer
Date: Wed, 3 Feb 2010 23:55:01 +0100
User-Agent: KMail/1.9.10
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>, Rik van Riel <riel@redhat.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Jiri Kosina <jkosina@suse.cz>
References: <201002012302.37380.l.lunak@suse.cz> <20100203170127.GH19641@balbir.in.ibm.com> <alpine.DEB.2.00.1002031021190.14088@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1002031021190.14088@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201002032355.01260.l.lunak@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 of February 2010, David Rientjes wrote:
> My rewrite for the badness() heuristic is centered on the idea that scores
> should range from 0 to 1000, 0 meaning "never kill this task" and 1000
> meaning "kill this task first."  The baseline for a thread, p, may be
> something like this:
>
> 	unsigned int badness(struct task_struct *p,
> 					unsigned long totalram)
> 	{
> 		struct task_struct *child;
> 		struct mm_struct *mm;
> 		int forkcount = 0;
> 		long points;
>
> 		task_lock(p);
> 		mm = p->mm;
> 		if (!mm) {
> 			task_unlock(p);
> 			return 0;
> 		}
> 		points = (get_mm_rss(mm) +
> 				get_mm_counter(mm, MM_SWAPENTS)) * 1000 /
> 				totalram;
> 		task_unlock(p);
>
> 		list_for_each_entry(child, &p->children, sibling)
> 			/* No lock, child->mm won't be dereferenced */
> 			if (child->mm && child->mm != mm)
> 				forkcount++;
>
> 		/* Forkbombs get penalized 10% of available RAM */
> 		if (forkcount > 500)
> 			points += 100;

 As far as I'm concerned, this is a huge improvement over the current code 
(and, incidentally :), quite close to what I originally wanted). I'd be 
willing to test it in few real-world desktop cases if you provide a patch.

> 		/*
> 		 * /proc/pid/oom_adj ranges from -1000 to +1000 to either
> 		 * completely disable oom killing or always prefer it.
> 		 */
> 		points += p->signal->oom_adj;

 This changes semantics of oom_adj, but given that I expect the above to make 
oom_adj unnecessary on the desktop for the normal cases, I don't really mind.

-- 
 Lubos Lunak
 openSUSE Boosters team, KDE developer
 l.lunak@suse.cz , l.lunak@kde.org
