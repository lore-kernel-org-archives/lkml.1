Return-Path: <linux-kernel-owner+w=401wt.eu-S1761857AbZCXSwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761857AbZCXSwp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 14:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761014AbZCXSwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 14:52:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56369 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759867AbZCXSwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 14:52:20 -0400
Date: Tue, 24 Mar 2009 19:51:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       ltt-dev@lists.casi.polymtl.ca, linux-mm@kvack.org,
       Dave Hansen <haveblue@us.ibm.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [patch 9/9] LTTng instrumentation - swap
Message-ID: <20090324185128.GJ31117@elte.hu>
References: <20090324155625.420966314@polymtl.ca> <20090324160149.188175023@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324160149.188175023@polymtl.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> +DECLARE_TRACE(swap_in,
> +	TPPROTO(struct page *page, swp_entry_t entry),
> +		TPARGS(page, entry));
> +DECLARE_TRACE(swap_out,
> +	TPPROTO(struct page *page),
> +		TPARGS(page));
> +DECLARE_TRACE(swap_file_open,
> +	TPPROTO(struct file *file, char *filename),
> +		TPARGS(file, filename));
> +DECLARE_TRACE(swap_file_close,
> +	TPPROTO(struct file *file),
> +		TPARGS(file));

These are more complete than the pagecache tracepoints, but still 
incomplete to make a comprehensive picture about swap activities.

Firstly, the swap_file_open/close events seem quite pointless. Most 
systems enable swap during bootup and never close it. These 
tracepoints just wont be excercised in practice.

Also, to _really_ help with debugging VM pressure problems, the 
whole LRU state-machine should be instrumented, and linked up with 
pagecache instrumentation via page frame numbers and (inode,offset) 
[file] and (pgd,addr) [anon] pairs.

Not just the fact that something got swapped out is interesting, but 
also the whole decision chain that leads up to it. The lifetime of a 
page how it jumps between the various stages of eviction and LRU 
scores.

a minor nit:

> +DECLARE_TRACE(swap_file_open,
> +	TPPROTO(struct file *file, char *filename),
> +		TPARGS(file, filename));

there's no need to pass in the filename - it can be deducted in the 
probe from struct file.

a small inconsistency:

> +DECLARE_TRACE(swap_in,
> +	TPPROTO(struct page *page, swp_entry_t entry),
> +		TPARGS(page, entry));
> +DECLARE_TRACE(swap_out,
> +	TPPROTO(struct page *page),
> +		TPARGS(page));

you pass in swp_entry to trace_swap_in(), which encodes the offset - 
but that parameter is not needed, the page already represents the 
offset at that stage in do_swap_page(). (the actual data is not read 
in yet from swap, but the page is already linked up in the 
swap-cache and has the offset available - which a probe can 
recover.)

So this suffices:

 DECLARE_TRACE(swap_in,
	TPPROTO(struct page *page),
		TPARGS(page));

 DECLARE_TRACE(swap_out,
	TPPROTO(struct page *page),
		TPARGS(page));

And here again i'd like to see actual meaningful probe contents via 
a TRACE_EVENT() construct. That shows and proves that it's all part 
of a comprehensive framework, and the data that is recovered is 
understood and put into a coherent whole - upstream. That makes it 
immediately useful to the built-in tracers, and will also cause 
fewer surprises downstream.

	Ingo
