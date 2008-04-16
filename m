Return-Path: <linux-kernel-owner+w=401wt.eu-S1758449AbYDPV4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758449AbYDPV4N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 17:56:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754147AbYDPVz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 17:55:58 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:22586 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235AbYDPVz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 17:55:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:user-agent:mime-version:content-type:from;
        b=PP43AhSgOy1H/4q60bAPE33JDy1SLx6f6z3cPTKLKJo3OZFJmJffzaFlxJi/8SX7bLPety2kevmMyYCxiy/sml6kDHmU4xWr3i3gdGcP/uA3W1Csuo77ilz6zWZl76vfMzkdtq8fmSz5QlUePMJFDdVBQGRJAVNblyfpI+J67UQ=
Date: Wed, 16 Apr 2008 23:45:56 +0200 (CEST)
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Jesper Juhl <jesper.juhl@gmail.com>
Subject: Possible mem leak in copy_process()
Message-ID: <alpine.LNX.1.00.0804162336480.9837@dragon.funnycrock.com>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
From: Jesper Juhl <jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Ingo,

I was just browsing through Coverity Scan results for the kernel and 
noticed one thing it spotted that looks valid but which I have no idea how 
to fix. 
The code is, as far as I can see, written by you so I thought I'd forward 
the info from Coverity to you in the hope that perhaps you'd know what to 
do about it :-)

It's a memory leak in copy_process() - this is what coverity reports : 


1004 	static struct task_struct *copy_process(unsigned long clone_flags,
1005 						unsigned long stack_start,
1006 						struct pt_regs *regs,
1007 						unsigned long stack_size,
1008 						int __user *child_tidptr,
1009 						struct pid *pid)
1010 	{
<...snip...>
1198 			retval = -ENOMEM;

Event alloc_fn: Called allocation function "alloc_pid" [model]
Event var_assign: Assigned variable "pid" to storage returned from "alloc_pid"
Also see events: [var_assign][leaked_storage][pass_arg]

1199 			pid = alloc_pid(task_active_pid_ns(p));

At conditional (1): "pid == 0" taking false path

1200 			if (!pid)
1201 				goto bad_fork_cleanup_io;
1202 	

At conditional (2): "clone_flags & 536870912 != 0" taking true path

1203 			if (clone_flags & CLONE_NEWPID) {
1204 				retval = pid_ns_prepare_proc(task_active_pid_ns(p));

At conditional (3): "retval < 0" taking false path

1205 				if (retval < 0)
1206 					goto bad_fork_free_pid;
1207 			}
1208 		}
1209 	

Event pass_arg: Variable "pid" not freed or pointed-to in function "pid_nr" [model]
Also see events: [alloc_fn][var_assign][leaked_storage]

1210 		p->pid = pid_nr(pid);
1211 		p->tgid = p->pid;

At conditional (4): "clone_flags & 65536 != 0" taking true path

1212 		if (clone_flags & CLONE_THREAD)
1213 			p->tgid = current->tgid;
1214 	

At conditional (5): "clone_flags & 16777216 != 0" taking true path

1215 		p->set_child_tid = (clone_flags & CLONE_CHILD_SETTID) ? child_tidptr : NULL;
1216 		/*
1217 		 * Clear TID on mm_release()?
1218 		 */

At conditional (6): "clone_flags & 2097152 != 0" taking true path

1219 		p->clear_child_tid = (clone_flags & CLONE_CHILD_CLEARTID) ? child_tidptr: NULL;
1220 	#ifdef CONFIG_FUTEX
1221 		p->robust_list = NULL;
1222 	#ifdef CONFIG_COMPAT
1223 		p->compat_robust_list = NULL;
1224 	#endif
1225 		INIT_LIST_HEAD(&p->pi_state_list);
1226 		p->pi_state_cache = NULL;
1227 	#endif
1228 		/*
1229 		 * sigaltstack should be cleared when sharing the same VM
1230 		 */

At conditional (7): "clone_flags & 16640 == 256" taking true path

1231 		if ((clone_flags & (CLONE_VM|CLONE_VFORK)) == CLONE_VM)
1232 			p->sas_ss_sp = p->sas_ss_size = 0;
1233 	
1234 		/*
1235 		 * Syscall tracing should be turned off in the child regardless
1236 		 * of CLONE_PTRACE.
1237 		 */
1238 		clear_tsk_thread_flag(p, TIF_SYSCALL_TRACE);
1239 	#ifdef TIF_SYSCALL_EMU
1240 		clear_tsk_thread_flag(p, TIF_SYSCALL_EMU);
1241 	#endif
1242 		clear_all_latency_tracing(p);
1243 	
1244 		/* Our parent execution domain becomes current domain
1245 		   These must match for thread signalling to apply */
1246 		p->parent_exec_id = p->self_exec_id;
1247 	
1248 		/* ok, now we should be set up.. */

At conditional (8): "clone_flags & 65536 != 0" taking true path

