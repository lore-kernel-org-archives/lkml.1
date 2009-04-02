Return-Path: <linux-kernel-owner+w=401wt.eu-S1756186AbZDBLhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186AbZDBLhB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 07:37:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbZDBLgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 07:36:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36361 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218AbZDBLgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 07:36:51 -0400
Date: Thu, 2 Apr 2009 13:36:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] perf_counter: add more context information
Message-ID: <20090402113643.GF10828@elte.hu>
References: <20090402091158.291810516@chello.nl> <20090402091319.493101305@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090402091319.493101305@chello.nl>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> Put in counts to tell which ips belong to what context.
> 
>   -----
>    | |  hv
>    | --
> nr | |  kernel
>    | --
>    | |  user
>   -----

btw., i have an observation about the format:

> -#define MAX_STACK_DEPTH		255
> +#define MAX_STACK_DEPTH		254
>  
>  struct perf_callchain_entry {
> -	u64	nr;
> +	u32	nr, hv, kernel, user;
>  	u64	ip[MAX_STACK_DEPTH];
>  };

For the special case of signal notifications, if the signal is 
delivered immediately to the same task that raised it (pid=0), the 
call chain is actually a still meaningful one: it is the stack that 
is below the currently executing signal handler context.

Wouldnt it make sense to record the full stack frame for that case, 
to allow walking/unwinding of the stack? Or can user-space do that 
just fine, based on its own signal context?

We are going to hard-code the "call-chain is a series of IPs, 
nothing else" model, and i'd like to make sure it's future-proof :)

	Ingo
