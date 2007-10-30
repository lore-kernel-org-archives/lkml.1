Return-Path: <linux-kernel-owner+w=401wt.eu-S1756177AbXJ3RlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177AbXJ3RlR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 13:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752300AbXJ3RlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 13:41:05 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2604 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549AbXJ3RlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 13:41:04 -0400
Subject: Re: [PATCH 3/4] UML - Implement get_wchan
From: Joe Perches <joe@perches.com>
To: Jeff Dike <jdike@addtoit.com>
Cc: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
In-Reply-To: <20071030172849.GA8367@c2.user-mode-linux.org>
References: <20071030172849.GA8367@c2.user-mode-linux.org>
Content-Type: text/plain
Date: Tue, 30 Oct 2007 10:40:46 -0700
Message-Id: <1193766046.24844.19.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-30 at 13:28 -0400, Jeff Dike wrote:
> +unsigned long get_wchan(struct task_struct *p)
> +{
> +	unsigned long stack_page, sp, ip, count = 0;

Perhaps instead of unsigned long?

bool skipped_ip;	//delayed initialization

> +
> +	if ((p == NULL) || (p == current) || (p->state == TASK_RUNNING))
> +		return 0;
> +
> +	stack_page = (unsigned long) task_stack_page(p);
> +	/* Bail if the process has no kernel stack for some reason */
> +	if (stack_page == 0)
> +		return 0;
> +
> +	sp = p->thread.switch_buf->JB_SP;
> +	/*
> +	 * Bail if the stack pointer is below the bottom of the kernel
> +	 * stack for some reason
> +	 */
> +	if (sp < stack_page)
> +		return 0;
> +

	skipped_ip = false;

> +	while (sp < stack_page + THREAD_SIZE) {
> +		ip = *((unsigned long *) sp);
> +		if (kernel_text_address(ip) && !in_sched_functions(ip)) {
> +			/*
> +			 * Skip one valid IP, which will be the low-level UML
> +			 * context switcher.
> +			 */
> +			if (count++ == 1)
> +				return ip;

			if (skipped_ip)
				return ip;
			skipped_ip = true;
> 
> +		}
> +
> +		sp += sizeof(unsigned long);
> +	}


