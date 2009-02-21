Return-Path: <linux-kernel-owner+w=401wt.eu-S1755195AbZBUTVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195AbZBUTVc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 14:21:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753439AbZBUTVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 14:21:24 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:58440 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166AbZBUTVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 14:21:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vFVdUC4Ja4JkrYeUJ8Z0fNR0fFpPs18nIR3SR403ntHKbXHwuJq9buHQDc5Vk3Cwjv
         YgTBNxSCHlIdHl867HehxacgyuCYkW8rlgf4QnOHUe42YKx+xKmP0798C2MyEgqQCBo+
         C8YewcLq3xW5kbP7+wV1abrZBoWA9/cSjI1eA=
MIME-Version: 1.0
In-Reply-To: <20090221174703.GA6860@linux.vnet.ibm.com>
References: <20090220134121.GA19575@damson.getinternet.no>
	 <20090220135000.GA9616@elte.hu> <20090220140157.GA12799@elte.hu>
	 <19f34abd0902200651k7e86aebay5398ef5ac0578561@mail.gmail.com>
	 <20090220154619.GC6960@linux.vnet.ibm.com>
	 <19f34abd0902201551o65a3650egf29d81e8b6823d67@mail.gmail.com>
	 <20090221014056.GU6960@linux.vnet.ibm.com>
	 <19f34abd0902210130p62fba6d0n906b321949409578@mail.gmail.com>
	 <20090221174703.GA6860@linux.vnet.ibm.com>
Date: Sat, 21 Feb 2009 20:21:22 +0100
Message-ID: <19f34abd0902211121i4eca3450y2c9306f73e23de7@mail.gmail.com>
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

2009/2/21 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> Is this behavior recent, or does it apply to earlier 2.6.29-rc kernels
> as well?  Does it happen with CONFIG_CLASSIC_RCU as well?  (From the
> trace above, I suspect that it might well do so, but if not, that will
> be valuable information as well.)

I don't know -- I haven't tried earlier kernels.

I just compiled a CONFIG_CLASSIC_RCU kernel, and it does happen there too:

[    1.061138] traversing list {
[    1.062281]     __free_vmap_area(c7803a40)
[    1.063177]     __free_vmap_area(c7803a80)
[    1.065217]     __free_vmap_area(c7803ac0)
[    1.066255]     __free_vmap_area(c7803b00)
[    1.067156]     kfree(c7803a40)
[    1.068292]     __free_vmap_area(c7803b40)
[    1.069094]     __free_vmap_area(c7803b80)
[    1.071051]     kfree(c7803a80)
[    1.072138]     __free_vmap_area(c7803bc0)
[    1.073101]     __free_vmap_area(c7803c00)
[    1.074065]     kfree(c7803ac0)
[    1.077126]     kfree(c7803b00)
[    1.078124]     __free_vmap_area(c7803c40)
[    1.079079]     __free_vmap_area(c7803c80)
...
[    4.645118]     __free_vmap_area(c7853440)
[    4.646099]     __free_vmap_area(c7853480)
[    4.646507]     __free_vmap_area(c78534c0)
[    4.647049]     kfree(c7853340)
[    4.648058]     kfree(c7853380)
[    4.650090] };
[    4.652061]     kfree(c78533c0)
[    4.653055]     kfree(c7853400)
[    4.656109]     kfree(c7853440)
[    4.656482]     kfree(c7853480)
[    4.656760]     kfree(c78534c0)
[    5.541885] traversing list {
[    5.543081]     __free_vmap_area(c7853380)
[    5.544071]     __free_vmap_area(c7853340)
...
[    8.977412]     __free_vmap_area(c7822400)
[    8.977723]     __free_vmap_area(c7822440)
[    8.978045]     kfree(c7822200)
[    8.978569]     kfree(c7822240)
[    8.979054]     kfree(c7822280)
[    8.979389] };
[    8.981051]     kfree(c78222c0)
[    8.983055]     kfree(c7822300)
[    8.984089]     kfree(c7822340)
[    8.984640] Freeing SMP alternatives: 20k freed
[    8.985146] ACPI: Core revision 20081204
[    8.986060]     kfree(c7822380)
[    8.987057]     kfree(c78223c0)
[    8.988052]     kfree(c7822400)
[    8.990045]     kfree(c7822440)
[    9.021526] ..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1

The only difference I can see is that they're clumped together more
closely (4-5 calls of one kind, then 4-5 calls of the other) than with
the Tree RCU.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
