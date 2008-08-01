Return-Path: <linux-kernel-owner+w=401wt.eu-S1757755AbYHADVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755AbYHADVj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 23:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753513AbYHADVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 23:21:31 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:53546 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbYHADVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 23:21:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=lZovjS+dhsLJHkJI1ZmH4vB2KaHenEsP5cJuOotf9d3OtA7ScjcVq3MiMHBO/nn1hS
         +zf5XZ1mmLa867DRVhIQPsgTJ0hB0bJLfA/Nu4LWkdObRKVXYb4J2wSluNHe7t7kWXHG
         YVvjjRm33qi3KX7YMUwRx69B8NXksMilxNUS4=
Message-ID: <b9df5fa10807312021p54400700ub679efb389839416@mail.gmail.com>
Date: Fri, 1 Aug 2008 09:21:28 +0600
From: "Rakib Mullick" <rakib.mullick@gmail.com>
To: pj@sgi.com, menage@google.com
Subject: [RESEND][PATCH] Removes extra checking in kernel/cpuset.c
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frist, thanks for sending comments about the patch. Now, in this
function what we're trying is to get a value for *pmask . After
setting *pmask value we again call 'cpus_intersects' , then if  'cs'
became NULL then a BUG_ON will be triggered from the last line of the
function. As Paul Jackson mentioned about two nits , so I resend it.
Hopefully my point is clear. If anything else please let me know.

Thanks a lot.

Signed-off-by: Md.Rakib H. Mullick (rakib.mullick@gmail.com)

diff -upr linux-2.6.26-rc9.orig/kernel/cpuset.c linux-2.6.26-rc9/kernel/cpuset.c
--- linux-2.6.26-rc9.orig/kernel/cpuset.c	2008-08-01 08:38:41.000000000 +0600
+++ linux-2.6.26-rc9/kernel/cpuset.c	2008-08-01 08:33:37.000000000 +0600
@@ -282,11 +282,11 @@ static struct file_system_type cpuset_fs

 static void guarantee_online_cpus(const struct cpuset *cs, cpumask_t *pmask)
 {
-	while (cs && !cpus_intersects(cs->cpus_allowed, cpu_online_map))
-		cs = cs->parent;
-	if (cs)
+	if (cs) {
+		while (!cpus_intersects(cs->cpus_allowed, cpu_online_map))
+			cs = cs->parent;
 		cpus_and(*pmask, cs->cpus_allowed, cpu_online_map);
-	else
+	} else
 		*pmask = cpu_online_map;
 	BUG_ON(!cpus_intersects(*pmask, cpu_online_map));
 }
@@ -306,13 +306,13 @@ static void guarantee_online_cpus(const

 static void guarantee_online_mems(const struct cpuset *cs, nodemask_t *pmask)
 {
-	while (cs && !nodes_intersects(cs->mems_allowed,
+	if (cs) {
+		while (!nodes_intersects(cs->mems_allowed,
 					node_states[N_HIGH_MEMORY]))
-		cs = cs->parent;
-	if (cs)
+			cs = cs->parent;
 		nodes_and(*pmask, cs->mems_allowed,
 					node_states[N_HIGH_MEMORY]);
-	else
+	} else
 		*pmask = node_states[N_HIGH_MEMORY];
 	BUG_ON(!nodes_intersects(*pmask, node_states[N_HIGH_MEMORY]));
 }
