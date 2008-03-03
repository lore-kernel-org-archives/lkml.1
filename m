Return-Path: <linux-kernel-owner+w=401wt.eu-S1761805AbYCCSL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761805AbYCCSL7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 13:11:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759451AbYCCSKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 13:10:38 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40638 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758935AbYCCSKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 13:10:36 -0500
Date: Mon, 3 Mar 2008 12:10:33 -0600
From: Paul Jackson <pj@sgi.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: maxk@qualcomm.com, mingo@elte.hu, tglx@linutronix.de, oleg@tv-sign.ru,
       rostedt@goodmis.org, linux-kernel@vger.kernel.org, rientjes@google.com
Subject: Re: [RFC/PATCH] cpuset: cpuset irq affinities
Message-Id: <20080303121033.c8c9651c.pj@sgi.com>
In-Reply-To: <1204567052.6241.4.camel@lappy>
References: <20080227222103.673194000@chello.nl>
	<1204311351.6243.130.camel@lappy>
	<20080229190223.GA17820@elte.hu>
	<47C87084.3090208@qualcomm.com>
	<1204318980.6243.133.camel@lappy>
	<47C8771C.1070001@qualcomm.com>
	<1204545445.11412.6.camel@twins>
	<20080303113621.1dfdda87.pj@sgi.com>
	<1204567052.6241.4.camel@lappy>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But as long as nobody does CS_CPU_EXCLUSIVE they may overlap, right?

It's a bit stronger than that:

 1) They need non-overlapping cpusets at this level to control
    the sched_domain setup, if they want to avoid load balancing
    across almost all CPUs in the system.  Depending on the kernel
    version, sched_domain partitioning is controlled either by the
    cpuset flag cpu_exclusive, or the cpuset flag sched_load_balance.

 2) They need non-overlapping cpusets at this level to control
    memory placement of some kernel allocations, which are allowed
    outside the current tasks cpuset, to be confined by the nearest
    ancestor cpuset marked 'mem_exclusive'

 3) Some sysadmin tools are likely coded to expect a /dev/cpuset/boot
    cpuset, not a /dev/cpuset/system/boot cpuset, as that has been
    customary for a long time.

(1) and (2) would break the major batch schedulers.  They typically
mark their top cpuset, /dev/cpuset/pbs or /dev/cpuset/lfs or whatever
batch scheduler it is, as cpu_exclusive and mem_exclusive, by way of
expressing their intention to pretty much own those CPUs and memory
nodes.  If we fired them up on a system where that wasn't allowed due
to overlap with /dev/cpuset/system, they'd croak.  Such changes as that
are costly and unappreciated.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
