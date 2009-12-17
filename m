Return-Path: <linux-kernel-owner+w=401wt.eu-S1765004AbZLQRRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765004AbZLQRRP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 12:17:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764967AbZLQRRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 12:17:13 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:61847 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764962AbZLQRRM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 12:17:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XyxaInWw3kX+TiJXc1be3JQDdVSMA0MxyrugfFMKKcF2QnFFDSMAw7iJnXKvkyutVT
         SCCwjJMs/rFHgMwny0povp5dnrcjRLZuPFPkSioVi6lbK8f4dZcg2NCZb6SURujbHFoC
         ngWwlFjb2FH+im4EF3kaGz+tnptoLRM11vbbs=
MIME-Version: 1.0
In-Reply-To: <4B2A65C6.7080009@caviumnetworks.com>
References: <1260266138-17684-1-git-send-email-u.kleine-koenig@pengutronix.de>
	 <20091217150120.GD24967@shareable.org>
	 <4B2A65C6.7080009@caviumnetworks.com>
Date: Thu, 17 Dec 2009 18:17:11 +0100
Message-ID: <84fc9c000912170917y4b2772d0n47bb4dabc74b91ef@mail.gmail.com>
Subject: Re: [PATCH] ARM: Convert BUG() to use unreachable()
From: Richard Guenther <richard.guenther@gmail.com>
To: David Daney <ddaney@caviumnetworks.com>
Cc: Jamie Lokier <jamie@shareable.org>, "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>,
       =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 6:09 PM, David Daney <ddaney@caviumnetworks.com> wrote:
> Jamie Lokier wrote:
>>
>> Uwe Kleine-König wrote:
>>>
>>> Use the new unreachable() macro instead of for(;;);
>>>        *(int *)0 = 0;
>>>          /* Avoid "noreturn function does return" */
>>> -       for (;;);
>>> +       unreachable();
>>
>> Will GCC-4.5 remove ("optimise away") the *(int *)0 = 0 because it
>> knows the branch of the code leading to unreachable can never be reached?
>>
>
> I don't know the definitive answer, so I am sending to gcc@...
>
> FYI: #define unreachable() __builtin_unreachable()

It shouldn't as *(int *)0 = 0; might trap.  But if you want to be sure
use
   __builtin_trap ();
instead for the whole sequence (the unreachable is implied then).
GCC choses a size-optimal trap representation for your target then.

Richard.

>
>> If GCC-4.5 does not, are you sure a future version of GCC will never
>> remove it?  In other words, is __builtin_unreachable() _defined_ in
>> such a way that it cannot remove the previous assignment?
>>
>> We have seen problems with GCC optimising away important tests for
>> NULL pointers in the kernel, due to similar propagation of "impossible
>> to occur" conditions, so it's worth checking with GCC people what the
>> effect of this one would be.
>>
>> In C, there is a general theoretical problem with back-propagation of
>> optimisations from code with undefined behaviour.  In the case of
>> __builtin_unreachable(), it would depend on all sorts of unclearly
>> defined semantics whether it can remove a preceding *(int *)0 = 0.
>>
>> I'd strongly suggest asking on the GCC list.  (I'd have mentioned this
>> earlier, if I'd known about the patch for other architectures).
>>
>> The documentation for __builtin_unreachable() only says the program is
>> undefined if control flow reaches it.  In other words, it does not say
>> what effect it can have on previous instructions, and I think it's
>> quite likely that it has not been analysed in a case like this.
>>
>> One thing that would give me a lot more confidence, because the GCC
>> documentation does mention asm(), is this:
>>
>>>      *(int *)0 = 0;
>>>      /* Ensure unreachableness optimisations cannot propagate back. *I/
>>>      __asm__ volatile("");
>>>      /* Avoid "noreturn function does return" */
>>>      unreachable();
>>
>> -- Jamie
>
>
