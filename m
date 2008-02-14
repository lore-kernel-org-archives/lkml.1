Return-Path: <linux-kernel-owner+w=401wt.eu-S1760891AbYBNSR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760891AbYBNSR1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 13:17:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754646AbYBNSRS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 13:17:18 -0500
Received: from r00tworld.com ([212.85.137.21]:41196 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754058AbYBNSRR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 13:17:17 -0500
From: pageexec@freemail.hu
To: Ingo Molnar <mingo@elte.hu>
Date: Thu, 14 Feb 2008 19:16:20 +0200
MIME-Version: 1.0
Subject: Re: [x86.git#mm] stack protector fixes, vmsplice exploit
Reply-to: pageexec@freemail.hu
CC: Sam Ravnborg <sam@ravnborg.org>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Message-ID: <47B49384.23437.F8FB16A@pageexec.freemail.hu>
In-reply-to: <20080214170058.GA2043@elte.hu>
References: <20080214170058.GA2043@elte.hu>
X-mailer: Pegasus Mail for Windows (4.41)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.21]); Thu, 14 Feb 2008 19:14:35 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 Feb 2008 at 18:00, Ingo Molnar wrote:

some comments:

>   x86: fix execve with -fstack-protect

the commit comment says:

> This hack was true up to the point the stackprotector added
> another word to the stack frame. Shifting all the addresses
> by 8 bytes, crashing and burning any exec attempt.

actually, that's not the problem here because the canary is in the
local variable area, it doesn't affect the passed arguments. what
happens here is that gcc treats the argument area as owned by the
callee, not the caller and is allowed to do certain tricks. for ssp
it will make a copy of the struct passed by value into the local
variable area and pass *its* address down, and it won't copy it back
into the original instance stored in the argument area.

so once sys_execve returns, the pt_regs passed by value hasn't at all
changed and its default content will cause a nice double fault (FWIW,
this part took me the longest to debug, being down with cold didn't
help it either ;).

>   x86: fix stackprotector canary updates during context switches

the commit says:

> Note: this means that we call __switch_to() [and its sub-functions]
> still with the old canary, but that is not a problem, both the previous
> and the next task has a high-quality canary. The only (mostly academic)
> disadvantage is that the canary of one task may leak onto the stack of
> another task, increasing the risk of information leaks, were an attacker
> able to read the stack of specific tasks (but not that of others).

the best practical defense against leaking the canary is to change its
value on every syscall but it has some performance impact in microbenchmarks.

>   x86: stackprotector: mix TSC to the boot canary

this should probably be implemented in a general get_random_long()
function...

>   x86: test the presence of the stackprotector
>   x86: streamline stackprotector

the config comment says -fstack-protector whereas you're really enabling
the stonger -fstack-protector-all feature (without the latter the ssp
test function sample_stackprotector_fn wouldn't even be instrumented ;-).

