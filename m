Return-Path: <linux-kernel-owner+w=401wt.eu-S1759784AbZEKVnE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759784AbZEKVnE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 17:43:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756481AbZEKVmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 17:42:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58435 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757055AbZEKVmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 17:42:49 -0400
Date: Mon, 11 May 2009 14:36:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: gregkh@suse.de, npiggin@suse.de, mel@csn.ul.ie, a.p.ziljstra@chello.nl,
       cl@linux-foundation.org, dave@linux.vnet.ibm.com, san@android.com,
       arve@android.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 09/11 -mmotm] oom: return vm size of oom killed task
Message-Id: <20090511143621.31a4b4b8.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.0905101502270.18804@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0905101458430.18804@chino.kir.corp.google.com>
	<alpine.DEB.2.00.0905101502270.18804@chino.kir.corp.google.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 May 2009 15:07:23 -0700 (PDT)
David Rientjes <rientjes@google.com> wrote:

> It's not optimal to continuously loop in the page allocator if the oom
> killer fails to kill a task.

Ambiguous.  This means either "selected a task but failed to kill it"
or "failed to select any task to kill".

>  Thus, it's necessary to report how many
> pages may be freed when the task finally exits to determine if any
> progress has been made.

>From this I infer that you're referring to the first case.

Under which circumstances can this happen?  Should we just go on and
select another process?

> This also changes the TIF_MEMDIE exception in select_bad_process().  If
> a task is found with this thread flag set, yet it has already detached
> its memory, then an additional task is chosen since we are still out of
> memory.

hm, that was fairly dumb of us.

But what state is this task in?  Has it actually returned all its
memory to the page allocator, or is its memory in some limbo state?  If
so, what is that state and why did it happen?

> total_vm is used instead of the file and anon rss since this is what the
> badness scoring heuristic is based on and it may be possible to oom kill
> a task with no rss causing the page allocator to believe no progress has
> been made.
