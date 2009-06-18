Return-Path: <linux-kernel-owner+w=401wt.eu-S1754167AbZFRQ41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167AbZFRQ41 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 12:56:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbZFRQ4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 12:56:20 -0400
Received: from smtp-out.google.com ([216.239.33.17]:21989 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbZFRQ4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 12:56:19 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=lFKXD6XNVRcLguVO1Ad9QjOuMYV00yeO0FaK7jNGCLBWUd0ZXenFgBKi8p39+LJCY
	mVRxk1HpvpAVFhTfjeekA==
Date: Thu, 18 Jun 2009 09:56:14 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: David Miller <davem@davemloft.net>
cc: eric.dumazet@gmail.com, jpiszcz@lucidpixels.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] ipv4: don't warn about skb ack allocation failures
In-Reply-To: <20090617.160840.58571632.davem@davemloft.net>
Message-ID: <alpine.DEB.2.00.0906180935130.2894@chino.kir.corp.google.com>
References: <4A3957A1.5030407@gmail.com> <alpine.DEB.2.00.0906171401440.7198@chino.kir.corp.google.com> <4A396EA2.60705@gmail.com> <20090617.160840.58571632.davem@davemloft.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jun 2009, David Miller wrote:

> From: Eric Dumazet <eric.dumazet@gmail.com>
> Date: Thu, 18 Jun 2009 00:30:58 +0200
> 
> > My point is that 99% of callers know allocation failures are
> > recoverable.
> 
> I agree that, surely for GFP_ATOMIC, warnings should be off
> by default.
> 

I disagree, page allocation failure messages show vital information about 
the state of the VM so that we can find bugs and GFP_ATOMIC allocations 
are the most common trigger for these diagnostic messages since 
__GFP_WAIT allocations can trigger direct reclaim (and __GFP_FS 
allocations can trigger the oom killer) to free memory and will retry the 
allocation if ~__GFP_NORETRY.

GFP_ATOMIC allocations are allowed to access memory deeper in zone 
watermarks so that they are more likely to succeed; page allocation 
failure messages indicate that the system is either completely oom or that 
there is a serious VM bug.

Defining GFP_ATOMIC as (__GFP_HIGH | __GFP_NOWARN) would also require the 
bit to be masked off if page allocation failure messages should be 
emitted.  GFP_ATOMIC | GFP_DMA allocations become
(GFP_ATOMIC | GFP_DMA) & ~__GFP_NOWARN, for example.  This is not normally 
how GFP_* macros are composed from __GFP_* bits because of the increasing 
complexity.

It's again my opinion that allocators that can recover ("recover" used 
here in the sense of simply delaying an ack such as the ipv4 case 
discussed earlier, for example) without side effects (like a failed 
syscall) should specify __GFP_NOWARN.

Page allocation failures have emitted warnings for all gfp masks without 
__GFP_NOWARN since 2.5.53 over six and a half years ago.
