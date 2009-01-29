Return-Path: <linux-kernel-owner+w=401wt.eu-S1758307AbZA2PAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758307AbZA2PAK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 10:00:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753951AbZA2O74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 09:59:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38514 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753854AbZA2O74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 09:59:56 -0500
Date: Thu, 29 Jan 2009 15:59:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frank Mehnert <Frank.Mehnert@Sun.COM>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH] x86: add might_sleep() to do_page_fault()
Message-ID: <20090129145921.GC6512@elte.hu>
References: <200901290905.10966.frank.mehnert@sun.com> <200901291502.48312.frank.mehnert@sun.com> <1233238854.4495.93.camel@laptop> <200901291541.32618.frank.mehnert@sun.com> <1233241003.4495.97.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233241003.4495.97.camel@laptop>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> VirtualBox calls do_page_fault() from an atomic context but runs into a
> might_sleep() way pas this point, cure that.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  arch/x86/mm/fault.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index 67e4df5..bb7f946 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -908,6 +908,11 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
>  		}
>  		down_read(&mm->mmap_sem);
>  	}
> +	/*
> +	 * The above down_read_trylock() might have succeeded in which case
> +	 * we'll have missed the might_sleep() from down_read().
> +	 */
> +	might_sleep();

should go into the 'else' branch i guess? In the down_read() case we 
already had the check.

	Ingo
