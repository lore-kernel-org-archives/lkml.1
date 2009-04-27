Return-Path: <linux-kernel-owner+w=401wt.eu-S1756614AbZD0LFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614AbZD0LFq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 07:05:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753755AbZD0LFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 07:05:13 -0400
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:32962 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753147AbZD0LFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 07:05:10 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=qgMonLB4CVn8/pQLyDkNatoazqxSBnjxbksWECFHqvLOB8L2syO7JAm/e2yGCZHCkg7Ahq/8q9XbCHvGQKnYSxmjqi3K1wLHWVS5vMpR8outBbzB0bY7dT1mYg7Q/EHIKSLmMNFidXq3K6FeV50OEsU5Qz5a9o4o0MPEbmbqt6s=  ;
X-YMail-OSG: 1mZTENIVM1mTx9QW61E3plyF2J5PO1o4Hd8nqOfDtoXePN0bhVbIHilZdtsUgheUTgqDPfbNw0YPEmoHYhjnCsZAIy_V7VXHaess0M5sM8VsWigWXWD6E2DAJakyeUPbBrL.uynFijLd.XSm3d4mpnct5G5oMBKVPjLxGSQmIlNI.YY5blVil7.tDieRPmraD0qWbeBm6PJBQ3HiRqlJ1Q62wjNQ8Mp0PCjfPra9zkJ3r3Ddfnc8ELBngLGU5RTPufRIHVm2CrhgtX0eDRf1qhuy89ulxs3.SkClw6.1WNwkKIE4ZRknGU_1YFk0L5Yvn3uoVI7eBrW5D1TA6BmbNQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: lkml <linux-kernel@vger.kernel.org>
Subject: Re:  Subject:    [tip:irq/genirq] genirq: assert that irq handlers are indeed running in hardirq context
Date: Mon, 27 Apr 2009 04:05:09 -0700
User-Agent: KMail/1.9.10
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904270405.09206.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Commit-ID:  044d408409cc4e1bc75c886e27ca85c270db104c
> Gitweb:    
> http://git.kernel.org/tip/044d408409cc4e1bc75c886e27ca85c270db104c Author: 
>    Peter Zijlstra <a.p.zijlstra@chello.nl>
> AuthorDate: Mon, 2 Mar 2009 16:13:32 +0100
> Commit:     Ingo Molnar <mingo@elte.hu>
> CommitDate: Tue, 3 Mar 2009 00:05:45 +0100
>
> genirq: assert that irq handlers are indeed running in hardirq context
>
> Make sure the genirq layer handlers are indeed running handlers
> in hardirq context. That is the genirq expectation and doing
> anything else is broken.

Actually, it's more like Peter Zijlstra's expectation.
Genirq works perfectly well without this.

And ... this causes regressions, so I suggest it get
reverted ASAP.

http://marc.info/?l=linux-kernel&m=124082644212584&w=2


>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> LKML-Reference: <1236006812.5330.632.camel@laptop>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
>
>
> ---
>  kernel/irq/handle.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
> index 3aba8d1..a2ee682 100644
> --- a/kernel/irq/handle.c
> +++ b/kernel/irq/handle.c
> @@ -328,6 +328,8 @@ irqreturn_t handle_IRQ_event(unsigned int irq, struct
> irqaction *action) irqreturn_t ret, retval = IRQ_NONE;
>  	unsigned int status = 0;
>
> +	WARN_ONCE(!in_irq(), "BUG: IRQ handler called from non-hardirq context!");

Notice also:  clearly untested.  No newline on the message.

> + 
>  	if (!(action->flags & IRQF_DISABLED))
>  		local_irq_enable_in_hardirq();
