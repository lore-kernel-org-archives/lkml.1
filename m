Return-Path: <linux-kernel-owner+w=401wt.eu-S1754548AbYCJDtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbYCJDtn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 23:49:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753562AbYCJDte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 23:49:34 -0400
Received: from mga03.intel.com ([143.182.124.21]:47164 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752912AbYCJDte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 23:49:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,472,1199692800"; 
   d="scan'208";a="216690867"
Subject: Re: [PATCH -mm] kprobes: kprobe-booster for ia64
From: Shaohua Li <shaohua.li@intel.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, ia64 <linux-ia64@vger.kernel.org>,
       "Luck, Tony" <tony.luck@intel.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       systemtap-ml <systemtap@sources.redhat.com>
In-Reply-To: <47D166E7.2050803@redhat.com>
References: <47D166E7.2050803@redhat.com>
Content-Type: text/plain
Date: Mon, 10 Mar 2008 11:43:20 +0800
Message-Id: <1205120600.20271.3.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-03-08 at 00:01 +0800, Masami Hiramatsu wrote:
> From: Masami Hiramatsu <mhiramat@redhat.com>
> 

> +
> +/*
> + * In this function, we check whether the target bundle modifies IP
> or
> + * it triggers an exception. If so, it cannot be boostable.
> + */
> +static int __kprobes can_boost(bundle_t *bundle, uint slot,
> +                              unsigned long bundle_addr)
> +{
> +       unsigned int template = bundle->quad0.template;
> +
> +       do {
> +               if (search_exception_tables(bundle_addr + slot) ||
> +                   __is_ia64_break_inst(bundle, slot))
> +                       return 0;       /* exception may occur in this
> bundle*/
> +       } while ((++slot) < 3);
> +       template &= 0x1e;
> +       if (template >= 0x10 /* including B unit */ ||
> +           template == 0x04 /* including X unit */ ||
> +           template == 0x06) /* undefined */
> +               return 0;
> +
> +       return 1;
> +}
> +
> +/* Prepare long jump bundle and disables other boosters if need */
> +static void __kprobes prepare_booster(struct kprobe *p)
> +{
> +       unsigned long addr = (unsigned long)p->addr & ~0xFULL;
> +       unsigned int slot = addr & 0xf;
slot = (unsigned long)p->addr & 0xf ?

> +       struct kprobe *other_kp;
> +
> +       if (can_boost(&p->ainsn.insn[0].bundle, slot, addr)) {
> +               set_brl_inst(&p->ainsn.insn[1].bundle, (bundle_t
> *)addr + 1);
> +               p->ainsn.inst_flag |= INST_FLAG_BOOSTABLE;
> +       }
> +
> +       /* disables boosters in previous slots */
> +       for (; addr < (unsigned long)p->addr; addr++) {
> +               other_kp = get_kprobe((void *)addr);
> +               if (other_kp)
> +                       other_kp->ainsn.inst_flag &=
> ~INST_FLAG_BOOSTABLE;
> +       }
> +}
> +
There is no lock to protect the flag. If one cpu invokes other_kp and
the other cpu is changing the flag, what's the result?

Thanks,
Shaohua

