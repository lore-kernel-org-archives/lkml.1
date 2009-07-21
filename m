Return-Path: <linux-kernel-owner+w=401wt.eu-S1755490AbZGUMQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490AbZGUMQR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 08:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755473AbZGUMQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 08:16:16 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62336 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755472AbZGUMQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 08:16:15 -0400
Message-ID: <4A65B1AE.5000305@cn.fujitsu.com>
Date: Tue, 21 Jul 2009 20:16:46 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Neil Horman <nhorman@tuxdriver.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Vivek Goyal <vgoyal@redhat.com>, Brayan Arraes <brayan@yack.com.br>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
Subject: Re: [PATCH] sysrq, kdump: fix regression, revert "simplify sysrq-c
 handler"
References: <4A64672E.8020005@cn.fujitsu.com> <4A6564F2.10404@jp.fujitsu.com> <20090721110857.GA21612@hmsreliant.think-freely.org>
In-Reply-To: <20090721110857.GA21612@hmsreliant.think-freely.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Horman wrote:
> On Tue, Jul 21, 2009 at 03:49:22PM +0900, Hidetoshi Seto wrote:
>> Lai Jiangshan wrote:
>>> 1) This fix breaks our tools.
>>>       This fix changes the ABI. panic_on_oops is default 0,
>>>    and a lots system do not specify the boot option "panic",
>>>    thus, Sysrq-c will not cause CrashDump(Kdump) as expected.
>>>
>>> 2) When CONFIG_KEXEC=n, Sysrq-c should become an invalid
>>>    command like Sysrq-D(CONFIG_LOCKDEP, show-all-locks).
>>>    But this fix makes it a valid command and let it do a
>>>    hazard thing: cause a page fault(NULL dereference) in kernel.
>>>
>>> So, we revert this fix.
>>>
>>> |commit d6580a9f15238b87e618310c862231ae3f352d2d
>>> |Author: Neil Horman <nhorman@tuxdriver.com>
>>> |Date:   Wed Jun 17 16:28:17 2009 -0700
>>>
>>> |    kexec: sysrq: simplify sysrq-c handler
>>>
>>> |    Currently the sysrq-c handler is bit over-engineered.  Its behavior is
>>> |    dependent on a few compile time and run time factors that alter its
>>> |    behavior which is really unnecessecary.
>>>
>>> |    If CONFIG_KEXEC is not configured, sysrq-c, crashes the system with a NULL
>>> |    pointer dereference.  If CONFIG_KEXEC is configured, it calls crash_kexec
>>> |    directly, which implies that the kexec kernel will either be booted (if
>>> |    its been previously loaded), or it will simply do nothing (the no kexec
>>> |    kernel has been loaded).
>>>
>>> |    It would be much easier to just simplify the whole thing to dereference a
>>> |    NULL pointer all the time regardless of configuration.  That way, it will
>>> |    always try to crash the system, and if a kexec kernel has been loaded into
>>> |    reserved space, it will still boot from the page fault trap handler
>>> |    (assuming panic_on_oops is set appropriately).
>>>
>>>
>>> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
>>> ---
>> FYI, this problem has already pointed by Ohmichi-san and this will be an
>> another patch for the following discussion:
>>   http://lists.infradead.org/pipermail/kexec/2009-July/003433.html
>> You can find my sloppy memo in:
>>   http://lists.infradead.org/pipermail/kexec/2009-July/003443.html
>>
>> I agree with you that SysRq-'c' is well known as for 'C'rashdump, and it is
>> not expected as 'C'rash without dump.
>>
>>
>> Thanks,
>> H.Seto
>>
>>
> None of this answers Erics question, what is it that you could do before, that
> you couldn't do now?  There are reasons to want to have a convienient way to
> crash the kernel, other than to test kdump (several distributions have augmented
> sysrq-c to do this for some time to test other previous dump mechanisms and
> features), so while its not been upstream, saying that its well known to test
> kdump without causing an oops is a bit of a misleading statement.  It seems to
> me that right now your major complaint is that the documentation is out of date,
> and you're having to do things slightly differently to get the same behavioral
> results. 


I totally agreed that we just do things slightly differently
to get the same behavioral results. And we did it as you said.

So, Actually, our problem has been solved as you said
before I send the patch.

I just thought your fix is not proper for the kernel.


> Would it solve your issue, if we simply updated the documentation to
> illustrate how it works now?
>

Also the naming should be updated.
Your Sysrq-c triggers an oops if I didn't misunderstand your fix.

Lai

---------
Quote from Documentation/sysrq.txt
"""
It is a 'magical' key combo you can hit which the kernel will
respond to regardless of whatever else it is doing, unless
it is completely locked up.
"""

We can image this condition, the kernel is close to dead,
we can't type any command to set panic_on_oops to 1.
so we try to get the kernel's core file and analyze it some day,
but sysrq-c just print something without crashdown.

How can we do now? SysRq becomes not so magical.
----------








