Return-Path: <linux-kernel-owner+w=401wt.eu-S1753801AbZGUGqI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801AbZGUGqI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 02:46:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751765AbZGUGqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 02:46:07 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63694 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751537AbZGUGqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 02:46:06 -0400
Message-ID: <4A65644F.7010309@cn.fujitsu.com>
Date: Tue, 21 Jul 2009 14:46:39 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Neil Horman <nhorman@tuxdriver.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>, Brayan Arraes <brayan@yack.com.br>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sysrq, kdump: fix regression, revert "simplify sysrq-c
 handler"
References: <4A64672E.8020005@cn.fujitsu.com> <m1d47vnoq6.fsf@fess.ebiederm.org> <20090720211644.GD9060@hmsreliant.think-freely.org>
In-Reply-To: <20090720211644.GD9060@hmsreliant.think-freely.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Horman wrote:
> On Mon, Jul 20, 2009 at 12:22:57PM -0700, Eric W. Biederman wrote:
>> Lai Jiangshan <laijs@cn.fujitsu.com> writes:
>>
>>> 1) This fix breaks our tools.
>>>       This fix changes the ABI. panic_on_oops is default 0,
>>>    and a lots system do not specify the boot option "panic",
>>>    thus, Sysrq-c will not cause CrashDump(Kdump) as expected.
>> How does it break your tools?
>>
> Well, upstream doesn't really care about ABI stability, particularly in the
> sysrq space. 

"simplify sysrq-c handler" sounds like a cleanup patch,
why we let a cleanup patch changes the ABI?


> That aside however, it seems like sysrq-c is doing the right thing
> with my patch in place, namely, attempting to crash the system.  If the
> panic_on_oops sysctl isn't set, then a crash fails, as expected

The original name is "crashdump", so crash should be performed as expected.

(unlike the prior behavior, which forced a kexec reboot of the system while ignoring the
> sysctl, which seems like it would be labeled the unexpected behavior to me.
> Regardless, it seems like the right thing to do if you want sysrq-c to do the
> right thing from the start is set panic on the kernel command line.  Not sure
> what the problem is there. 
> 
>>> 2) When CONFIG_KEXEC=n, Sysrq-c should become an invalid
>>>    command like Sysrq-D(CONFIG_LOCKDEP, show-all-locks).
>>>    But this fix makes it a valid command and let it do a
>>>    hazard thing: cause a page fault(NULL dereference) in kernel.
>>>
>>> So, we revert this fix.
>> The idea was to extend sysrq-d to also be a way of testing NULL
>> pointer dereferences.  How is that a bad idea?
>>
> Agreed, about the only thing that I see as wrong with my change is that I

also the naming.

> neglected to change the documentation.  Prior to my change, the behavior was
> completely muddled.  Sysrq-c would do one of 3 things:
> 
> 1) If kexec wasn't built into the kernel, it would do nothing
> 2) If kexec was built into the kernel but not enabled, it would try and fail to
> execute a kdump
> 3) if kdump was enabled and configured, it would crash

I don't think it's muddled.
1) If kexec wasn't built into the kernel, IT'S NOT A VALID COMMAND.
2),3) It always try to crashdump. not oops, not normal panic.

> 
> Under the current implementation, you can always crash the kernel (assuming
> you've enabled sysrq, and have permission to use it), which will trigger a kdump
> (or just crash the system, which is usefull for development in and of its own
> right), or will simply record and oops (if panic_on_oops is clear).  The only
> case that left open is booting a kdump kernel without handling a bad page fault,
> which you can do from user space anyway via the kexec -e command.  I fail to see
> how the previous implementation is superior.

Even I agreed your fix, I don't agreed your naming,
For your fix, the correct naming should be:

.help_msg       = "oops(C)",
.action_msg     = "Trigger an oops"

And document it:
Sysrq-c always causes an oops by an indirect way. It'll do one of 4 things:
1) panic_on_oops=0, it is just kill the current task.
2) panic_on_oops=1, but CONFIG_KEXEC=n, just normal panic
3) panic_on_oops=1, CONFIG_KEXEC=y, but not enabled, just normal panic
4) panic_on_oops=1, CONFIG_KEXEC=y, kdump was enabled, CrashDump.

Lai.



