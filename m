Return-Path: <linux-kernel-owner+w=401wt.eu-S1763943AbXGXSNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763943AbXGXSNw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 14:13:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763326AbXGXSNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 14:13:38 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40109 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763584AbXGXSNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 14:13:37 -0400
Date: Tue, 24 Jul 2007 11:13:04 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Satyam Sharma <ssatyam@cse.iitk.ac.in>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6/8] i386: bitops: Don't mark memory as clobbered
 unnecessarily
In-Reply-To: <1185298932.6586.22.camel@localhost>
Message-ID: <alpine.LFD.0.999.0707241108360.3607@woody.linux-foundation.org>
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in>
  <20070723160558.22137.71943.sendpatchset@cselinux1.cse.iitk.ac.in> 
 <alpine.LFD.0.999.0707231054290.3607@woody.linux-foundation.org> 
 <1185270756.5439.256.camel@localhost.localdomain> 
 <alpine.LFD.0.999.0707241021210.3607@woody.linux-foundation.org>
 <1185298932.6586.22.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 24 Jul 2007, Trond Myklebust wrote:
> 
> That's not what the Documentation/memory-barriers.txt states:

Hmm.. You're right. We only actually need it for the unconditional bitops, 
like the *unlock* side.

IOW, if you do a spinlock with the bitops, the locking side should be able 
to use a "test_and_set_bit()" on its own, but the unlocking side should be

	smp_mb__before_clear_bit();
	clear_bit();

because the ones that don't return a value also don't imply a memory 
barrier.

		Linus
