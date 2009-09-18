Return-Path: <linux-kernel-owner+w=401wt.eu-S1756347AbZIRJxC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347AbZIRJxC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 05:53:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754276AbZIRJxB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 05:53:01 -0400
Received: from smtp-out.google.com ([216.239.33.17]:56719 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbZIRJxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 05:53:00 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=MbSxWM6n9c9EjJJCpxQTjKVYDOHglBlVyJEm7r7R4M+g9ZDO12HeEypLIbT4rOE7L
	/537MnnBN11f/qpwi/vGg==
Date: Fri, 18 Sep 2009 02:52:55 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Suresh Jayaram <sureshjayaram@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Yinghai Lu <yinghai@kernel.org>,
       Jesse Brandeburg <jesse.brandeburg@gmail.com>
Subject: Re: mmotm 2009-09-09-22-56 uploaded
In-Reply-To: <38c3c4860909180238x7c9f305dsbce1492e2018c5a5@mail.gmail.com>
Message-ID: <alpine.DEB.1.00.0909180245030.24690@chino.kir.corp.google.com>
References: <200909100601.n8A61Eju002109@imap1.linux-foundation.org> <38c3c4860909132302j3fd7afe1p984b91d74eb1d782@mail.gmail.com> <alpine.DEB.1.00.0909142147220.30373@chino.kir.corp.google.com> <38c3c4860909150320qc4a203eu7552294ef0aafd2c@mail.gmail.com>
 <alpine.DEB.1.00.0909151535150.17284@chino.kir.corp.google.com> <38c3c4860909180238x7c9f305dsbce1492e2018c5a5@mail.gmail.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Sep 2009, Suresh Jayaram wrote:

> I enabled the CONFIG_DEBUG_PER_CPU_MAPS and rebuilt the kernel, but
> now I don't see the oops anymore.

CONFIG_DEBUG_PER_CPU_MAPS will debug it and also silently mask the error 
by returning cpu_online_mask instead of a NULL pointer to a non-existant 
node_to_cpumask_map.

> But what I see in dmesg output is:
> 
> Sep 16 09:22:57 jay-t60p kernel: cpumask_of_node(-1): no node_to_cpumask_map!
> 
> followed by a call trace for irqbalance (attached).
> 

Sep 16 09:22:57 jay-t60p kernel: cpumask_of_node(-1): no node_to_cpumask_map!
Sep 16 09:22:57 jay-t60p kernel: Pid: 2400, comm: irqbalance Not tainted 2.6.31-rc9-mm1-0.1-default #8
Sep 16 09:22:57 jay-t60p kernel: Call Trace:
Sep 16 09:22:57 jay-t60p kernel:  [<ffffffff8102fcf3>] cpumask_of_node+0x4f/0x58
Sep 16 09:22:57 jay-t60p kernel:  [<ffffffff811890f3>] local_cpus_show+0x1f/0x48
Sep 16 09:22:57 jay-t60p kernel:  [<ffffffff811fe7ba>] dev_attr_show+0x20/0x44
Sep 16 09:22:57 jay-t60p kernel:  [<ffffffff81123a19>] sysfs_read_file+0xb2/0x131
Sep 16 09:22:57 jay-t60p kernel:  [<ffffffff810cfe34>] vfs_read+0xb1/0x187
Sep 16 09:22:58 jay-t60p kernel:  [<ffffffff810cffce>] sys_read+0x47/0x70
Sep 16 09:22:58 jay-t60p kernel:  [<ffffffff8100b9eb>] system_call_fastpath+0x16/0x1b

This seems to be related to 2547089 "x86/PCI: initialize PCI bus node 
numbers early" since cpumask_of_pcibus() on x86 doesn't check for -1 
pcibus_to_node() like most other architectures.  It'll simply index into 
cpumask_of_node for whatever the pci_sysdata's node is, and in this case 
that's -1.

I'm assuming mp_bus_to_node is pointing to a non-online node or simply the 
busnum is greater than 256.

 [ arch/x86/pci/common.c should _really_ be using NUMA_NO_NODE instead of
   hardcoding -1 everywhere, btw. ]
