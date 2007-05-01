Return-Path: <linux-kernel-owner+w=401wt.eu-S1031213AbXEANCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031213AbXEANCt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 09:02:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031221AbXEANCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 09:02:49 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:16883 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031213AbXEANCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 09:02:48 -0400
Date: Tue, 1 May 2007 06:01:32 -0700
From: Bill Irwin <bill.irwin@oracle.com>
To: Andi Kleen <ak@suse.de>
Cc: Eric Dumazet <dada1@cosmosbay.com>, ebiederm@xmission.com,
       patches@x86-64.org, linux-kernel@vger.kernel.org, bill.irwin@oracle.com
Subject: Re: [PATCH] [30/30] x86_64: Add missing !X86_PAE dependincy to the 2G/2G split.
Message-ID: <20070501130132.GL26598@holomorphy.com>
Mail-Followup-To: Bill Irwin <bill.irwin@oracle.com>,
	Andi Kleen <ak@suse.de>, Eric Dumazet <dada1@cosmosbay.com>,
	ebiederm@xmission.com, patches@x86-64.org,
	linux-kernel@vger.kernel.org
References: <20070501557.815359000@suse.de> <20070501035829.1C93D13CAF@wotan.suse.de> <4636C16F.204@cosmosbay.com> <20070501062132.GQ25929@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070501062132.GQ25929@bingen.suse.de>
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2007 at 06:26:23AM +0200, Eric Dumazet wrote:
>> Hum... We lose a usefull 2G/2G split. Should'nt we use a patch to change 
>> PAGE_OFFSET to 0x8000000 instead of 0x78000000 and keep 2G/2G split ?

On Tue, May 01, 2007 at 08:21:32AM +0200, Andi Kleen wrote:
> I dropped the patch for now.

I'm more miffed about what it's cleaning up after than the patch itself.


On Tue, May 01, 2007 at 06:26:23AM +0200, Eric Dumazet wrote:
>> [PATCH] i386 : Adjust CONFIG_PAGE_OFFSET in case of 2G/2G split and X86_PAE
>> When in PAE mode we require that the user kernel divide to be
>> on a 1G boundary.  We must therefore make sure PAGE_OFFSET is correctlty 
>> defined in the 2G/2G split and PAE mode.

On Tue, May 01, 2007 at 08:21:32AM +0200, Andi Kleen wrote:
> Looks reasonable. Did you test both cases? wli, ok for you too?

Sorry about the delay in replying.

I don't mind so long as we're not letting doorstop configs through. I'd
probably do something more like

Index: sched/arch/i386/Kconfig
===================================================================
--- sched.orig/arch/i386/Kconfig	2007-05-01 04:35:47.065162310 -0700
+++ sched/arch/i386/Kconfig	2007-05-01 04:36:50.100754504 -0700
@@ -571,6 +571,9 @@
 		bool "3G/1G user/kernel split (for full 1G low memory)"
 	config VMSPLIT_2G
 		bool "2G/2G user/kernel split"
+	config VMSPLIT_2G_OPT
+		depends on !HIGHMEM
+		bool "2G/2G user/kernel split (for full 2G low memory)"
 	config VMSPLIT_1G
 		bool "1G/3G user/kernel split"
 endchoice
@@ -578,7 +581,8 @@
 config PAGE_OFFSET
 	hex
 	default 0xB0000000 if VMSPLIT_3G_OPT
-	default 0x78000000 if VMSPLIT_2G
+	default 0x80000000 if VMSPLIT_2G
+	default 0x78000000 if VMSPLIT_2G_OPT
 	default 0x40000000 if VMSPLIT_1G
 	default 0xC0000000
 
as a stopgap measure, but I'm not all that interested in grabbing patch
credits where others could do it easily enough. Either of the config
alterations is fine by me as they now stand; maybe Eric Dumazet might
care to do something like my suggestion at some point.

My interest here is in approaches that aren't really centered around
config options. Those are pmd handling for 1GB-unaligned PAGE_OFFSET
in PAE and dynamic vmallocspace reservation, the latter of which is
more complex than the first. I'd probably only do the pmd handling as
it's much easier than dynamic vmallocspace, which does substantial
violence to the core in order to reserve chunks of ZONE_NORMAL's
virtualspace so that no boot-time virtualspace reservations need to be
made for vmalloc(). Basically it would make vmalloc() proper use
physically contiguous memory and vmap() fiddle with ZONE_NORMAL
pagetables while reserving physical memory underlying the virtualspace
reserved for vmap() so that it's no longer necessary to carve
vmallocspace out of userspace to avoid highmem. That would occur at the
cost of runtime memory footprint of the rarely-called vmap() and
ZONE_NORMAL mapping updates. It would also alleviate pressure on
vmallocspace in configurations where it would be severely limited.

I'm doing a bit of thinking about this laptop-avoiding-highmem problem.
I've not come up with any better ideas than the dynamic vmallocspace
approach to avoid ABI damage while avoiding both highmem and sacrificing
memory for 1GB laptops, and slightly mitigating ABI damage for 2GB
laptops' highmem avoidance efforts. I'm thinking the applicability
isn't broad enough to merit the effort of dynamic vmallocspace. The pmd
fixup for 1GB-unaligned splits is not such a big deal in comparison.


-- wli
