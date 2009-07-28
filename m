Return-Path: <linux-kernel-owner+w=401wt.eu-S1753816AbZG1TrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816AbZG1TrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 15:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751451AbZG1TrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 15:47:19 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:38956 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbZG1TrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 15:47:19 -0400
Date: Tue, 28 Jul 2009 15:47:13 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
       yakui_zhao <yakui.zhao@intel.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: Dynamic configure max_cstate
In-reply-to: <1248672613.2560.604.camel@ymzhang>
Message-id: <alpine.LFD.2.00.0907281532120.16740@localhost.localdomain>
References: <1248672613.2560.604.camel@ymzhang>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> When running a fio workload, I found sometimes cpu C state has
> big impact on the result. Mostly, fio is a disk I/O workload
> which doesn't spend much time with cpu, so cpu switch to C2/C3
> freqently and the latency is big.
> 
> If I start kernel with idle=poll or processor.max_cstate=1,
> the result is quite good. Consider a scenario that machine is
> busy at daytime and free at night. Could we add a dynamic
> configuration interface for processor.max_cstate or something
> similiar with sysfs? So user applications could change the
> max_cstate dynamically? For example, we could add a new
> parameter to function cpuidle_governor->select to mark the
> highest c state.

max_cstate is a debug param.  It isn't a run-time API and never will be.
User-space shouldn't need to know or care about C-states,
and if it appears it needs to, then we have a bug we need to fix.

The interface in Documentation/power/pm_qos_interface.txt
is supposed to handle this.  Though if the underlying code
is not noticing IO interrupts, then it can't help.

Another thing to look at is processor.latency_factor
which you can change at run-time in
/sys/module/processor/parameters/latency_factor

We multiply the advertised exit latency by this
before deciding to enter a C-state.  The concept
is that ACPI reports a performance number, but what
we really want is a power break-even.  Anyway,
we know the default mulitple is too low, and will be
raising it shortly.

Of course if the current code is not predicting any
IO interrupts on your IO-only workload, this, like
pm_qos, will not help.

cheers,
-Len Brown, Intel Open Source Technology Center
