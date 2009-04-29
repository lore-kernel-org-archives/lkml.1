Return-Path: <linux-kernel-owner+w=401wt.eu-S1757373AbZD2RWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373AbZD2RWE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 13:22:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751545AbZD2RVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 13:21:53 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:7745 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbZD2RVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 13:21:52 -0400
X-IronPort-AV: E=Sophos;i="4.40,267,1238976000"; 
   d="scan'208";a="73873494"
From: Roland Dreier <rdreier@cisco.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>, hpa@zytor.com,
       tglx@linutronix.de, h.mitake@gmail.com, rpjday@crashcourse.ca,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Remove readq()/writeq() on 32-bit
References: <49EE37AF.4020507@zytor.com>
	<20090421.173123.191021055.davem@davemloft.net>
	<adak55438gp.fsf_-_@cisco.com>
	<20090428.221228.217954247.davem@davemloft.net>
	<20090429115654.GC11586@elte.hu>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 29 Apr 2009 10:21:45 -0700
In-Reply-To: <20090429115654.GC11586@elte.hu> (Ingo Molnar's message of "Wed,
	29 Apr 2009 13:56:54 +0200")
Message-ID: <adaljpj1il2.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 29 Apr 2009 17:21:45.0660 (UTC) FILETIME=[F8AC8FC0:01C9C8EE]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > What caused 2c5643b1 was that right now we have ugly per driver
 > #defines and inlines for readq/writeq. See:

but 2c5643b1 doesn't fix that situation -- a portable driver still needs
the #defines for other 32-bit architectures.  And 2c5643b1 isn't really
a particularly good step towards rectifying the situation, since if
every 32-bit architecture follows suit and adds its own compatibility
versions, then we'll want someone to go through and unify them into a
generic implementation.  In other words removing the x86 private version
will be part of the work in getting to a final solution.

 > Atomicity of a 64-bit IO space access on 32-bit platforms, on an 
 > unknown-bitness transport (it might even be a 64-bit PCI device 
 > bridged over a 32-bit bridge) is obviously not guaranteed.

Yes, some platforms may not be able to give true atomicity.  eg 32-bit
PowerPC has no instructions that generate 64-bit cycles, even on the CPU
bus.  I do think the 32-bit PCI thing is a bit of a red herring, since
eg PCIe devices can rely on a 64-bit bus.

 > So trying to suggest that 64-bit readq/writeq when running on a 
 > 64-bit kernel is somehow atomic (or can be made atomic) is really 
 > wrong IMO. The 32-bit wrapper is simply the expression of how the 
 > CPU would do a 64-bit access even in 64-bit mode anyway [if the 
 > transport is 32-bit].

As far as I know, all 64-bit CPUs doing 64-bit accesses to a PCIe device
(eg the NIC driven by the niu driver) will generate 64-bit bus cycles.

The issue for me is that the benefit of having this compatibility define
is rather minimal, while the cost is potentially high: spending a long
time debugging platform-specific bugs -- the symptoms will not point
immediately to the IO define, of course.

 - R.
