Return-Path: <linux-kernel-owner+w=401wt.eu-S965823AbYD1WcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965823AbYD1WcH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 18:32:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934334AbYD1Wbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 18:31:55 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:60134 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933993AbYD1Wbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 18:31:55 -0400
Date: Mon, 28 Apr 2008 17:31:50 -0500
From: Paul Jackson <pj@sgi.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: torvalds@linux-foundation.org, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/4] kernel: fix integer as NULL pointer warnings
Message-Id: <20080428173150.640e39f8.pj@sgi.com>
In-Reply-To: <1209417199.14173.101.camel@brick>
References: <1209417199.14173.101.camel@brick>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey wrote:
=============

kernel/cpuset.c:1268:52: warning: Using plain integer as NULL pointer
kernel/pid_namespace.c:95:24: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 kernel/cpuset.c        |    3 ++-
 kernel/pid_namespace.c |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 024888b..48a976c 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1265,7 +1265,8 @@ static ssize_t cpuset_common_file_write(struct cgroup *cont,
 		return -E2BIG;
 
 	/* +1 for nul-terminator */
-	if ((buffer = kmalloc(nbytes + 1, GFP_KERNEL)) == 0)
+	buffer = kmalloc(nbytes + 1, GFP_KERNEL);
+	if (!buffer)
 		return -ENOMEM;
 
 	if (copy_from_user(buffer, userbuf, nbytes)) {
diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index 6d792b6..5ca37fa 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -92,7 +92,7 @@ static struct pid_namespace *create_pid_namespace(int level)
 	atomic_set(&ns->pidmap[0].nr_free, BITS_PER_PAGE - 1);
 
 	for (i = 1; i < PIDMAP_ENTRIES; i++) {
-		ns->pidmap[i].page = 0;
+		ns->pidmap[i].page = NULL;
 		atomic_set(&ns->pidmap[i].nr_free, BITS_PER_PAGE);
 	}
 

=========
Looks ok.

kernel/cpuset.c changes usually go through Andrew Morton's *-mm tree,
where they can be sequenced and (the frequent ;) collisions resolved.
So I added him to the CC list.

Reviewed-by: Paul Jackson <pj@sgi.com>

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
