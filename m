Return-Path: <linux-kernel-owner+w=401wt.eu-S934453AbZDCR3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934453AbZDCR3W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 13:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933850AbZDCR3B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 13:29:01 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:52435 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761167AbZDCR27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 13:28:59 -0400
Subject: Re: [PATCH -tip 4/6 V4.1] x86: kprobes checks safeness of
	insertion address.
From: Jim Keniston <jkenisto@us.ibm.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: ananth@in.ibm.com, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>, kvm@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <49D63327.8020009@redhat.com>
References: <49D4F4E9.2030809@redhat.com> <20090403051854.GA4846@in.ibm.com>
	 <49D63327.8020009@redhat.com>
Content-Type: text/plain
Date: Fri, 03 Apr 2009 10:28:06 -0700
Message-Id: <1238779686.3568.18.camel@dyn9047018139.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-03 at 12:02 -0400, Masami Hiramatsu wrote:
> Ensure safeness of inserting kprobes by checking whether the specified
> address is at the first byte of a instruction. This is done by decoding
> probed function from its head to the probe point.
> 
> changes from v4:
>  - change a comment according to Ananth's suggestion.
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> Cc: Jim Keniston <jkenisto@us.ibm.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
> 
>  arch/x86/kernel/kprobes.c |   51 +++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 51 insertions(+), 0 deletions(-)
> 
> 
> diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
...
> 
> +/* Recover original instruction */

/* Recover the probed instruction at addr for further analysis. */
See below.

> +static int recover_probed_instruction(kprobe_opcode_t *buf, unsigned long addr)
> +{
> +	struct kprobe *kp;
> +	kp = get_kprobe((void *)addr);
> +	if (!kp)
> +		return -EINVAL;
> +
> +	/* Don't use p->ainsn.insn; which will be modified by fix_riprel */

fix_riprel doesn't affect the instruction's length, which is what
concerns this patch.  But we want this function to be useful for
unforeseen uses as well, so I like the code you have.  Just consider the
suggested comment changes.

	/*
	 * Don't use p->ainsn.insn, which could be modified -- e.g.,
	 * by fix_riprel().
	 */

> +	memcpy(buf, kp->addr, MAX_INSN_SIZE * sizeof(kprobe_opcode_t));
> +	buf[0] = kp->opcode;
> +	return 0;
> +}

Jim Keniston

