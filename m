Return-Path: <linux-kernel-owner+w=401wt.eu-S1753254AbYJDKup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbYJDKup (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 06:50:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbYJDKuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 06:50:37 -0400
Received: from pih-relay05.plus.net ([212.159.14.18]:57860 "EHLO
	pih-relay05.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbYJDKug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 06:50:36 -0400
Message-ID: <48E74A88.50904@yahoo.com>
Date: Sat, 04 Oct 2008 11:50:48 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
User-Agent: Thunderbird 2.0.0.17 (Macintosh/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Reading EeePC900 battery info causes stalls when using SLUB (was
 Re: How how   latent should non-preemptive scheduling be?)
References: <20080922115749.GE14301@elte.hu> <48D88DB4.9020003@yahoo.com> <20080923115323.GA27240@elte.hu> <48D919A9.5000708@yahoo.com> <48D9460C.5040504@yahoo.com> <48D96725.1080909@yahoo.com> <20080927204834.GA31650@elte.hu> <48DFEF8A.3000502@yahoo.com> <20080929083709.GD18663@elte.hu> <48E16097.8060905@yahoo.com> <20080930112241.GC21367@elte.hu> <48E22720.9030603@yahoo.com>
In-Reply-To: <48E22720.9030603@yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Plusnet-Relay: b85fb3b4067f4733e09588780a2fa90f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sitsofe Wheeler wrote:
> I have an EeePC 900 (Intel Celeron 900Mhz) and it seems to be
> skipping while playing sound through various desktop apps with a
> 2.6.27rc6 kernel. It is running off an SD card which really shows up

After weeks of head scratching as to why these latencies didn't occur
using the xandros 2.6.21.4 kernel (but keeping the same userspace) when
my own kernels would always show this problem I finally found the answer
after reading
http://tservice.net.ru/~s0mbre/blog/devel/other/2008_10_01 on kernel
planet - SLUB can cause regressions compared to SLAB. Switching from 
SLUB to SLAB made the problem more or less disappear (which I guess 
makes sense given the large number of kmem_* calls that are made when 
reading the battery).

My understanding with the memory allocators is that SLOB is the smallest 
and simplest. Its forté is that it uses very little memory which makes 
it ideal for embedded systems and is the easiest allocator to 
understand. The downside is that it might tend towards memory 
fragmentation the longer a system runs and is apparently a little bit 
slower than SLAB. The SLAB allocator is something that the linux kernel 
has had for many years and was a good performer until the pressures to 
perform with large SMP systems started to come in to play (at which 
point lots of memory would be used up on fixed structures - 
http://lwn.net/Articles/229984/ ). SLUB is the newest allocator, scales 
up well and has finer grained diagnostics that SLAB.

Prior to today my understanding was that SLUB would be able to replace 
SLAB in all scenarios and perform just as well or better. However now 
I'm not so sure (SLAB appears to be less latent than SLUB). Other than 
SLUB's newness are there cases where SLAB should be chosen instead of 
SLUB (e.g. uniprocessor desktop systems with hundreds of megabytes of 
RAM)? Will SLAB exist as an alternative to SLUB for certain setups?

-- 
Sitsofe | http://sucs.org/~sits
