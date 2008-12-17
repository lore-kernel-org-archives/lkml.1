Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752283AbYLQSyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283AbYLQSyQ (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 13:54:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751060AbYLQSx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 13:53:58 -0500
Received: from mx2.redhat.com ([66.187.237.31]:45236 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957AbYLQSx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 13:53:58 -0500
Subject: [PATCH] sys_execve and sys_uselib do not call into fsnotify
From: Eric Paris <eparis@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
        hch@infradead.org
Content-Type: text/plain
Date: Wed, 17 Dec 2008 13:53:20 -0500
Message-Id: <1229540000.3384.40.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sys_execve and sys_uselib do not call into fsnotify so inotify does not get
open events for these types of syscalls.  This patch simply makes the
requisite fsnotify calls.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/exec.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)


diff --git a/fs/exec.c b/fs/exec.c
index ec5df9a..cbd93b5 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -51,6 +51,7 @@
 #include <linux/audit.h>
 #include <linux/tracehook.h>
 #include <linux/kmod.h>
+#include <linux/fsnotify.h>
 
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
@@ -135,6 +136,8 @@ asmlinkage long sys_uselib(const char __user * library)
 	if (IS_ERR(file))
 		goto out;
 
+	fsnotify_open(file->f_path.dentry);
+
 	error = -ENOEXEC;
 	if(file->f_op) {
 		struct linux_binfmt * fmt;
@@ -687,6 +690,8 @@ struct file *open_exec(const char *name)
 	if (IS_ERR(file))
 		return file;
 
+	fsnotify_open(file->f_path.dentry);
+
 	err = deny_write_access(file);
 	if (err) {
 		fput(file);


