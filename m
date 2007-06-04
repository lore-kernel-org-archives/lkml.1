Return-Path: <linux-kernel-owner+w=401wt.eu-S1760448AbXFDSln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760448AbXFDSln (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 14:41:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755911AbXFDSld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 14:41:33 -0400
Received: from waste.org ([66.93.16.53]:59510 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754779AbXFDSlc (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 14:41:32 -0400
Date: Mon, 4 Jun 2007 13:41:06 -0500
From: Matt Mackall <mpm@selenic.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>, akpm@linux-foundation.org,
       Linux-kernel@vger.kernel.org
Subject: Re: Interesting interaction between lguest and CFS
Message-ID: <20070604184106.GG11115@waste.org>
References: <20070604173710.GR11166@waste.org> <20070604175436.GC30274@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070604175436.GC30274@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2007 at 07:54:36PM +0200, Ingo Molnar wrote:
> 
> * Matt Mackall <mpm@selenic.com> wrote:
> 
> > With 2.6.22-rc3-mm1, I've got a long-running video transcoding going 
> > on. In other windows, I'm compiling, reading email, etc. with no 
> > noticeable problems.
> > 
> > If I fire up lguest and leave it sitting at a shell prompt for a 
> > couple moments, when I return to type something at the prompt, it can 
> > take 2-3 seconds for my input to echo. Once it starts responding, 
> > typing latency disappears. Suspend the other app and the latency 
> > disappears.
> > 
> > The system isn't swapping and has basically no I/O load.
> 
> could you send me the /proc/PID/sched file of that task which shows this 
> 2-3 seconds delay? (if it's a shell and a graphical terminal then please 
> send the sched-debug file of both.) I suspect the latency goes away if 
> you strace -f the shell task(s)? If not then please send the strace 
> output too.

Not sure why the shell task (bash) is interesting here?

gnome-terminal(4177)->bash(4409)->lg(24934)->lguest(24936)->lguest(24944)

(lg is a shell script to launch lguest)

/proc/4177/sched 
wait_start               :                   0
wait_start_fair          :                   0
exec_start               :                   0
sleep_start              :   53594838106004537
sleep_start_fair         :   53575815099165186
block_start              :                   0
sleep_max                :         57476665627
block_max                :   18014060106626075
exec_max                 :             4021419
wait_max                 :           557161172
last_ran                 :                   0
wait_runtime             :            23552233
wait_runtime_overruns    :             1864716
wait_runtime_underruns   :                 310
sum_exec_runtime         :        678350336100
clock-delta              :                  94

cat /proc/4409/sched 
wait_start               :                   0
wait_start_fair          :                   0
exec_start               :                   0
sleep_start              :   53593602868366272
sleep_start_fair         :   53575146154577161
block_start              :                   0
sleep_max                :       2006065218683
block_max                :           457256091
exec_max                 :             3995741
wait_max                 :           107832482
last_ran                 :                   0
wait_runtime             :            23634554
wait_runtime_overruns    :                 316
wait_runtime_underruns   :                   9
sum_exec_runtime         :           289263702
clock-delta              :                  83

/proc/24936/sched 
wait_start               :                   0
wait_start_fair          :                   0
exec_start               :                   0
sleep_start              :   53594765858891273
sleep_start_fair         :   53575748785282138
block_start              :                   0
sleep_max                :            21492554
block_max                :            27044576
exec_max                 :             4008057
wait_max                 :          1253670288
last_ran                 :                   0
wait_runtime             :            23955448
wait_runtime_overruns    :              270678
wait_runtime_underruns   :                   1
sum_exec_runtime         :         36978464446
clock-delta              :                  81

/proc/24944/sched 
wait_start               :                   0
wait_start_fair          :                   0
exec_start               :                   0
sleep_start              :   53594628265104224
sleep_start_fair         :   53575623092295018
block_start              :                   0
sleep_max                :        223179035512
block_max                :                   0
exec_max                 :             3960054
wait_max                 :          4334838886
last_ran                 :                   0
wait_runtime             :            23959470
wait_runtime_overruns    :                1243
wait_runtime_underruns   :                  15
sum_exec_runtime         :            17872418
clock-delta              :                  81

strace -f doesn't kill the latency, here's an strace:

24936 13:39:44.469329 rt_sigprocmask(SIG_BLOCK, [USR1], NULL, 8) = 0
24936 13:39:44.469572 select(4, [0 3], NULL, NULL, {0, 0}) = 0 (Timeout)
24936 13:39:44.469677 rt_sigprocmask(SIG_UNBLOCK, [USR1], NULL, 8) = 0
24936 13:39:44.469765 read(7, 0xbfe6c010, 8) = -1 EINTR (Interrupted system call)
24936 13:39:48.699490 --- SIGUSR1 (User defined signal 1) @ 0 (0) ---
24936 13:39:48.699655 sigreturn()       = ? (mask now [])
24936 13:39:48.699842 rt_sigprocmask(SIG_BLOCK, [USR1], NULL, 8) = 0
24936 13:39:48.699939 select(4, [0 3], NULL, NULL, {0, 0}) = 1 (in [0], left {0, 0})
24936 13:39:48.700063 write(7, "\1\0\0\0\0\0\0\0", 8) = 5675552
24936 13:39:48.700168 readv(0, [{"sdfsdfsdfsdfsdon\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 256}], 1) = 14
24936 13:39:48.700360 write(7, "\2\0\0\0\3\0\0\0", 8) = 0
24936 13:39:48.700451 select(4, [0 3], NULL, NULL, {0, 0}) = 0 (Timeout)
24936 13:39:48.700547 rt_sigprocmask(SIG_UNBLOCK, [USR1], NULL, 8) = 0
24936 13:39:48.700635 read(7, "P\216\304\2\0\0\0\0", 8) = 8
24936 13:39:48.700872 rt_sigprocmask(SIG_BLOCK, [USR1], NULL, 8) = 0
24936 13:39:48.700962 writev(1, [{"s", 1}], 1) = 1
24936 13:39:48.701200 select(4, [0 3], NULL, NULL, {0, 0}) = 0 (Timeout)
24936 13:39:48.701297 rt_sigprocmask(SIG_UNBLOCK, [USR1], NULL, 8) = 0
24936 13:39:48.701385 read(7, "P\216\304\2\0\0\0\0", 8) = 8
24936 13:39:48.701495 rt_sigprocmask(SIG_BLOCK, [USR1], NULL, 8) = 0
24936 13:39:48.701584 writev(1, [{"d", 1}], 1) = 1
24936 13:39:48.701773 select(4, [0 3], NULL, NULL, {0, 0}) = 0 (Timeout)
24936 13:39:48.701870 rt_sigprocmask(SIG_UNBLOCK, [USR1], NULL, 8) = 0
24936 13:39:48.701957 read(7, "P\216\304\2\0\0\0\0", 8) = 8
24936 13:39:48.702061 rt_sigprocmask(SIG_BLOCK, [USR1], NULL, 8) = 0
24936 13:39:48.702149 writev(1, [{"f", 1}], 1) = 1
24936 13:39:48.702336 select(4, [0 3], NULL, NULL, {0, 0}) = 0 (Timeout)
24936 13:39:48.702431 rt_sigprocmask(SIG_UNBLOCK, [USR1], NULL, 8) = 0
24936 13:39:48.702519 read(7, "P\216\304\2\0\0\0\0", 8) = 8
24936 13:39:48.702622 rt_sigprocmask(SIG_BLOCK, [USR1], NULL, 8) = 0
24936 13:39:48.702710 writev(1, [{"s", 1}], 1) = 1
24936 13:39:48.702898 select(4, [0 3], NULL, NULL, {0, 0}) = 0 (Timeout)
24936 13:39:48.702993 rt_sigprocmask(SIG_UNBLOCK, [USR1], NULL, 8) = 0
24936 13:39:48.703157 read(7, "P\216\304\2\0\0\0\0", 8) = 8
24936 13:39:48.703264 rt_sigprocmask(SIG_BLOCK, [USR1], NULL, 8) = 0
24936 13:39:48.703352 writev(1, [{"d", 1}], 1) = 1
24936 13:39:48.703541 select(4, [0 3], NULL, NULL, {0, 0}) = 0 (Timeout)
24936 13:39:48.703636 rt_sigprocmask(SIG_UNBLOCK, [USR1], NULL, 8) = 0
24936 13:39:48.703724 read(7, "P\216\304\2\0\0\0\0", 8) = 8
24936 13:39:48.703828 rt_sigprocmask(SIG_BLOCK, [USR1], NULL, 8) = 0
24936 13:39:48.703916 writev(1, [{"f", 1}], 1) = 1
24936 13:39:48.704103 select(4, [0 3], NULL, NULL, {0, 0}) = 0 (Timeout)
24936 13:39:48.704198 rt_sigprocmask(SIG_UNBLOCK, [USR1], NULL, 8) = 0
24936 13:39:48.704285 read(7, "P\216\304\2\0\0\0\0", 8) = 8
24936 13:39:48.704389 rt_sigprocmask(SIG_BLOCK, [USR1], NULL, 8) = 0
24936 13:39:48.704476 writev(1, [{"s", 1}], 1) = 1
24936 13:39:48.704662 select(4, [0 3], NULL, NULL, {0, 0}) = 0 (Timeout)
24936 13:39:48.704758 rt_sigprocmask(SIG_UNBLOCK, [USR1], NULL, 8) = 0
24936 13:39:48.704845 read(7, "P\216\304\2\0\0\0\0", 8) = 8
24936 13:39:48.704948 rt_sigprocmask(SIG_BLOCK, [USR1], NULL, 8) = 0
24936 13:39:48.705036 writev(1, [{"d", 1}], 1) = 1
24936 13:39:48.705222 select(4, [0 3], NULL, NULL, {0, 0}) = 0 (Timeout)
24936 13:39:48.705317 rt_sigprocmask(SIG_UNBLOCK, [USR1], NULL, 8) = 0
24936 13:39:48.705405 read(7, "P\216\304\2\0\0\0\0", 8) = 8
24936 13:39:48.705508 rt_sigprocmask(SIG_BLOCK, [USR1], NULL, 8) = 0
24936 13:39:48.705595 writev(1, [{"f", 1}], 1) = 1
24936 13:39:48.705781 select(4, [0 3], NULL, NULL, {0, 0}) = 0 (Timeout)
24936 13:39:48.705877 rt_sigprocmask(SIG_UNBLOCK, [USR1], NULL, 8) = 0
24936 13:39:48.705964 read(7, "P\216\304\2\0\0\0\0", 8) = 8
24936 13:39:48.706068 rt_sigprocmask(SIG_BLOCK, [USR1], NULL, 8) = 0
24936 13:39:48.706155 writev(1, [{"s", 1}], 1) = 1
24936 13:39:48.706341 select(4, [0 3], NULL, NULL, {0, 0}) = 0 (Timeout)
24936 13:39:48.706483 rt_sigprocmask(SIG_UNBLOCK, [USR1], NULL, 8) = 0
24936 13:39:48.706571 read(7, "P\216\304\2\0\0\0\0", 8) = 8
24936 13:39:48.706675 rt_sigprocmask(SIG_BLOCK, [USR1], NULL, 8) = 0
24936 13:39:48.706763 writev(1, [{"d", 1}], 1) = 1
24936 13:39:48.706950 select(4, [0 3], NULL, NULL, {0, 0}) = 0 (Timeout)
24936 13:39:48.707045 rt_sigprocmask(SIG_UNBLOCK, [USR1], NULL, 8) = 0
24936 13:39:48.707221 read(7, "P\216\304\2\0\0\0\0", 8) = 8
24936 13:39:48.707325 rt_sigprocmask(SIG_BLOCK, [USR1], NULL, 8) = 0
24936 13:39:48.707414 writev(1, [{"f", 1}], 1) = 1
24936 13:39:48.707600 select(4, [0 3], NULL, NULL, {0, 0}) = 0 (Timeout)
24936 13:39:48.707695 rt_sigprocmask(SIG_UNBLOCK, [USR1], NULL, 8) = 0
24936 13:39:48.707800 read(7, "P\216\304\2\0\0\0\0", 8) = 8
24936 13:39:48.707904 rt_sigprocmask(SIG_BLOCK, [USR1], NULL, 8) = 0
24936 13:39:48.707992 writev(1, [{"s", 1}], 1) = 1
24936 13:39:48.708177 select(4, [0 3], NULL, NULL, {0, 0}) = 0 (Timeout)
24936 13:39:48.708273 rt_sigprocmask(SIG_UNBLOCK, [USR1], NULL, 8) = 0
24936 13:39:48.708360 read(7, "P\216\304\2\0\0\0\0", 8) = 8
24936 13:39:48.708463 rt_sigprocmask(SIG_BLOCK, [USR1], NULL, 8) = 0
24936 13:39:48.708551 writev(1, [{"d", 1}], 1) = 1
24936 13:39:48.708736 select(4, [0 3], NULL, NULL, {0, 0}) = 0 (Timeout)
24936 13:39:48.708832 rt_sigprocmask(SIG_UNBLOCK, [USR1], NULL, 8) = 0
24936 13:39:48.708919 read(7, 0xbfe6c010, 8) = -1 EINTR (Interrupted system call)
24936 13:39:48.951555 --- SIGUSR1 (User defined signal 1) @ 0 (0) ---
24936 13:39:48.951697 sigreturn()       = ? (mask now [])
24936 13:39:48.951884 rt_sigprocmask(SIG_BLOCK, [USR1], NULL, 8) = 0
24936 13:39:48.951983 select(4, [0 3], NULL, NULL, {0, 0}) = 0 (Timeout)
24936 13:39:48.952092 rt_sigprocmask(SIG_UNBLOCK, [USR1], NULL, 8) = 0
24936 13:39:48.952184 read(7,  <unfinished ...>



-- 
Mathematics is the supreme nostalgia of our time.
