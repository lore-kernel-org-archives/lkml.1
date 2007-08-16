Return-Path: <linux-kernel-owner+w=401wt.eu-S1759274AbXHPT6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759274AbXHPT6q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 15:58:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754076AbXHPT6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 15:58:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39454 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751613AbXHPT6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 15:58:31 -0400
Message-ID: <46C4ABA5.9010804@redhat.com>
Date: Thu, 16 Aug 2007 15:55:17 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (Macintosh/20070509)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
CC: Herbert Xu <herbert@gondor.apana.org.au>,
       Paul Mackerras <paulus@samba.org>, Satyam Sharma <satyam@infradead.org>,
       Christoph Lameter <clameter@sgi.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Netdev <netdev@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, ak@suse.de,
       heiko.carstens@de.ibm.com, David Miller <davem@davemloft.net>,
       schwidefsky@de.ibm.com, wensong@linux-vs.org, horms@verge.net.au,
       wjiang@resilience.com, cfriesen@nortel.com, zlynx@acm.org,
       rpjday@mindspring.com, jesper.juhl@gmail.com,
       segher@kernel.crashing.org
Subject: Re: [PATCH 0/24] make atomic_read() behave consistently across all
 architectures
References: <20070816003948.GY9645@linux.vnet.ibm.com> <Pine.LNX.4.64.0708151740570.10497@schroedinger.engr.sgi.com> <18115.44462.622801.683446@cargo.ozlabs.ibm.com> <20070816020042.GA30650@gondor.apana.org.au> <18115.45316.702491.681906@cargo.ozlabs.ibm.com> <alpine.LFD.0.999.0708160800130.24380@enigma.security.iitk.ac.in> <alpine.LFD.0.999.0708160815510.24380@enigma.security.iitk.ac.in> <18115.52863.638655.658466@cargo.ozlabs.ibm.com> <20070816053945.GB32442@gondor.apana.org.au> <18115.62741.807704.969977@cargo.ozlabs.ibm.com> <20070816070907.GA964@gondor.apana.org.au> <Pine.LNX.4.64.0708161743500.13267@kivilampi-30.cs.helsinki.fi>
In-Reply-To: <Pine.LNX.4.64.0708161743500.13267@kivilampi-30.cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ilpo Järvinen wrote:
> On Thu, 16 Aug 2007, Herbert Xu wrote:
> 
>> We've been through that already.  If it's a busy-wait it
>> should use cpu_relax. 
> 
> I looked around a bit by using some command lines and ended up wondering 
> if these are equal to busy-wait case (and should be fixed) or not:
> 
> ./drivers/telephony/ixj.c
> 6674:   while (atomic_read(&j->DSPWrite) > 0)
> 6675-           atomic_dec(&j->DSPWrite);
> 
> ...besides that, there are couple of more similar cases in the same file 
> (with braces)...

atomic_dec() already has volatile behavior everywhere, so this is 
semantically okay, but this code (and any like it) should be calling 
cpu_relax() each iteration through the loop, unless there's a compelling 
reason not to.  I'll allow that for some hardware drivers (possibly this 
one) such a compelling reason may exist, but hardware-independent core 
subsystems probably have no excuse.

If the maintainer of this code doesn't see a compelling reason to add 
cpu_relax() in this loop, then it should be patched.

	-- Chris
