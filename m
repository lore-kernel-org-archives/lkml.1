Return-Path: <linux-kernel-owner+w=401wt.eu-S1758980AbYGNXGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758980AbYGNXGZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 19:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758850AbYGNXGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 19:06:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42767 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758452AbYGNXGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 19:06:14 -0400
Date: Mon, 14 Jul 2008 16:05:40 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
cc: Vegard Nossum <vegard.nossum@gmail.com>, Paul Menage <menage@google.com>,
       Max Krasnyansky <maxk@qualcomm.com>, Paul Jackson <pj@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, miaox@cn.fujitsu.com,
       rostedt@goodmis.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: current linux-2.6.git: cpusets completely broken
In-Reply-To: <b647ffbd0807141538g2004f245m5f54ec962f475ba5@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0807141602250.3017@woody.linux-foundation.org>
References: <20080712031736.GA3040@damson.getinternet.no>  <alpine.LFD.1.10.0807112026390.2875@woody.linux-foundation.org>  <b647ffbd0807120304o7a500dc9oce761e51c9dce908@mail.gmail.com>  <alpine.LFD.1.10.0807121254490.2875@woody.linux-foundation.org> 
 <alpine.LFD.1.10.0807121411350.2875@woody.linux-foundation.org> <b647ffbd0807141538g2004f245m5f54ec962f475ba5@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Jul 2008, Dmitry Adamushko wrote:
> 
> cpu_clear(cpu, cpu_active_map); _alone_ does not guarantee that after
> its completion, no new tasks can appear on (be migrated to) 'cpu'.

But I think we should make it do that.

I do realize that we "queue" processes, but that's part of the whole 
complexity. More importantly, the people who do that kind of asynchronous 
queueing don't even really care - *if* they cared about the process 
_having_ to show up on the destination core, they'd be waiting 
synchronously and re-trying (which they do).

So by doing the test for cpu_active_map not at queuing time, but at the 
time when we actually try to do the migration, we can now also make that 
cpu_active_map be totally serialized.

(Of course, anybody who clears the bit does need to take the runqueue lock 
of that CPU too, but cpu_down() will have to do that as it does the 
"migrate away live tasks" anyway, so that's not a problem)

		Linus
