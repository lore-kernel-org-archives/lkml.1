Return-Path: <linux-kernel-owner+w=401wt.eu-S1758288AbZFQWbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758288AbZFQWbY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 18:31:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755122AbZFQWbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 18:31:17 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:45793 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700AbZFQWbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 18:31:16 -0400
Message-ID: <4A396EA2.60705@gmail.com>
Date: Thu, 18 Jun 2009 00:30:58 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: "David S. Miller" <davem@davemloft.net>,
       Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch] ipv4: don't warn about skb ack allocation failures
References: <alpine.DEB.2.00.0906161203160.27742@p34.internal.lan> <alpine.DEB.2.00.0906161205260.27742@p34.internal.lan> <alpine.DEB.2.00.0906171227040.1089@chino.kir.corp.google.com> <4A394F27.8060308@gmail.com> <alpine.DEB.2.00.0906171326120.4786@chino.kir.corp.google.com> <4A3957A1.5030407@gmail.com> <alpine.DEB.2.00.0906171401440.7198@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.0906171401440.7198@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 18 Jun 2009 00:30:59 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes a écrit :
> On Wed, 17 Jun 2009, Eric Dumazet wrote:
> 
>>> Yes, if they are recoverable without any side effects.  Otherwise, they 
>>> will continue to emit page allocation failure messages which cause users 
>>> to waste their time when they recognize a problem of an unknown 
>>> seriousness level in both reporting the issue and looking for resulting 
>>> corruption.  The __GFP_NOWARN annotation suppresses such warnings for 
>>> those very reasons.
>> Then why emit the warning at first place ?
>>
>> Once we patch all call sites to use GFP_ATOMIC | __GFP_NOWARN, I bet 99% 
>> GFP_ATOMIC allocations in kernel will use it, so we go back to silent mode.
>>
>> If a GFP_ATOMIC call site *cannot* use __GFP_NOWARN, it will either :
>>
>> - call panic()
>> - crash with a nice stack trace because caller was not aware NULL could be
>> returned by kmalloc()
>>
>>
>> Maybe GFP_ATOMIC should include __GFP_NOWARN
>>
>> #define GFP_ATOMIC  (__GFP_HIGH)
>> ->
>> #define GFP_ATOMIC  (__GFP_HIGH | __GFP_NOWARN)
>>
> 
> You must now mask off __GFP_NOWARN in the gfp flags for the allocation if 
> you have a GFP_ATOMIC allocation that wants the page allocation failure 
> warning messages.  That message includes pertinent information with regard 
> to the state of the VM that is otherwise unavailable by a BUG_ON() or NULL 
> pointer dereference.
> 
> For example, I could only diagnose Justin's failure as a harmless page 
> allocator warning because I could identify its caller, the gfp mask of the 
> allocation attempt, and the memory available.  It would not have otherwise 
> been possible to find that the system was actually oom.
> 
> The general principle is that it is up to the caller to know whether an 
> allocation failure is recoverable or not and not up to any VM 
> implementation.

My point is that 99% of callers know allocation failures are
recoverable.

Instead of patching 10000 places in kernel, just patch 10 places where
allocations failures are not recoverable and call BUG() or whatever
lovely debugging aid (using __GFP_NOFAIL for example, I dont know)

GFP_NOWARN should be the default, and GFP_WARN_AND_FULL_EXPLANATION the exception.

In the past, only high order page allocations could trigger some trace,
I wonder why current kernels want to warn that an allocation failed,
since kmalloc(sz, GFP_ATOMIC) is allowed to return NULL and always was.

