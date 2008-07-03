Return-Path: <linux-kernel-owner+w=401wt.eu-S1756824AbYGCVEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824AbYGCVEx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 17:04:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753995AbYGCVEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 17:04:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42792 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753800AbYGCVEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 17:04:43 -0400
Date: Thu, 3 Jul 2008 17:03:44 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 1/2] Avoid bio_endio recursion
In-Reply-To: <20080702090048.2ec99b72@lxorguk.ukuu.org.uk>
Message-ID: <Pine.LNX.4.64.0807031637040.20244@engineering.redhat.com>
References: <Pine.LNX.4.64.0806240118250.24220@engineering.redhat.com>
 <20080624080744.GL20851@kernel.dk> <Pine.LNX.4.64.0806241017390.23052@engineering.redhat.com>
 <20080625082421.GU20851@kernel.dk> <Pine.LNX.4.64.0806252008380.11130@engineering.redhat.com>
 <20080626070723.GL20851@kernel.dk> <Pine.LNX.4.64.0807020001290.9097@engineering.redhat.com>
 <20080702090048.2ec99b72@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jul 2008, Alan Cox wrote:

> On Wed, 2 Jul 2008 00:09:22 -0400 (EDT)
> Mikulas Patocka <mpatocka@redhat.com> wrote:
>
>>> Right, that wont work of course. Completions are typically done through
>>> a softirq, so it is not currently done with hard interrupts disabled.
>>
>> I thought, from hardirq - that's what IDE is doing. And they are called
>
> Even IDE will sometimes complete from a timer on an error.
>
>> And does local_irq_restore() need to execute even more costy "popf" when
>> it makes a transition from disabled to disabled state? What's
>> local_irq_restore semantics --- is it allowed to use local_irq_restore for
>> transition from interrupt-enabled state into interrupt-disabled state?
>
> If you are worried about performance the network layer has _irq variants
> of various functions that are faster and can only be called from the
> right context (eg kfree_skb_irq), so you could do two versions of that
> code.
>
> Alan

I was thinking about a general optimization --- something like this. On 
Core2 it doesn't make much sense --- cli is fast there (just 11 ticks). On 
Pentium 4 it would make sense, because cli is much more costy there.

Mikulas

---
  include/asm-x86/irqflags.h |    3 ++-
  1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6.26-rc8/include/asm-x86/irqflags.h
===================================================================
--- linux-2.6.26-rc8.orig/include/asm-x86/irqflags.h	2008-06-02 23:13:32.000000000 +0200
+++ linux-2.6.26-rc8/include/asm-x86/irqflags.h	2008-07-03 22:53:32.000000000 +0200
@@ -101,7 +101,8 @@ static inline unsigned long __raw_local_
  {
  	unsigned long flags = __raw_local_save_flags();

-	raw_local_irq_disable();
+	if (flags & X86_EFLAGS_IF)
+		raw_local_irq_disable();

  	return flags;
  }
