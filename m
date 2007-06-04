Return-Path: <linux-kernel-owner+w=401wt.eu-S1754741AbXFDL2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbXFDL2O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 07:28:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753507AbXFDL17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 07:27:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56926 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753364AbXFDL17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 07:27:59 -0400
Date: Mon, 4 Jun 2007 13:27:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Smalley <sds@tycho.nsa.gov>,
       James Carter <jwcart2@tycho.nsa.gov>, Paul Moore <paul.moore@hp.com>,
       James Morris <jmorris@namei.org>
Subject: [bug] very high non-preempt latency in context_struct_compute_av()
Message-ID: <20070604112745.GA26350@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


a simple ssh login triggers a ~130 msecs non-preemptible latency even 
with CONFIG_PREEMPT enabled, on a fast Core2Duo CPU (!).

the latency is caused by a _very_ long loop in the SELinux code:

    sshd-4828  0.N.. 465894us : avtab_search_node (context_struct_compute_av)
    sshd-4828  0.N.. 465895us : cond_compute_av (context_struct_compute_av)
    sshd-4828  0.N.. 465895us : avtab_search_node (cond_compute_av)
    sshd-4828  0.N.. 465895us : avtab_search_node (context_struct_compute_av)
    sshd-4828  0.N.. 465896us : cond_compute_av (context_struct_compute_av)
    sshd-4828  0.N.. 465896us : avtab_search_node (cond_compute_av)
    sshd-4828  0.N.. 465896us : avtab_search_node (context_struct_compute_av)
    sshd-4828  0.N.. 465896us : cond_compute_av (context_struct_compute_av)
    sshd-4828  0.N.. 465896us : avtab_search_node (cond_compute_av)

it is triggered like this:

    sshd-4828  0..s. 462986us : tasklet_action (__do_softirq)
    sshd-4828  0..s. 462986us : rcu_process_callbacks (tasklet_action)
    sshd-4828  0..s. 462986us : __rcu_process_callbacks (rcu_process_callbacks)
    sshd-4828  0..s. 462987us : __rcu_process_callbacks (rcu_process_callbacks)
    sshd-4828  0D.s. 462987us : _local_bh_enable (__do_softirq)
    sshd-4828  0DN.. 462987us : idle_cpu (irq_exit)
    sshd-4828  0.N.. 462988us : avtab_search_node (context_struct_compute_av)
    sshd-4828  0.N.. 462989us : cond_compute_av (context_struct_compute_av)

and it ends like this after 130 msecs:

    sshd-4828  0.N.. 594068us : ebitmap_contains (constraint_expr_eval)
    sshd-4828  0.N.. 594068us : ebitmap_get_bit (constraint_expr_eval)
    sshd-4828  0.N.. 594068us : constraint_expr_eval (context_struct_compute_av)
    sshd-4828  0.N.. 594068us : ebitmap_contains (constraint_expr_eval)
    sshd-4828  0.N.. 594068us : ebitmap_get_bit (constraint_expr_eval)
    sshd-4828  0.N.. 594070us : sprintf (sel_write_user)
    sshd-4828  0.N.. 594070us : vsnprintf (sprintf)
    sshd-4828  0.N.. 594072us : number (vsnprintf)
    sshd-4828  0.N.. 594072us : security_sid_to_context (sel_write_user)
    sshd-4828  0.N.. 594073us : _read_lock (security_sid_to_context)
    sshd-4828  0.N.. 594073us : sidtab_search (security_sid_to_context)
    sshd-4828  0.N.. 594073us : context_struct_to_string (security_sid_to_context)
    sshd-4828  0.N.. 594074us : mls_compute_context_len (context_struct_to_string)
    sshd-4828  0.N.. 594075us : ebitmap_cmp (mls_compute_context_len)
    sshd-4828  0.N.. 594075us : __kmalloc (context_struct_to_string)
    sshd-4828  0.N.. 594076us : sprintf (context_struct_to_string)
    sshd-4828  0.N.. 594077us : vsnprintf (sprintf)

i've got the full trace saved away (200 MB ...) and can upload it, but 
it's just repetitions of the above lines.

The distribution is Fedora 7, v2.6.21 (but also happens in recent -git) 
and a simple 'ssh localhost' login is enough to trigger this. It 
triggers every time and this is causing audio skipping in certain apps. 
It is even visible in glxgears smoothness: a small 'bump' is visible in 
the otherwise smooth rotation of glxgears. Enabling CONFIG_PREEMPT does 
not fix this issue as the function runs under spinlocks. (enabling 
CONFIG_PREEMPT_RT in -rt fixes the issue - but that still leaves us with 
the huge 130 msecs cost of that function.)

	Ingo
