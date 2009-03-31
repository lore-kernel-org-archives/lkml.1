Return-Path: <linux-kernel-owner+w=401wt.eu-S1764677AbZCaXwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764677AbZCaXwU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 19:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764841AbZCaXv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 19:51:57 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55157 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764792AbZCaXv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 19:51:56 -0400
Date: Wed, 1 Apr 2009 01:48:23 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Markus Metzger <markus.t.metzger@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, markus.t.metzger@gmail.com, roland@redhat.com,
       eranian@googlemail.com, juan.villacis@intel.com, ak@linux.jf.intel.com
Subject: Re: [patch 1/21] x86, bts: fix race when bts tracer is removed
Message-ID: <20090331234823.GB28228@redhat.com>
References: <20090331145051.A12111@sedona.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090331145051.A12111@sedona.ch.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31, Markus Metzger wrote:
>
> Read the tracer once during a context switch.
> ...
> @@ -1044,36 +1051,39 @@ void ds_switch_to(struct task_struct *pr
>  {
>  	struct ds_context *prev_ctx = prev->thread.ds_ctx;
>  	struct ds_context *next_ctx = next->thread.ds_ctx;
> +	unsigned long debugctlmsr = next->thread.debugctlmsr;
>
>  	if (prev_ctx) {
> +		struct bts_tracer *tracer = prev_ctx->bts_master;
> +
>  		update_debugctlmsr(0);
>
> -		if (prev_ctx->bts_master &&
> -		    (prev_ctx->bts_master->trace.ds.flags & BTS_TIMESTAMPS)) {
> +		if (tracer && (tracer->flags & BTS_TIMESTAMPS)) {

In theory, we need barrier() after reading ->bts_master.

(actually, I did see the bug reports when the compiler read the pointer
 twice with the code like above).

Off-topic, but afaics modulo bts_task_departs/bts_task_arrives we
have the identical code for prev_ctx/next_ctx, perhaps it makes
sense to make a helper which calls bts_write().



To clarify, even _if_ I am right and _if_ you agree, we can do this
later, I am not suggesting to change this patch right now.

Oleg.

