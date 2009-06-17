Return-Path: <linux-kernel-owner+w=401wt.eu-S1754733AbZFQVNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733AbZFQVNG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 17:13:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751451AbZFQVM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 17:12:56 -0400
Received: from smtp-out.google.com ([216.239.45.13]:15557 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbZFQVMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 17:12:55 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=GHI5QWcY3DDoHhmQ8lOv6Yv4jRwspPYG/si8mCluhYtLDekLz3ZvfD5ZBs/K4Cn5z
	CYJRX7OfyEff7g7/Sx91g==
Date: Wed, 17 Jun 2009 14:12:50 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: "David S. Miller" <davem@davemloft.net>,
       Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch] ipv4: don't warn about skb ack allocation failures
In-Reply-To: <4A3957A1.5030407@gmail.com>
Message-ID: <alpine.DEB.2.00.0906171401440.7198@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0906161203160.27742@p34.internal.lan> <alpine.DEB.2.00.0906161205260.27742@p34.internal.lan> <alpine.DEB.2.00.0906171227040.1089@chino.kir.corp.google.com> <4A394F27.8060308@gmail.com> <alpine.DEB.2.00.0906171326120.4786@chino.kir.corp.google.com>
 <4A3957A1.5030407@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jun 2009, Eric Dumazet wrote:

> > Yes, if they are recoverable without any side effects.  Otherwise, they 
> > will continue to emit page allocation failure messages which cause users 
> > to waste their time when they recognize a problem of an unknown 
> > seriousness level in both reporting the issue and looking for resulting 
> > corruption.  The __GFP_NOWARN annotation suppresses such warnings for 
> > those very reasons.
> 
> Then why emit the warning at first place ?
> 
> Once we patch all call sites to use GFP_ATOMIC | __GFP_NOWARN, I bet 99% 
> GFP_ATOMIC allocations in kernel will use it, so we go back to silent mode.
> 
> If a GFP_ATOMIC call site *cannot* use __GFP_NOWARN, it will either :
> 
> - call panic()
> - crash with a nice stack trace because caller was not aware NULL could be
> returned by kmalloc()
> 
> 
> Maybe GFP_ATOMIC should include __GFP_NOWARN
> 
> #define GFP_ATOMIC  (__GFP_HIGH)
> ->
> #define GFP_ATOMIC  (__GFP_HIGH | __GFP_NOWARN)
> 

You must now mask off __GFP_NOWARN in the gfp flags for the allocation if 
you have a GFP_ATOMIC allocation that wants the page allocation failure 
warning messages.  That message includes pertinent information with regard 
to the state of the VM that is otherwise unavailable by a BUG_ON() or NULL 
pointer dereference.

For example, I could only diagnose Justin's failure as a harmless page 
allocator warning because I could identify its caller, the gfp mask of the 
allocation attempt, and the memory available.  It would not have otherwise 
been possible to find that the system was actually oom.

The general principle is that it is up to the caller to know whether an 
allocation failure is recoverable or not and not up to any VM 
implementation.
