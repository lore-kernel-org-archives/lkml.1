Return-Path: <linux-kernel-owner+w=401wt.eu-S1752021AbZAZPRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021AbZAZPRl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 10:17:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751305AbZAZPRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 10:17:32 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:47908 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbZAZPRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 10:17:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=DobPMdbsLFdLgLaZTGMXUBXqBzoSu+Un1w7JkG/qd6m2RQBg20dH6epJWRIDQZtONl
         1mKBLN6GnixQYnIia/razLwpPPApoL/fOo5swXpPeiHT+PxO2j91NkF2tdKccQexoqZL
         eCT7HNGSf+IBhnPA7tzYmvQjMzPH8wdMgZXH8=
From: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Subject: Re: next-20090107: WARNING: at kernel/sched.c:4435
To: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Laurent Riffard <laurent.riffard@free.fr>,
       Kernel development list <linux-kernel@vger.kernel.org>
Date: Mon, 26 Jan 2009 18:17:15 +0300
Message-ID: <20090126151521.8534.46503.stgit@nx>
In-Reply-To: <0090126150909.GG9128@elte.hu>
References: <0090126150909.GG9128@elte.hu>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, Jan 26, 2009 at 18:09, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Alexey Zaytsev <alexey.zaytsev@gmail.com> wrote:
>
>> On Mon, Jan 26, 2009 at 17:43, Ingo Molnar <mingo@elte.hu> wrote:
>> >
>> > * Alexey Zaytsev <alexey.zaytsev@gmail.com> wrote:
>> >
>> >> On Wed, Jan 14, 2009 at 05:00, Nick Piggin <npiggin@suse.de> wrote:
>> >> > On Sun, Jan 11, 2009 at 03:49:45AM +0100, Ingo Molnar wrote:
>> >> >>
>> >> >> * Alexey Zaytsev <alexey.zaytsev@gmail.com> wrote:
>> >> >>
>> >> >> > One more instance of http://marc.info/?l=linux-kernel&m=123134586202636&w=2
>> >> >> > Added Ingo Molnar to CC.
>> >> >>
>> >> >> added Nick on Cc:. Nick, it's about:
>> >> >>
>> >> >> > commit 7317d7b87edb41a9135e30be1ec3f7ef817c53dd
>> >> >> > Author: Nick Piggin <nickpiggin@yahoo.com.au>
>> >> >> > Date:   Tue Sep 30 20:50:27 2008 +1000
>> >> >> >
>> >> >> >    sched: improve preempt debugging
>> >> >>
>> >> >> causing a seemingly spurious warning.
>> >> >
>> >> > I don't know how it is spurious... Presumably the sequence _would_ have
>> >> > caused preempt count to go negative if the bkl were not held...
>> >> >
>> >> > __do_softirq does a __local_bh_disable on entry, and it seems like the
>> >> > _local_bh_enable on exit is what causes this warning. So something is
>> >> > unbalanced somehow. Or is it some weird thing we do in early boot that
>> >> > I am missing?
>> >> >
>> >> > Can you put in some printks around these functions in early boot to
>> >> > get an idea of what preempt_count is doing?
>> >> >
>> >>
>> >> Hi again.
>> >>
>> >> Finally got to debug this. The preempt count on the first __do_softirq entry
>> >> ever is 0, as it is set in irq_ctx_init(). The interrupted swapper
>> >> thread happens
>> >> to be in the kernel_locked() state at the moment, so the warning.
>> >>
>> >> I don't understand why the softirq preempt count is initialized to 0.
>> >> Should not it be SOFTIRQ_OFFSET instead?
>> >
>> > hm, indeed. So this triggers on irqstacks, if an irq happens to hit
>> > the first time a softirq executes (ever)? After that point the
>> > preempt_count in the irq-stack ought to stay elevated.
>>
>> No, this happens on the first softirq, which is run after an irq. An irq
>> interrupts the swapper thread while it is holding the blk. It is
>> executed on the hard irq stack, and the corresponding
>> thread_info.preempt_count is set correctly by irq_ctx_init(), so nothing
>> happens. After the hard IRQ is over, a softirq is run on the soft irq
>> stack, but irq_ctx_init() set it's preempt_count to zero. So after the
>> first softirq os over, sub_preempt_count() discovers that the preempt
>> count is goind back to zero, while the BKL is held (by the interrupted
>> thread), and refuses to decrease the count. So the spftirq preempt_count
>> stays SOFTIRQ_OFFSET which is now correct, so no further warnings are
>> triggered.
>
> yeah. So we need to fix the initial softirq-stack preempt_count value.

Like this? ;)

From: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Subject: [PATCH] Set the initial softirq preempt count to SOFTIRQ_OFFSET

Does not changes the preemption semantics, as the
softirq's obviously can't be preempted, but fixes
a spurious warning in sub_preempt_count, which
happens when the preempt count is returned to
zero, and the interrupted thread is holding the
BKL.

Signed-off-by: Alexey Zaytsev <alexey.zaytsev@gmail.com>
---

 arch/x86/kernel/irq_32.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index 74b9ff7..8d99de6 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -141,7 +141,7 @@ void __cpuinit irq_ctx_init(int cpu)
 	irqctx->tinfo.task		= NULL;
 	irqctx->tinfo.exec_domain	= NULL;
 	irqctx->tinfo.cpu		= cpu;
-	irqctx->tinfo.preempt_count	= 0;
+	irqctx->tinfo.preempt_count	= SOFTIRQ_OFFSET;
 	irqctx->tinfo.addr_limit	= MAKE_MM_SEG(0);
 
 	softirq_ctx[cpu] = irqctx;

