Return-Path: <linux-kernel-owner+w=401wt.eu-S1760122AbYG1WAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760122AbYG1WAU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 18:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751383AbYG1WAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 18:00:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41607 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893AbYG1WAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 18:00:04 -0400
Message-ID: <488E4166.5070304@redhat.com>
Date: Mon, 28 Jul 2008 18:00:06 -0400
From: Chuck Ebbert <cebbert@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jan Beulich <jbeulich@novell.com>, Andi Kleen <andi@firstfloor.org>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH] i386: improve double fault handling
References: <4880A912.76E4.0078.0@novell.com> <4881263B.7060700@zytor.com> <48846B02.76E4.0078.0@novell.com> <20080721110510.GC10782@elte.hu> <4885CEFE.76E4.0078.0@novell.com> <20080728134252.GI5515@elte.hu>
In-Reply-To: <20080728134252.GI5515@elte.hu>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> All CPUs hitting a double fault simultaneously and corrupting each 
> others' kernel stack is a theoretical possibility - but is handling it 
> worth the complexity? It appears to me that a lock plus a short stub 
> function that takes the lock (with no stack usage) would handle that 
> much better.

That can't happen now because the TSS gets marked busy so we will get a
triple fault instead. One thing we might want to do in the current code
is unset the busy flag after handling the fault and before we start looping
at the end of the handler so we can handle another fault later.

> 
> So i'm really uneasy about all this. Breakage in such rarely used code 
> gets found very late, and has thus a high risk of losing debug 
> information when we need it the most. (i.e. it works in the exact 
> _opposite_ way of the intented goal of making things more robust - it 
> makes things less robust)
> 

Also how much bloat does this cause, having a per-CPU TSS and stack for every
fault handler that uses this method?

