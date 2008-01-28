Return-Path: <linux-kernel-owner+w=401wt.eu-S1761574AbYA1R0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761574AbYA1R0b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 12:26:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755226AbYA1R0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 12:26:24 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42542 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751703AbYA1R0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 12:26:23 -0500
Message-ID: <479E0F5C.3080600@redhat.com>
Date: Mon, 28 Jan 2008 12:22:36 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Abhishek Sagar <sagar.abhishek@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, jkenisto@us.ibm.com,
       ananth@in.ibm.com, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 3/3] x86: WARN_ON breakpoints from .kprobes.text section
References: <479C4A4F.10604@gmail.com> <479C94F6.2070502@redhat.com>	 <863e9df20801270733n4b82b595u8421fb07c18acaa6@mail.gmail.com>	 <479D00EC.20600@redhat.com> <863e9df20801280316w59c51a91la9cece372086e673@mail.gmail.com>
In-Reply-To: <863e9df20801280316w59c51a91la9cece372086e673@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Abhishek Sagar wrote:
> On 1/28/08, Masami Hiramatsu <mhiramat@redhat.com> wrote:
>> Thank you for explanation, I hope I can understand it.
>> Even if it causes a trap recursively, it could be checked (and ignored) by
>> longjump_break_handler(), and passed to the debugger correctly.
> 
> Yes, all non-kprobe breakpoints are left to the kernel to be handled.
> The objective here is to intercept the trap handling of a certain
> category of such breakpoints and emit a warning. The premise being
> that .kprobes.text section is a logical breakpoint-free zone.

Oh, I think I've gotten what misleads you.
The .kprobes.text section is a KPROBES-FREE zone. There may be
breakpoints owned by other debuggers and hand-coded breakpoints
(like as jprobe_return).

>> Please consider that someone expands jprobe(jprobe2) which uses
>> jprobe_return2() instead of jprobe_return(), how would you handle it?
> 
> By a simple modification of is_jprobe_bkpt() (defined in patch #2 of
> this series).

IMO, one of advantages of current logic is that you can add another break_handler-based
probe as an module without any patches. Even if someone makes fooprobe which is
not a jprobe variant, current logic can treat it correctly.
(Another advantage is the performance. Current logic checks only if there is a
 running kprobe and there is no kprobes related to the trapped address, instead of
 checking address section every time when each breakpoint is hit.)

>> Current kprobes provides an opportunity to those external probe frameworks
>> for checking it by themselves.
> 
> Could you clarirfy this with some example. For now I'm assuming that
> by external probe frameworks you mean kernel modules using kprobes.

Yes, I mentioned it above.

> If
> they embed breakpoints in their handlers, then they will simply not be
> caught by this check because thay cannot lie in the .kprobes.text
> section.

They cannot lie kprobes in the .kprobes.text section, but can put
breakpoints by hand. this is the reason why kprobes provides break_handler.

Thanks,
Best Regards,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

