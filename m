Return-Path: <linux-kernel-owner+w=401wt.eu-S1758723AbYESNCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758723AbYESNCZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:02:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751011AbYESNCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:02:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56067 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758144AbYESNCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:02:05 -0400
Date: Mon, 19 May 2008 15:01:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@qumranet.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make LIST_POISON less deadly
Message-ID: <20080519130151.GE13546@elte.hu>
References: <1211125094-32167-1-git-send-email-avi@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1211125094-32167-1-git-send-email-avi@qumranet.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Avi Kivity <avi@qumranet.com> wrote:

> The list macros use LIST_POISON1 and LIST_POISON2 as undereferencable 
> pointers in order to trap erronous use of freed list_heads.  
> Unfortunately userspace can arrange for those pointers to actually be 
> dereferencable, potentially turning an oops to an expolit.
> 
> To avoid this allow architectures (currently x86_64 only) to override 
> the default values for these pointers with truly-undereferncable 
> values. This is easy on x86_64 as the virtual address space is smaller 
> than the range spanned by pointer values.

nice idea!

i'd suggest a slightly different solution:

> +/*
> + * Define LIST_POISON[12] as pointers that cannot be dereferenced.
> + */
> +#ifdef CONFIG_X86_84
> +#  undef LIST_POISON1
> +#  undef LIST_POISON2
> +#  define LIST_POISON1 ((void *)0x8001000100010001L)
> +#  define LIST_POISON2 ((void *)0x8002000200020002L)
> +#endif

i'd suggest to add an ARCH_ILLEGAL_POINTER define instead, which 
defaults to zero and gets added to pointer-ish poison values. That makes 
it both simpler and also it does not need any include/asm changes 
because ARCH_ILLEGAL_POINTER can be set from the Kconfig space.

hm?

	Ingo
