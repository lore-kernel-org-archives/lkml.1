Return-Path: <linux-kernel-owner+w=401wt.eu-S1761520AbZD1O7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761520AbZD1O7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 10:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754947AbZD1O7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 10:59:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49627 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753762AbZD1O7C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 10:59:02 -0400
Date: Tue, 28 Apr 2009 16:58:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] x86: cleanup alternative.h
Message-ID: <20090428145839.GA26546@elte.hu>
References: <20090422201852.092307236@polymtl.ca> <20090422202453.673946867@polymtl.ca> <20090428130501.GC26600@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090428130501.GC26600@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Ingo, do you think the cleanup below would be worth merging ? It 
> adds the ability to use ALTERNATIVE() directly in gcc inline 
> assembly _and_ cleans up the current alternative*() cut-and-paste 
> coding style. :)

Sure it's worth it! Your patch removes quite a bit of code:

   1 file changed, 22 insertions(+), 36 deletions(-)

One small style detail:

> +/* alternative assembly primitive */
> +#define ALTERNATIVE(oldinstr, newinstr, feature) \
> +	      "661:\n\t" oldinstr "\n662:\n"			\
> +	      ".section .altinstructions,\"a\"\n"		\
> +	      _ASM_ALIGN "\n"					\
> +	      _ASM_PTR "661b\n"		/* label */		\
> +	      _ASM_PTR "663f\n"		/* new instruction */	\
> +	      "	 .byte " __stringify(feature) "\n"	/* feature bit */ \
> +	      "	 .byte 662b-661b\n"	/* sourcelen */		\
> +	      "	 .byte 664f-663f\n"	/* replacementlen */	\
> +	      ".previous\n"					\
> +	      ".section .altinstr_replacement,\"ax\"\n"		\
> +	      "663:\n\t" newinstr "\n664:\n"  /* replacement */	\
> +	      ".previous"

Please try to align both the continuation backslashes and the 
comments vertically. Something like:

> +#define ALTERNATIVE(oldinstr, newinstr, feature)			 \
> +									 \
> +	"661:\n\t" oldinstr "\n662:\n"					 \
> +	".section .altinstructions,\"a\"\n"			 	 \
> +	_ASM_ALIGN "\n"						 	 \
> +	_ASM_PTR "661b\n"			   /* label           */ \
> +	_ASM_PTR "663f\n"			   /* new instruction */ \
> +	 "	 .byte " __stringify(feature) "\n" /* feature bit     */ \
> +	 "	 .byte 662b-661b\n"		   /* sourcelen       */ \
> +	 "	 .byte 664f-663f\n"		   /* replacementlen  */ \ 

... should do the trick. (also note the extra line after the #define)

	Ingo
