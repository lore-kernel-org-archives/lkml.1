Return-Path: <linux-kernel-owner+w=401wt.eu-S1752716AbZIXNjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716AbZIXNjg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 09:39:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbZIXNjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 09:39:35 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:39082 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728AbZIXNjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 09:39:33 -0400
Message-ID: <4ABB767D.6080004@gmail.com>
Date: Thu, 24 Sep 2009 15:39:09 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric_?= =?ISO-8859-1?Q?Weisbecker?= 
	<fweisbec@gmail.com>,
       Ulrich Drepper <drepper@redhat.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       linux-perf-users@vger.kernel.org
Subject: [PATCH] perf tools: Dont use openat()
References: <4ABB6EB7.7000002@gmail.com> <20090924131250.GA15132@elte.hu>
In-Reply-To: <20090924131250.GA15132@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 24 Sep 2009 15:39:10 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar a écrit :
> * Eric Dumazet <eric.dumazet@gmail.com> wrote:
> 
>> Hi Ingo
>>
>> Here is a patch for perf.
> 
> Applied, thanks Eric!
> 
>> BTW, use of openat() is a nuisance, since many machines have old glibc
>> (RHEL 4 Update 5 -> glibc-2.3.4-2.36 on my dev machine for example)
> 
> We can certainly remove that reliance - wanna send a patch for it?

Here it is

Thanks

[PATCH] perf tools: Dont use openat()

openat() is still a young glibc facility, better to not use it
in a non performance critical program (perf list)

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 tools/perf/util/parse-events.c |   49 ++++++++++++-------------------
 1 files changed, 20 insertions(+), 29 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 13ab4b8..865208d 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -165,33 +165,31 @@ struct tracepoint_path *tracepoint_id_to_path(u64 config)
 	DIR *sys_dir, *evt_dir;
 	struct dirent *sys_next, *evt_next, sys_dirent, evt_dirent;
 	char id_buf[4];
-	int sys_dir_fd, fd;
+	int fd;
 	u64 id;
 	char evt_path[MAXPATHLEN];
+	char dir_path[MAXPATHLEN];
 
 	if (valid_debugfs_mount(debugfs_path))
 		return NULL;
 
 	sys_dir = opendir(debugfs_path);
 	if (!sys_dir)
-		goto cleanup;
-	sys_dir_fd = dirfd(sys_dir);
+		return NULL;
 
 	for_each_subsystem(sys_dir, sys_dirent, sys_next) {
-		int dfd = openat(sys_dir_fd, sys_dirent.d_name,
-				 O_RDONLY|O_DIRECTORY), evt_dir_fd;
-		if (dfd == -1)
-			continue;
-		evt_dir = fdopendir(dfd);
-		if (!evt_dir) {
-			close(dfd);
+
+		snprintf(dir_path, MAXPATHLEN, "%s/%s", debugfs_path,
+			 sys_dirent.d_name);
+		evt_dir = opendir(dir_path);
+		if (!evt_dir)
 			continue;
-		}
-		evt_dir_fd = dirfd(evt_dir);
+
 		for_each_event(sys_dirent, evt_dir, evt_dirent, evt_next) {
-			snprintf(evt_path, MAXPATHLEN, "%s/id",
+			
+			snprintf(evt_path, MAXPATHLEN, "%s/%s/id", dir_path,
 				 evt_dirent.d_name);
-			fd = openat(evt_dir_fd, evt_path, O_RDONLY);
+			fd = open(evt_path, O_RDONLY);
 			if (fd < 0)
 				continue;
 			if (read(fd, id_buf, sizeof(id_buf)) < 0) {
@@ -225,7 +223,6 @@ struct tracepoint_path *tracepoint_id_to_path(u64 config)
 		closedir(evt_dir);
 	}
 
-cleanup:
 	closedir(sys_dir);
 	return NULL;
 }
@@ -761,28 +758,24 @@ static void print_tracepoint_events(void)
 {
 	DIR *sys_dir, *evt_dir;
 	struct dirent *sys_next, *evt_next, sys_dirent, evt_dirent;
-	int sys_dir_fd;
 	char evt_path[MAXPATHLEN];
+	char dir_path[MAXPATHLEN];
 
 	if (valid_debugfs_mount(debugfs_path))
 		return;
 
 	sys_dir = opendir(debugfs_path);
 	if (!sys_dir)
-		goto cleanup;
-	sys_dir_fd = dirfd(sys_dir);
+		return;
 
 	for_each_subsystem(sys_dir, sys_dirent, sys_next) {
-		int dfd = openat(sys_dir_fd, sys_dirent.d_name,
-				 O_RDONLY|O_DIRECTORY), evt_dir_fd;
-		if (dfd == -1)
-			continue;
-		evt_dir = fdopendir(dfd);
-		if (!evt_dir) {
-			close(dfd);
+
+		snprintf(dir_path, MAXPATHLEN, "%s/%s", debugfs_path,
+			 sys_dirent.d_name);
+		evt_dir = opendir(dir_path);
+		if (!evt_dir)
 			continue;
-		}
-		evt_dir_fd = dirfd(evt_dir);
+
 		for_each_event(sys_dirent, evt_dir, evt_dirent, evt_next) {
 			snprintf(evt_path, MAXPATHLEN, "%s:%s",
 				 sys_dirent.d_name, evt_dirent.d_name);
@@ -791,8 +784,6 @@ static void print_tracepoint_events(void)
 		}
 		closedir(evt_dir);
 	}
-
-cleanup:
 	closedir(sys_dir);
 }
 
