Return-Path: <linux-kernel-owner+w=401wt.eu-S1755510AbYACUNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510AbYACUNl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 15:13:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752531AbYACUNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 15:13:32 -0500
Received: from mx1.redhat.com ([66.187.233.31]:32995 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040AbYACUNb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 15:13:31 -0500
Message-ID: <477D4183.60909@redhat.com>
Date: Thu, 03 Jan 2008 15:11:47 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Abhishek Sagar <sagar.abhishek@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Harvey Harrison <harvey.harrison@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, qbarnes@gmail.com,
       ananth@in.ibm.com, jkenisto@us.ibm.com
Subject: Re: [PATCH] x86: kprobes change kprobe_handler flow
References: <1198806265.6323.34.camel@brick> <4778E8B0.6010400@gmail.com>	 <20080101153558.GJ4434@elte.hu> <477A971A.8030006@gmail.com>	 <477BD366.1060504@redhat.com> <863e9df20801021131j3a4d655dgd00fa60e39a97ec@mail.gmail.com> <477C08A0.503@redhat.com> <477D2595.4060102@gmail.com>
In-Reply-To: <477D2595.4060102@gmail.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Abhishek Sagar wrote:
> Masami Hiramatsu wrote:
...
> Done. You should find the desired changed in this patch.

Well done!
This cleans it up very well.
I have just one more comment.

> @@ -463,14 +487,26 @@ static int __kprobes reenter_kprobe(struct kprobe *p, struct pt_regs *regs,
>  		arch_disarm_kprobe(p);
>  		regs->ip = (unsigned long)p->addr;
>  		reset_current_kprobe();
> -		return 1;
> +		preempt_enable_no_resched();
> +		break;
>  #endif
> +	case KPROBE_HIT_ACTIVE:
> +		recursive_singlestep(p, regs, kcb);
> +		break;
> +	case KPROBE_HIT_SS:
> +		if (*p->ainsn.insn == BREAKPOINT_INSTRUCTION) {
> +			regs->flags &= ~TF_MASK;
> +			regs->flags |= kcb->kprobe_saved_flags;
> +			return 0;
> +		} else {
> +			recursive_singlestep(p, regs, kcb);
> +		}
> +		break;
> +	default:
> +		/* impossible cases */
> +		WARN_ON(1);

WARN_ON() does not call panic(). Since the kernel doesn't stop,
we need to prepare singlestep after that.

How about this?
---
+	case KPROBE_HIT_ACTIVE:
+		break;
+	case KPROBE_HIT_SS:
+		if (*p->ainsn.insn == BREAKPOINT_INSTRUCTION) {
+			regs->flags &= ~TF_MASK;
+			regs->flags |= kcb->kprobe_saved_flags;
+			return 0;
+		}
+		break;
+	default:
+		/* impossible cases */
+		WARN_ON(1);
 	}
 	save_previous_kprobe(kcb);
 	set_current_kprobe(p, regs, kcb);
 	kprobes_inc_nmissed_count(p);
 	prepare_singlestep(p, regs);
 	kcb->kprobe_status = KPROBE_REENTER;
 	return 1;
 }
---


Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com, masami.hiramatsu.pt@hitachi.com

