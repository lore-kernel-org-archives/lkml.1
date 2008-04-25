Return-Path: <linux-kernel-owner+w=401wt.eu-S1765815AbYDYVU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765815AbYDYVU1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 17:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759204AbYDYVUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 17:20:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60764 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757006AbYDYVUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 17:20:13 -0400
Message-ID: <481249FB.8070204@zytor.com>
Date: Fri, 25 Apr 2008 14:15:39 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Jiri Slaby <jirislaby@gmail.com>, David Miller <davem@davemloft.net>,
       zdenek.kabelac@gmail.com, rjw@sisk.pl, paulmck@linux.vnet.ibm.com,
       akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
       herbert@gondor.apana.org.au, penberg@cs.helsinki.fi, clameter@sgi.com,
       linux-kernel@vger.kernel.org, pageexec@freemail.hu,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 1/1] x86: fix text_poke
References: <alpine.LFD.1.10.0804250904560.2779@woody.linux-foundation.org> <20080425161916.GD3265@one.firstfloor.org> <20080425163035.GE9503@Krystal> <481209F2.4050908@zytor.com> <20080425170929.GA16180@Krystal> <20080425183748.GB16180@Krystal> <48123C9B.9020306@zytor.com> <20080425203717.GB25950@Krystal> <481241DC.3070601@zytor.com> <alpine.LFD.1.10.0804251349510.2779@woody.linux-foundation.org> <20080425211205.GC25950@Krystal>
In-Reply-To: <20080425211205.GC25950@Krystal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> 
> The point is to provide a way to dynamically enable code at runtime
> without noticeable performance impact on the system. It's principally
> useful to control the markers in the kernel, which can be placed in very
> frequently executed code paths. The original markers add a memory read,
> test and conditional branch at each marker site. By using the immediate
> values patchset, it goes down to a load immediate value, test and branch.
> 
> However, Ingo was still unhappy with the conditional branch, so I cooked
> this jump patching optimization on top of the immediate values. It
> looks for an expected pattern which limits the liveliness of the %al and
> ZF registers to the 3 instructions and, if it finds it, patches a jump
> located just before the mov instruction to skip the whole pattern and
> behave exactly like the conditional branch.
> 
> So basically we get code dynamically actvated by patching a single jump.
> 

Note that all these optimizations only make sense if the case where we 
*take* the "marker" is frequent, *and* the marker itself is not too 
expensive.

If that is not the case, just put in a noop that is dynamically patched 
to an INT3 or ICEBP instruction (one byte) or an INT instruction (two 
bytes), take the exception, look up the source address and revector to 
the marker code.

	-hpa
