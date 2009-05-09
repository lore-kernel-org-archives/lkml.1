Return-Path: <linux-kernel-owner+w=401wt.eu-S1756183AbZEIQwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183AbZEIQwy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 12:52:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754883AbZEIQtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 12:49:24 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:54469 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755085AbZEIQtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 12:49:22 -0400
Message-Id: <20090509162209.217414024@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sat, 09 May 2009 12:22:09 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, "Frank Ch. Eigler" <fche@redhat.com>,
       Jason Baron <jbaron@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       fweisbec@gmail.com, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       peterz@infradead.org, jiayingz@google.com, roland@redhat.com,
       mbligh@google.com
Subject: [RFC patch 00/20] Kernel tracing thread flag
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Sat,  9 May 2009 16:47:17 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the generalisation of the TIF_SYSCALL_FTRACE thread flag for :

- multiple tracers (even accessible from modules)
- multiple architectures

It includes :

- Addition of the TIF_KERNEL_TRACE for all Linux architectures.
- Modification of some architecture entry*.S files to ensure that the thread
  flag is re-read upon syscall exit to ensure that syscall exit is traced.
  Basically, what I try to achieve here is to make sure that given the following
  sequence will get its syscall exit event traced :

- Thread preempted in a system call
- Activation of all TIF_KERNEL_TRACE thread flags
- ...enough time passes to expect that all tracing sites are activated...
- syscall exit -> expected to be traced

But if the thread flags used at syscall exit are the same that has been read at
syscall entry, the event will be skipped. This does not permit reaching a known
"quiescent state" where we know that all tracing sites are activated.

Note that having non-perfectly matched syscall trace entry/exit may have
implications wrt getname/putname refcounting for instance, and could cause
problems if getname/putname was used in the syscall entry/exit pairs. We will
have to deal with this somehow when we face this problem. Keeping a per-thread
flag saying that a matching syscall_entry tracing has been executed could fix
this problem. We could even re-use TIF_SYSCALL_FTRACE for this specific purpose.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
