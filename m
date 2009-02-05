Return-Path: <linux-kernel-owner+w=401wt.eu-S1756458AbZBEX6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756458AbZBEX6e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 18:58:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755816AbZBEX6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 18:58:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36902 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755751AbZBEX6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 18:58:19 -0500
Date: Fri, 6 Feb 2009 00:57:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Nick Piggin <npiggin@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       systemtap-ml <systemtap@sources.redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [BUGFIX][PATCH -rc/-mm] prevent kprobes from catching spurious
	page  faults
Message-ID: <20090205235727.GA16040@elte.hu>
References: <497FC3B1.7050805@redhat.com> <497FE895.1080708@redhat.com> <20090128154824.GA6025@Krystal> <49808EEF.1020700@redhat.com> <20090128171331.GA9006@Krystal> <49809CCE.40409@redhat.com> <20090128181053.GC9908@Krystal> <498B6457.20302@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498B6457.20302@redhat.com>
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


* Masami Hiramatsu <mhiramat@redhat.com> wrote:

> -	if (notify_page_fault(regs))
> -		return;
>  	if (unlikely(kmmio_fault(regs, address)))
>  		return;
> 
> @@ -634,6 +632,9 @@ void __kprobes do_page_fault(struct pt_r
>  		if (spurious_fault(address, error_code))
>  			return;
> 
> +		/* kprobes don't want to hook the spurious faults. */
> +		if (notify_page_fault(regs))
> +			return;
>  		/*
>  		 * Don't take the mm semaphore here. If we fixup a prefetch
>  		 * fault we could otherwise deadlock.
> @@ -641,6 +642,9 @@ void __kprobes do_page_fault(struct pt_r
>  		goto bad_area_nosemaphore;
>  	}
> 
> +	/* kprobes don't want to hook the spurious faults. */
> +	if (notify_page_fault(regs))
> +		return;

I dont know - this spreads that callback to two places now. Any
reason why kprobes cannot call spurious_fault(), if there's a
probe active?

Also, moving that would remove the planned cleanup of merging these
two into one call:

 	if (notify_page_fault(regs))
 		return;
  	if (unlikely(kmmio_fault(regs, address)))
  		return;

We should reduce the probing cross section, not increase it,
especially in such a critical codepath as the pagefault handler.

Btw., why cannot kprobes install a dynamic probe to the fault
handler itself? That way the default path would have no such
callbacks and checks at all.

	Ingo
