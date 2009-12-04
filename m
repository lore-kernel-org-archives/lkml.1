Return-Path: <linux-kernel-owner+w=401wt.eu-S932066AbZLDAxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932066AbZLDAxW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 19:53:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754450AbZLDAxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 19:53:17 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50399 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272AbZLDAxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 19:53:16 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.4.0
Message-ID: <4B185DD6.1030109@np.css.fujitsu.com>
Date: Fri, 04 Dec 2009 09:54:46 +0900
From: Jin Dongming <jin.dongming@np.css.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Simon Kagstrom <simon.kagstrom@netinsight.net>
CC: LKLM <linux-kernel@vger.kernel.org>
Subject: Re: Question about kmsg_dump for OOPS
References: <4B172ACE.7080806@np.css.fujitsu.com> <20091203092622.599b3814@marrow.netinsight.se>
In-Reply-To: <20091203092622.599b3814@marrow.netinsight.se>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Simon

I am sorry for replying late.

Thank you for your answer and your information.
I will read the discussion and consider whether there is a better method
to resolve my problem.

Best Regards,
Jin Dongming

Simon Kagstrom wrote:
> Hi Jin!
> 
> On Thu, 03 Dec 2009 12:04:46 +0900
> Jin Dongming <jin.dongming@np.css.fujitsu.com> wrote:
> 
>> I have a question about kmsg_dump which needs your help.
>> The question is as following:
>>     Why not put the kmsg_dump() for OOPS into oops_end() and before the branch
>>     of crash_kexec()?
>>
>> The reason for the question is as following:
>>     Now the kmsg_dump() for OOPS is added in oops_exit(). When OOPS happened,
>>     kernel will call oops_end(). If the crash_kexec() is executed first in
>>     oops_end(), the oops_exit() could not be called. And also the kmsg_dump()
>>     for PANIC could not be executed. So I think that the kmsg_dump() for OOPS
>>     will lose its real meaning.
> 
> It would be OK to move it for my part, I understand your reasoning.
> How this is handled seems to vary a bit between architectures though.
> ARM has (arch/arm/kernel/die.c)
> 
>   NORET_TYPE void die(const char *str, struct pt_regs *regs, int err)
>   {
> 	[...]
> 	if (panic_on_oops)
> 		panic("Fatal exception");
> 
> 	oops_exit();
> 	[...]
> 
> while x86 does (arch/x86/kernel/dumpstack.c):
> 
>   void __kprobes oops_end(unsigned long flags, struct pt_regs *regs, int signr)
>   {
> 	if (regs && kexec_should_crash(current))
> 		crash_kexec(regs);
> 	[...]
> 	oops_exit();
> 	[...]
> 	if (in_interrupt())
> 		panic("Fatal exception in interrupt");
> 	if (panic_on_oops)
> 		panic("Fatal exception");
> 
> 
> There was some additional discussion on this a while ago in these two
> threads:
> 
>   http://lkml.org/lkml/2009/11/11/404
> 
>   http://lkml.org/lkml/2009/10/23/131
> 
> where there additionally was a request to move
> 
>   atomic_notifier_call_chain(&panic_notifier_list, 0, buf);
> 
> before kmsg_dump() and crash_kexec(). I can't immediately see any
> problem with this approach, but I'm no expert on kexec. The discussion
> didn't really conclude on this matter though.
> 
> // Simon
> 
> 

