Return-Path: <linux-kernel-owner+w=401wt.eu-S1767323AbXECCZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767323AbXECCZl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 22:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767330AbXECCZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 22:25:41 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:47804 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767323AbXECCZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 22:25:40 -0400
Date: Wed, 2 May 2007 19:25:34 -0700
From: Bill Irwin <bill.irwin@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       wli@holomorphy.com
Subject: Re: [PATCH] i386: fix suspend/resume with dynamically allocated irq stacks
Message-ID: <20070503022534.GD26598@holomorphy.com>
Mail-Followup-To: Bill Irwin <bill.irwin@oracle.com>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46394139.605@goop.org>
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2007 at 06:56:09PM -0700, Jeremy Fitzhardinge wrote:
> +static void __cpuinit __free_irqstack(int cpu, void *stk)
> +{
> +	int i;
> +
> +	if (!cpu)
> +		return;
> +
> +	unmap_vm_area(per_cpu(irqstack_area, cpu));
> +
> +	for (i = 0; i < THREAD_SIZE/PAGE_SIZE; ++i)
> +		__free_page(per_cpu(irqstack_pages, cpu)[i]);
> +}

This will leak the vm_struct and also leave it in the vmlist.
work_free_thread_info() needs to be redone too. It should be

	remove_vm_area( /* unmap and remove the vm_struct from vmlist */ );
	kfree( /* free the vm_struct */ );
	for (i = 0; i < THREAD_SIZE/PAGE_SIZE; ++i)
		__free_page( /* dredge up the appropriate page to free */ );


-- wli
