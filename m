Return-Path: <linux-kernel-owner+w=401wt.eu-S1756673AbYGYLmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673AbYGYLmw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 07:42:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752473AbYGYLmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 07:42:42 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:61634 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471AbYGYLml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 07:42:41 -0400
X-Greylist: delayed 642 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Jul 2008 07:42:41 EDT
X-IronPort-AV: E=Sophos;i="4.31,252,1215403200"; 
   d="scan'208";a="13310501"
Message-ID: <4889B9AE.3050108@citrix.com>
Date: Fri, 25 Jul 2008 12:31:58 +0100
From: Alex Nixon <alex.nixon@citrix.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: "Alex Nixon (Intern)" <Alex.Nixon@eu.citrix.com>,
       Andi Kleen <andi@firstfloor.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ian Campbell <Ian.Campbell@eu.citrix.com>,
       "Theodore Ts'o" <tytso@mit.edu>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: Large increase in context switch rate
References: <487E43D9.7080703@goop.org> <87mykgrxtv.fsf@basil.nowhere.org> <0E902970173AF84089673FA54B7FE78A329073@lonpexch01.citrite.net> <200807241126.48364.nickpiggin@yahoo.com.au>
In-Reply-To: <200807241126.48364.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Jul 2008 11:31:52.0925 (UTC) FILETIME=[0930E8D0:01C8EE4A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I've bisected down to commit ba52de123d454b57369f291348266d86f4b35070 -
>> [PATCH] inode-diet.  Before that kernbench consistently reports about
>> 35k context switches (total), and after that commit about 53k.  The
>> benchmarks are being run on a tmpfs.  I've verified the results on a
>> different machine, albeit with an almost identical setup (the same
>> kernels and debian distro, kernbench version, and benchmarking a build
>> of the same source).
>>
>> Seems to be a mystery why that patch is (seemingly) the culprit...

The relevant changeset had caused the blocksize to default to 1024 (as opposed
to 4096) - as a result there was a large increase in the time spent waiting on
pipes.

Instead of re-adding the line taken out of fs/pipe.c by Theodore I opted instead
to change the default block size for pseudo-filesystems to PAGE_SIZE, to try
avoid making pipe.c inconsistent with Theodore's new approach.

The performance penalty from these extra context switches is fairly small, but 
is magnified when virtualization is involved, hence the desire to keep it lower
if possible.


>From 4b568a72fc42b52279507eb4d1339e0637ae719a Mon Sep 17 00:00:00 2001
From: Alex Nixon <t_alexn@alexn-desktop.(none)>
Date: Fri, 25 Jul 2008 11:26:44 +0100
Subject: [PATCH] VFS: increase pseudo-filesystem block size to PAGE_SIZE.

Changeset ba52de123d454b57369f291348266d86f4b35070 caused the block size used
by pseudo-filesystems to decrease from PAGE_SIZE to 1024 leading to a doubling
of the number of context switches during a kernbench run.

Signed-off-by: Alex Nixon <Alex.Nixon@citrix.com>
---
 fs/libfs.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/libfs.c b/fs/libfs.c
index baeb71e..1add676 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -216,8 +216,8 @@ int get_sb_pseudo(struct file_system_type *fs_type, char *name,
 
 	s->s_flags = MS_NOUSER;
 	s->s_maxbytes = ~0ULL;
-	s->s_blocksize = 1024;
-	s->s_blocksize_bits = 10;
+	s->s_blocksize = PAGE_SIZE;
+	s->s_blocksize_bits = PAGE_SHIFT;
 	s->s_magic = magic;
 	s->s_op = ops ? ops : &simple_super_operations;
 	s->s_time_gran = 1;
-- 
1.5.4.3


