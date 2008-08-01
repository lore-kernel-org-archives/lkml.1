Return-Path: <linux-kernel-owner+w=401wt.eu-S1754325AbYHAOCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325AbYHAOCT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 10:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752816AbYHAOCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 10:02:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44070 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752294AbYHAOCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 10:02:08 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080728150501.GC16555@linux-sh.org>
References: <20080728150501.GC16555@linux-sh.org> <20080728150359.GA16555@linux-sh.org> <20080728150430.GB16555@linux-sh.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] binfmt_elf_fdpic: Convert initial stack alignment to arch_align_stack().
X-Mailer: MH-E 8.0.3+cvs; nmh 1.3; GNU Emacs 23.0.50
Date: Fri, 01 Aug 2008 15:01:19 +0100
Message-ID: <27552.1217599279@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mundt <lethal@linux-sh.org> wrote:

> +	 * In some cases (e.g. Hyper-Threading), we want to avoid L1
> +	 * evictions by the processes running on the same package. One
> +	 * thing we can do is to shuffle the initial stack for them, so
> +	 * we give the architecture an opportunity to do so here.
> +	 */
>  #ifdef CONFIG_MMU
> -	sp = bprm->p;
> +	sp = arch_align_stack(bprm->p);
>  #else
> -	sp = mm->start_stack;
> +	sp = arch_align_stack(mm->start_stack);

Ummm...  You're calling arch_align_stack() under NOMMU...  Is that really a
good idea?

You can't necessarily move the stack pointer without exiting the allocated
region or shrinking the amount of stack space the executable asked for.  If
you want to do this sort of thing, you need to tell the memory allocator what
you're up to - or at the very least allocate some slack.

David
