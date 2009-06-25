Return-Path: <linux-kernel-owner+w=401wt.eu-S1757347AbZFYP0C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347AbZFYP0C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 11:26:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755294AbZFYPZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 11:25:53 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:59341 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754724AbZFYPZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 11:25:52 -0400
Subject: Re: kmemleak false positive?
From: Catalin Marinas <catalin.marinas@arm.com>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20090625145600.GA6654@redhat.com>
References: <20090625001137.GB22755@redhat.com>
	 <1245921918.26218.19.camel@pc1117.cambridge.arm.com>
	 <20090625145600.GA6654@redhat.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Thu, 25 Jun 2009 16:25:39 +0100
Message-Id: <1245943539.26218.70.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Jun 2009 15:25:40.0197 (UTC) FILETIME=[327B0150:01C9F5A9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-25 at 10:56 -0400, Dave Jones wrote:
> On Thu, Jun 25, 2009 at 10:25:17AM +0100, Catalin Marinas wrote:
>  > > kmemleak:   backtrace:
>  > > kmemleak:     [<c04fd8b3>] kmemleak_alloc+0x193/0x2b8
>  > > kmemleak:     [<c04f5e73>] kmem_cache_alloc+0x11e/0x174
>  > > kmemleak:     [<c0aae5a7>] debug_objects_mem_init+0x63/0x1d9
>  > > kmemleak:     [<c0a86a62>] start_kernel+0x2da/0x38d
>  > > kmemleak:     [<c0a86090>] i386_start_kernel+0x7f/0x98
>  > > kmemleak:     [<ffffffff>] 0xffffffff
>  > 
>  > It could be a false positive. Do you get some "kmemleak: referenced"
>  > messages as well at a later time? In this case, it is just transient
>  > "leak", caused maybe by pointers stored on the stack or registers.
> 
> Yes, some time later.
[...]
> Hmm, it's pretty noisy, and everything it's found so far looks to be
> a false positive.

In this case, it would make sense to enable task stacks scanning by
default:

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 17096d1..a38418a 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -194,7 +194,7 @@ static unsigned long jiffies_min_age;
 /* delay between automatic memory scannings */
 static signed long jiffies_scan_wait;
 /* enables or disables the task stacks scanning */
-static int kmemleak_stack_scan;
+static int kmemleak_stack_scan = 1;
 /* mutex protecting the memory scanning */
 static DEFINE_MUTEX(scan_mutex);
 /* mutex protecting the access to the /sys/kernel/debug/kmemleak file */

>  > You can mount debugfs on /sys/kerne/debug and read the kmemleak file in
>  > there (it triggers a new scan as well).
> 
> Currently prints the acpi traces I already posted.

If they are still consistently shown with stack=on, it could be a leak.

-- 
Catalin

