Return-Path: <linux-kernel-owner+w=401wt.eu-S1754845AbZBUShb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845AbZBUShb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 13:37:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753058AbZBUShY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 13:37:24 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:56170 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890AbZBUShW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 13:37:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BkkBEChN6OhnoCvdG4YB1xvMpRXYKMO5ldKHhRc0c/ojAE8Sa58NGtkviQxW7BTyip
         QDXtVf4L+Lph3zHAo8Tdd58cncltmQxyZWWXK+l8yZMu74mTLaZEkmoDY/0MFe9sfg1T
         YPaXWPXGHd1RkPAAXc2gmqa5sp3rrqqrYYK50=
MIME-Version: 1.0
In-Reply-To: <19f34abd0902211008k39afd449k604aaf34f693c9a6@mail.gmail.com>
References: <20090220134121.GA19575@damson.getinternet.no>
	 <20090220135000.GA9616@elte.hu> <20090220140157.GA12799@elte.hu>
	 <19f34abd0902200651k7e86aebay5398ef5ac0578561@mail.gmail.com>
	 <20090220154619.GC6960@linux.vnet.ibm.com>
	 <19f34abd0902201551o65a3650egf29d81e8b6823d67@mail.gmail.com>
	 <20090221014056.GU6960@linux.vnet.ibm.com>
	 <19f34abd0902210130p62fba6d0n906b321949409578@mail.gmail.com>
	 <20090221174703.GA6860@linux.vnet.ibm.com>
	 <19f34abd0902211008k39afd449k604aaf34f693c9a6@mail.gmail.com>
Date: Sat, 21 Feb 2009 19:37:20 +0100
Message-ID: <19f34abd0902211037w2293af16t561444d11cc834b8@mail.gmail.com>
Subject: Re: [PATCH] mm: fix lazy vmap purging (use-after-free error)
From: Vegard Nossum <vegard.nossum@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/2/21 Vegard Nossum <vegard.nossum@gmail.com>:
> Here's the disassembly (I hope it won't wrap):
>
> 0xc1073ec0 <rcu_check_callbacks+0>:     push   %ebp
> 0xc1073ec1 <rcu_check_callbacks+1>:     test   %edx,%edx
> 0xc1073ec3 <rcu_check_callbacks+3>:     mov    %esp,%ebp
> 0xc1073ec5 <rcu_check_callbacks+5>:     push   %ebx
> 0xc1073ec6 <rcu_check_callbacks+6>:     mov    %eax,%ebx
> 0xc1073ec8 <rcu_check_callbacks+8>:     je     0xc1073f08
> <rcu_check_callbacks+72>
> 0xc1073eca <rcu_qsctr_inc+0>:   mov    $0xc1771320,%eax
> 0xc1073ecf <rcu_qsctr_inc+5>:   add    -0x3e8fa900(,%ebx,4),%eax
> 0xc1073ed6 <rcu_qsctr_inc+12>:  mov    (%eax),%edx
> 0xc1073ed8 <rcu_qsctr_inc+14>:  movb   $0x1,0xc(%eax)
> 0xc1073edc <rcu_qsctr_inc+18>:  mov    %edx,0x8(%eax)
> 0xc1073edf <rcu_bh_qsctr_inc+0>:        mov    $0xc1771380,%eax
> 0xc1073ee4 <rcu_bh_qsctr_inc+5>:        add    -0x3e8fa900(,%ebx,4),%eax
> 0xc1073eeb <rcu_bh_qsctr_inc+12>:       mov    (%eax),%edx
> 0xc1073eed <rcu_bh_qsctr_inc+14>:       movb   $0x1,0xc(%eax)
> 0xc1073ef1 <rcu_bh_qsctr_inc+18>:       mov    %edx,0x8(%eax)
> 0xc1073ef4 <rcu_check_callbacks+52>:    mov    $0x8,%eax
>
> Seems to be rcu_qsctr_inc() that reloads %edx. If I'd guess, I'd say
> x86's per_cpu macros. But it seems so strange that the corruption
> would not manifest in other ways too.
>

Okay, I don't really think it's an error. The if (user) test happens
at the very beginning and gcc decides to reuse %edx. GDB doesn't know
this, so it thinks the parameter changed, but at this point the
parameter simply won't be used anymore.

So you're right: The value can't be trusted (after entry, anyway).


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
