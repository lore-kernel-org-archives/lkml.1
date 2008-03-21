Return-Path: <linux-kernel-owner+w=401wt.eu-S1755231AbYCUJmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231AbYCUJmA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 05:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752885AbYCUJlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 05:41:52 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:13034 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880AbYCUJlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 05:41:51 -0400
Message-ID: <47E382DB.70503@colorfullife.com>
Date: Fri, 21 Mar 2008 10:41:47 +0100
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Nadia Derbey <Nadia.Derbey@bull.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Scalability requirements for sysv ipc (was: ipc: store ipcs into
 IDRs)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I noticed that sysv ipc now uses very special locking: first a global 
rw-semaphore, then within that semaphore rcu:
 > linux-2.6.25-rc3:/ipc/util.c:
> struct kern_ipc_perm *ipc_lock(struct ipc_ids *ids, int id)
> {
>         struct kern_ipc_perm *out;
>         int lid = ipcid_to_idx(id);
>
>         down_read(&ids->rw_mutex);
>
>         rcu_read_lock();
>         out = idr_find(&ids->ipcs_idr, lid);
ids->rw_mutex is a per-namespace (i.e.: usually global) semaphore. Thus 
ipc_lock writes into a global cacheline. Everything else is based on 
per-object locking, especially sysv sem doesn't contain a single global 
lock/statistic counter/...
That can't be the Right Thing (tm): Either there are cases where we need 
the scalability (then using IDRs is impossible), or the scalability is 
never needed (then the remaining parts from RCU should be removed).
I don't have a suitable test setup, has anyone performed benchmarks 
recently?
Is sysv semaphore still important, or have all apps moved to posix 
semaphores/futexes?
Nadia: Do you have access to a suitable benchmark?

A microbenchmark on a single-cpu system doesn't help much (except that 
2.6.25 is around factor 2 slower for sysv msg ping-pong between two 
tasks compared to the numbers I remember from older kernels....)

--
    Manfred
