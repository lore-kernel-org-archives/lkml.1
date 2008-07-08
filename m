Return-Path: <linux-kernel-owner+w=401wt.eu-S1756064AbYGHSXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064AbYGHSXP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 14:23:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753949AbYGHSXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 14:23:00 -0400
Received: from rn-out-0910.google.com ([64.233.170.190]:56893 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522AbYGHSW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 14:22:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=eKMbidOcZ0+CoaeoOCQ/qWiRe/n42Q4e5SOb7TGHqiXFNwqrAiHdF3eiiCGZ79Lkc0
         NvnUii1HjbwsCJYGnJnhNuMS4UbYD/796lpb5aXEqMENC1Phr/U8MLmFRXdtOrNHrYbh
         ChctyBkIX9Qg4vGJTZvfXYPqGTKX6tgGxwLFQ=
Message-ID: <19f34abd0807081122p20c73cd9p7129d297ac36a3ad@mail.gmail.com>
Date: Tue, 8 Jul 2008 20:22:57 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Mike Travis" <travis@sgi.com>
Subject: Re: [PATCH 1/1] x86: Change _node_to_cpumask_ptr to return const ptr
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       mm-commits@vger.kernel.org, "Yinghai Lu" <yhlu.kernel@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4873AC5C.1040705@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200806090918.m599Ib0G012837@imap1.linux-foundation.org>
	 <4863C334.2090007@sgi.com> <486452CC.8050502@sgi.com>
	 <48651EF5.5090808@sgi.com> <20080703084401.GB7873@elte.hu>
	 <19f34abd0807030155x22b0033dj780830bad840216f@mail.gmail.com>
	 <20080703090100.GA10872@elte.hu> <48739E87.2060604@sgi.com>
	 <19f34abd0807081035k2c7a18eckc8aa749a6f015f65@mail.gmail.com>
	 <4873AC5C.1040705@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 8, 2008 at 8:05 PM, Mike Travis <travis@sgi.com> wrote:
>>> Note: I did not change node_to_cpumask_ptr() in include/asm-generic/topology.h
>>>      as node_to_cpumask_ptr_next() does change the cpumask value.
>>
>> Hmmm. Does it really?
>>
>> #define node_to_cpumask_ptr_next(v, node)                               \
>>                           _##v = node_to_cpumask(node)
>>
>> This doesn't seem to modify it?
>
> Well I thought about it.  The pointer (*v) does not change
> but the underlying cpumask variable is updated with the
> cpumask for the (supposedly) new node number.  You can see
> that in this code snippet from kernel/sched.c:
>
>        for (i = 1; i < SD_NODES_PER_DOMAIN; i++) {
>                int next_node = find_next_best_node(node, &used_nodes);
>
>                node_to_cpumask_ptr_next(nodemask, next_node);
>                cpus_or(*span, *span, *nodemask);
>        }
>
> In the optimized (x86_64) case, the pointer is simply modified
> to point to the new node_to_cpumask_map[node] entry.  It remains
> a pointer to a const value.
>
> But the non-optimized version replaces the const cpumask value
> with the new cpumask value.  Isn't this breaking the const
> attribute?

No, I think the pointer really should be const. This doesn't guarantee
that the value doesn't change behind our backs, it only prevents us
from modifying it ourselves.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
