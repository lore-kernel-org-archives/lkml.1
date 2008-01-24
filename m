Return-Path: <linux-kernel-owner+w=401wt.eu-S1755970AbYAXTOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970AbYAXTOw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 14:14:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753594AbYAXTOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 14:14:44 -0500
Received: from waste.org ([66.93.16.53]:57386 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751960AbYAXTOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 14:14:43 -0500
Subject: Re: [PATCH UPDATE] x86: ignore spurious faults
From: Matt Mackall <mpm@selenic.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Harvey Harrison <harvey.harrison@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>
In-Reply-To: <4797DBA0.5020909@goop.org>
References: <4797D64D.1060105@goop.org> <1201133916.16972.124.camel@brick>
	 <4797DBA0.5020909@goop.org>
Content-Type: text/plain
Date: Thu, 24 Jan 2008 13:14:06 -0600
Message-Id: <1201202046.3897.41.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-01-23 at 16:28 -0800, Jeremy Fitzhardinge wrote:
> When changing a kernel page from RO->RW, it's OK to leave stale TLB
> entries around, since doing a global flush is expensive and they pose
> no security problem.  They can, however, generate a spurious fault,
> which we should catch and simply return from (which will have the
> side-effect of reloading the TLB to the current PTE).
> 
> This can occur when running under Xen, because it frequently changes
> kernel pages from RW->RO->RW to implement Xen's pagetable semantics.
> It could also occur when using CONFIG_DEBUG_PAGEALLOC, since it avoids
> doing a global TLB flush after changing page permissions.

There's perhaps an opportunity to do this lazy TLB trick in the mmap
path as well, where RW mappings are initially mapped as RO so we can
catch processes dirtying them and then switched to RW. If the mapping is
shared across threads on multiple cores, we can defer synchronizing the
TLBs on the others.

-- 
Mathematics is the supreme nostalgia of our time.

