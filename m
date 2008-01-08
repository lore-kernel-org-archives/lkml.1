Return-Path: <linux-kernel-owner+w=401wt.eu-S1762300AbYAHQ4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762300AbYAHQ4a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 11:56:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753980AbYAHQ4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 11:56:20 -0500
Received: from ns2.suse.de ([195.135.220.15]:45461 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762214AbYAHQ4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 11:56:19 -0500
To: Changli Gao <xiaosuo@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Improve scalability of epoll_ctl
From: Andi Kleen <andi@firstfloor.org>
References: <478397F7.1030005@gmail.com>
Date: Tue, 08 Jan 2008 17:56:18 +0100
In-Reply-To: <478397F7.1030005@gmail.com> (Changli Gao's message of "Tue\, 08 Jan 2008 23\:34\:15 +0800")
Message-ID: <p73k5mkqmrx.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changli Gao <xiaosuo@gmail.com> writes:

> Replace the epitem rbtree with a dynamic array to get the constant insertion/deletion/modification time of the file descriptors. Reuse the size argument of epoll_create, however the size must be smaller than the max file descriptor number: ether the resource limitation or the compiling time limitation.

Numbers, numbers, numbers on the improvement missing? 

> +	if (size < PAGE_SIZE / sizeof(struct epitem*)) {
> +		ep->epi_array = kmalloc(msize, GFP_KERNEL);
> +		ep->epi_array_size = size;
> +	} else {
> +		msize = PAGE_ALIGN(msize);
> +		ep->epi_array = vmalloc(msize);

Are you sure it's faster? vmalloc/vfree can be quite slow because
they have to change the MMU state of the kernel and take global
locks. 

The other problem is that on 32bit systems vmalloc space is somewhat
limited -- you might have added an unintended scaling limit.

-Andi
