Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab0BQUd5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 15:33:57 -0500
Received: from eagle.jhcloos.com ([207.210.242.212]:36172 "EHLO
	eagle.jhcloos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755608Ab0BQUdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 15:33:20 -0500
From: James Cloos <cloos@jhcloos.com>
To: linux-kernel@vger.kernel.org
Cc: Chris Mason <chris.mason@oracle.com>, linux-fsdevel@vger.kernel.org,
       linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
       jfs-discussion@lists.sourceforge.net
Subject: Re: [Regression] Filesystem I/O is CPU-bound in rc7 and rc8
In-Reply-To: <20100215154516.GB11057@think> (Chris Mason's message of "Mon, 15
	Feb 2010 10:45:16 -0500")
References: <m3pr48bjfg.fsf@lugabout.jhcloos.org>
	<20100215154516.GB11057@think>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1.90 (gnu/linux)
Face: iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABHNCSVQICAgIfAhkiAAAAI1J
 REFUOE+lU9ESgCAIg64P1y+ngUdxhl5H8wFbbM0OmUiEhKkCYaZThXCo6KE5sCbA1DDX3genvO4d
 eBQgEMaM5qy6uWk4SfBYfdu9jvBN9nSVDOKRtwb+I3epboOsOX5pZbJNsBJFvmQQ05YMfieIBnYX
 FK2N6dOawd97r/e8RjkTLzmMsiVgrAoEugtviCM3v2WzjgAAAABJRU5ErkJggg==
Copyright: Copyright 2009 James Cloos
OpenPGP: ED7DAEA6; url=http://jhcloos.com/public_key/0xED7DAEA6.asc
OpenPGP-Fingerprint: E9E9 F828 61A4 6EA9 0F2B  63E7 997A 9F17 ED7D AEA6
Date: Wed, 17 Feb 2010 15:04:47 -0500
Message-ID: <m3d403632g.fsf@lugabout.jhcloos.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Hashcash: 1:30:100217:linux-kernel@vger.kernel.org::9wKRocalT3ml6/L3:00000000000000000000000000000000N0/D5
X-Hashcash: 1:30:100217:chris.mason@oracle.com::D0eS2HWCAq80kvij:00000000000000000000000000000000000000kh6tu
X-Hashcash: 1:30:100217:linux-fsdevel@vger.kernel.org::OXsIaHfDiNyZtSp4:0000000000000000000000000000000b8xIu
X-Hashcash: 1:30:100217:linux-ext4@vger.kernel.org::VCP6TJOl3VG/cVa+:00000000000000000000000000000000002sRgg
X-Hashcash: 1:30:100217:linux-btrfs@vger.kernel.org::2ZrIyOD1s6TAYF43:000000000000000000000000000000000HPknZ
X-Hashcash: 1:30:100217:jfs-discussion@lists.sourceforge.net::nGi/6QFCpY1z/QRr:000000000000000000000000b5KpC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While getting re-aquainted with perf, and after upgrading to the current
version, I see that do_page_fault, unmap_vmas, get_page_from_freelist,
handle_mm_fault, __do_fault and T.1339 tend to get the most time when the
kernel is spinning.

T.1339 is in this part of kallsyms:

,----< grep -E -C9 ^c1027750 /proc/kallsyms >
| c10266a0 T sched_setscheduler_nocheck
| c10266c0 T sched_setscheduler
| c10266e0 t do_sched_setscheduler
| c1026770 T sys_sched_setparam
| c1026790 T sys_sched_setscheduler
| c10267c0 T sched_fork
| c1026900 T task_oncpu_function_call
| c1026960 T print_cfs_rq
| c1027640 T scheduler_tick
| c1027750 t T.1339
| c10277f0 T schedule_tail
| c1027830 t ftrace_raw_output_sched_kthread_stop
| c1027930 t ftrace_raw_output_sched_kthread_stop_ret
| c1027a30 t ftrace_raw_output_sched_wait_task
| c1027b40 t ftrace_raw_output_sched_switch
| c1027c90 t ftrace_raw_output_sched_migrate_task
| c1027da0 t ftrace_raw_output_sched_process_wait
| c1027eb0 t ftrace_raw_output_sched_process_fork
| c1027fc0 t ftrace_raw_output_sched_stat_runtime
`----

suggesting that T.1339 is part of sched.

This leaves the impression that the issue is related to either
scheduling or paging.

I don't see any commits in the rc6..rc7 timeframe which stand out
as likely suspects.

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
