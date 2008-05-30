Return-Path: <linux-kernel-owner+w=401wt.eu-S1753220AbYE3MWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220AbYE3MWT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 08:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751475AbYE3MWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 08:22:12 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:40855 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbYE3MWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 08:22:11 -0400
Date: Fri, 30 May 2008 05:22:06 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, maneesh@linux.vnet.ibm.com,
       jkennisto@us.ibm.com
Subject: Question about smp_read_barrier_depends() in kernel/marker.c
Message-ID: <20080530122206.GA23396@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Mathieu,

I am a bit confused by the smp_read_barrier_depends() in kernel/markers.c.
My (probably naive) view is that they need to move as shown in the patch
below.  Help?

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 marker.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -urpNa -X dontdiff linux-2.6.26-rc4/kernel/marker.c linux-2.6.26-rc4-marker-srbd/kernel/marker.c
--- linux-2.6.26-rc4/kernel/marker.c	2008-05-30 04:39:01.000000000 -0700
+++ linux-2.6.26-rc4-marker-srbd/kernel/marker.c	2008-05-30 05:05:55.000000000 -0700
@@ -133,8 +133,8 @@ void marker_probe_cb(const struct marker
 		 * data. Same as rcu_dereference, but we need a full smp_rmb()
 		 * in the fast path, so put the explicit barrier here.
 		 */
-		smp_read_barrier_depends();
 		multi = mdata->multi;
+		smp_read_barrier_depends();
 		for (i = 0; multi[i].func; i++) {
 			va_start(args, fmt);
 			multi[i].func(multi[i].probe_private, call_private, fmt,
@@ -183,8 +183,8 @@ void marker_probe_cb_noarg(const struct 
 		 * data. Same as rcu_dereference, but we need a full smp_rmb()
 		 * in the fast path, so put the explicit barrier here.
 		 */
-		smp_read_barrier_depends();
 		multi = mdata->multi;
+		smp_read_barrier_depends();
 		for (i = 0; multi[i].func; i++)
 			multi[i].func(multi[i].probe_private, call_private, fmt,
 				&args);
@@ -271,6 +271,7 @@ marker_entry_add_probe(struct marker_ent
 	new[nr_probes].func = probe;
 	new[nr_probes].probe_private = probe_private;
 	entry->refcount = nr_probes + 1;
+	smp_wmb(); /* Ensure struct is initialized before publication. *
 	entry->multi = new;
 	entry->ptype = 1;
 	debug_print_probes(entry);
