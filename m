Return-Path: <linux-kernel-owner+w=401wt.eu-S1756916AbZCFXDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916AbZCFXDv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 18:03:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbZCFXDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 18:03:42 -0500
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:46060 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753202AbZCFXDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 18:03:41 -0500
Subject: Process accounting in interrupt diabled cases
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Ingo Molnar <mingo@elte.hu>
Cc: schwidefsky@de.ibm.com, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       virtualization@lists.linux-foundation.org
Content-Type: text/plain
Organization: VMware INC.
Date: Fri, 06 Mar 2009 15:03:35 -0800
Message-Id: <1236380615.4637.67.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am not sure, but I think this may be a process accounting bug.

If interrupts are disabled for a considerable amount of time ( say
multiple ticks), the process accounting code will still account a single
tick for such cases, on the next interrupt tick.
Shouldn't we have some way to fix that case like we do for NO_HZ
restart_sched_tick case, where we account for multiple idle ticks.
 
IOW, doesn't process accounting need to account for these cases when
interrupts are disabled for more than one tick period?

I stumbled across this while trying to find a solution to figure out the
amount of stolen time from Linux, when it is running under a hypervisor.
One of the solutions could be to ask the hypervisor directly for this
info, but in my quest to find a generic solution I think the below would
work too.
The total process time accounted by the system on a cpu ( system, idle,
wait and etc) when deducted from the amount TSC counter has advanced
since boot, should give us this info about the cputime stolen from the
kernel  (by either hypervisor or other cases like say, SMI) on a
particular CPU. 
i.e. PCPU_STOLEN = (TSC since boot)  - (PCPU-idle + system + wait + ...)

But for this to work the above problem about process accounting in
interrupt disabled cases need to work correctly. 

Let me know if I overlooking any case where the above assumption might
not hold true.

Thanks,
Alok



