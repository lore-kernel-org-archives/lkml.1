Return-Path: <linux-kernel-owner+w=401wt.eu-S1757063AbZDKHwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063AbZDKHwa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 03:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756871AbZDKHvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 03:51:48 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:20851 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756547AbZDKHvr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 03:51:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iJw7v7XhI0wEWksQl4nWY3Vs+EcAU9amSNJINNZa8NuxRFEKKanV1jD0R6wUIf1Cmp
         FcTMcnZlbBgG6hI+/+TbPmCGdVECjt31B9uRx1cP9rX1m8+W7KlBG0uJpOqtG7Nh0SuR
         EtetBXWlJXjYgsF0yRkKGERhTAjCR40J1i1Ng=
MIME-Version: 1.0
In-Reply-To: <m1tz4wcgm8.fsf@fess.ebiederm.org>
References: <20090408210735.GD11159@us.ibm.com>
	 <m1r601fg9l.fsf@fess.ebiederm.org> <20090410200919.GA7242@us.ibm.com>
	 <m1tz4wcgm8.fsf@fess.ebiederm.org>
Date: Sat, 11 Apr 2009 00:51:46 -0700
Message-ID: <86802c440904110051p3e071f8etd0792702c08d9ec5@mail.gmail.com>
Subject: Re: [PATCH 2/3] [BUGFIX] x86/x86_64: fix CPU offlining triggered 
	inactive device IRQ interrruption
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Shaohua Li <shaohua.li@intel.com>
Cc: Gary Hade <garyhade@us.ibm.com>, mingo@elte.hu, mingo@redhat.com,
       tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
       linux-kernel@vger.kernel.org, lcm@us.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 10, 2009 at 3:02 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Gary Hade <garyhade@us.ibm.com> writes:
>
> It looks like some additional bugs have slipped in since last I looked.
>
> set_irq_affinity does this:
> ifdef CONFIG_GENERIC_PENDING_IRQ
>        if (desc->status & IRQ_MOVE_PCNTXT || desc->status & IRQ_DISABLED) {
>                cpumask_copy(desc->affinity, cpumask);
>                desc->chip->set_affinity(irq, cpumask);
>        } else {
>                desc->status |= IRQ_MOVE_PENDING;
>                cpumask_copy(desc->pending_mask, cpumask);
>        }
> #else
>
> That IRQ_DISABLED case is a software state and as such it has nothing to
> do with how safe it is to move an irq in process context.
>

commit 932775a4ab622e3c99bd59f14cc7d96722f79501
Author: venkatesh.pallipadi@intel.com <venkatesh.pallipadi@intel.com>
Date:   Fri Sep 5 18:02:15 2008 -0700

    x86: HPET_MSI change IRQ affinity in process context when it is disabled

    Change the IRQ affinity in the process context when the IRQ is disabled.

    Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Shaohua Li <shaohua.li@intel.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index ddc9568..ad2ce72 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -87,10 +87,11 @@ int irq_set_affinity(unsigned int irq, cpumask_t cpumask)
                return -EINVAL;

 #ifdef CONFIG_GENERIC_PENDING_IRQ
-       if (desc->status & IRQ_MOVE_PCNTXT) {
+       if (desc->status & IRQ_MOVE_PCNTXT || desc->status & IRQ_DISABLED) {
                unsigned long flags;

                spin_lock_irqsave(&desc->lock, flags);
+               desc->affinity = cpumask;
                desc->chip->set_affinity(irq, cpumask);
                spin_unlock_irqrestore(&desc->lock, flags);
        } else
