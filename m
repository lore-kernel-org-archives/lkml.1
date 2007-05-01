Return-Path: <linux-kernel-owner+w=401wt.eu-S1754838AbXEARCK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbXEARCK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 13:02:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754845AbXEARCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 13:02:10 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:23448 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754838AbXEARCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 13:02:06 -0400
Date: Tue, 1 May 2007 10:00:46 -0700
From: Bill Irwin <bill.irwin@oracle.com>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Bill Irwin <bill.irwin@oracle.com>, Andi Kleen <ak@suse.de>,
       ebiederm@xmission.com, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [30/30] x86_64: Add missing !X86_PAE dependincy to the 2G/2G split.
Message-ID: <20070501170046.GO26598@holomorphy.com>
Mail-Followup-To: Bill Irwin <bill.irwin@oracle.com>,
	Eric Dumazet <dada1@cosmosbay.com>, Andi Kleen <ak@suse.de>,
	ebiederm@xmission.com, patches@x86-64.org,
	linux-kernel@vger.kernel.org
References: <20070501557.815359000@suse.de> <20070501035829.1C93D13CAF@wotan.suse.de> <4636C16F.204@cosmosbay.com> <20070501062132.GQ25929@bingen.suse.de> <20070501130132.GL26598@holomorphy.com> <46376210.6090200@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <46376210.6090200@cosmosbay.com>
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Irwin a écrit :
>> as a stopgap measure, but I'm not all that interested in grabbing patch
>> credits where others could do it easily enough. Either of the config
>> alterations is fine by me as they now stand; maybe Eric Dumazet might
>> care to do something like my suggestion at some point.

On Tue, May 01, 2007 at 05:51:44PM +0200, Eric Dumazet wrote:
> Your patch is very fine Bill, please resubmit it with proper Signed-off-by
> My first patch was a trivial reaction to try to keep alive 2G/2G split, 
> yours is better for fine tuning.

I was hoping you would submit it as an update, but maybe adding your
Signed-off-by: to my own will do.


-- wli


Only 1GB-aligned kernel/user splits are now handled for PAE. The
2GB/2GB split attempts to avoid aliasing vmallocspace with the 1:1
mapping for physical memory by using an actual split of 1.875/2.125
to accommodate 128MB of vmallocspace out of what would otherwise
be a full 2GB for userspace. That attempt disturbs the alignment
required by PAE for 2GB/2GB splits, and furthermore does not provide
a 2GB/2GB split as advertised.

This patch resolves the issues here in two manners. The first is
by providing a true 2GB/2GB split in addition to the 1.875/2.125
split. The second is by renaming the 1.875/2.125 split to
CONFIG_VMSPLIT_2G_OPT analogously to CONFIG_VMSPLIT_3G_OPT, which
performs a similar manuever to avoid aliasing vmallocspace with
the 1:1 mapping for physical memory around the 3GB boundary. With
the 1.875/2.125 split properly-named, its config option is then
tagged as depending on !HIGHMEM to express the PAE implementation's
current inability to deal with such unaligned splits.

This patch is essentially a combination of two patches, one written
by Eric Biederman and the other by Eric Dumazet. If they could add
their Signed-off-by: to this, I'd be much obliged.

Signed-off-by: William Irwin <wli@holomorphy.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Mark Lord <lkml@rtr.ca>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Andi Kleen <ak@suse.de>


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
 
