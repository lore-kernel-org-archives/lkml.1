Return-Path: <linux-kernel-owner+w=401wt.eu-S1161309AbXBUPxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161309AbXBUPxu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 10:53:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161314AbXBUPxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 10:53:50 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:40235 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161296AbXBUPxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 10:53:48 -0500
Subject: Re: [PATCH 03/29] mm: allow PF_MEMALLOC from softirq context
From: Arjan van de Ven <arjan@infradead.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Thomas Graf <tgraf@suug.ch>, David Miller <davem@davemloft.net>
In-Reply-To: <20070221144841.823705000@taijtu.programming.kicks-ass.net>
References: <20070221144304.512721000@taijtu.programming.kicks-ass.net>
	 <20070221144841.823705000@taijtu.programming.kicks-ass.net>
Content-Type: text/plain
Organization: Intel International BV
Date: Wed, 21 Feb 2007 16:53:37 +0100
Message-Id: <1172073217.3531.200.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Index: linux-2.6-git/kernel/softirq.c
> ===================================================================
> --- linux-2.6-git.orig/kernel/softirq.c	2006-12-14 10:02:18.000000000 +0100
> +++ linux-2.6-git/kernel/softirq.c	2006-12-14 10:02:52.000000000 +0100
> @@ -209,6 +209,8 @@ asmlinkage void __do_softirq(void)
>  	__u32 pending;
>  	int max_restart = MAX_SOFTIRQ_RESTART;
>  	int cpu;
> +	unsigned long pflags = current->flags;
> +	current->flags &= ~PF_MEMALLOC;
>  
>  	pending = local_softirq_pending();
>  	account_system_vtime(current);
> @@ -247,6 +249,7 @@ restart:
>  
>  	account_system_vtime(current);
>  	_local_bh_enable();
> +	current->flags = pflags;

this wipes out all the flags in one go.... evil.
What if something just selected this process for OOM killing? you nuke
that flag here again. Would be nicer if only the PF_MEMALLOC bit got
inherited in the restore path..




