Return-Path: <linux-kernel-owner+w=401wt.eu-S1756065AbZD2Lfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065AbZD2Lfu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 07:35:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752146AbZD2Lfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 07:35:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50885 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757AbZD2Lfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 07:35:39 -0400
Date: Wed, 29 Apr 2009 13:34:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, sam@ravnborg.org, tabbott@MIT.EDU,
       tglx@linutronix.de
Subject: Re: [tip:x86/kbuild] x86, vmlinux.lds: fix relocatable symbols
Message-ID: <20090429113454.GA11586@elte.hu>
References: <20090429105056.GA28720@uranus.ravnborg.org> <tip-fd0731944333db6e9e91b6954c6ef95f4b71ab04@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-fd0731944333db6e9e91b6954c6ef95f4b71ab04@git.kernel.org>
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


* tip-bot for Ingo Molnar <mingo@elte.hu> wrote:

> Commit-ID:  fd0731944333db6e9e91b6954c6ef95f4b71ab04
> Gitweb:     http://git.kernel.org/tip/fd0731944333db6e9e91b6954c6ef95f4b71ab04
> Author:     Ingo Molnar <mingo@elte.hu>
> AuthorDate: Wed, 29 Apr 2009 12:56:58 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Wed, 29 Apr 2009 13:01:18 +0200
> 
> x86, vmlinux.lds: fix relocatable symbols
> 
> __init_begin/_end symbols should be inside sections as well,
> otherwise the relocatable kernel gets confused when freeing
> init sections in the wrong place.
> 
> [ Impact: fix bootup crash ]
> 
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: Tim Abbott <tabbott@MIT.EDU>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> LKML-Reference: <20090429105056.GA28720@uranus.ravnborg.org>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> ---
>  arch/x86/kernel/vmlinux.lds.S |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
> index 0bdbaa5..4c85b2e 100644
> --- a/arch/x86/kernel/vmlinux.lds.S
> +++ b/arch/x86/kernel/vmlinux.lds.S
> @@ -255,8 +255,8 @@ SECTIONS
>  
>  	/* Init code and data - will be freed after init */
>  	. = ALIGN(PAGE_SIZE);
> -	__init_begin = .; /* paired with __init_end */
>  	.init.text : AT(ADDR(.init.text) - LOAD_OFFSET) {
> +		__init_begin = .; /* paired with __init_end */
>  		_sinittext = .;
>  		INIT_TEXT
>  		_einittext = .;
> @@ -346,8 +346,11 @@ SECTIONS
>  #endif
>  
>  	. = ALIGN(PAGE_SIZE);
> +
>  	/* freed after init ends here */
> -	__init_end = .;
> +	.init.end : AT(ADDR(.init.end) - LOAD_OFFSET) {
> +		__init_end = .;
> +	}
>  
>  #ifdef CONFIG_X86_64
>  	.data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) {

For the record - this fixed the crash i reported. No further 
problems so far, with about 200 test iterations on 7 boxes.

	Ingo
