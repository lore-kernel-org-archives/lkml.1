Return-Path: <linux-kernel-owner+w=401wt.eu-S1757488AbYISIzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488AbYISIzT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 04:55:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbYISIzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 04:55:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58679 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751389AbYISIzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 04:55:05 -0400
Date: Fri, 19 Sep 2008 01:55:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Brett Pemberton <brett@vpac.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: BUG: soft lockup in 2.6.25.5
Message-Id: <20080919015502.4183933d.akpm@linux-foundation.org>
In-Reply-To: <1221796156.4019.204.camel@sys05.in.vpac.org>
References: <1221796156.4019.204.camel@sys05.in.vpac.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Sep 2008 13:49:16 +1000 Brett Pemberton <brett@vpac.org> wrote:

> I'm getting about 3-5 machines in a cluster of 95 hanging with 
> 
> BUG: soft lockup - CPU#7 stuck for 61s! [pdflush:321]
> 
> per week.  Nothing in common each time, different users running
> different jobs on different nodes.
> 
> The most recent is at the end of this email, .config is attached.
> 
> Googling is scary.  Many people reporting these, but never any response.
> It's happening on enough separate nodes that I can't believe it's
> hardware, although they are identical machines:
> 
> - 2x Quad-Core AMD Opteron(tm) Processor 2356
> - 32gb ram
> - 4 x sata drives
> 
> Running CentOS 5.2 with a kernel.org kernel
> Has been happening with a variety of kernels from 2.6.25 - present.

Yes, it's a false positive.  With a lot of memory and a random-access
or lot-of-files writing behaviour, it can take tremendous amounts of
time to get everything stored on the disk.

Not sure what to do about it, really.  Perhaps touch the softlockup
detector somewhere in the writeback code.

> I'd love any advice on where to turn to next and what avenues to pursue.

Set /proc/sys/kernel/softlockup_thresh to zero to shut it up :(

hm, there's a bug...

--- a/Documentation/sysctl/kernel.txt~a
+++ a/Documentation/sysctl/kernel.txt
@@ -351,9 +351,10 @@ kernel.  This value defaults to SHMMAX.
 
 softlockup_thresh:
 
-This value can be used to lower the softlockup tolerance
-threshold. The default threshold is 10s.  If a cpu is locked up
-for 10s, the kernel complains.  Valid values are 1-60s.
+This value can be used to lower the softlockup tolerance threshold.  The
+default threshold is 60 seconds.  If a cpu is locked up for 60 seconds, the
+kernel complains.  Valid values are 1-60 seconds.  Setting this tunable to
+zero will disable the softlockup detection altogether.
 
 ==============================================================
 
_

