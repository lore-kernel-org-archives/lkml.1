Return-Path: <linux-kernel-owner+w=401wt.eu-S1752071AbZA3RK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071AbZA3RK0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 12:10:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751824AbZA3RKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 12:10:12 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44817 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751618AbZA3RKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 12:10:10 -0500
Date: Fri, 30 Jan 2009 09:08:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>,
       Ingo Molnar <mingo@redhat.com>, Dave Jones <davej@redhat.com>,
       cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] work_on_cpu: Use our own workqueue.
Message-Id: <20090130090835.416e7662.akpm@linux-foundation.org>
In-Reply-To: <20090130134935.GC17401@elte.hu>
References: <20090116191108.135927000@polaris-admin.engr.sgi.com>
	<200901291213.32959.rusty@rustcorp.com.au>
	<20090128181205.3b15fa4a.akpm@linux-foundation.org>
	<200901301633.54013.rusty@rustcorp.com.au>
	<20090129223042.47dc42a1.akpm@linux-foundation.org>
	<20090130134935.GC17401@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Jan 2009 14:49:35 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> > So we still don't have any non-buggy proposal.
> 
> Current upstream code is not pretty (due to the extra workqueue) but not 
> buggy either. You'd be right to point out that it is easy to insert a bug 
> into it and thus it's not pleasant (more of a workaround than a real fix) 
> but if it's outright buggy then please talk up.

OK, so we're not aware of anything in there which will trigger the bug
yet.  Although allocate_threshold_blocks() takes about half the locks in
the kernel - it can run an ext3 commit, it does netlink tx, synchronous
process exec, etc.

Why not give up and kill the whole work_on_cpu() thing?  afaict the
only caller which cannot be immediately switched to use an IPI is
mce_amd_64's allocate_threshold_blocks(), and it looks like that can be
trivially fixed by moving the entire function except for one rdmsr() up
into the caller.  

