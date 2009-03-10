Return-Path: <linux-kernel-owner+w=401wt.eu-S1755981AbZCJOlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981AbZCJOlJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 10:41:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752971AbZCJOkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 10:40:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55488 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752247AbZCJOky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 10:40:54 -0400
Date: Tue, 10 Mar 2009 15:40:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: prasad@linux.vnet.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [patch 08/11] Modify Ptrace routines to access breakpoint
	registers
Message-ID: <20090310144002.GF3850@elte.hu>
References: <20090305043440.189041194@linux.vnet.ibm.com> <20090305044051.GI17747@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090305044051.GI17747@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* prasad@linux.vnet.ibm.com <prasad@linux.vnet.ibm.com> wrote:

> -static unsigned long debugreg_addr_limit(struct task_struct *task)
> -{
> -#ifdef CONFIG_IA32_EMULATION
> -	if (test_tsk_thread_flag(task, TIF_IA32))
> -		return IA32_PAGE_OFFSET - 3;
> -#endif
> -	return TASK_SIZE_MAX - 7;
> -}
> -

I dont see where this security check has been carried over into 
the generic code. The new code has:

 +int arch_check_va_in_userspace(unsigned long va, struct task_struct *tsk)
 +{
 +       return (va < TASK_SIZE);
 +}

but i think that misses the detail that it's not just the start 
address of an x86 breakpoint that has to be considered, but also 
the end addess of it.

For example a hardware breakpoint can be at 0xbfffffff with a 
length of 4 bytes - thus overlapping into kernel-space by 3 
bytes. It is important to not let that happen.

	Ingo
