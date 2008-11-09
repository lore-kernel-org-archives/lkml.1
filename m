Return-Path: <linux-kernel-owner+w=401wt.eu-S1756758AbYKIWcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758AbYKIWcb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 17:32:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755875AbYKIWcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 17:32:22 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:61631 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755760AbYKIWcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 17:32:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=ba98+vCBJ/Vxo+N5npmWPJPJvQKYp317T32IUEOX6GaYaK3FtwxhkaqVgXldiyKA1N
         G78jwyN2IMqE8WY/XBU1hjWvAjSvLEPvIrOSu4Vx3sQvdcaZbgTX0ZSRYSdjdT50Ptrp
         aAiN08xPN3k5DZct9QzxCjdsLGaDe7Li+TU5Y=
Date: Mon, 10 Nov 2008 01:35:42 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] proc: remove '##' usage
Message-ID: <20081109223542.GA16813@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[added to proc.git]

commit 5d8880e3e0fb96459c652ac5e1504b90c949b3b9
Author: Alexey Dobriyan <adobriyan@gmail.com>
Date:   Mon Nov 10 01:32:52 2008 +0300

    proc: remove '##' usage
    
    Inability to jump to /proc/*/foo handlers with ctags is annoying.
    
    Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 4a1c578..6e850e9 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -109,25 +109,22 @@ struct pid_entry {
 	.op   = OP,					\
 }
 
-#define DIR(NAME, MODE, OTYPE)							\
-	NOD(NAME, (S_IFDIR|(MODE)),						\
-		&proc_##OTYPE##_inode_operations, &proc_##OTYPE##_operations,	\
-		{} )
-#define LNK(NAME, OTYPE)					\
+#define DIR(NAME, MODE, iops, fops)	\
+	NOD(NAME, (S_IFDIR|(MODE)), &iops, &fops, {} )
+#define LNK(NAME, get_link)					\
 	NOD(NAME, (S_IFLNK|S_IRWXUGO),				\
 		&proc_pid_link_inode_operations, NULL,		\
-		{ .proc_get_link = &proc_##OTYPE##_link } )
-#define REG(NAME, MODE, OTYPE)				\
-	NOD(NAME, (S_IFREG|(MODE)), NULL,		\
-		&proc_##OTYPE##_operations, {})
-#define INF(NAME, MODE, OTYPE)				\
+		{ .proc_get_link = get_link } )
+#define REG(NAME, MODE, fops)				\
+	NOD(NAME, (S_IFREG|(MODE)), NULL, &fops, {})
+#define INF(NAME, MODE, read)				\
 	NOD(NAME, (S_IFREG|(MODE)), 			\
 		NULL, &proc_info_file_operations,	\
-		{ .proc_read = &proc_##OTYPE } )
-#define ONE(NAME, MODE, OTYPE)				\
+		{ .proc_read = read } )
+#define ONE(NAME, MODE, show)				\
 	NOD(NAME, (S_IFREG|(MODE)), 			\
 		NULL, &proc_single_file_operations,	\
-		{ .proc_show = &proc_##OTYPE } )
+		{ .proc_show = show } )
 
 /*
  * Count the number of hardlinks for the pid_entry table, excluding the .
@@ -2118,12 +2115,12 @@ static const struct file_operations proc_pid_attr_operations = {
 };
 
 static const struct pid_entry attr_dir_stuff[] = {
-	REG("current",    S_IRUGO|S_IWUGO, pid_attr),
-	REG("prev",       S_IRUGO,	   pid_attr),
-	REG("exec",       S_IRUGO|S_IWUGO, pid_attr),
-	REG("fscreate",   S_IRUGO|S_IWUGO, pid_attr),
-	REG("keycreate",  S_IRUGO|S_IWUGO, pid_attr),
-	REG("sockcreate", S_IRUGO|S_IWUGO, pid_attr),
+	REG("current",    S_IRUGO|S_IWUGO, proc_pid_attr_operations),
+	REG("prev",       S_IRUGO,	   proc_pid_attr_operations),
+	REG("exec",       S_IRUGO|S_IWUGO, proc_pid_attr_operations),
+	REG("fscreate",   S_IRUGO|S_IWUGO, proc_pid_attr_operations),
+	REG("keycreate",  S_IRUGO|S_IWUGO, proc_pid_attr_operations),
+	REG("sockcreate", S_IRUGO|S_IWUGO, proc_pid_attr_operations),
 };
 
 static int proc_attr_dir_readdir(struct file * filp,
@@ -2445,74 +2442,74 @@ static const struct file_operations proc_task_operations;
 static const struct inode_operations proc_task_inode_operations;
 
 static const struct pid_entry tgid_base_stuff[] = {
-	DIR("task",       S_IRUGO|S_IXUGO, task),
-	DIR("fd",         S_IRUSR|S_IXUSR, fd),
-	DIR("fdinfo",     S_IRUSR|S_IXUSR, fdinfo),
+	DIR("task",       S_IRUGO|S_IXUGO, proc_task_inode_operations, proc_task_operations),
+	DIR("fd",         S_IRUSR|S_IXUSR, proc_fd_inode_operations, proc_fd_operations),
+	DIR("fdinfo",     S_IRUSR|S_IXUSR, proc_fdinfo_inode_operations, proc_fdinfo_operations),
 #ifdef CONFIG_NET
-	DIR("net",        S_IRUGO|S_IXUGO, net),
+	DIR("net",        S_IRUGO|S_IXUGO, proc_net_inode_operations, proc_net_operations),
 #endif
-	REG("environ",    S_IRUSR, environ),
-	INF("auxv",       S_IRUSR, pid_auxv),
-	ONE("status",     S_IRUGO, pid_status),
-	ONE("personality", S_IRUSR, pid_personality),
-	INF("limits",	  S_IRUSR, pid_limits),
+	REG("environ",    S_IRUSR, proc_environ_operations),
+	INF("auxv",       S_IRUSR, proc_pid_auxv),
+	ONE("status",     S_IRUGO, proc_pid_status),
+	ONE("personality", S_IRUSR, proc_pid_personality),
+	INF("limits",	  S_IRUSR, proc_pid_limits),
 #ifdef CONFIG_SCHED_DEBUG
-	REG("sched",      S_IRUGO|S_IWUSR, pid_sched),
+	REG("sched",      S_IRUGO|S_IWUSR, proc_pid_sched_operations),
 #endif
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
-	INF("syscall",    S_IRUSR, pid_syscall),
+	INF("syscall",    S_IRUSR, proc_pid_syscall),
 #endif
-	INF("cmdline",    S_IRUGO, pid_cmdline),
-	ONE("stat",       S_IRUGO, tgid_stat),
-	ONE("statm",      S_IRUGO, pid_statm),
-	REG("maps",       S_IRUGO, maps),
+	INF("cmdline",    S_IRUGO, proc_pid_cmdline),
+	ONE("stat",       S_IRUGO, proc_tgid_stat),
+	ONE("statm",      S_IRUGO, proc_pid_statm),
+	REG("maps",       S_IRUGO, proc_maps_operations),
 #ifdef CONFIG_NUMA
-	REG("numa_maps",  S_IRUGO, numa_maps),
+	REG("numa_maps",  S_IRUGO, proc_numa_maps_operations),
 #endif
-	REG("mem",        S_IRUSR|S_IWUSR, mem),
-	LNK("cwd",        cwd),
-	LNK("root",       root),
-	LNK("exe",        exe),
-	REG("mounts",     S_IRUGO, mounts),
-	REG("mountinfo",  S_IRUGO, mountinfo),
-	REG("mountstats", S_IRUSR, mountstats),
+	REG("mem",        S_IRUSR|S_IWUSR, proc_mem_operations),
+	LNK("cwd",        proc_cwd_link),
+	LNK("root",       proc_root_link),
+	LNK("exe",        proc_exe_link),
+	REG("mounts",     S_IRUGO, proc_mounts_operations),
+	REG("mountinfo",  S_IRUGO, proc_mountinfo_operations),
+	REG("mountstats", S_IRUSR, proc_mountstats_operations),
 #ifdef CONFIG_PROC_PAGE_MONITOR
-	REG("clear_refs", S_IWUSR, clear_refs),
-	REG("smaps",      S_IRUGO, smaps),
-	REG("pagemap",    S_IRUSR, pagemap),
+	REG("clear_refs", S_IWUSR, proc_clear_refs_operations),
+	REG("smaps",      S_IRUGO, proc_smaps_operations),
+	REG("pagemap",    S_IRUSR, proc_pagemap_operations),
 #endif
 #ifdef CONFIG_SECURITY
-	DIR("attr",       S_IRUGO|S_IXUGO, attr_dir),
+	DIR("attr",       S_IRUGO|S_IXUGO, proc_attr_dir_inode_operations, proc_attr_dir_operations),
 #endif
 #ifdef CONFIG_KALLSYMS
-	INF("wchan",      S_IRUGO, pid_wchan),
+	INF("wchan",      S_IRUGO, proc_pid_wchan),
 #endif
 #ifdef CONFIG_SCHEDSTATS
-	INF("schedstat",  S_IRUGO, pid_schedstat),
+	INF("schedstat",  S_IRUGO, proc_pid_schedstat),
 #endif
 #ifdef CONFIG_LATENCYTOP
-	REG("latency",  S_IRUGO, lstats),
+	REG("latency",  S_IRUGO, proc_lstats_operations),
 #endif
 #ifdef CONFIG_PROC_PID_CPUSET
-	REG("cpuset",     S_IRUGO, cpuset),
+	REG("cpuset",     S_IRUGO, proc_cpuset_operations),
 #endif
 #ifdef CONFIG_CGROUPS
-	REG("cgroup",  S_IRUGO, cgroup),
+	REG("cgroup",  S_IRUGO, proc_cgroup_operations),
 #endif
-	INF("oom_score",  S_IRUGO, oom_score),
-	REG("oom_adj",    S_IRUGO|S_IWUSR, oom_adjust),
+	INF("oom_score",  S_IRUGO, proc_oom_score),
+	REG("oom_adj",    S_IRUGO|S_IWUSR, proc_oom_adjust_operations),
 #ifdef CONFIG_AUDITSYSCALL
-	REG("loginuid",   S_IWUSR|S_IRUGO, loginuid),
-	REG("sessionid",  S_IRUGO, sessionid),
+	REG("loginuid",   S_IWUSR|S_IRUGO, proc_loginuid_operations),
+	REG("sessionid",  S_IRUGO, proc_sessionid_operations),
 #endif
 #ifdef CONFIG_FAULT_INJECTION
-	REG("make-it-fail", S_IRUGO|S_IWUSR, fault_inject),
+	REG("make-it-fail", S_IRUGO|S_IWUSR, proc_fault_inject_operations),
 #endif
 #if defined(USE_ELF_CORE_DUMP) && defined(CONFIG_ELF_CORE)
-	REG("coredump_filter", S_IRUGO|S_IWUSR, coredump_filter),
+	REG("coredump_filter", S_IRUGO|S_IWUSR, proc_coredump_filter_operations),
 #endif
 #ifdef CONFIG_TASK_IO_ACCOUNTING
-	INF("io",	S_IRUGO, tgid_io_accounting),
+	INF("io",	S_IRUGO, proc_tgid_io_accounting),
 #endif
 };
 
@@ -2785,66 +2782,66 @@ out_no_task:
  * Tasks
  */
 static const struct pid_entry tid_base_stuff[] = {
-	DIR("fd",        S_IRUSR|S_IXUSR, fd),
-	DIR("fdinfo",    S_IRUSR|S_IXUSR, fdinfo),
-	REG("environ",   S_IRUSR, environ),
-	INF("auxv",      S_IRUSR, pid_auxv),
-	ONE("status",    S_IRUGO, pid_status),
-	ONE("personality", S_IRUSR, pid_personality),
-	INF("limits",	 S_IRUSR, pid_limits),
+	DIR("fd",        S_IRUSR|S_IXUSR, proc_fd_inode_operations, proc_fd_operations),
+	DIR("fdinfo",    S_IRUSR|S_IXUSR, proc_fdinfo_inode_operations, proc_fd_operations),
+	REG("environ",   S_IRUSR, proc_environ_operations),
+	INF("auxv",      S_IRUSR, proc_pid_auxv),
+	ONE("status",    S_IRUGO, proc_pid_status),
+	ONE("personality", S_IRUSR, proc_pid_personality),
+	INF("limits",	 S_IRUSR, proc_pid_limits),
 #ifdef CONFIG_SCHED_DEBUG
-	REG("sched",     S_IRUGO|S_IWUSR, pid_sched),
+	REG("sched",     S_IRUGO|S_IWUSR, proc_pid_sched_operations),
 #endif
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
-	INF("syscall",   S_IRUSR, pid_syscall),
+	INF("syscall",   S_IRUSR, proc_pid_syscall),
 #endif
-	INF("cmdline",   S_IRUGO, pid_cmdline),
-	ONE("stat",      S_IRUGO, tid_stat),
-	ONE("statm",     S_IRUGO, pid_statm),
-	REG("maps",      S_IRUGO, maps),
+	INF("cmdline",   S_IRUGO, proc_pid_cmdline),
+	ONE("stat",      S_IRUGO, proc_tid_stat),
+	ONE("statm",     S_IRUGO, proc_pid_statm),
+	REG("maps",      S_IRUGO, proc_maps_operations),
 #ifdef CONFIG_NUMA
-	REG("numa_maps", S_IRUGO, numa_maps),
+	REG("numa_maps", S_IRUGO, proc_numa_maps_operations),
 #endif
-	REG("mem",       S_IRUSR|S_IWUSR, mem),
-	LNK("cwd",       cwd),
-	LNK("root",      root),
-	LNK("exe",       exe),
-	REG("mounts",    S_IRUGO, mounts),
-	REG("mountinfo",  S_IRUGO, mountinfo),
+	REG("mem",       S_IRUSR|S_IWUSR, proc_mem_operations),
+	LNK("cwd",       proc_cwd_link),
+	LNK("root",      proc_root_link),
+	LNK("exe",       proc_exe_link),
+	REG("mounts",    S_IRUGO, proc_mounts_operations),
+	REG("mountinfo",  S_IRUGO, proc_mountinfo_operations),
 #ifdef CONFIG_PROC_PAGE_MONITOR
-	REG("clear_refs", S_IWUSR, clear_refs),
-	REG("smaps",     S_IRUGO, smaps),
-	REG("pagemap",    S_IRUSR, pagemap),
+	REG("clear_refs", S_IWUSR, proc_clear_refs_operations),
+	REG("smaps",     S_IRUGO, proc_smaps_operations),
+	REG("pagemap",    S_IRUSR, proc_pagemap_operations),
 #endif
 #ifdef CONFIG_SECURITY
-	DIR("attr",      S_IRUGO|S_IXUGO, attr_dir),
+	DIR("attr",      S_IRUGO|S_IXUGO, proc_attr_dir_inode_operations, proc_attr_dir_operations),
 #endif
 #ifdef CONFIG_KALLSYMS
-	INF("wchan",     S_IRUGO, pid_wchan),
+	INF("wchan",     S_IRUGO, proc_pid_wchan),
 #endif
 #ifdef CONFIG_SCHEDSTATS
-	INF("schedstat", S_IRUGO, pid_schedstat),
+	INF("schedstat", S_IRUGO, proc_pid_schedstat),
 #endif
 #ifdef CONFIG_LATENCYTOP
-	REG("latency",  S_IRUGO, lstats),
+	REG("latency",  S_IRUGO, proc_lstats_operations),
 #endif
 #ifdef CONFIG_PROC_PID_CPUSET
-	REG("cpuset",    S_IRUGO, cpuset),
+	REG("cpuset",    S_IRUGO, proc_cpuset_operations),
 #endif
 #ifdef CONFIG_CGROUPS
-	REG("cgroup",  S_IRUGO, cgroup),
+	REG("cgroup",  S_IRUGO, proc_cgroup_operations),
 #endif
-	INF("oom_score", S_IRUGO, oom_score),
-	REG("oom_adj",   S_IRUGO|S_IWUSR, oom_adjust),
+	INF("oom_score", S_IRUGO, proc_oom_score),
+	REG("oom_adj",   S_IRUGO|S_IWUSR, proc_oom_adjust_operations),
 #ifdef CONFIG_AUDITSYSCALL
-	REG("loginuid",  S_IWUSR|S_IRUGO, loginuid),
-	REG("sessionid",  S_IRUSR, sessionid),
+	REG("loginuid",  S_IWUSR|S_IRUGO, proc_loginuid_operations),
+	REG("sessionid",  S_IRUSR, proc_sessionid_operations),
 #endif
 #ifdef CONFIG_FAULT_INJECTION
-	REG("make-it-fail", S_IRUGO|S_IWUSR, fault_inject),
+	REG("make-it-fail", S_IRUGO|S_IWUSR, proc_fault_inject_operations),
 #endif
 #ifdef CONFIG_TASK_IO_ACCOUNTING
-	INF("io",	S_IRUGO, tid_io_accounting),
+	INF("io",	S_IRUGO, proc_tid_io_accounting),
 #endif
 };
 
