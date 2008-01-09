Return-Path: <linux-kernel-owner+w=401wt.eu-S1753122AbYAIGOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122AbYAIGOx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 01:14:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750867AbYAIGOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 01:14:45 -0500
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:57343 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbYAIGOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 01:14:44 -0500
Date: Wed, 9 Jan 2008 07:14:08 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       David Miller <davem@davemloft.net>, hskinnemoen@atmel.com,
       schwidefsky@de.ibm.com, tony.luck@intel.com,
       Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCHv3] kprobes: Introduce kprobe_handle_fault()
Message-ID: <20080109061408.GA9486@osiris.ibm.com>
References: <1199737486.7666.12.camel@brick> <18307.64807.204087.375733@cargo.ozlabs.ibm.com> <1199833324.6424.12.camel@brick> <1199852360.6424.39.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199852360.6424.39.camel@brick>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +/*
> + * If it is a kprobe pagefault we can not be premptible so return before

Missing 'e' in preemptible.
However, the old code you removed had a lot of preempt_disable/enable calls
that you removed. Hope you checked that preemption was always disabled
already and the calls were not necessary (true at least for s390).

Are there cases where this code could be called with preemption enabled?
If so then that looks like a bug anyway. I'd say the preemptible check
should be removed or turned into a WARN_ON.

> + * calling kprobe_running() as it will assert on smp_processor_id if
> + * preemption is enabled.
> + */
> +static inline int kprobe_handle_fault(struct pt_regs *regs, int trapnr)
> +{
> +	if (!user_mode(regs) && !preemptible() && kprobe_running() &&
> +	    kprobe_fault_handler(regs, trapnr))
> +		return 1;
> +	else
> +		return 0;

I like this better (not including any other changes):

	if (!user_mode(regs) && !preemptible() && kprobe_running())
		return kprobe_fault_handler(regs, trapnr);
	return 0;
