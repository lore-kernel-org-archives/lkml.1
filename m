Return-Path: <linux-kernel-owner+w=401wt.eu-S1423357AbXBPGo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423357AbXBPGo4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 01:44:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423358AbXBPGo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 01:44:56 -0500
Received: from smtp.osdl.org ([65.172.181.24]:54161 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423357AbXBPGoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 01:44:55 -0500
Date: Thu, 15 Feb 2007 22:43:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@muc.de>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       "Jan Beulich" <JBeulich@novell.com>
Subject: Re: [patch 12/21] Xen-paravirt: Allocate and free vmalloc areas
Message-Id: <20070215224322.5c73d8e9.akpm@linux-foundation.org>
In-Reply-To: <20070216022531.417300365@goop.org>
References: <20070216022449.739760547@goop.org>
	<20070216022531.417300365@goop.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Feb 2007 18:25:01 -0800 Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> +void lock_vm_area(struct vm_struct *area)
> +{
> +	unsigned long i;
> +	char c;
> +
> +	/*
> +	 * Prevent context switch to a lazy mm that doesn't have this area
> +	 * mapped into its page tables.
> +	 */
> +	preempt_disable();
> +
> +	/*
> +	 * Ensure that the page tables are mapped into the current mm. The
> +	 * page-fault path will copy the page directory pointers from init_mm.
> +	 */
> +	for (i = 0; i < area->size; i += PAGE_SIZE)
> +		(void)__get_user(c, (char __user *)area->addr + i);
> +}
> +EXPORT_SYMBOL_GPL(lock_vm_area);

This won't work when CONFIG_PREEMPT=y.  The pagefault handler will see
in_atomic() and will scram.

(pet-peeve-from-someone-who-remembers-fortran: the reader expects the
variable `i' to be signed.  signed int really)
