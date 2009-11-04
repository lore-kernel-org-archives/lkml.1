Return-Path: <linux-kernel-owner+w=401wt.eu-S1756426AbZKDP3B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756426AbZKDP3B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 10:29:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755673AbZKDP3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 10:29:00 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36137 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751187AbZKDP27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 10:28:59 -0500
Date: Wed, 4 Nov 2009 07:28:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Justin Mattock <justinmattock@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       gcc@gcc.gnu.org, David Rientjes <rientjes@cs.washington.edu>
Subject: Re: cc1plus invoked oom-killer: gfp_mask=0x280da, order=0,
 oom_adj=0
Message-Id: <20091104072826.8b2dfb73.akpm@linux-foundation.org>
In-Reply-To: <20091104182238.54CB.A69D9226@jp.fujitsu.com>
References: <dd18b0c30911021329g3c99a783n6b0a293240c3312c@mail.gmail.com>
	<20091103222432.4a94bd8f.akpm@linux-foundation.org>
	<20091104182238.54CB.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  4 Nov 2009 18:32:16 +0900 (JST) KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > It would help if the oom-killer were to print some information about
> > the oom-killed process's memory footprint.
> > 
> 
> 
> How about this?

looks good, thanks.

> ========
> Subject: [PATCH] oom: show vsz and rss information of the killed process
> 
> In typical oom anylysis scenario, we frequently want to know the killed
> process has memory leak or not at first step.
> This patch add vsz and rss information to oom log for helping its
> analysis. It save much times of debugging guys.
> 
> example:
> ===================================================================
> rsyslogd invoked oom-killer: gfp_mask=0x201da, order=0, oom_adj=0
> Pid: 1308, comm: rsyslogd Not tainted 2.6.32-rc6 #24
> Call Trace:
> [<ffffffff8132e35b>] ?_spin_unlock+0x2b/0x40
> [<ffffffff810f186e>] oom_kill_process+0xbe/0x2b0
> 
> (snip)
> 
> 492283 pages non-shared
> Out of memory: kill process 2341 (memhog) score 527276 or a child
> Killed process 2341 (memhog) vsz:1054552kB, anon-rss:970588kB, file-rss:4kB
> ===========================================================================
>                              ^
>                              |
>                             here
> ...
>
> +	if (verbose) {
> +		task_lock(p);

We need to be careful with which locks we take on the oom-killer path,
because it can be called by code which already holds locks.  But I
expect task_lock() will be OK.

> +		printk(KERN_ERR "Killed process %d (%s) "
> +		       "vsz:%lukB, anon-rss:%lukB, file-rss:%lukB\n",
> +		       task_pid_nr(p), p->comm,
> +		       K(p->mm->total_vm),
> +		       K(get_mm_counter(p->mm, anon_rss)),
> +		       K(get_mm_counter(p->mm, file_rss)));
> +		task_unlock(p);
> +	}

