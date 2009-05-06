Return-Path: <linux-kernel-owner+w=401wt.eu-S1754314AbZEFFTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314AbZEFFTn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 01:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750901AbZEFFTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 01:19:33 -0400
Received: from mga07.intel.com ([143.182.124.22]:33700 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750702AbZEFFTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 01:19:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,301,1239001200"; 
   d="scan'208";a="139644977"
Subject: Re: [PATCH] Fix early panic issue on machines with memless node
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Jack Steiner <steiner@sgi.com>
Cc: David Rientjes <rientjes@google.com>, alex.shi@intel.com,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>
In-Reply-To: <20090505202730.GA9831@sgi.com>
References: <1241493327.27664.17.camel@ymzhang>
	 <alpine.DEB.2.00.0905042026010.29856@chino.kir.corp.google.com>
	 <20090505163608.GA20385@sgi.com>
	 <alpine.DEB.2.00.0905051250510.20021@chino.kir.corp.google.com>
	 <20090505202730.GA9831@sgi.com>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 06 May 2009 13:19:52 +0800
Message-Id: <1241587192.27664.56.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-05 at 15:27 -0500, Jack Steiner wrote:
> On Tue, May 05, 2009 at 12:52:54PM -0700, David Rientjes wrote:
> > On Tue, 5 May 2009, Jack Steiner wrote:
> > 
> > > I was able to duplicate your original problem. Your patch below solves the
> > > problem. AFAICT, it causes no new reqgressions to the various configurations
> > > that I'm testing. (I'll add the "mem=2G" to my configs that I test).
> > > 
> > 
> > Great, it would be helpful to catch these problems before 2.6.30 is 
> > released.  I've passed my patch along to Ingo.
> > 
> > > However, I see a new regression that was not present a couple of weeks ago.
> > > Configurations that have nodes with cpus and no memory panic during
> > > boot. This occurs both with and without your patch and is not related to "mem=".
> > > 
> > > I need to isolate the problem but here is the stack trace. :
> > > 	Pid: 0, comm: swapper Not tainted 2.6.30-rc4-next-20090505-medusa #12
> > > 	Call Trace:
> > > 	 [<ffffffff806b919e>] early_idt_handler+0x5e/0x71
> > > 	 [<ffffffff802920fe>] ? build_zonelists_node+0x4c/0x8d
> > > 	 [<ffffffff8029333f>] __build_all_zonelists+0x1ae/0x55a
> > > 	 [<ffffffff80293932>] build_all_zonelists+0x1b5/0x263
> > > 	 [<ffffffff806b9b6e>] start_kernel+0x17a/0x3c5
> > > 	 [<ffffffff806b9140>] ? early_idt_handler+0x0/0x71
> > > 	 [<ffffffff806b92a7>] x86_64_start_reservations+0xae/0xb2
> > > 	 [<ffffffff806b93fd>] x86_64_start_kernel+0x152/0x161
> > > 
> > 
> > Please post your .config since it apparently differs from x86_64 defconfig 
> > judging by my debugging symbols and also the full output of the panic.
> 
> I suspect I mislead you when I mentioned "configurations". I did not mean
> the .config file. I use a more-or-less standard .config file.
> 
> I do much of my testing on a system simulator. Using a simulator config file,
> I specify the system configuration such as number of nodes, sockets per node,
> cpus per socket, memory per socket, address map, boot options, etc. This
> makes it easy to quickly test a lot of strange (but real) configurations.
> 
> The configuration above that is failing is a 2-socket Nehelem blade that has no
> memory on socket 0. All memory is located on socket 1.  The panic is caused by a
> null dereference of NODE_DATA(0).
> 
> Still looking....
It seems in function setup_node_bootmem:

        if (!end)
                return;

stops the initialization of node_data[nodeid]. Later on panic when build_zonelists
dereference ﻿NODE_DATA(0).

Although a node is memoryless, but mostly it has small blocks of memory, so function
acpi_scan_nodes marks them offline. However, if getting node info in
acpi_numa_processor_affinity_init. the node might have no any memory, and ﻿acpi_scan_nodes
doesn't mark it offline.

The logic is confusing with patch dc09855191809. Could you revert it to retest?


