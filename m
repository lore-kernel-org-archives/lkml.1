Return-Path: <linux-kernel-owner+w=401wt.eu-S1756311AbZLISSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311AbZLISSh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 13:18:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755200AbZLISSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 13:18:34 -0500
Received: from claw.goop.org ([74.207.240.146]:33032 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755182AbZLISSd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 13:18:33 -0500
Message-ID: <4B1FE9FD.3030407@goop.org>
Date: Wed, 09 Dec 2009 10:18:37 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091125 Fedora/3.0-3.12.rc1.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickens <hugh@veritas.com>
Subject: Re: [GIT PULL] x86/paravirt for v2.6.33
References: <20091203210913.GA24351@elte.hu> <alpine.LFD.2.00.0912081329460.3560@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0912081329460.3560@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/09 13:34, Linus Torvalds wrote:
> I do _not_ want to add any more task_pt_regs() crap, please.
>
> Why? It's wrong for at least vm86 mode (and from kernel system calls).
>    

Would the stack frame version work in these cases?

> Maybe we can't get into system calls from vm86 mode, and the kernel
> hopefully doesn't do those things anyway, but the point is, you chose the
> wrong way to go.
>    

iopl doesn't make much sense as a kernel-called syscall, unless the 
caller is intending to change the usermode iopl.  In which case, won't 
task_pt_regs() do the right thing - by pointing to the saved usermode 
register set - vs modifying the ptregs the caller may pass in?

iopl is also one of the special set of syscalls which get special 
handing in entry_*.S, so I don't think doing a direct call from within 
the kernel is ever sensible, and it should always be possible to make 
task_pt_regs return meaningful results.

I agree with you that vm86 would be a problem if its possible to call iopl.

> The old version that actually passed the stack frame was better. Why pick
> the inferior version?
>    

Mainly because it exposes the difference between the 32 and 64-bit ABIs, 
requiring separate code for each case; it seemed like an opportunity to 
remove the differences.

Anyway, I'll post a patch to revert to the pt_regs-based version shortly.

     J
