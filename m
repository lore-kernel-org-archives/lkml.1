Return-Path: <linux-kernel-owner+w=401wt.eu-S1755730AbZBAB26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730AbZBAB26 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 20:28:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752546AbZBAB2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 20:28:50 -0500
Received: from smtp1.stealer.net ([88.198.224.204]:58455 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbZBAB2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 20:28:50 -0500
X-Greylist: delayed 337 seconds by postgrey-1.27 at vger.kernel.org; Sat, 31 Jan 2009 20:28:49 EST
Date: Sun, 1 Feb 2009 02:22:54 +0100 (CET)
From: Sven Wegener <sven.wegener@stealer.net>
To: David Rientjes <rientjes@google.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Dave Chinner <david@fromorbit.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] mm: Fix dirty_bytes/dirty_background_bytes sysctls on 64bit
 arches
In-Reply-To: <alpine.DEB.2.00.0811230228530.11384@chino.kir.corp.google.com>
Message-ID: <alpine.LNX.2.00.0902010218350.6140@titan.stealer.net>
References: <alpine.DEB.2.00.0811230228070.11384@chino.kir.corp.google.com> <alpine.DEB.2.00.0811230228530.11384@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
Organization: STEALER.net
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: 0.1
X-Spam-Bar: /
X-Spam-Report: Scanned by SpamAssassin 3.2.1-gr1 2007-05-02 on smtp1.stealer.net at Sun, 01 Feb 2009 01:23:10 +0000
	Bayes: 0.4415 Tokens: new, 183; hammy, 5; neutral, 1; spammy, 2.
	AutoLearn: no
	*  0.1 RDNS_NONE Delivered to trusted network by a host with no rDNS
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4415]
X-Spam-Signature: 351ddf438204ec765f36569b39f1b92f581e467f
X-DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to pass an unsigned long as the minimum, because it gets casted
to an unsigned long in the sysctl handler. If we pass an int, we'll
access four more bytes on 64bit arches, resulting in a random minimum
value.

Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
---
 kernel/sysctl.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 790f9d7..c5ef44f 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -101,6 +101,7 @@ static int two = 2;
 
 static int zero;
 static int one = 1;
+static unsigned long one_ul = 1;
 static int one_hundred = 100;
 
 /* this is needed for the proc_dointvec_minmax for [fs_]overflow UID and GID */
@@ -974,7 +975,7 @@ static struct ctl_table vm_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &dirty_background_bytes_handler,
 		.strategy	= &sysctl_intvec,
-		.extra1		= &one,
+		.extra1		= &one_ul,
 	},
 	{
 		.ctl_name	= VM_DIRTY_RATIO,
@@ -995,7 +996,7 @@ static struct ctl_table vm_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &dirty_bytes_handler,
 		.strategy	= &sysctl_intvec,
-		.extra1		= &one,
+		.extra1		= &one_ul,
 	},
 	{
 		.procname	= "dirty_writeback_centisecs",
