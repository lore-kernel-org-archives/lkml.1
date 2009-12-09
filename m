Return-Path: <linux-kernel-owner+w=401wt.eu-S1756989AbZLISji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989AbZLISji (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 13:39:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756925AbZLISjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 13:39:32 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55209 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756843AbZLISjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 13:39:31 -0500
Date: Wed, 9 Dec 2009 10:38:51 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickens <hugh@veritas.com>
Subject: Re: [GIT PULL] x86/paravirt for v2.6.33
In-Reply-To: <wqm7jny7wc4aessgbtsgv0bw.1260383370120@email.android.com>
Message-ID: <alpine.LFD.2.00.0912091032380.3560@localhost.localdomain>
References: <wqm7jny7wc4aessgbtsgv0bw.1260383370120@email.android.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 9 Dec 2009, H. Peter Anvin wrote:
> "Jeremy Fitzhardinge" <jeremy@goop.org> wrote:
> >
> >But I'm not sure I understand the objection to task_pt_regs(); is it 
> >considered deprecated?   This patch received quite a lot of discussion 
> >with no mention of it.  Should we consider all its uses as suspect?

I personally would be much happier without ever seeing a single 
task_pt_regs() call outside of pure ptrace() users (and quite frankly, 
even there I'd be happier if it was basically done once, and then 'struct 
pt_regs' being passed around as an argument as much as possible).

In the case of 'ptrace' we control the stack of the tracee. 

In other cases, we do _not_.

For example, think about us ever implementing 'tasklets' or async system 
calls in general. It's _very_ possible that we'd have a special stolen 
stack for them, and run the low-level system call function from that 
stack. Then something like task_pt_regs() migth very well do the wrong 
thing.

Now, I'm not saying that 'sys_iopl()' would ever be a valid target for 
async system calls, but I _am_ saying that system calls that depend on 
task_pt_regs() are fundamnetally fragile and broken, and have subtle 
interactions.

In contrast, if you make it very explicit that the system call gets passed 
a pointer to its pt_regs, then it still has all the same issues, but now 
it's not subtle any more - now it's explicitly encoded in the call 
sequence on both the caller and callee sides, and somebody doing tasklets 
would hopefully see that "oh, iopl() has that same special thing that 
fork/clone/vfork/execve has, and touches the stack frame register set 
explicitly".

			Linus
