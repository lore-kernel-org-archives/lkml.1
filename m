Return-Path: <linux-kernel-owner+w=401wt.eu-S1753959AbZF0EcD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959AbZF0EcD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 00:32:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751427AbZF0Ebx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 00:31:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:57556 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932AbZF0Ebv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 00:31:51 -0400
Date: Sat, 27 Jun 2009 04:31:10 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       vince@deater.net, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       vince@deater.net, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/urgent] perf_counter tools: Remove dead code
Message-ID: <tip-fde953c1c67986e1c381fa50d8207b1578b5cefa@git.kernel.org>
Git-Commit-ID: fde953c1c67986e1c381fa50d8207b1578b5cefa
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 27 Jun 2009 04:31:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fde953c1c67986e1c381fa50d8207b1578b5cefa
Gitweb:     http://git.kernel.org/tip/fde953c1c67986e1c381fa50d8207b1578b5cefa
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Sat, 27 Jun 2009 06:06:39 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 27 Jun 2009 06:06:39 +0200

perf_counter tools: Remove dead code

Vince Weaver reported that there's a handful of #ifdef __MINGW32__
sections in the code.

Remove them as they are in essence dead code - as unlike upstream
Git, the perf tool is unlikely to be ported to Windows.

Reported-by: Vince Weaver <vince@deater.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/util/help.c        |   15 ------
 tools/perf/util/pager.c       |    5 +--
 tools/perf/util/run-command.c |   95 +----------------------------------------
 tools/perf/util/run-command.h |    5 --
 tools/perf/util/util.h        |   15 ------
 5 files changed, 3 insertions(+), 132 deletions(-)

diff --git a/tools/perf/util/help.c b/tools/perf/util/help.c
index 6653f7d..17a00e0 100644
--- a/tools/perf/util/help.c
+++ b/tools/perf/util/help.c
@@ -126,21 +126,6 @@ static int is_executable(const char *name)
 	    !S_ISREG(st.st_mode))
 		return 0;
 
-#ifdef __MINGW32__
-	/* cannot trust the executable bit, peek into the file instead */
-	char buf[3] = { 0 };
-	int n;
-	int fd = open(name, O_RDONLY);
-	st.st_mode &= ~S_IXUSR;
-	if (fd >= 0) {
-		n = read(fd, buf, 2);
-		if (n == 2)
-			/* DOS executables start with "MZ" */
-			if (!strcmp(buf, "#!") || !strcmp(buf, "MZ"))
-				st.st_mode |= S_IXUSR;
-		close(fd);
-	}
-#endif
 	return st.st_mode & S_IXUSR;
 }
 
diff --git a/tools/perf/util/pager.c b/tools/perf/util/pager.c
index a28bcca..1915de2 100644
--- a/tools/perf/util/pager.c
+++ b/tools/perf/util/pager.c
@@ -9,7 +9,6 @@
 
 static int spawned_pager;
 
