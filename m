Return-Path: <linux-kernel-owner+w=401wt.eu-S1757345AbZJBIlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345AbZJBIlP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 04:41:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757284AbZJBIlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 04:41:13 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41482 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756484AbZJBIlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 04:41:10 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] cgroup: fix strstrip() abuse
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>
In-Reply-To: <20091002173635.5F6C.A69D9226@jp.fujitsu.com>
References: <20091002173635.5F6C.A69D9226@jp.fujitsu.com>
Message-Id: <20091002173955.5F72.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri,  2 Oct 2009 17:41:08 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cgroup_write_X64() and cgroup_write_string() ignore the return
value of strstrip().
it makes small inconsistent behavior.

example: 
=========================
 # cd /mnt/cgroup/hoge
 # cat memory.swappiness
 60
 # echo "59 " > memory.swappiness
 # cat memory.swappiness
 59
 # echo " 58" > memory.swappiness
 bash: echo: write error: Invalid argument


This patch fixes it.

Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 kernel/cgroup.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

Index: b/kernel/cgroup.c
===================================================================
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1710,14 +1710,13 @@ static ssize_t cgroup_write_X64(struct c
 		return -EFAULT;
 
 	buffer[nbytes] = 0;     /* nul-terminate */
-	strstrip(buffer);
 	if (cft->write_u64) {
-		u64 val = simple_strtoull(buffer, &end, 0);
+		u64 val = simple_strtoull(strstrip(buffer), &end, 0);
 		if (*end)
 			return -EINVAL;
 		retval = cft->write_u64(cgrp, cft, val);
 	} else {
-		s64 val = simple_strtoll(buffer, &end, 0);
+		s64 val = simple_strtoll(strstrip(buffer), &end, 0);
 		if (*end)
 			return -EINVAL;
 		retval = cft->write_s64(cgrp, cft, val);
@@ -1753,8 +1752,7 @@ static ssize_t cgroup_write_string(struc
 	}
 
 	buffer[nbytes] = 0;     /* nul-terminate */
-	strstrip(buffer);
-	retval = cft->write_string(cgrp, cft, buffer);
+	retval = cft->write_string(cgrp, cft, strstrip(buffer));
 	if (!retval)
 		retval = nbytes;
 out:


