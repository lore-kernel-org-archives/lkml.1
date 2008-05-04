Return-Path: <linux-kernel-owner+w=401wt.eu-S1754716AbYEDPER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbYEDPER (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 11:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbYEDPD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 11:03:57 -0400
Received: from tomts25.bellnexxia.net ([209.226.175.188]:51508 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751966AbYEDPD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 11:03:56 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: As8EAMdsHUhMROPA/2dsb2JhbACBU6gL
Date: Sun, 4 May 2008 11:03:53 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Ingo Molnar <mingo@elte.hu>, Jiri Slaby <jirislaby@gmail.com>,
       David Miller <davem@davemloft.net>, zdenek.kabelac@gmail.com,
       rjw@sisk.pl, paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
       linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
       penberg@cs.helsinki.fi, clameter@sgi.com, linux-kernel@vger.kernel.org,
       pageexec@freemail.hu
Subject: Re: [PATCH 1/1] x86: fix text_poke
Message-ID: <20080504150353.GB23137@Krystal>
References: <481241DC.3070601@zytor.com> <alpine.LFD.1.10.0804251349510.2779@woody.linux-foundation.org> <20080425211205.GC25950@Krystal> <481249FB.8070204@zytor.com> <20080425214704.GD25950@Krystal> <48125635.3060303@zytor.com> <20080425223015.GB31226@Krystal> <alpine.LFD.1.10.0804251534420.2779@woody.linux-foundation.org> <20080428204342.GD27154@Krystal> <48163B50.8010608@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <48163B50.8010608@goop.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:57:14 up 65 days, 11:08,  3 users,  load average: 0.21, 0.56,
	0.92
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jeremy Fitzhardinge (jeremy@goop.org) wrote:
> Mathieu Desnoyers wrote:
>> Markers, with immediate values, only clobbers the eax register and the
>> ZF. It does not restrain inlining nor loop unrolling. It also requires
>> gcc to leave the variables in which the marker is interested "live".
>
> That in itself is pretty significant.  If that value would otherwise be 
> constant folded or strength-reduced away, you're putting a big limitation 
> on what the compiler can do.  The mere fact that its necessary to do 
> something to preserve many values shows how much the compiler transforms 
> the code away from what's in the source, and specifically referencing 
> otherwise unused intermediates inhibits that.
>
> In other words, if you weren't preventing optimisations, you wouldn't need 
> to preserve values as much, because the optimiser wouldn't be getting rid 
> of them.  If you need to preserve lots of values, you're necessarily 
> preventing the optimiser from doing its job.
>
>    J

I am not saying that the standard marker will have to inhibit
optimizations. Actually, it's the contrary : a well-thought marker
should _not_ modify that kind of optimization, and we should put markers
in code locations less likely to inhibit gcc optimizations. However, in
the case where we happen to be interested in information otherwise
optimized away by GCC, it makes sense to inhibit this optimization in
order to have the information available for tracing.

I expect this to happen rarely, but I think we must deal with
optimizations to make sure we never trace garbage due to some unexpected
gcc optimization. I think it's a small (e.g. undetectable at the
macrobenchmark level) price to pay to get correct tracing information.

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
