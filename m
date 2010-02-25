Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759066Ab0BYKYZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 05:24:25 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:45996 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759010Ab0BYKYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 05:24:23 -0500
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: containers@lists.linux-foundation.org, Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>, Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org,
       "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [PATCH] cgroup: do not use dprintf in cgroup_event_listener
Date: Thu, 25 Feb 2010 12:24:07 +0200
Message-Id: <1267093447-2607-1-git-send-email-kirill@shutemov.name>
X-Mailer: git-send-email 1.6.6.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

glibc's dprintf(3) is buggy:
http://sourceware.org/bugzilla/show_bug.cgi?id=11319

Let's not to use it in the example.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
---
 Documentation/cgroups/cgroup_event_listener.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/Documentation/cgroups/cgroup_event_listener.c b/Documentation/cgroups/cgroup_event_listener.c
index 8c2d7aa..8c2bfc4 100644
--- a/Documentation/cgroups/cgroup_event_listener.c
+++ b/Documentation/cgroups/cgroup_event_listener.c
@@ -23,6 +23,7 @@ int main(int argc, char **argv)
 	int cfd = -1;
 	int event_control = -1;
 	char event_control_path[PATH_MAX];
+	char line[LINE_MAX];
 	int ret;
 
 	if (argc != 3) {
@@ -39,7 +40,7 @@ int main(int argc, char **argv)
 
 	ret = snprintf(event_control_path, PATH_MAX, "%s/cgroup.event_control",
 			dirname(argv[1]));
-	if (ret > PATH_MAX) {
+	if (ret >= PATH_MAX) {
 		fputs("Path to cgroup.event_control is too long\n", stderr);
 		goto out;
 	}
@@ -57,7 +58,13 @@ int main(int argc, char **argv)
 		goto out;
 	}
 
-	ret = dprintf(event_control, "%d %d %s", efd, cfd, argv[2]);
+	ret = snprintf(line, LINE_MAX, "%d %d %s", efd, cfd, argv[2]);
+	if (ret >= LINE_MAX) {
+		fputs("Arguments string is too long\n", stderr);
+		goto out;
+	}
+
+	ret = write(event_control, line, strlen(line) + 1);
 	if (ret == -1) {
 		perror("Cannot write to cgroup.event_control");
 		goto out;
-- 
1.6.6.2

