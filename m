Return-Path: <linux-kernel-owner+w=401wt.eu-S1753931AbYKUHxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931AbYKUHxV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 02:53:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbYKUHxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 02:53:09 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39472 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220AbYKUHxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 02:53:08 -0500
Date: Fri, 21 Nov 2008 08:52:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Liming Wang <liming.wang@windriver.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] function tracing: fix wrong position computing of
	stack_trace
Message-ID: <20081121075256.GA16242@elte.hu>
References: <1227236418-6023-1-git-send-email-liming.wang@windriver.com> <1227236418-6023-2-git-send-email-liming.wang@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227236418-6023-2-git-send-email-liming.wang@windriver.com>
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


* Liming Wang <liming.wang@windriver.com> wrote:

> Impact: make output of stack_trace complete if buffer overflow
> 
> When read buffer overflows, the output of stack_trace isn't 
> complete.
> 
> When printing records with seq_printf in t_show, if the read buffer 
> has overflowed by the current record, then this record won't be 
> printed to user space through read buffer, it will just be dropped 
> in this printing.
> 
> When next printing, t_start should return the "*pos"th record, which 
> is the one dropped by previous printing, but it just returns 
> (m->private + *pos)th record.
> 
> Here we use a more sane method to implement seq_operations which can 
> be found in kernel code. Thus we needn't initialize m->private.
> 
> About testing, it's not easy to overflow read buffer, but we can use 
> seq_printf to print more padding bytes in t_show, then it's easy to 
> check whether or not records are lost.
> 
> This commit has been tested on both condition of overflow and non 
> overflow.
> 
> Signed-off-by: Liming Wang <liming.wang@windriver.com>
> ---
>  kernel/trace/trace_stack.c |   24 +++++++++++++++---------
>  1 files changed, 15 insertions(+), 9 deletions(-)

applied to tip/tracing/urgent, thanks!

Note, i changed 'buffer overflow' to 'buffer overrun'. (buffer 
overflow is a term typically used in a security context)

> -	i++;
> +	if (v == SEQ_START_TOKEN )
> +		i = 0;
> +	else {
> +		i = *(long *)v;
> +		i++;
> +	}

i also fixed these two minor style problems pointed out by 
scripts/checkpatch.pl:

| ERROR: space prohibited before that close parenthesis ')'
| #47: FILE: kernel/trace/trace_stack.c:187:
| +	if (v == SEQ_START_TOKEN )
|
| ERROR: space prohibited before that close parenthesis ')'
| #82: FILE: kernel/trace/trace_stack.c:245:
| +	if (v == SEQ_START_TOKEN ) {
|
| total: 2 errors, 0 warnings, 0 checks, 64 lines checked

	Ingo
