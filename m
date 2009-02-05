Return-Path: <linux-kernel-owner+w=401wt.eu-S1756088AbZBEFdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088AbZBEFdq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 00:33:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752663AbZBEFdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 00:33:36 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:10663 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbZBEFdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 00:33:35 -0500
X-IronPort-AV: E=Sophos;i="4.37,383,1231113600"; 
   d="scan'208";a="62361241"
From: Roland Dreier <rdreier@cisco.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Eli Cohen <eli@mellanox.co.il>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: FW: [PATCH] powerpc/mm: Export HPAGE_SHIFT
References: <20090203164930.GA10101@mtls03> <ada8wonnh3t.fsf@cisco.com>
	<1233712248.16867.131.camel@pasglop>
	<20090203211329.d6190a08.akpm@linux-foundation.org>
	<aday6wmn2vr.fsf@cisco.com>
	<20090203222601.747ca8b7.akpm@linux-foundation.org>
	<adad4dym2zp.fsf@cisco.com> <1233791729.4612.28.camel@pasglop>
	<ada7i45lb9x.fsf@cisco.com> <1233811493.4612.69.camel@pasglop>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 04 Feb 2009 21:33:34 -0800
In-Reply-To: <1233811493.4612.69.camel@pasglop> (Benjamin Herrenschmidt's
	message of "Thu, 05 Feb 2009 16:24:53 +1100")
Message-ID: <adawsc5jvm9.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 05 Feb 2009 05:33:34.0621 (UTC) FILETIME=[49C14CD0:01C98753]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Right, but then you need to set that in the VMA's, and thus gone is your
 > nice fast g_u_p() that doesn't touch VMAs :-)

Registering memory is a slow path thing in the RDMA world.  Speeding it
up is nice, so we make userspace do the madvise(VM_DONTCOPY) if it cares
but if it doesn't it can leave it out.

 > > Yes, but unfortunately MPI says apps can allocate memory however they
 > > damn well please... in any case these issues are all-too-well-known in
 > > the RDMA world for quite a while.

 > Yup. What do you think of the idea of pre-COWing pages with an elevated
 > count at fork time ?

Super-duper sucks if the first thing the child does is exec() :)
Also if the parent has registered > half the memory in the system then
it's instant OOM.  So not that useful for the RDMA case :)

The one thing that might make sense is to pre-COW any partial pages that
the parent has registered -- ie if half a page can be used by the child,
at least pre-COW that, but leave all the full pages with VM_DONTCOPY.

 - R.
