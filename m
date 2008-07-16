Return-Path: <linux-kernel-owner+w=401wt.eu-S1758749AbYGPNqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758749AbYGPNqs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 09:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757139AbYGPNqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 09:46:40 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:8409 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728AbYGPNqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 09:46:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=r2+oYuWNl0ffM7xudaJTLmK2gqGYpGGFTGnyliXq2yCRYoSC7aHoMr+JEiKPZd3AqF
         A21jyHzjs8PBUUqyvbT7xVzm7+lE7AqSZeLVzJjM3iPU6ejQlVgyfyvd7X1q1TGdKzSY
         SOZ7JeWyoulEJBB1HJlHNLfLT4nvE/13rBWK4=
Message-ID: <19f34abd0807160646t55aa7227t4ac53302345ee828@mail.gmail.com>
Date: Wed, 16 Jul 2008 15:46:39 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: more header fixes
Cc: linux-kernel@vger.kernel.org, "the arch/x86 maintainers" <x86@kernel.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <20080716131745.GA10266@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080610214544.GA14824@damson.getinternet.no>
	 <20080618103006.GF15255@elte.hu>
	 <19f34abd0806180919v5a8c21e7ua7e1f928d8a53ab4@mail.gmail.com>
	 <20080626120202.GH29619@elte.hu>
	 <19f34abd0806260953h504ff85dmf11a59171df3442b@mail.gmail.com>
	 <20080701092820.GA31309@elte.hu> <20080716115137.GA8075@elte.hu>
	 <19f34abd0807160550v68aacb58nbdd46b0fe74c4704@mail.gmail.com>
	 <20080716130839.GA1296@elte.hu> <20080716131745.GA10266@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 3:17 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Ingo Molnar <mingo@elte.hu> wrote:
>
>> thanks. I've picked up these changes and rebased them to -git. (that
>> way they can be maintained as a topic easier) The few files that were
>> left out due to conflicts we can do later on. I pushed the result out
>> into the tip/x86/header-guards topic branch - please double-check that
>> i merged it right.
>
> hm, doesnt work with:
>
> http://redhat.com/~mingo/misc/config-Wed_Jul_16_15_13_24_CEST_2008.bad
>
> include/asm/mpspec.h:39: error: 'MAX_MP_BUSSES' undeclared here (not in
> a function)
> In file included from include/asm/smp.h:15,
>                 from include/linux/smp.h:28,
>                 from include/asm/desc.h:8,
>                 from include/asm/elf.h:89,
>                 from include/linux/elf.h:7,
>                 from arch/x86/boot/compressed/misc.c:29:
> include/asm/io_apic.h:149: error: 'MAX_IRQ_SOURCES' undeclared here (not
> in a function)
>
> etc. Some of those header guards confused some other code i guess.

Yes, you are right. Check out this incredibly hideous hack of
arch/x86/boot/compressed/misc.c:

/*
 * we have to be careful, because no indirections are allowed here, and
 * paravirt_ops is a kind of one. As it will only run in baremetal anyway,
 * we just keep it from happening
 */
#undef CONFIG_PARAVIRT
#ifdef CONFIG_X86_32
#define _ASM_DESC_H_ 1
#endif

#ifdef CONFIG_X86_64
#define _LINUX_STRING_H_ 1
#define __LINUX_BITMAP_H 1
#endif

I'm not sure how we should proceed with this. On one hand, we could
just fix the issues as they come up and be done with it. On the other
hand, this was exactly the thing I wanted to avoid by automatic it. I
guess it can never be fully automated... The question is if there is
any danger of *silent* (read: runtime) breakage, which would be much
worse than compiler errors.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
