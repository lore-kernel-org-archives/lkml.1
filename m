Return-Path: <linux-kernel-owner+w=401wt.eu-S1423342AbXDYSdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423342AbXDYSdg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 14:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423363AbXDYSdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 14:33:36 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:6642 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423342AbXDYSdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 14:33:35 -0400
X-IronPort-AV: i="4.14,451,1170662400"; 
   d="scan'208"; a="140538383:sNHT47419911"
To: Andi Kleen <ak@suse.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       mst@mellanox.co.il, jackm@mellanox.co.il
Subject: Re: pgprot_writecombine() and PATs on x86
X-Message-Flag: Warning: May contain useful information
References: <ada1wi8xrgt.fsf@cisco.com> <200704252019.28017.ak@suse.de>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 25 Apr 2007 11:33:28 -0700
In-Reply-To: <200704252019.28017.ak@suse.de> (Andi Kleen's message of "Wed, 25 Apr 2007 20:19:27 +0200")
Message-ID: <adaslaowbgn.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 25 Apr 2007 18:33:28.0352 (UTC) FILETIME=[37A90200:01C78768]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > > Where do your patches to add an implementation of
 > > pgprot_writecombine() using PATs on x86 stand?  
 > 
 > It's on my todo list.

Great.  Let me know if there's anything I can do to help.

 > When it's PCI space you can likely just use MTRRs. PAT is mostly useful
 > for applications that do IO with random memory pages

Actually MTRRs seem to be inadequate for a number of reasons.  For
example I have a system where /proc/mtrr looks like:

	$ cat /proc/mtrr 
	reg00: base=0x00000000 (   0MB), size=8192MB: write-back, count=1
	reg01: base=0x200000000 (8192MB), size= 512MB: write-back, count=1
	reg02: base=0x220000000 (8704MB), size= 256MB: write-back, count=1
	reg03: base=0xd0000000 (3328MB), size= 256MB: uncachable, count=1
	reg04: base=0xe0000000 (3584MB), size= 512MB: uncachable, count=1

And I want to map the second half of the second BAR of this device
with write-combining:

	0d:00.0 InfiniBand: Mellanox Technologies Unknown device 634a (rev a0)
		Subsystem: Mellanox Technologies Unknown device 634a
		Flags: bus master, fast devsel, latency 0, IRQ 16
		Memory at fc400000 (64-bit, non-prefetchable) [size=1M]
		Memory at d8000000 (64-bit, prefetchable) [size=8M]
		Memory at fc3fe000 (64-bit, non-prefetchable) [size=8K]
		Capabilities: <access denied>

So it's not clear that there will be enough MTRRs to handle
everything, or that even if there are enough, that there's a safe way
to update the MTRRs to get from the boot-up config to the one we want.
In this case I guess there is a way but it uses all 8 MTRRs, so adding
a device that also wants write combining won't work.

And definitely trying to set up the MTRRs automatically is going to to
be very fragile.  So I think having pgprot_writecombine() implemented
with PATs is really the only sane thing even for this PCI space.

 - R.
