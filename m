Return-Path: <linux-kernel-owner+w=401wt.eu-S1757951AbXGNHWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757951AbXGNHWv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 03:22:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751918AbXGNHWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 03:22:44 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:35483 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbXGNHWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 03:22:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=iBSgQzbZJdQegpOQ4bANjdRbsFOWtq4MSxfrBi8PBafxfzocWp+LMfIcr3RLVEIPS1x4ZnyY9u2p9/piL2aHWRBg3tXnMmA0EVRggKIOJtTkePGsqSQS8eebjmVNmvGpZSJLVrjOyB/LEdBkARlqerqV2vv/i8XW4ZXX71w2+lg=
Date: Sat, 14 Jul 2007 11:22:39 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] F00F bug fixup for i386 - use immediate values
Message-ID: <20070714072239.GA5822@martell.zuzino.mipt.ru>
References: <20070714012642.499375439@polymtl.ca> <20070714012743.511046887@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070714012743.511046887@polymtl.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2007 at 09:26:43PM -0400, Mathieu Desnoyers wrote:
> Use the faster immediate values for F00F bug handling in do_page_fault.

> --- linux-2.6-lttng.orig/arch/i386/mm/fault.c
> +++ linux-2.6-lttng/arch/i386/mm/fault.c
> @@ -492,7 +493,7 @@
>  	/*
>  	 * Pentium F0 0F C7 C8 bug workaround.
>  	 */
> -	if (boot_cpu_data.f00f_bug) {
> +	immediate_if (&f00f_bug_fix) {

This code is not called during normal pagefaults and even during invalid
userspace accesses.

Out of curiosity, I inserted printk() at this place to see where I was
wrong. I got only two hits:

	Checking if this processor honours the WP bit even in supervisor mode... do_page_fault:
	Freeing unused kernel memory: 116k freed
	do_page_fault:

Resume: nobody gives a fuck about performance of this particular if,
	so conversion it totally pointless.