1249 		p->exit_signal = (clone_flags & CLONE_THREAD) ? -1 : (clone_flags & CSIGNAL);
1250 		p->pdeath_signal = 0;
1251 		p->exit_state = 0;
1252 	
1253 		/*
1254 		 * Ok, make it visible to the rest of the system.
1255 		 * We dont wake it up yet.
1256 		 */
1257 		p->group_leader = p;
1258 		INIT_LIST_HEAD(&p->thread_group);
1259 		INIT_LIST_HEAD(&p->ptrace_children);
1260 		INIT_LIST_HEAD(&p->ptrace_list);
1261 	
1262 		/* Now that the task is set up, run cgroup callbacks if
1263 		 * necessary. We need to run them before the task is visible
1264 		 * on the tasklist. */
1265 		cgroup_fork_callbacks(p);
1266 		cgroup_callbacks_done = 1;
1267 	
1268 		/* Need tasklist lock for parent etc handling! */
1269 		write_lock_irq(&tasklist_lock);
1270 	
1271 		/*
1272 		 * The task hasn't been attached yet, so its cpus_allowed mask will
1273 		 * not be changed, nor will its assigned CPU.
1274 		 *
1275 		 * The cpus_allowed mask of the parent may have changed after it was
1276 		 * copied first time - so re-copy it here, then check the child's CPU
1277 		 * to ensure it is on a valid CPU (and if not, just force it back to
1278 		 * parent's CPU). This avoids alot of nasty races.
1279 		 */
1280 		p->cpus_allowed = current->cpus_allowed;
1281 		p->rt.nr_cpus_allowed = current->rt.nr_cpus_allowed;

At conditional (9): "0" taking false path
At conditional (10): "((0) ? constant_test_bit : (variable_test_bit)) == 0" taking true path

1282 		if (unlikely(!cpu_isset(task_cpu(p), p->cpus_allowed) ||
1283 				!cpu_online(task_cpu(p))))

At conditional (11): "4 == 4" taking true path

1284 			set_task_cpu(p, smp_processor_id());
1285 	
1286 		/* CLONE_PARENT re-uses the old parent */

At conditional (12): "clone_flags & 98304 != 0" taking true path

1287 		if (clone_flags & (CLONE_PARENT|CLONE_THREAD))
1288 			p->real_parent = current->real_parent;
1289 		else
1290 			p->real_parent = current;
1291 		p->parent = p->real_parent;
1292 	
1293 		spin_lock(&current->sighand->siglock);
1294 	
1295 		/*
1296 		 * Process group and session signals need to be delivered to just the
1297 		 * parent before the fork or both the parent and the child after the
1298 		 * fork. Restart if a signal comes in before we add the new process to
1299 		 * it's process group.
1300 		 * A fatal signal pending means that current will exit, so the new
1301 		 * thread can't slip out of an OOM kill (or normal SIGKILL).
1302 	 	 */
1303 		recalc_sigpending();

At conditional (13): "signal_pending != 0" taking false path

1304 		if (signal_pending(current)) {
1305 			spin_unlock(&current->sighand->siglock);
1306 			write_unlock_irq(&tasklist_lock);
1307 			retval = -ERESTARTNOINTR;
1308 			goto bad_fork_free_pid;
1309 		}
1310 	

At conditional (14): "clone_flags & 65536 != 0" taking true path

1311 		if (clone_flags & CLONE_THREAD) {
1312 			p->group_leader = current->group_leader;
1313 			list_add_tail_rcu(&p->thread_group, &p->group_leader->thread_group);
1314 	

At conditional (15): "((get_current)->signal)->it_virt_expires != 0" 
taking true path

1315 			if (!cputime_eq(current->signal->it_virt_expires,
1316 					cputime_zero) ||
1317 			    !cputime_eq(current->signal->it_prof_expires,
1318 					cputime_zero) ||
1319 			    current->signal->rlim[RLIMIT_CPU].rlim_cur != RLIM_INFINITY ||
1320 			    !list_empty(&current->signal->cpu_timers[0]) ||
1321 			    !list_empty(&current->signal->cpu_timers[1]) ||
1322 			    !list_empty(&current->signal->cpu_timers[2])) {
1323 				/*
1324 				 * Have child wake up on its first tick to check
1325 				 * for process CPU timers.
1326 				 */
1327 				p->it_prof_expires = jiffies_to_cputime(1);
1328 			}
1329 		}
1330 	

At conditional (16): "(p)->pid != 0" taking false path

1331 		if (likely(p->pid)) {
1332 			add_parent(p);
1333 			if (unlikely(p->ptrace & PT_PTRACED))
1334 				__ptrace_link(p, current->parent);
1335 	
1336 			if (thread_group_leader(p)) {
1337 				if (clone_flags & CLONE_NEWPID)
1338 					p->nsproxy->pid_ns->child_reaper = p;
1339 	
1340 				p->signal->leader_pid = pid;
1341 				p->signal->tty = current->signal->tty;
1342 				set_task_pgrp(p, task_pgrp_nr(current));
1343 				set_task_session(p, task_session_nr(current));
1344 				attach_pid(p, PIDTYPE_PGID, task_pgrp(current));
1345 				attach_pid(p, PIDTYPE_SID, task_session(current));
1346 				list_add_tail_rcu(&p->tasks, &init_task.tasks);
1347 				__get_cpu_var(process_counts)++;
1348 			}
1349 			attach_pid(p, PIDTYPE_PID, pid);
1350 			nr_threads++;
1351 		}
1352 	
1353 		total_forks++;
1354 		spin_unlock(&current->sighand->siglock);
1355 		write_unlock_irq(&tasklist_lock);
1356 		proc_fork_connector(p);
1357 		cgroup_post_fork(p);

Event leaked_storage: Returned without freeing storage "pid"
Also see events: [alloc_fn][var_assign][pass_arg]

1358 		return p;


Perhaps it can never happen the way Coverity thinks it can. You are a much 
better judge of that than I, but it looks to me like it's at least 
possible in theory - in which case we have a potential leak every time we 
create a new process and that can't be good...

Anyway, just wanted to bring it to your attention.  Bye bye :-)


-- 
 Jesper Juhl < jesper.juhl@gmail.com>


