Return-Path: <linux-kernel-owner+w=401wt.eu-S1755229AbYACRSF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229AbYACRSF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 12:18:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751900AbYACRRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 12:17:55 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35303 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744AbYACRRy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 12:17:54 -0500
Message-ID: <477D184A.8090009@redhat.com>
Date: Thu, 03 Jan 2008 12:15:54 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Abhishek Sagar <sagar.abhishek@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Harvey Harrison <harvey.harrison@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, qbarnes@gmail.com,
       ananth@in.ibm.com, jkenisto@us.ibm.com
Subject: Re: [PATCH] x86: kprobes change kprobe_handler flow
References: <1198806265.6323.34.camel@brick> <4778E8B0.6010400@gmail.com>	 <20080101153558.GJ4434@elte.hu> <477A971A.8030006@gmail.com>	 <477BD366.1060504@redhat.com> <863e9df20801021131j3a4d655dgd00fa60e39a97ec@mail.gmail.com> <477C08A0.503@redhat.com>
In-Reply-To: <477C08A0.503@redhat.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Abhishek,

Masami Hiramatsu wrote:
...
>>>> +     case KPROBE_HIT_SS:
>>>> +             if (*p->ainsn.insn == BREAKPOINT_INSTRUCTION) {
>>>> +                     regs->flags &= ~TF_MASK;
>>>> +                     regs->flags |= kcb->kprobe_saved_flags;
>>>> +             } else {
>>>> +                     /* BUG? */
>>>> +             }
>>>> +             break;
>>> If my thought is correct, we don't need to use swich-case here,
>>> Because there are only 2 cases, KPROBE_HIT_SSDONE (x86-64 only)
>>> or others.
>>> As a result, this function just setups re-entrance.
>> As you've also pointed out in your previous reply, this case is
>> peculiar and therefore I believe it should be marked as a BUG(). I've
>> left the original case, if (kcb->kprobe_status==KPROBE_HIT_SS) &&
>> (*p->ainsn.insn == BREAKPOINT_INSTRUCTION), untouched and is handled
>> as it was before. However, if (kcb->kprobe_status==KPROBE_HIT_SS) &&
>> !(*p->ainsn.insn == BREAKPOINT_INSTRUCTION), then instead of
>> incrementing nmissed count like before, it should cry out a BUG. This
>> is not an ordinary recursive probe handling case which should update
>> the nmissed count.
> 
> Hmm, I can not agree, because it is possible to insert a kprobe
> into kprobe's instruction buffer. If it should be a bug, we must
> check it when registering the kprobe.

I discussed it with other maintainers and knew that current kprobes
does not allow user to insert a kprobe to another kprobe's instruction
buffer, because register_kprobe ensures the insertion address is text.
Now I changed my mind. I think that case (p && kprobe_running() &&
kcb->kprobe_status==KPROBE_HIT_SS) is BUG(), even if (*p->ainsn.insn ==
BREAKPOINT_INSTRUCTION).

> (And also, in *p->ainsn.insn == BREAKPOINT_INSTRUCTION case, I doubt
> that the kernel can handle this "orphaned" breakpoint, because the
> breakpoint address has been changed.)

I also changed my mind. In this case, the kernel debugger can retrieve
correct breakpoint address by using kprobe_running() as below.
---
kp = kprobe_running();
if (kp)
	addr = kp->addr;
else
	addr = regs->ip;
---

The last discussion point is that we should restore flags or not if
(!p && kprobe_running() && kcb->kprobe_status==KPROBE_HIT_SS).
I think we do not need to do that if the debugger premises that
kprobes exists.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com, masami.hiramatsu.pt@hitachi.com

