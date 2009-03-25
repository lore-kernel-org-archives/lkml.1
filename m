Return-Path: <linux-kernel-owner+w=401wt.eu-S1756835AbZCYXXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835AbZCYXXZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 19:23:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752991AbZCYXXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 19:23:17 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:35228 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752861AbZCYXXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 19:23:16 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18890.48350.132781.696909@cargo.ozlabs.ibm.com>
Date: Thu, 26 Mar 2009 10:23:10 +1100
From: Paul Mackerras <paulus@samba.org>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, akpm@linux-foundation.org, tglx@linutronix.de,
       mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: record time running and
 time enabled for each counter
In-Reply-To: <49CAA384.60101@linux.vnet.ibm.com>
References: <18890.6578.728637.139402@cargo.ozlabs.ibm.com>
	<tip-03ced439c94d692363307eeb3abe0bbfa2d08a01@git.kernel.org>
	<49CAA384.60101@linux.vnet.ibm.com>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corey Ashford writes:

> This change looks good to me, except:
> 
> How do I know which value comes first after the counter value if I have 
> both PERF_FORMAT_TOTAL_TIME_ENABLED and PERF_FORMAT_TOTAL_TIME_RUNNING 
> set?  Are they in the order of their enum values?

Yes.

>  The order should be 
> described somewhere.

This comment that I added to perf_counter.h:

/*
 * Bits that can be set in hw_event.read_format to request that
 * reads on the counter should return the indicated quantities,
 * in increasing order of bit value, after the counter value.
 */

describes the order ("in increasing order of bit value").  So you will
get the count, total time enabled, total time running, in that order.

>  Is there anything to keep a kernel code change 
> from inadvertantly reversing the position of two values at some point in 
> the future?

Well, that would be an ABI breakage.  Once it's upstream, we won't
break the ABI, and if someone does break it and no-one realizes at the
time, we'll revert their change once we do realize.  (With a possible
exception for security holes that can't be fixed without breaking the
ABI, of course, but I can't see how that would be the case here.)

Until it goes into Linus' tree, we can still change the ABI in
incompatible ways.  Ingo and Peter are talking about using a tagged
format for the data obtained from read(), which would solve your
problem in another way, though it would make the userspace code more
complicated (it would have to check that the tags were what it was
expecting, and cope with the situation where it doesn't get a value it
needs).

Paul.
