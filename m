Return-Path: <linux-kernel-owner+w=401wt.eu-S1757586AbZHQKLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757586AbZHQKLS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 06:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757410AbZHQKLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 06:11:17 -0400
Received: from cyrus.watson.org ([65.122.17.42]:60343 "EHLO cyrus.watson.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842AbZHQKLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 06:11:17 -0400
Date: Mon, 17 Aug 2009 11:11:18 +0100 (BST)
From: Robert Watson <rwatson@FreeBSD.org>
X-X-Sender: robert@fledge.watson.org
To: David Wagner <daw@cs.berkeley.edu>
cc: Oliver Pinter <oliver.pntr@gmail.com>, freebsd-hackers@FreeBSD.org,
       linux-kernel@vger.kernel.org
Subject: Re: Security: information leaks in /proc enable keystroke recovery
In-Reply-To: <200908170058.n7H0wahu005383@taverner.cs.berkeley.edu>
Message-ID: <alpine.BSF.2.00.0908171046010.1901@fledge.watson.org>
References: <200908170058.n7H0wahu005383@taverner.cs.berkeley.edu>
User-Agent: Alpine 2.00 (BSF 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 16 Aug 2009, David Wagner wrote:

> I accept your argument that there is no point trying to defend against 
> deliberate communication of information between two cooperating processes 
> via some sneaky channel; there is no hope of stopping that in 
> general-purpose commodity OS's.  If process X and Y are both colluding to 
> send information from X to Y, they will succeed, no matter how hard we try. 
> We have no hope of closing all such channels, for general-purpose commodity 
> OS's (like FreeBSD or Linux).

Moving beyind EIP/ESP, which are clearly a bad idea:

The OS community has not engaged well with the concerns raised by past 
cache-based crypto side channels, in part because it seemed the least complex 
solution was hardening crypto against having key-driven footprints in the 
cache.  However, the problem they represent (avoiding the use of shared 
resources between mutually untrusting processes, and then mitigating efects 
that remain) definitely sounds like the covert channel problem, with very 
similar concerns extensively discussed in the documents I referred to.

In an interactive system, the scheduling of threads in a process reflect the 
completion of various events: user I/O, network I/O, disk I/O, or perhaps the 
expiration of a timer associated with application-internal events (animations, 
statistics, etc).  Monitoring these from another process is intentionally easy 
on commodity OS's -- there are a variety of monitoring statistics, from the 
already mentioned process/thread execution time, to context switch counters, 
wait channels/addresses, lock states, timestamps on special devices, etc, not 
to mention having CPU sink processes that nice themselves appropriately and 
hang around monitoring execution of other processes/threads/the kernel through 
gaps in its own scheduling.  Some of the intentional mechanisms are specific 
to processes, and easy to block by policy.  Others are global, and begin the 
sliding down the slope of "making the system and applications a lot harder to 
analyze and debug", something that sites frequently hosting large numbers of 
mutually untrusting users (web farms) may not be willing to deal do.

Into the area of techniques that annoy people: my guess is that you may also 
be able to measure the context switching of processes on other CPUs through 
very careful timing of events in the kernel on your local CPU.  For example, 
it's a reasonable bet that using the TSC and carefully selected system 
calls/arguments, you can measure cache line behavior associated with kernel 
scheduler/statistic lines that will be pulled to another CPU when a context 
switch takes place.  For example, consider per-CPU run queue locks or context 
switch statistics, which may in edge cases be pulled to another CPU, such as 
when monitoring takes place.  If they are already local to the attacking CPU, 
no context switch has taken place on the other CPU since you last checked; if 
they're non-local, a context switch has taken place.

Following Colin Percival's paper on cache side channels for RSA, there was a 
lot of discussion about how the OS could help mitigate these problems: do you 
provide "security critical sections" around cryptography which introduce 
temporary but performance-degrading mutual exclusion of caches based on 
knowledge of the CPU topology, for example.  Identifying and offering similar 
trade-offs between performance and security, avoiding excess complexity, and 
in particular, limiting the scope of those performance losses to only critical 
moments will be key if the security community wants to engage the OS community 
here.  Otherwise I suspect these concerns will pass by, unaddressed, again.

Robert N M Watson
Computer Laboratory
University of Cambridge
