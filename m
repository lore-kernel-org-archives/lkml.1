Return-Path: <linux-kernel-owner+w=401wt.eu-S1754104AbXLDOHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104AbXLDOHk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 09:07:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752944AbXLDOHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 09:07:32 -0500
Received: from perninha.conectiva.com.br ([200.140.247.100]:44787 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbXLDOHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 09:07:31 -0500
Date: Tue, 4 Dec 2007 12:07:15 -0200
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       herton@mandriva.com.br, dvgevers@xs4all.nl
Subject: [local DoS] Re: Linux 2.6.24-rc4
Message-ID: <20071204120715.4ea204a8@mandriva.com.br>
In-Reply-To: <alpine.LFD.0.9999.0712032055080.2981@woody.linux-foundation.org>
References: <alpine.LFD.0.9999.0712032055080.2981@woody.linux-foundation.org>
Organization: Mandriva
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.2; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, 3 Dec 2007 21:08:12 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> escreveu:

| That said, none of the changes are really _exciting_ or really scary. And 
| we should have fixed a number of regressions, although more certainly 
| remain.

 A Mandriva user reported this bug last week. Run the following program
as a normal user.

"""
#include <stdio.h>
#include <sched.h>

int main(void)
{
	sched_rr_get_interval(1, NULL);
	return 0;
}
"""

 You should get the following OOPS and the machine will hang.

"""
divide error: 0000 [#1] SMP 
Modules linked in: af_packet snd_seq_dummy snd_seq_oss snd_seq_midi_event ipv6 snd_seq snd_pcm_oss snd_mie

Pid: 4202, comm: unhide Not tainted (2.6.24-desktop-0.rc3.2mdv #1)
EIP: 0060:[<c01276cb>] EFLAGS: 00010046 CPU: 0
EIP is at sched_slice+0x3b/0x60
EAX: 00000004 EBX: c4b40000 ECX: 00000004 EDX: 00000000
ESI: 00000000 EDI: 00000000 EBP: d7d2bf84 ESP: d7d2bf78
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process unhide (pid: 4202, ti=d7d2a000 task=d7d29580 task.ti=d7d2a000)
Stack: c140a0a0 df98a000 00000000 d7d2bfb0 c012cc1e d7d2bfb8 d7c019f4 00000064 
       0804a898 00000000 00000286 00000001 b7f3acc0 00000000 d7d2a000 c010830e 
       00000001 bffdc2b8 b7f0cff4 b7f3acc0 00000000 bffdc2c8 000000a1 0000007b 
Call Trace:
 [<c01094ca>] show_trace_log_lvl+0x1a/0x30
 [<c010958b>] show_stack_log_lvl+0xab/0xd0
 [<c010966d>] show_registers+0xbd/0x1c0
 [<c0109894>] die+0x124/0x250
 [<c0109a51>] do_trap+0x91/0xc0
 [<c0109f55>] do_divide_error+0x85/0x90
 [<c033bc6a>] error_code+0x72/0x78
 [<c012cc1e>] sys_sched_rr_get_interval+0x7e/0xf0
 [<c010830e>] sysenter_past_esp+0x6b/0xa1
 =======================
Code: d6 89 7c 24 08 8b 40 08 e8 b3 fe ff ff 8b 0e 8b 3b 89 d6 0f af f1 f7 e1 8d 1c 16 89 da 89 d1 31 d2  
EIP: [<c01276cb>] sched_slice+0x3b/0x60 SS:ESP 0068:d7d2bf78
"""

 That OOPS is from a -rc3-git1 Mandriva kernel, but the same thing
happens with you're latest tree.

 I've reported it to vendor-sec but looks like it's only
present in 2.6.24-rcs and Ingo's CFS backports.

 As Ingo's usually very responsive and he didn't answer me so
far I'm starting to think you can't reproduce this problem?

 Anyway, the problem seems to be in sched_slice() called by
sys_sched_rr_get_interval():

time_slice = NS_TO_JIFFIES(sched_slice(cfs_rq_of(se), se));

 sched_slice() will use 'cfs_rq->load.weight' as the base for a
division, which is zero for process 1.

 The following hack fixes the problem for me.

-----

Index: linux-2.6.23/kernel/sched_fair.c
===================================================================
--- linux-2.6.23.orig/kernel/sched_fair.c
+++ linux-2.6.23/kernel/sched_fair.c
@@ -266,7 +266,8 @@ static u64 sched_slice(struct cfs_rq *cf
 	u64 slice = __sched_period(cfs_rq->nr_running);
 
 	slice *= se->load.weight;
-	do_div(slice, cfs_rq->load.weight);
+	if (likely(cfs_rq->load.weight))
+		do_div(slice, cfs_rq->load.weight);
 
 	return slice;
 }


-- 
Luiz Fernando N. Capitulino
