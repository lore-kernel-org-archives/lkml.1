Return-Path: <linux-kernel-owner+w=401wt.eu-S1754807AbYJVRPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807AbYJVRPW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 13:15:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752490AbYJVRPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 13:15:01 -0400
Received: from gv-out-0910.google.com ([216.239.58.184]:20378 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757192AbYJVRPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:15:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=CRJWFVQO1xpW1MLgMdVpAoze/roTL2pUEnFLCcEddrMRQUKpP72AWQFZaFv1Pu5Jki
         L1UEqgZm/KgLKfAKJ4tI8xKZWPYACtXT7yfi5lnO/VO1nh5vhGBeNC21pCJ8y7JmxyV9
         FDrA6A4lYIJnxGF64P+yFOab+3mbQtLmZyGTE=
Message-ID: <48FF5F8F.6070202@gmail.com>
Date: Wed, 22 Oct 2008 19:14:55 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH][RESEND] tracepoint: Check if the probe has been registered
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we try to remove a probe that has not been already registered,
the tracepoint_entry_remove_probe() function will dereference a NULL
pointer.
Check the probe before removing it to avoid crashes.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Acked-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/tracepoint.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index f2b7c28..af8c856 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -131,6 +131,9 @@ tracepoint_entry_remove_probe(struct tracepoint_entry *entry, void *probe)
 
 	old = entry->funcs;
 
+	if (!old)
+		return NULL;
+
 	debug_print_probes(entry);
 	/* (N -> M), (N > 1, M >= 0) probes */
 	for (nr_probes = 0; old[nr_probes]; nr_probes++) {
@@ -388,6 +391,11 @@ int tracepoint_probe_unregister(const char *name, void *probe)
 	if (entry->rcu_pending)
 		rcu_barrier_sched();
 	old = tracepoint_entry_remove_probe(entry, probe);
+	if (!old) {
+		printk(KERN_WARNING "Warning: Trying to unregister a probe"
+				    "that doesn't exist\n");
+		goto end;
+	}
 	mutex_unlock(&tracepoints_mutex);
 	tracepoint_update_probes();		/* may update entry */
 	mutex_lock(&tracepoints_mutex);

