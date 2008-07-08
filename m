Return-Path: <linux-kernel-owner+w=401wt.eu-S1754973AbYGHVWJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973AbYGHVWJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 17:22:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751297AbYGHVVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 17:21:53 -0400
Received: from wx-out-0506.google.com ([66.249.82.239]:54584 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbYGHVVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 17:21:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=iFsBESS8Q43fWsEH8sk6IEz1TaUvBtMM0guAuVF4XWmoQ9eZeVT7cm4kb54tOd7NlF
         IxytW2+ejMJoiJQpxg20xNuPGIWfpMvVoyd13oL4RghU73NUFw6zHeaRNe0R8oSmg4PD
         bVlhIbhTz9FmyUZ09pIkQXCvMVcv42BGEq+B4=
Message-ID: <19f34abd0807081421j67771dbclfae1fcfaa9ad4bcd@mail.gmail.com>
Date: Tue, 8 Jul 2008 23:21:50 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Mike Travis" <travis@sgi.com>
Subject: Re: [PATCH 1/1] x86: Change _node_to_cpumask_ptr to return const ptr
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       mm-commits@vger.kernel.org, "Yinghai Lu" <yhlu.kernel@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4873D33B.4040300@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200806090918.m599Ib0G012837@imap1.linux-foundation.org>
	 <48651EF5.5090808@sgi.com> <20080703084401.GB7873@elte.hu>
	 <19f34abd0807030155x22b0033dj780830bad840216f@mail.gmail.com>
	 <20080703090100.GA10872@elte.hu> <48739E87.2060604@sgi.com>
	 <19f34abd0807081035k2c7a18eckc8aa749a6f015f65@mail.gmail.com>
	 <4873AC5C.1040705@sgi.com>
	 <19f34abd0807081122p20c73cd9p7129d297ac36a3ad@mail.gmail.com>
	 <4873D33B.4040300@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 8, 2008 at 10:51 PM, Mike Travis <travis@sgi.com> wrote:
> Vegard Nossum wrote:
>> On Tue, Jul 8, 2008 at 8:05 PM, Mike Travis <travis@sgi.com> wrote:
>>>>> Note: I did not change node_to_cpumask_ptr() in include/asm-generic/topology.h
>>>>>      as node_to_cpumask_ptr_next() does change the cpumask value.
>>>> Hmmm. Does it really?
>>>>
>>>> #define node_to_cpumask_ptr_next(v, node)                               \
>>>>                           _##v = node_to_cpumask(node)
>>>>
>>>> This doesn't seem to modify it?
>>> Well I thought about it.  The pointer (*v) does not change
>>> but the underlying cpumask variable is updated with the
>>> cpumask for the (supposedly) new node number.  You can see
>>> that in this code snippet from kernel/sched.c:
>>>
>>>        for (i = 1; i < SD_NODES_PER_DOMAIN; i++) {
>>>                int next_node = find_next_best_node(node, &used_nodes);
>>>
>>>                node_to_cpumask_ptr_next(nodemask, next_node);
>>>                cpus_or(*span, *span, *nodemask);
>>>        }
>>>
>>> In the optimized (x86_64) case, the pointer is simply modified
>>> to point to the new node_to_cpumask_map[node] entry.  It remains
>>> a pointer to a const value.
>>>
>>> But the non-optimized version replaces the const cpumask value
>>> with the new cpumask value.  Isn't this breaking the const
>>> attribute?
>>
>> No, I think the pointer really should be const. This doesn't guarantee
>> that the value doesn't change behind our backs, it only prevents us
>> from modifying it ourselves.
>>
>>
>> Vegard
>>
>
> Is this what you had in mind:
>
>
> --- linux-2.6.tip.orig/include/asm-generic/topology.h
> +++ linux-2.6.tip/include/asm-generic/topology.h
> @@ -60,7 +60,7 @@
>  #ifndef node_to_cpumask_ptr
>
>  #define        node_to_cpumask_ptr(v, node)                                    \
> -               cpumask_t _##v = node_to_cpumask(node), *v = &_##v
> +               const cpumask_t _##v = node_to_cpumask(node), *v = &_##v
>
>  #define node_to_cpumask_ptr_next(v, node)                              \
>                          _##v = node_to_cpumask(node)
>
>
> (It's taking a while as now I need to do some cross-compile testing.)

Actually, no.

We don't want the _##v to be const, do we? What do you think about
this? (Watch out for whitespace munges)

diff --git a/include/asm-generic/topology.h b/include/asm-generic/topology.h
index a6aea79..56957f2 100644
--- a/include/asm-generic/topology.h
+++ b/include/asm-generic/topology.h
@@ -60,7 +60,8 @@
 #ifndef node_to_cpumask_ptr

 #define        node_to_cpumask_ptr(v, node)
-               cpumask_t _##v = node_to_cpumask(node), *v = &_##v
+               cpumask_t _##v = node_to_cpumask(node);                 \
+               const cpumask_t *v = &_##v;

 #define node_to_cpumask_ptr_next(v, node)                              \
                          _##v = node_to_cpumask(node)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
