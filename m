Return-Path: <linux-kernel-owner+w=401wt.eu-S1752366AbYJ1PkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366AbYJ1PkO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 11:40:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751981AbYJ1Pj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 11:39:59 -0400
Received: from el-out-1112.google.com ([209.85.162.176]:3221 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594AbYJ1Pj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 11:39:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=KNnBoGIBh5OdKmNgysfaHoiqbTe23Qb0Xy1k5fyV5/bO5dDnYMxX8qOa5gni4Skvwf
         w2NxFJSiAb8qjU5ZrF4kUe6bF5JNH0RJ7n9DI+/JAW7WS5khkMcPr2n9J5KKahsNywjA
         hqtlX/OeyeFRPjLqMZcOKBucxzVTgQ1xos/Ac=
Message-ID: <21d34cad0810280839j1b2280c7g1dcd67d52fddad8b@mail.gmail.com>
Date: Tue, 28 Oct 2008 23:39:55 +0800
From: "Qinghuang Feng" <qhfeng.kernel@gmail.com>
To: "Vivek Goyal" <vgoyal@redhat.com>
Subject: [PATCH RESEND] kdump: update Documentation gdbmacros.txt
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       linux-doc@vger.kernel.org, maneesh@in.ibm.com, alexn@telia.com,
       vatsa@in.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The  previous patch sent about two weeks ago has a problem:
I define an internal marco named __show_state, but it is called
with an another name "show_state". This problem efforted
only the new macros "psusr" and "pskern" introduced by me.

The problem has been fixed in this patch, and this  patch
has been tested.

BTW, I haven't got reply from original  authors of the doc,
what should I do next?

This patch is for linus-git, and it do the following:

1.updates macros in the file to fix the following errors:
(gdb) btt
There is no member named pid_list.
(gdb) bttnobp
There is no member named pid_list.

2.fix bugs in two places when iterateing thread members in a thread group

original macro:
16 define bttnobp
....
21         while ($next_t != $init_t)
...
34                 set $next_th=(((char
*)$next_t->pids[1].pid_list.next) - $pid_off)
35                 while ($next_th != $next_t)
36                         set $next_th=(struct task_struct *)$next_th
37                         printf "\npid %d; comm %s:\n", $next_t.pid,
$next_t.comm
now, we should print info about the thread member, but it  print
info of threadgroup leader repeatly.
...
3.introduce two auxiliary macros: psusr and pskern to list info of all tasks
viewed in userspace and kernelspace respectively.

The following is the testing result, bu it is test in X86 and kgdb remote
debugging environment:
a.out is a muti-thread program, and one of its threads exec the "top".
(gdb) pskern
address		state		uid	pid	ppid	comm
0xC03512F4	running		0	0	0	swapper
....
0xD9418180	sleeping	0	2379	2371	bash
0xD94191C0	sleeping	0	2383	2379	a.out
0xDC52DA20	sleeping	0	2384	2379	a.out
0xDC52D610	sleeping	0	2385	2379	a.out
0xDC52D200	sleeping	0	2386	2379	a.out
0xDC52CDF0	sleeping	0	2387	2386	top
address		state		uid	pid	ppid	comm
(gdb) btt
....
pid 2379; addr:0xd9418180; comm bash:
=====================================
do_wait + 2227 in section .text
sys_wait4 + 121 in section .text
sys_waitpid + 19 in section .text
ia32_sysenter_target + 127 in section .text
pid 2383; addr:0xd94191c0; comm a.out:
=====================================
do_nanosleep + 84 in section .text
hrtimer_nanosleep + 74 in section .text
sys_nanosleep + 66 in section .text
ia32_sysenter_target + 127 in section .text
pid 2384; addr:0xdc52da20; comm a.out:
=====================================
do_nanosleep + 84 in section .text
hrtimer_nanosleep + 74 in section .text
sys_nanosleep + 66 in section .text
ia32_sysenter_target + 127 in section .text
pid 2385; addr:0xdc52d610; comm a.out:
---Type <return> to continue, or q <return> to quit---
=====================================
do_nanosleep + 84 in section .text
hrtimer_nanosleep + 74 in section .text
sys_nanosleep + 66 in section .text
ia32_sysenter_target + 127 in section .text
pid 2386; addr:0xdc52d200; comm a.out:
=====================================
do_wait + 2227 in section .text
sys_wait4 + 121 in section .text
sys_waitpid + 19 in section .text
ia32_sysenter_target + 127 in section .text
pid 2387; addr:0xdc52cdf0; comm top:
=====================================
schedule_timeout + 109 in section .text
do_select + 1081 in section .text
core_sys_select + 440 in section .text
sys_select + 143 in section .text
ia32_sysenter_target + 127 in section .text

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
---
diff --git a/Documentation/kdump/gdbmacros.txt
b/Documentation/kdump/gdbmacros.txt
index 9b9b454..84acf7d 100644
--- a/Documentation/kdump/gdbmacros.txt
+++ b/Documentation/kdump/gdbmacros.txt
@@ -13,39 +13,146 @@
 # Maneesh Soni <maneesh@in.ibm.com>
 #

+define __show_state
+        if ($arg0->state == 0)
+                printf "running\t\t"
+                else
+                if ($arg0->state == 1)
+                        printf "sleeping\t"
+                        else
+                        if ($arg0->state == 2)
+                                printf "disksleep\t"
+                                else
+                                if ($arg0->state == 4)
+                                        printf "zombie\t"
+                                        else
+                                        if ($arg0->state == 8)
+                                                printf "stopped\t"
+                                                else
+                                                if ($arg0->state == 16)
+                                                        printf "wpaging\t"
+                                                        else
+
printf "%d\t\t", $arg0->state
+                                                        end
+                                                end
+                                        end
+                                end
+                        end
+                end
+end
+document __show_state
+internel macro, don't call it by hand
+end
+
+
+define psusr
+        printf "address\t\tstate\t\tuid\tpid\tppid\tcomm\n"
+        set $init_t = &init_task
+        set $tasks_off=((size_t)&((struct task_struct *)0)->tasks)
+        set $next_t=(((char *)($init_t->tasks).next) - $tasks_off)
+
+        while ($next_t != $init_t)
+		set $next_t=(struct task_struct *)$next_t
+		printf "0x%08X\t", $next_t
+		__show_state $next_t
+		printf "%d\t%d\t%d\t%s\n", \
+			$next_t->uid, $next_t->pid, \
+			$next_t->parent->pid, $next_t->comm
+		set  $next_t=(char *)($next_t->tasks.next) - $tasks_off
+        end
+
+        printf "address\t\tstate\t\tuid\tpid\tppid\tcomm\n"
+        printf "----end----\n"
+
+end
+document psusr
+print information for all tasks, but not including thread members.
+This command looks like "ps -aux" in userspace.
+end
+
+
+define pskern
+        printf "address\t\tstate\t\tuid\tpid\tppid\tcomm\n"
+        set $init_t = &init_task
+        printf "0x%08X\t", $init_t
+        __show_state $init_t
+        printf "%d\t%d\t%d\t%s\n", \
+                $init_t->uid, $init_t->pid, \
+                $init_t->parent->pid, $init_t->comm
+	
+	set $tasks_off=((size_t)&((struct task_struct *)0)->tasks)
+	set $thread_off=((size_t)&((struct task_struct *)0)->thread_group.next)
+	set $next_t=(((char *)($init_t->tasks).next) - $tasks_off)
+
+	while ($next_t != $init_t)
+		set $next_t=(struct task_struct *)$next_t
+
+		printf "0x%08X\t", $next_t
+		__show_state $next_t
+		printf "%d\t%d\t%d\t%s\n", \
+			$next_t->uid, $next_t->pid, \
+			$next_t->parent->pid, $next_t->comm
+
+		set $next_th=(((char *)$next_t->thread_group.next) - $thread_off)
+
+		while ($next_th != $next_t)
+			set $next_th=(struct task_struct *)$next_th
+
+			printf "0x%08X\t", $next_th
+			__show_state $next_th
+			printf "%d\t%d\t%d\t%s\n", \
+				$next_th->uid, $next_th->pid, \
+				$next_th->parent->pid, $next_th->comm
+
+			set $next_th=(((char *)$next_th->thread_group.next) - $thread_off)
+		end
+
+		set  $next_t=(char *)($next_t->tasks.next) - $tasks_off
+        end
+
+        printf "address\t\tstate\t\tuid\tpid\tppid\tcomm\n"
+        printf "----end----\n"
+
+end
+document pskern
+print infor for all tasks viewed in kernel, including all thread members
+and swapper(PID==0).
+end
+
+
+define __prinfo_nobp
+        printf "\npid %d; addr:0x%08x; comm %s:\n", \
+                $arg0.pid, $arg0, $arg0.comm
+        printf "=====================================\n"
+        set var $stackp = $arg0.thread.sp
+        set var $stack_top = ($stackp & ~4095) + 4096
+
+        while ($stackp < $stack_top)
+                if (*($stackp) > _stext && *($stackp) < _sinittext)
+                        info symbol *($stackp)
+                end
+        set $stackp += 4
+        end
+end
+document __prinfo_nobp
+internal macro, don't call it by hand.
+end
+
+
 define bttnobp
 	set $tasks_off=((size_t)&((struct task_struct *)0)->tasks)
-	set $pid_off=((size_t)&((struct task_struct *)0)->pids[1].pid_list.next)
+	set $thread_off=((size_t)&((struct task_struct *)0)->thread_group.next)
 	set $init_t=&init_task
 	set $next_t=(((char *)($init_t->tasks).next) - $tasks_off)
+
 	while ($next_t != $init_t)
 		set $next_t=(struct task_struct *)$next_t
-		printf "\npid %d; comm %s:\n", $next_t.pid, $next_t.comm
-		printf "===================\n"
-		set var $stackp = $next_t.thread.esp
-		set var $stack_top = ($stackp & ~4095) + 4096
-
-		while ($stackp < $stack_top)
-			if (*($stackp) > _stext && *($stackp) < _sinittext)
-				info symbol *($stackp)
-			end
-			set $stackp += 4
-		end
-		set $next_th=(((char *)$next_t->pids[1].pid_list.next) - $pid_off)
+		__prinfo_nobp $next_t
+		set $next_th=(((char *)$next_t->thread_group.next) - $thread_off)
 		while ($next_th != $next_t)
 			set $next_th=(struct task_struct *)$next_th
-			printf "\npid %d; comm %s:\n", $next_t.pid, $next_t.comm
-			printf "===================\n"
-			set var $stackp = $next_t.thread.esp
-			set var $stack_top = ($stackp & ~4095) + 4096
-
-			while ($stackp < $stack_top)
-				if (*($stackp) > _stext && *($stackp) < _sinittext)
-					info symbol *($stackp)
-				end
-				set $stackp += 4
-			end
-			set $next_th=(((char *)$next_th->pids[1].pid_list.next) - $pid_off)
+			__prinfo_nobp $next_th
+			set $next_th=(((char *)$next_th->thread_group.next) - $thread_off)
 		end
 		set $next_t=(char *)($next_t->tasks.next) - $tasks_off
 	end
@@ -54,42 +161,41 @@ document bttnobp
 	dump all thread stack traces on a kernel compiled with !CONFIG_FRAME_POINTER
 end

+
+define __prinfo
+        printf "\npid %d; addr:0x%08x; comm %s:\n", \
+                $arg0.pid, $arg0, $arg0.comm
+        printf "=====================================\n"
+        set var $stackp = $arg0.thread.sp
+        set var $stack_top = ($stackp & ~4095) + 4096
+        set var $stack_bot = ($stackp & ~4095)
+
+        set $stackp = *($stackp)
+        while (($stackp < $stack_top) && ($stackp > $stack_bot))
+                set var $addr = *($stackp + 4)
+                info symbol $addr
+                set $stackp = *($stackp)
+        end
+end
+document __prinfo
+internal macro, don't call it by hand.
+end
+
+
 define btt
 	set $tasks_off=((size_t)&((struct task_struct *)0)->tasks)
-	set $pid_off=((size_t)&((struct task_struct *)0)->pids[1].pid_list.next)
+	set $thread_off=((size_t)&((struct task_struct *)0)->thread_group.next)
 	set $init_t=&init_task
 	set $next_t=(((char *)($init_t->tasks).next) - $tasks_off)
+
 	while ($next_t != $init_t)
 		set $next_t=(struct task_struct *)$next_t
-		printf "\npid %d; comm %s:\n", $next_t.pid, $next_t.comm
-		printf "===================\n"
-		set var $stackp = $next_t.thread.esp
-		set var $stack_top = ($stackp & ~4095) + 4096
-		set var $stack_bot = ($stackp & ~4095)
-
-		set $stackp = *($stackp)
-		while (($stackp < $stack_top) && ($stackp > $stack_bot))
-			set var $addr = *($stackp + 4)
-			info symbol $addr
-			set $stackp = *($stackp)
-		end
-
-		set $next_th=(((char *)$next_t->pids[1].pid_list.next) - $pid_off)
+		__prinfo $next_t
+		set $next_th=(((char *)$next_t->thread_group.next) - $thread_off)
 		while ($next_th != $next_t)
 			set $next_th=(struct task_struct *)$next_th
-			printf "\npid %d; comm %s:\n", $next_t.pid, $next_t.comm
-			printf "===================\n"
-			set var $stackp = $next_t.thread.esp
-			set var $stack_top = ($stackp & ~4095) + 4096
-			set var $stack_bot = ($stackp & ~4095)
-
-			set $stackp = *($stackp)
-			while (($stackp < $stack_top) && ($stackp > $stack_bot))
-				set var $addr = *($stackp + 4)
-				info symbol $addr
-				set $stackp = *($stackp)
-			end
-			set $next_th=(((char *)$next_th->pids[1].pid_list.next) - $pid_off)
+			__prinfo $next_th	
+			set $next_th=(((char *)$next_th->thread_group.next) - $thread_off)
 		end
 		set $next_t=(char *)($next_t->tasks.next) - $tasks_off
 	end
@@ -101,7 +207,7 @@ end
 define btpid
 	set var $pid = $arg0
 	set $tasks_off=((size_t)&((struct task_struct *)0)->tasks)
-	set $pid_off=((size_t)&((struct task_struct *)0)->pids[1].pid_list.next)
+	set $thread_off=((size_t)&((struct task_struct *)0)->thread_group)
 	set $init_t=&init_task
 	set $next_t=(((char *)($init_t->tasks).next) - $tasks_off)
 	set var $pid_task = 0
@@ -113,29 +219,19 @@ define btpid
 			set $pid_task = $next_t
 		end

-		set $next_th=(((char *)$next_t->pids[1].pid_list.next) - $pid_off)
+		set $next_th=(((char *)$next_t->thread_group.next) - $thread_off)
 		while ($next_th != $next_t)
 			set $next_th=(struct task_struct *)$next_th
 			if ($next_th.pid == $pid)
 				set $pid_task = $next_th
 			end
-			set $next_th=(((char *)$next_th->pids[1].pid_list.next) - $pid_off)
+			set $next_th=(((char *)$next_th->thread_group.next) - $thread_off)
 		end
 		set $next_t=(char *)($next_t->tasks.next) - $tasks_off
 	end

-	printf "\npid %d; comm %s:\n", $pid_task.pid, $pid_task.comm
-	printf "===================\n"
-	set var $stackp = $pid_task.thread.esp
-	set var $stack_top = ($stackp & ~4095) + 4096
-	set var $stack_bot = ($stackp & ~4095)
-
-	set $stackp = *($stackp)
-	while (($stackp < $stack_top) && ($stackp > $stack_bot))
-		set var $addr = *($stackp + 4)
-		info symbol $addr
-		set $stackp = *($stackp)
-	end
+	__prinfo $pid_task
+
 end
 document btpid
 	backtrace of pid
@@ -145,7 +241,7 @@ end
 define trapinfo
 	set var $pid = $arg0
 	set $tasks_off=((size_t)&((struct task_struct *)0)->tasks)
-	set $pid_off=((size_t)&((struct task_struct *)0)->pids[1].pid_list.next)
+	set $thread_off=((size_t)&((struct task_struct *)0)->thread_group.next)
 	set $init_t=&init_task
 	set $next_t=(((char *)($init_t->tasks).next) - $tasks_off)
 	set var $pid_task = 0
@@ -157,13 +253,13 @@ define trapinfo
 			set $pid_task = $next_t
 		end

-		set $next_th=(((char *)$next_t->pids[1].pid_list.next) - $pid_off)
+		set $next_th=(((char *)$next_t->thread_group.next) - $thread_off)
 		while ($next_th != $next_t)
 			set $next_th=(struct task_struct *)$next_th
 			if ($next_th.pid == $pid)
 				set $pid_task = $next_th
 			end
-			set $next_th=(((char *)$next_th->pids[1].pid_list.next) - $pid_off)
+			set $next_th=(((char *)$next_th->thread_group.next) - $thread_off)
 		end
 		set $next_t=(char *)($next_t->tasks.next) - $tasks_off
 	end
