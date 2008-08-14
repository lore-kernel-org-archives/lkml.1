Return-Path: <linux-kernel-owner+w=401wt.eu-S1755305AbYHOAD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305AbYHOAD4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 20:03:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751654AbYHOADs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 20:03:48 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:56330 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbYHOADr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 20:03:47 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Andrew Morton" <akpm@linux-foundation.org>
References: <1218705441-21838-1-git-send-email-yhlu.kernel@gmail.com>
	<20080814132638.GA18743@elte.hu>
	<86802c440808141201o2c66236cwbc5ce37f9675504d@mail.gmail.com>
	<m1ljyzcqg4.fsf@frodo.ebiederm.org>
	<86802c440808141342k6cb0dc59ud067018b0a171232@mail.gmail.com>
Date: Thu, 14 Aug 2008 16:55:32 -0700
In-Reply-To: <86802c440808141342k6cb0dc59ud067018b0a171232@mail.gmail.com>
	(Yinghai Lu's message of "Thu, 14 Aug 2008 13:42:48 -0700")
Message-ID: <m17iajb18r.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Yinghai Lu" <yhlu.kernel@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0306]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 00/53] dyn_array/nr_irqs/sparse_irq support v10
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Yinghai Lu" <yhlu.kernel@gmail.com> writes:

> On Thu, Aug 14, 2008 at 1:05 PM, Eric W. Biederman


>> What I wound up using in my tree is a little different.
>>
>> I introduced an opaque/empty structure: struct irq to be used in places
>> where we need pointers instead of an integer irq number in the interfaces.
>>
>> I have a version of the genirq api that works on struct irq instead of
>> unsigned int irq.
>>
>> I have functions:
>> struct irq * to_irq(unsigned int nr);
>> struct irq_desc *to_idesc(struct irq *);
>> unsigned int irq_nr(struct irq *irq);
>
> struct irq {
>   unsigned int nr;
>   struct irq_desc *idesc;
> }

I did:
  struct irq_desc {
  	struct irq irq;
        ....
  }
  Then to_idesc is just a container_of call.  Or simply a type cast but
  that is rude.

Having nr be a field in struct irq is possibly valid.

When last we talked about the design Linus was emphatic that what gets
exposed to drivers be an opaque token.  When I looked for 99%+ of the
arch code we can use that same opaque token.  irq_desc is something
we don't really care about except in do_IRQ().

So I guess the truly important thing is that struct irq is not
ultimately available in a usable form to drivers.

We seem to give drivers access to everything when they include interrupt.h
So I'm not certain how strict we can succeed in being still is a good goal
to aim for.

>> Is there any reason why the migration path for architectures can not be:
>> Until they are converted:
>> #define NR_IRQS and use the irq_desc array.
>>
>> If they are just using a dynamically allocated array.
>> #define NR_IRQS nr_irqs
>>
>> Once we kill the array entirely.
>> #undef NR_IRQS or
>> #define NR_IRQS 0xfffff000
> why not use -1U here?

So that negative error codes continue not to be valid irqs.

In most places irq is an unsigned int so it may safely be used to index irq_desc.
In other paces people are sloppier and used a signed value so they can return
negative error values.   create_irq() on x86 is one of those places.  There
is also platform_get_irq.  and possibly a few others.

Eric

