Return-Path: <linux-kernel-owner+w=401wt.eu-S1752677AbYIJBYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbYIJBYR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 21:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751548AbYIJBYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 21:24:06 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:21132 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbYIJBYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 21:24:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=J+QqX4nNeFkbN0yiZms5zg2v9DEk7fNLOF6CmUsmdOsc8H77VzrcUVI9yDST+4pRG0
         YU2AXNp5Sik56Z7zEC+sD/0v4aX/+aY3QObnWlhJVQObHFakae0+bRhEWO09hOovoFJo
         OKThcuKKfyVjgniPa/DkCsLFpaltjxbxjJiDo=
Message-ID: <86802c440809091824u715ef2a0o6dc772f66212c38f@mail.gmail.com>
Date: Tue, 9 Sep 2008 18:24:03 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: TARGET_CPUS in assign_irq_vector
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <48C719C0.6060201@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48C6F913.1010509@goop.org>
	 <86802c440809091554y349366fdu8e4ca59797ab4205@mail.gmail.com>
	 <48C70ADC.8060004@goop.org>
	 <86802c440809091726y4db8f85eg2d478b482862c5f9@mail.gmail.com>
	 <48C719C0.6060201@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 9, 2008 at 5:50 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> Yinghai Lu wrote:
>> On Tue, Sep 9, 2008 at 4:46 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>>
>>> Yinghai Lu wrote:
>>>
>>>> target_cpus is the cpus that could be possible to used to take vector
>>>> and process that irq. so at least it should be online.
>>>>
>>>>
>>> Would it be wrong to make it possible_cpu_mask?
>>>
>>>
>> it is wrong
>
> What happens if you online a new cpu and migrate the irq to it?  Does it
> get allocated a new vector?

for phys_flat mode: it will get new vector for on new cpu.

>
> I'm using create_irq() as a general irq and vector allocation mechanism
> for Xen interrupts.  I'd like to be able to allocate a vector across all
> possible cpus so I can bind Xen event channels to vectors.  Should I: 1)
> add a create_irq_cpus() which takes a cpu mask rather than defaulting to
> TARGET_CPUS, 2) modify struct genapic to insert by own target_cpus(),
> 3) give up because the idea is fundamentally ill-conceived, or 4)
> something else?

seems need to rework __assign_irq_vector a little bit.

to
cpumask_t (*vector_allocation_domain_t)(int cpu)
static int __assign_irq_vector(int irq, cpumask_t mask,
vector_allocation_domain_t p)

...

and you could have your own

static cpumask_t vec_domain_alloc(int cpu)
{
        cpumask_t domain = cpu_possible_map;
        return domain;
}


static int assign_irq_vector_all(int irq)
{
        int err;
        unsigned long flags;
        cpumask_t mask = cpu_possible_map;

        spin_lock_irqsave(&vector_lock, flags);
        err = __assign_irq_vector(irq, mask, vec_domain_alloc);
        spin_unlock_irqrestore(&vector_lock, flags);
        return err;
}

YH
