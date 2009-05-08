Return-Path: <linux-kernel-owner+w=401wt.eu-S1763934AbZEHSu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763934AbZEHSu2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 14:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755267AbZEHSuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 14:50:16 -0400
Received: from havoc.gtf.org ([69.61.125.42]:58258 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753522AbZEHSuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 14:50:15 -0400
Date: Fri, 8 May 2009 14:50:15 -0400
From: Jeff Garzik <jeff@garzik.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: viro@zeniv.linux.org.uk, mingo@elte.hu,
       Andrew Morton <akpm@linux-foundation.org>, roland@redhat.com
Subject: [RFC PATCH 2/2] kernel/sched.c: VLA in middle of struct
Message-ID: <20090508185015.GA11320@havoc.gtf.org>
References: <20090508184838.GA11157@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090508184838.GA11157@havoc.gtf.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The semantics for variable-length arrays __in the middle of structs__
are quite muddy, and a case in sched.c presents an interesting case,
as the preceding code comment indicates:

	/*
	 * The cpus mask in sched_group and sched_domain hangs off
	 the end.  * FIXME: use cpumask_var_t or dynamic percpu alloc
	 to avoid * wasting space for nr_cpu_ids < CONFIG_NR_CPUS.  */
	struct static_sched_group {
		struct sched_group sg; DECLARE_BITMAP(cpus,
		CONFIG_NR_CPUS);
	};

	struct static_sched_domain {
		struct sched_domain sd; DECLARE_BITMAP(span,
		CONFIG_NR_CPUS);
	};

Both sched_group and sched_domain have the following trailing struct
member:

	unsigned long cpumask[];

So this change is intended largely to spawn a discussion, because
I'm not sure this VLA-in-middle-of-struct behavior is guaranteed to
always behave as expected?

Maybe a C expert can say whether cpumask[0] is better than cpumask[],
or have other comments?

Obviously not to be applied...

NOT-Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
----
 kernel/sched.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 3d6b183..8056d74 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7757,13 +7757,13 @@ int sched_smt_power_savings = 0, sched_mc_power_savings = 0;
  * for nr_cpu_ids < CONFIG_NR_CPUS.
  */
 struct static_sched_group {
-	struct sched_group sg;
 	DECLARE_BITMAP(cpus, CONFIG_NR_CPUS);
+	struct sched_group sg;
 };
 
 struct static_sched_domain {
-	struct sched_domain sd;
 	DECLARE_BITMAP(span, CONFIG_NR_CPUS);
+	struct sched_domain sd;
 };
 
 /*
