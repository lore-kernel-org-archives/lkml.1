Return-Path: <linux-kernel-owner+w=401wt.eu-S936257AbZLQEGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936257AbZLQEGe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:06:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936158AbZLQEGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:06:08 -0500
Received: from kroah.org ([198.145.64.141]:52326 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936239AbZLQEGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:06:01 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:57:02 2009
Message-Id: <20091217035702.439056851@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:57:27 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: [150/151] perf_event: Fix incorrect range check on cpu number
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Paul Mackerras <paulus@samba.org>

commit 0f624e7e5625f4c30c836b7a5decfe2553582391 upstream.

It is quite legitimate for CPUs to be numbered sparsely, meaning
that it possible for an online CPU to have a number which is
greater than the total count of possible CPUs.

Currently find_get_context() has a sanity check on the cpu
number where it checks it against num_possible_cpus().  This
test can fail for a legitimate cpu number if the
cpu_possible_mask is sparsely populated.

This fixes the problem by checking the CPU number against
nr_cpumask_bits instead, since that is the appropriate check to
ensure that the cpu number is same to pass to cpu_isset()
subsequently.

Reported-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Paul Mackerras <paulus@samba.org>
Tested-by: Michael Neuling <mikey@neuling.org>
Acked-by: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20091215084032.GA18661@brick.ozlabs.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/perf_event.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1583,7 +1583,7 @@ static struct perf_event_context *find_g
 		if (perf_paranoid_cpu() && !capable(CAP_SYS_ADMIN))
 			return ERR_PTR(-EACCES);
 
-		if (cpu < 0 || cpu > num_possible_cpus())
+		if (cpu < 0 || cpu >= nr_cpumask_bits)
 			return ERR_PTR(-EINVAL);
 
 		/*


