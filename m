Return-Path: <linux-kernel-owner+w=401wt.eu-S1758976AbYEMHTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758976AbYEMHTk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 03:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755331AbYEMHTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 03:19:31 -0400
Received: from smtp-out.google.com ([216.239.33.17]:10336 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754114AbYEMHTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 03:19:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:references:user-agent:date:from:to:cc:
	subject:content-disposition;
	b=Yv/tPcu9C6QwBZ9dExT48pR5vGsDhCH7m0BHsTiKVUVmVlRVsH4MSuwnBA1QieBgR
	kLPeJU9dkgq3SG/uvIrvA==
Message-Id: <20080513071522.635138000@menage.corp.google.com>
References: <20080513063707.049448000@menage.corp.google.com>
User-Agent: quilt/0.45-1
Date: Mon, 12 May 2008 23:37:11 -0700
From: menage@google.com
To: pj@sgi.com, xemul@openvz.org, balbir@in.ibm.com, serue@us.ibm.com,
       akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: [RFC/PATCH 4/8]: CGroup Files: Move notify_on_release file to separate write handler
Content-Disposition: inline; filename=cgroup_notify_on_release_file.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the write handler for the cgroups notify_on_release
file into a separate handler. This handler requires no cgroups locking
since it relies on atomic bitops for synchronization.

Signed-off-by: Paul Menage <menage@google.com>

---
 kernel/cgroup.c |   27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

Index: cgroup-2.6.25-mm1/kernel/cgroup.c
===================================================================
--- cgroup-2.6.25-mm1.orig/kernel/cgroup.c
+++ cgroup-2.6.25-mm1/kernel/cgroup.c
@@ -1440,13 +1440,6 @@ static ssize_t cgroup_common_file_write(
 	case FILE_TASKLIST:
 		retval = attach_task_by_pid(cgrp, buffer);
 		break;
-	case FILE_NOTIFY_ON_RELEASE:
-		clear_bit(CGRP_RELEASABLE, &cgrp->flags);
-		if (simple_strtoul(buffer, NULL, 10) != 0)
-			set_bit(CGRP_NOTIFY_ON_RELEASE, &cgrp->flags);
-		else
-			clear_bit(CGRP_NOTIFY_ON_RELEASE, &cgrp->flags);
-		break;
 	default:
 		retval = -EINVAL;
 		goto out2;
@@ -2275,6 +2268,18 @@ static u64 cgroup_read_notify_on_release
 	return notify_on_release(cgrp);
 }
 
+static int cgroup_write_notify_on_release(struct cgroup *cgrp,
+					  struct cftype *cft,
+					  u64 val)
+{
+	clear_bit(CGRP_RELEASABLE, &cgrp->flags);
+	if (val)
+		set_bit(CGRP_NOTIFY_ON_RELEASE, &cgrp->flags);
+	else
+		clear_bit(CGRP_NOTIFY_ON_RELEASE, &cgrp->flags);
+	return 0;
+}
+
 /*
  * for the common functions, 'private' gives the type of file
  */
@@ -2291,7 +2296,7 @@ static struct cftype files[] = {
 	{
 		.name = "notify_on_release",
 		.read_u64 = cgroup_read_notify_on_release,
-		.write = cgroup_common_file_write,
+		.write_u64 = cgroup_write_notify_on_release,
 		.private = FILE_NOTIFY_ON_RELEASE,
 	},
 };

--