-#ifndef __MINGW32__
 static void pager_preexec(void)
 {
 	/*
@@ -24,7 +23,6 @@ static void pager_preexec(void)
 
 	setenv("LESS", "FRSX", 0);
 }
-#endif
 
 static const char *pager_argv[] = { "sh", "-c", NULL, NULL };
 static struct child_process pager_process;
@@ -70,9 +68,8 @@ void setup_pager(void)
 	pager_argv[2] = pager;
 	pager_process.argv = pager_argv;
 	pager_process.in = -1;
-#ifndef __MINGW32__
 	pager_process.preexec_cb = pager_preexec;
-#endif
+
 	if (start_command(&pager_process))
 		return;
 
diff --git a/tools/perf/util/run-command.c b/tools/perf/util/run-command.c
index b2f5e85..a393534 100644
--- a/tools/perf/util/run-command.c
+++ b/tools/perf/util/run-command.c
@@ -65,7 +65,6 @@ int start_command(struct child_process *cmd)
 		cmd->err = fderr[0];
 	}
 
-#ifndef __MINGW32__
 	fflush(NULL);
 	cmd->pid = fork();
 	if (!cmd->pid) {
@@ -118,71 +117,6 @@ int start_command(struct child_process *cmd)
 		}
 		exit(127);
 	}
-#else
-	int s0 = -1, s1 = -1, s2 = -1;	/* backups of stdin, stdout, stderr */
-	const char **sargv = cmd->argv;
-	char **env = environ;
-
-	if (cmd->no_stdin) {
-		s0 = dup(0);
-		dup_devnull(0);
-	} else if (need_in) {
-		s0 = dup(0);
-		dup2(fdin[0], 0);
-	} else if (cmd->in) {
-		s0 = dup(0);
-		dup2(cmd->in, 0);
-	}
-
-	if (cmd->no_stderr) {
-		s2 = dup(2);
-		dup_devnull(2);
-	} else if (need_err) {
-		s2 = dup(2);
-		dup2(fderr[1], 2);
-	}
-
-	if (cmd->no_stdout) {
-		s1 = dup(1);
-		dup_devnull(1);
-	} else if (cmd->stdout_to_stderr) {
-		s1 = dup(1);
-		dup2(2, 1);
-	} else if (need_out) {
-		s1 = dup(1);
-		dup2(fdout[1], 1);
-	} else if (cmd->out > 1) {
-		s1 = dup(1);
-		dup2(cmd->out, 1);
-	}
-
-	if (cmd->dir)
-		die("chdir in start_command() not implemented");
-	if (cmd->env) {
-		env = copy_environ();
-		for (; *cmd->env; cmd->env++)
-			env = env_setenv(env, *cmd->env);
-	}
-
-	if (cmd->perf_cmd) {
-		cmd->argv = prepare_perf_cmd(cmd->argv);
-	}
-
-	cmd->pid = mingw_spawnvpe(cmd->argv[0], cmd->argv, env);
-
-	if (cmd->env)
-		free_environ(env);
-	if (cmd->perf_cmd)
-		free(cmd->argv);
-
-	cmd->argv = sargv;
-	if (s0 >= 0)
-		dup2(s0, 0), close(s0);
-	if (s1 >= 0)
-		dup2(s1, 1), close(s1);
-	if (s2 >= 0)
-		dup2(s2, 2), close(s2);
-#endif
 
 	if (cmd->pid < 0) {
 		int err = errno;
@@ -288,14 +222,6 @@ int run_command_v_opt_cd_env(const char **argv, int opt, const char *dir, const
 	return run_command(&cmd);
 }
 
-#ifdef __MINGW32__
-static __stdcall unsigned run_thread(void *data)
-{
-	struct async *async = data;
-	return async->proc(async->fd_for_proc, async->data);
-}
-#endif
-
 int start_async(struct async *async)
 {
 	int pipe_out[2];
@@ -304,7 +230,6 @@ int start_async(struct async *async)
 		return error("cannot create pipe: %s", strerror(errno));
 	async->out = pipe_out[0];
 
-#ifndef __MINGW32__
 	/* Flush stdio before fork() to avoid cloning buffers */
 	fflush(NULL);
 
@@ -319,33 +244,17 @@ int start_async(struct async *async)
 		exit(!!async->proc(pipe_out[1], async->data));
 	}
 	close(pipe_out[1]);
-#else
-	async->fd_for_proc = pipe_out[1];
-	async->tid = (HANDLE) _beginthreadex(NULL, 0, run_thread, async, 0, NULL);
-	if (!async->tid) {
-		error("cannot create thread: %s", strerror(errno));
-		close_pair(pipe_out);
-		return -1;
-	}
-#endif
+
 	return 0;
 }
 
 int finish_async(struct async *async)
 {
-#ifndef __MINGW32__
 	int ret = 0;
 
 	if (wait_or_whine(async->pid))
 		ret = error("waitpid (async) failed");
-#else
-	DWORD ret = 0;
-	if (WaitForSingleObject(async->tid, INFINITE) != WAIT_OBJECT_0)
-		ret = error("waiting for thread failed: %lu", GetLastError());
-	else if (!GetExitCodeThread(async->tid, &ret))
-		ret = error("cannot get thread exit code: %lu", GetLastError());
-	CloseHandle(async->tid);
-#endif
+
 	return ret;
 }
 
diff --git a/tools/perf/util/run-command.h b/tools/perf/util/run-command.h
index 328289f..cc1837d 100644
--- a/tools/perf/util/run-command.h
+++ b/tools/perf/util/run-command.h
@@ -79,12 +79,7 @@ struct async {
 	int (*proc)(int fd, void *data);
 	void *data;
 	int out;	/* caller reads from here and closes it */
-#ifndef __MINGW32__
 	pid_t pid;
-#else
-	HANDLE tid;
-	int fd_for_proc;
-#endif
 };
 
 int start_async(struct async *async);
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index b8cfed7..b4be607 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -67,7 +67,6 @@
 #include <assert.h>
 #include <regex.h>
 #include <utime.h>
-#ifndef __MINGW32__
 #include <sys/wait.h>
 #include <sys/poll.h>
 #include <sys/socket.h>
@@ -81,20 +80,6 @@
 #include <netdb.h>
 #include <pwd.h>
 #include <inttypes.h>
-#if defined(__CYGWIN__)
-#undef _XOPEN_SOURCE
-#include <grp.h>
-#define _XOPEN_SOURCE 600
-#include "compat/cygwin.h"
-#else
-#undef _ALL_SOURCE /* AIX 5.3L defines a struct list with _ALL_SOURCE. */
-#include <grp.h>
-#define _ALL_SOURCE 1
-#endif
-#else 	/* __MINGW32__ */
-/* pull in Windows compatibility stuff */
-#include "compat/mingw.h"
-#endif	/* __MINGW32__ */
 
 #ifndef NO_ICONV
 #include <iconv.h>
