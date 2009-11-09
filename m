Return-Path: <linux-kernel-owner+w=401wt.eu-S1756295AbZKIP60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295AbZKIP60 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 10:58:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756065AbZKIP6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 10:58:25 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45260 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756078AbZKIP6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 10:58:25 -0500
Date: Mon, 9 Nov 2009 07:57:35 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Thomas Gleixner <tglx@linutronix.de>
cc: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: Help needed: Resume problems in 2.6.32-rc, perhaps related to
 preempt_count leakage in keventd
In-Reply-To: <alpine.LFD.2.00.0911091452300.2725@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0911090733150.31845@localhost.localdomain>
References: <200911091250.31626.rjw@sisk.pl> <20091109120217.GB18399@elte.hu> <200911091324.37955.rjw@sisk.pl> <20091109124937.GA21114@elte.hu> <alpine.LFD.2.00.0911091452300.2725@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 9 Nov 2009, Thomas Gleixner wrote:
> 
> I think it _IS_ releated because the worker_thread is CPU affine and
> the debug_smp_processor_id() check does:

Hmm. We do know CPU affinity is destroyed by CPU hotplug. People have 
complained about that before (for user-space processes that get moved 
around due to hot-unplug/plug).

And the suspend/resume process does CPU hotplug to take down all but one 
CPU. The workqueues should act on those events already, but maybe there's 
a bug somewhere. None of that is new to 32-rc, though - is it?

And workqueue_cpu_callback() seems buggy. It loops over the 'workqueues' 
list with no protection. Yes, we do 'stop_machine' for CPU hotplug events, 
but only for the very internal one (CPU_DYING) will the CPU notifiers be 
called with the machine stopped).

Hmm. I don't see any changes in kernel/cpu.c or kernel/workqueue.c that 
look at all relevant. But scheduler changes could certainly matter.

			Linus
