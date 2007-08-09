Return-Path: <linux-kernel-owner+w=401wt.eu-S939638AbXHINPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939638AbXHINPc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 09:15:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933756AbXHINPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 09:15:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33367 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758447AbXHINPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 09:15:08 -0400
Date: Thu, 9 Aug 2007 09:14:23 -0400
From: Chris Snook <csnook@redhat.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       torvalds@linux-foundation.org
Cc: netdev@vger.kernel.org, akpm@linux-foundation.org, ak@suse.de,
       heiko.carstens@de.ibm.com, davem@davemloft.net, schwidefsky@de.ibm.com,
       wensong@linux-vs.org, horms@verge.net.au, wjiang@resilience.com,
       cfriesen@nortel.com, zlynx@acm.org, rpjday@mindspring.com,
       jesper.juhl@gmail.com
Subject: [PATCH 0/24] make atomic_read() behave consistently across all architectures
Message-ID: <20070809131423.GA9927@shell.boston.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

As recent discussions[1], and bugs[2] have shown, there is a great deal of
confusion about the expected behavior of atomic_read(), compounded by the
fact that it is not the same on all architectures.  Since users expect calls
to atomic_read() to actually perform a read, it is not desirable to allow
the compiler to optimize this away.  Requiring the use of barrier() in this
case is inefficient, since we only want to re-load the atomic_t variable,
not everything else in scope.

This patchset makes the behavior of atomic_read uniform by removing the
volatile keyword from all atomic_t and atomic64_t definitions that currently
have it, and instead explicitly casts the variable as volatile in
atomic_read().  This leaves little room for creative optimization by the
compiler, and is in keeping with the principles behind "volatile considered
harmful".

Busy-waiters should still use cpu_relax(), but fast paths may be able to
reduce their use of barrier() between some atomic_read() calls.

	-- Chris

1)	http://lkml.org/lkml/2007/7/1/52
2)	http://lkml.org/lkml/2007/8/8/122
