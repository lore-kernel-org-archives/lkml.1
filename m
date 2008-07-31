Return-Path: <linux-kernel-owner+w=401wt.eu-S1757431AbYGaPqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431AbYGaPqe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 11:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752769AbYGaPqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 11:46:14 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:64573 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884AbYGaPqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 11:46:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=mZCGojuQc0tEaam2dPrdM9hBuc+SSIW0AXEMQsEef+j0FcLJ7qodyqqOfPfk5PowWD
         Fx0+mYcl8fXlVckC4gek+RoUA7IUdRCDEvSs2H5HEtTJJcxgiH5C6SkCWqkZTOZFijb3
         tLIqYze8LDw62cacOdMk7SJazb/p+bcXz1Lpk=
Message-ID: <b9df5fa10807310846g27913d82icf2a82e77992ba9f@mail.gmail.com>
Date: Thu, 31 Jul 2008 21:46:11 +0600
From: "Rakib Mullick" <rakib.mullick@gmail.com>
To: pj@sgi.com, menage@google.com
Subject: [PATCH] Removes extra checking in kernel/cpuset.c
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello guys, this patch removes an extra checking over 'cs' in
functions 'guarantee_online_cpus' and 'guarantee_online_mems'.

Thanks.

Signed-off-by: Md.Rakib H. Mullick (rakib.mullick@gmail.com)

--- kernel/cpuset.c.orig	2008-07-31 17:03:34.000000000 +0600
+++ kernel/cpuset.c	2008-07-31 21:33:34.000000000 +0600
@@ -282,10 +282,11 @@ static struct file_system_type cpuset_fs

 static void guarantee_online_cpus(const struct cpuset *cs, cpumask_t *pmask)
 {
-	while (cs && !cpus_intersects(cs->cpus_allowed, cpu_online_map))
-		cs = cs->parent;
-	if (cs)
+	if (cs) {
+		while (!cpus_intersects(cs->cpus_allowed, cpu_online_map))
+			cs = cs->parent;
 		cpus_and(*pmask, cs->cpus_allowed, cpu_online_map);
+	}
 	else
 		*pmask = cpu_online_map;
 	BUG_ON(!cpus_intersects(*pmask, cpu_online_map));
@@ -306,12 +307,13 @@ static void guarantee_online_cpus(const

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
+	}
 	else
 		*pmask = node_states[N_HIGH_MEMORY];
 	BUG_ON(!nodes_intersects(*pmask, node_states[N_HIGH_MEMORY]));
