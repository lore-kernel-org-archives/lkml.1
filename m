Return-Path: <linux-kernel-owner+w=401wt.eu-S1755739AbZBKHUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739AbZBKHUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 02:20:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752355AbZBKHUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 02:20:41 -0500
Received: from sj-iport-1.cisco.com ([171.71.176.70]:42493 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbZBKHUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 02:20:40 -0500
X-IronPort-AV: E=Sophos;i="4.38,191,1233532800"; 
   d="scan'208";a="140814335"
From: Roland Dreier <rdreier@cisco.com>
To: David Miller <davem@davemloft.net>
Cc: randy.dunlap@oracle.com, linux-next@vger.kernel.org,
       general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: Re: [ofa-general] [PATCH 2.6.30] RDMA/cxgb3: Remove modulo math.
References: <499223F8.1010204@opengridcomputing.com>
	<20090210.170740.208470781.davem@davemloft.net>
	<adaeiy5ahza.fsf@cisco.com>
	<20090210.172347.189515015.davem@davemloft.net>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 10 Feb 2009 23:20:39 -0800
In-Reply-To: <20090210.172347.189515015.davem@davemloft.net> (David Miller's
	message of "Tue, 10 Feb 2009 17:23:47 -0800 (PST)")
Message-ID: <ada4oz1a188.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 11 Feb 2009 07:20:39.0316 (UTC) FILETIME=[3DA67540:01C98C19]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Must be compiler and platform specific because with gcc-4.1.3 on
 > sparc with -O2, for the test program:
 > 
 > unsigned long page_size[4];
 > 
 > int main(int argc)
 > {
 >         unsigned long long x = argc;
 > 
 >         return x % (1UL << (12 + page_size[argc]));
 > }
 > 
 > I get a call to __umoddi3:

You're not testing the same thing.  The original code was:

		wqe->recv.sgl[i].to = cpu_to_be64(((u32) wr->sg_list[i].addr) %
				(1UL << (12 + page_size[i])));

and it's not that easy to see with all the parentheses, but the
expression being done is (u32) % (unsigned long).  So rather than
unsigned long long in your program, you should have just done unsigned
(u32 is unsigned int on all Linux architectures).  In that case gcc does
not generate a call to any library function in all the versions I have
handy, although gcc 4.1 does do a div instead of an and.  (And I don't
think any 32-bit architectures require a library function for (unsigned)
% (unsigned), so the code should be OK)

Your example shows that gcc is missing a strength reduction opportunity
in not handling (u64) % (unsigned long) on 32 bit architectures, but I
guess it is a more difficult optimization to do, since gcc has to know
that it can simply zero the top 32 bits.

 - R.
