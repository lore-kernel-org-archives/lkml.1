Return-Path: <linux-kernel-owner+w=401wt.eu-S1763032AbYBFMxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763032AbYBFMxx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 07:53:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762517AbYBFMxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 07:53:43 -0500
Received: from mx1.redhat.com ([66.187.233.31]:51775 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762033AbYBFMxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 07:53:42 -0500
Message-ID: <47A9AD63.6060200@redhat.com>
Date: Wed, 06 Feb 2008 07:51:47 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, ia64 <linux-ia64@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: Re: [RFC][PATCH] kprobes: kprobe-booster for ia64
References: <47A8E995.1090400@redhat.com> <1FE6DD409037234FAB833C420AA843EC84804C@orsmsx424.amr.corp.intel.com>
In-Reply-To: <1FE6DD409037234FAB833C420AA843EC84804C@orsmsx424.amr.corp.intel.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Tony,

Thank you for review.
Luck, Tony wrote:
> +/* Insert a long branch code */
> +static void __kprobes set_brl_inst(void *from, void *to)
> +{
> +	s64 rel = ((s64) to - (s64) from) >> 4;
> +	bundle_t *brl;
> +	brl = (bundle_t *) ((u64) from & ~0xf);
> +	brl->quad0.template = 0x05;	/* [MLX](stop) */
> +	brl->quad0.slot0 = NOP_M_INST;	/* nop.m 0x0 */
> +	brl->quad0.slot1_p0 = ((rel >> 20) & 0x7fffffffff) << 2;
> +	brl->quad1.slot1_p1 = (((rel >> 20) & 0x7fffffffff) << 2) >> (64 - 46);
> +	/* brl.cond.sptk.many.clr rel<<4 (qp=0) */
> +	brl->quad1.slot2 = BRL_INST(rel >> 59, rel & 0xfffff);
> +}
> 
> Is this function operating directly on the instruction bundle in the
> kernel code?  If so, the bundle will contain some "interesting"
> intermediate values as each of the "brl->xxx = yyy;" are processed.
> If another cpu should try to execute this bundle while the modifications
> are in progress, then the results will be not what you want.

No, this function writes brl on kprobe's instruction buffer
(kprobe.ainsn.insn->bundle[1]) when preparing the kprobe.
So, other cpu never execute it, and we don't need to write it atomically.

> On cpu models that support st16 you could construct the brl instruction
> and use a single st16 to update the whole bundle atomically.
> 
> -Tony

Thank you again,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

