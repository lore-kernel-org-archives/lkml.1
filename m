Return-Path: <linux-kernel-owner+w=401wt.eu-S933125AbXGVMxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933125AbXGVMxK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 08:53:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761593AbXGVMwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 08:52:34 -0400
Received: from ns2.suse.de ([195.135.220.15]:41358 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932694AbXGVMwc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 08:52:32 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: [PATCH 3/3] x86_64: offset apicid_to_node before use it before init_cpu_to_node
Date: Sun, 22 Jul 2007 14:52:26 +0200
User-Agent: KMail/1.9.6
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       joachim.deguara@amd.com
References: <86802c440707211749x3258891fhbb72a155dc484e86@mail.gmail.com>
In-Reply-To: <86802c440707211749x3258891fhbb72a155dc484e86@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707221452.27002.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 22 July 2007 02:49:41 Yinghai Lu wrote:
> [PATCH 3/3] x86_64: offset apicid_to_node before use it before init_cpu_to_node
> 
> When acpi=off or there is no SRAT defined, apicid_to_node is got from K8
> Northbridge PCI configuration space in k8_scan_nodes() in
> arch/x86_64/mm/k8toplogy.c.
> The problem is that it assumes bsp apic id is 0 at that point.
> For four socket system with Quad core cpus installed, all cpus apic id
> is offset by 4, and bsp apic id is 4.
> For eight socket system with dual core cpus installed, all cpus apic id
> is offset by 2, and bsp apic id is 2.
> We need offset apicid_to_node array according to boot_cpu_id.--- bsp apic id.
> before we use apicid_to_node array.
> boot_cpu_id is only valid init_apic_mappings.

<rant>
This thing is getting more and more messy. If it gets any more complicated
I promise I'll rip out the non ACPI support for quad core NUMA completely
and let it require ACPI.  Even the people who have a religious problem
with ACPI will need to eventually get over it and LinuxBIOS just has
to create proper tables, not pile hacks over hacks. It probably was a mistake in 
the first place to add it.
</rant>

I don't think you can mess with apicid_to_node[] unconditionally here. 
e.g. for the ACPI case or for the Intel NUMA case you'll just break everything.

What you should do is split init_apic_mappings() up and do a early
call that just checks if the CPU has an APIC and maps it using the 
fixmap and reads boot_cpu_id.  Then you can use that information
in k8topology.c to create correct tables.

-Andi
