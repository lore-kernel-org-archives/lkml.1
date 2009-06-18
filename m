Return-Path: <linux-kernel-owner+w=401wt.eu-S1754856AbZFRTXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856AbZFRTXl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 15:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751150AbZFRTXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 15:23:33 -0400
Received: from smtp-out.google.com ([216.239.45.13]:33702 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbZFRTXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 15:23:32 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=re0iXq+6ntK5e9HPZUOd1mOTk2eoje8rN0frh8Jz/0153wIiWCtLCiB2t4eL+9GKm
	wFiXmP+tt2c28U0kWtHzw==
Date: Thu, 18 Jun 2009 12:23:28 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: David Miller <davem@davemloft.net>
cc: eric.dumazet@gmail.com, jpiszcz@lucidpixels.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] ipv4: don't warn about skb ack allocation failures
In-Reply-To: <20090618.120034.246557840.davem@davemloft.net>
Message-ID: <alpine.DEB.2.00.0906181212380.10979@chino.kir.corp.google.com>
References: <4A396EA2.60705@gmail.com> <20090617.160840.58571632.davem@davemloft.net> <alpine.DEB.2.00.0906180935130.2894@chino.kir.corp.google.com> <20090618.120034.246557840.davem@davemloft.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Jun 2009, David Miller wrote:

> > I disagree, page allocation failure messages show vital information about 
> > the state of the VM so that we can find bugs and GFP_ATOMIC allocations 
> > are the most common trigger for these diagnostic messages since 
> > __GFP_WAIT allocations can trigger direct reclaim (and __GFP_FS 
> > allocations can trigger the oom killer) to free memory and will retry the 
> > allocation if ~__GFP_NORETRY.
> 
> It's COMPLETELY and ABSOLUTELY normal for GFP_ATOMIC allocations to
> fail in the networking.
> 

__GFP_NOWARN exists for that reason.

> If you warn it will just spam the logs, and on a router forwarding
> millions of packets per second are you sure that can ever be sane?
> 

The spamming is ratelimited, but GFP_ATOMIC is really the only time we get 
such diagnostic information since __GFP_WAIT allocations can reclaim, 
__GFP_FS allocations can utilize the oom killer, and other order-0 
allocations are implicitly ~__GFP_NORETRY.

As previously mentioned, GFP_ATOMIC allocations that are not __GFP_NOWARN 
have been emitting these diagnostics since 2.5.53.  This has been on your 
TODO list for 6 1/2 years and now you insist all GFP_ATOMIC allocations 
change their default behavior?

I understand what you're trying to avoid, but I disagree with the approach 
of altering the default behavior of GFP_ATOMIC.  I may suggest that 
emitting the page allocation failures become a compile time option; 
CONFIG_DEBUG_VM would be my suggestion.

> Use statistics and tracing if necessary, but log spam no way...
> 

You need the meminfo that is emitted at the time of failure for it to be 
useful.
