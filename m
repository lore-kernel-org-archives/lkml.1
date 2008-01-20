Return-Path: <linux-kernel-owner+w=401wt.eu-S1758259AbYATBOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758259AbYATBOj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 20:14:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754273AbYATBOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 20:14:30 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37511 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754057AbYATBO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 20:14:29 -0500
Message-ID: <4792A073.60602@sgi.com>
Date: Sat, 19 Jan 2008 17:14:27 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] x86: Add config variables for SMP_MAX
References: <20080118183011.354965000@sgi.com> <20080118183011.917801000@sgi.com> <20080119145243.GA27974@elte.hu> <20080119151522.GA7774@elte.hu> <20080119152357.GA11706@elte.hu>
In-Reply-To: <20080119152357.GA11706@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
>> and then it crashes with:
>>
>>  [    0.000000] Bootmem setup node 0 0000000000000000-000000003fff0000
>>  [    0.000000] KERN_NOTICE cpu_to_node(0): usage too early!
>>  PANIC: early exception 06 rip 10:ffffffff81f77f30 error 0 cr2 f06f53
>>  [    0.000000] Pid: 0, comm: swapper Not tainted 2.6.24-rc8 #422
>>  [    0.000000]
>>  [    0.000000] Call Trace:
>>  [    0.000000]  [<ffffffff81f76b4a>] ? setup_node_bootmem+0x1a0/0x1b8
>>  [    0.000000]  [<ffffffff81f77f30>] ? acpi_scan_nodes+0x204/0x255
>>  [    0.000000]  [<ffffffff81f77f30>] ? acpi_scan_nodes+0x204/0x255
>>  [    0.000000]  [<ffffffff81f77103>] ? numa_initmem_init+0x343/0x471
>>

I *think* but have not been able to verify that this will fix the above panic:


--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -393,7 +393,7 @@ int __init acpi_scan_nodes(unsigned long
                        setup_node_bootmem(i, nodes[i].start, nodes[i].end);

        for (i = 0; i < NR_CPUS; i++) {
-               int node = cpu_to_node(i);
+               int node = early_cpu_to_node(i);
                if (node == NUMA_NO_NODE)
                        continue;
                if (!node_isset(node, node_possible_map))

The problem is that the x86 test tree kernel doesn't boot, even without my
changes.  And the stack trace I don't think is correct.

Thanks,
Mike
