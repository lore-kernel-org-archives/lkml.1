Return-Path: <linux-kernel-owner+w=401wt.eu-S1758156AbYHUVnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156AbYHUVnQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 17:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753561AbYHUVm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 17:42:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52262 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752840AbYHUVm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 17:42:59 -0400
Date: Thu, 21 Aug 2008 14:41:57 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH] Writer-biased low-latency rwlock v8
In-Reply-To: <48ADDD6D.6000504@zytor.com>
Message-ID: <alpine.LFD.1.10.0808211433091.3487@nehalem.linux-foundation.org>
References: <alpine.LFD.1.10.0808161014300.3324@nehalem.linux-foundation.org> <20080816211954.GB7358@Krystal> <alpine.LFD.1.10.0808161422290.3324@nehalem.linux-foundation.org> <20080817075335.GA25019@Krystal> <alpine.LFD.1.10.0808170909420.3324@nehalem.linux-foundation.org>
 <20080817191034.GA5258@Krystal> <20080818232500.GF6732@linux.vnet.ibm.com> <20080819060417.GB24085@Krystal> <20080819073345.GA30285@Krystal> <alpine.LFD.1.10.0808190946560.3324@nehalem.linux-foundation.org> <20080821205045.GA24909@Krystal>
 <alpine.LFD.1.10.0808211356360.3487@nehalem.linux-foundation.org> <48ADDD6D.6000504@zytor.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 21 Aug 2008, H. Peter Anvin wrote:
>
> First of all, let me say I don't pretend to understand formally how you deal
> with overflow-after-the-fact, as unlikely as it is.

Just make sure it can't overflow. With spinlocks, you are guaranteed that 
you won't have more than NR_CPU's thing, so 20 bits is pretty safe. 30 
bits is ridiculously safe.

> However, it seems to me to be an easy way to avoid it.  Simply by changing the
> read-test mask to $0x80000003, you will kick the code down the slow path once
> the read counter reaches $0x80000004 (2^29+1 readers), where you can do any
> necessary fixup -- or BUG() -- at leisure.

Sure, you could do things like that, but that sounds like a separate 
"debugging" version, not the main one.

> This fastpath ends up being identical in size and performance to the one you
> posted, although yours could be reduced by changing the test to a testb
> instruction -- at the almost certainly unacceptable expense of taking a
> partial-register stall on the CPUs that have those.

Well, you could just change the "testl $3,%eax" into an "andl $3,%eax", 
and it will be two bytes shorter with no partial register stall.

I forgot that "testl" doesn't have the byte immediate version.

		Linus
