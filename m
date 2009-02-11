Return-Path: <linux-kernel-owner+w=401wt.eu-S1756561AbZBKBT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561AbZBKBT0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 20:19:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755763AbZBKBSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 20:18:53 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:59162 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755368AbZBKBSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 20:18:51 -0500
X-IronPort-AV: E=Sophos;i="4.38,188,1233532800"; 
   d="scan'208";a="247038214"
From: Roland Dreier <rdreier@cisco.com>
To: David Miller <davem@davemloft.net>
Cc: swise@opengridcomputing.com, randy.dunlap@oracle.com,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
Subject: Re: [ofa-general] [PATCH 2.6.30] RDMA/cxgb3: Remove modulo math.
References: <20090210184448.22891.31130.stgit@dell3.ogc.int>
	<adamyctajv8.fsf@cisco.com> <499223F8.1010204@opengridcomputing.com>
	<20090210.170740.208470781.davem@davemloft.net>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 10 Feb 2009 17:18:49 -0800
In-Reply-To: <20090210.170740.208470781.davem@davemloft.net> (David Miller's
	message of "Tue, 10 Feb 2009 17:07:40 -0800 (PST)")
Message-ID: <adaeiy5ahza.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 11 Feb 2009 01:18:50.0667 (UTC) FILETIME=[B2497FB0:01C98BE6]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Is this required?  Strength reduction optimization should do this
> > automatically (and the code has been there for quite a while, so
> > obviously it isn't causing problems)

> GCC won't optimize that modulus the way you expect, try for yourself
> and look at the assembler if you don't believe me. :-)

Are you thinking of the case when there are signed integers involved and
so "% modulus" might produce a different result than "& (modulus - 1)"
(because the compiler can't know that things are never negative)?
Because in this case the compiler seems to do what I thought it would;
the relevant part of the i386 assembly for

		wqe->recv.sgl[i].to = cpu_to_be64(((u32) wr->sg_list[i].addr) %
				(1UL << (12 + page_size[i])));

is

        movl    %eax, 28(%edi,%ebx)     # <variable>.length,
        <variable>.len
        movzbl  28(%esp,%esi), %ecx     # page_size, tmp89
        movl    $1, %eax        #, tmp92
        addl    $12, %ecx       #, tmp90
        sall    %cl, %eax       # tmp90, tmp92
        movl    (%esp), %ecx    # wr,
        decl    %eax    # tmp93
        movl    12(%ecx), %edx  # <variable>.sg_list, <variable>.sg_list
        andl    (%edx,%ebx), %eax       # <variable>.addr, tmp93

ie the compiler computes the modulus, then does decl to compute
modulus-1 and then &s with it.

Or am I misunderstanding your point?

 - R.
