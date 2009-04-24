Return-Path: <linux-kernel-owner+w=401wt.eu-S1760433AbZDXRBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760433AbZDXRBc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 13:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753701AbZDXRBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 13:01:14 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:5310 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282AbZDXRBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 13:01:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dxAAttMVDQPDTDGzhSxZCyyUj4eFfHoZVI6iHtkSBgXuU0on7mvazigXn605vsjovl
         AUCqOzaKpanDEsFKGh+9Xp+D+fCqyhuE68K4RrjGULikUEeC4f9UTiN25M1PZl+YHGRU
         kaY6B3rquJFQ9cMivx5lgORPAE7k3A13qs7ro=
MIME-Version: 1.0
In-Reply-To: <b647ffbd0904240711v6e6930f5ia438bdcd69a015a4@mail.gmail.com>
References: <1240258569.6195.8.camel@earth> <1240344440.5861.10.camel@earth>
	 <1240439073.12721.23.camel@earth> <20090423082704.GD599@elte.hu>
	 <b647ffbd0904230155t61578496pf75fb79e54def3a3@mail.gmail.com>
	 <Pine.LNX.4.64.0904231807370.7545@blonde.anvils>
	 <b647ffbd0904231516x576c7ae4y36fedc9bc4fcf0f@mail.gmail.com>
	 <Pine.LNX.4.64.0904241300340.21735@blonde.anvils>
	 <b647ffbd0904240711v6e6930f5ia438bdcd69a015a4@mail.gmail.com>
Date: Fri, 24 Apr 2009 19:01:11 +0200
Message-ID: <b647ffbd0904241001u2d787931k99d12112e0b09ff@mail.gmail.com>
Subject: Re: [PATCH] x86 microcode: work_on_cpu and cleanup of the 
	synchronization logic
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Peter Oruba <peter.oruba@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/24 Dmitry Adamushko <dmitry.adamushko@gmail.com>:
> 2009/4/24 Hugh Dickins <hugh@veritas.com>:
>> On Fri, 24 Apr 2009, Dmitry Adamushko wrote:
>>> 2009/4/23 Hugh Dickins <hugh@veritas.com>:
>>> >
>>> > I guess your mutex Synchronization works out, but are interrupts
>>> > still disabled around the critical wrmsr()s, wherever they're getting
>>> > called from?
>>>
>>> Yes, *msr() calls are only done from functions that are now being
>>> called via smp_call_function_single(). The later seems to always do it
>>> with disabled interrupts. The only exception is mc_sysdev_resume()
>>> calling  ->apply_microcode() directly but this one in turn is always
>>> called with disabled interrupts.
>>>
>>> But now that you mentioned it I wonder if we may actually need a
>>> spinlock there... can we have multi-threaded cpus/cores with (all |
>>> some) shared msr registers?
>>
>> Good thinking, yes we can and do, unless I'm misinterpreting the
>> evidence.  Though P4 Xeon and Atom startup messages give the opposite
>> impression, claiming to update all cpus from lower revision, more
>> careful tests starting from "maxcpus=1" and then "echo 1 >online"
>> (which, unless you've fiddled around putting the microcode_ctl'ed
>> microcode.dat into /lib/firmware/intel-ucode/wherever, isn't able
>> to update at online time on Intel) shows that the later onlined
>> siblings already have the updated microcode applied to their
>> previously onlined siblings.  Which isn't surprising, but I'd
>> been lulled into thinking the opposite by the startup sequence.
>
> Ah, stupid me :-/ These differences in behavior during the startup and
> the later update reveal a real bug in my patch.
>
> this part:
>
> mutex_lock(&microcode_mutex);
> error = sysdev_driver_register(&cpu_sysdev_class, &mc_sysdev_driver);
> mutex_unlock(&microcode_mutex);
>
> sysdev_driver_register() calls mc_sysdev_driver's ->add() (which is
> mc_sysdev_add()) for each cpu in a loop. Obviously, "microcode_mutex"
> can't help to serialize these calls, oops. A very obvious thing but I
> missed it.

Well, never mind about this one. I might have really been in an
altered state of mind and now need to wait until it comes back to
(let's call it) normality.
All ucode operations are synchronous so obviously we don't need to
serialize actions that run sequentially one after another. Sorry for
the noise here.

But then I wonder why behavior (the fact that all threads seem to
upgrade to a newer version during the startup but they seem to already
be 'up-to-date' if onlined later) during the startup is different...
Too pity that I can't see it with my setups (heh, I perhaps could play
with it by actually downgrading cpus to older ucode).


-- 
Best regards,
Dmitry Adamushko
