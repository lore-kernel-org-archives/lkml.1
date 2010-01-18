Return-Path: <linux-kernel-owner+w=401wt.eu-S1753814Ab0ARKnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814Ab0ARKnm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 05:43:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106Ab0ARKnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 05:43:41 -0500
Received: from smtp-out.google.com ([216.239.44.51]:7825 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab0ARKnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 05:43:40 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=N3dHW7ppzp8ZZdt5s/ZgdYYBYy4vGhKgGNemW7yk6e6IhB/mzpmAMN1viwPMV3cUh
	RbjJNNSd3RxZ2ar9Tjvzg==
Date: Mon, 18 Jan 2010 02:43:22 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Yinghai Lu <yinghai@kernel.org>
cc: Haicheng Li <haicheng.li@linux.intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/mm/srat_64.c: nodes_parsed should include all nodes
 detected by ACPI.
In-Reply-To: <86802c441001172230y137b4916h7d744a96ab75873d@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1001180231430.20677@chino.kir.corp.google.com>
References: <4B501C4D.4080907@linux.intel.com> <alpine.DEB.2.00.1001171338170.16238@chino.kir.corp.google.com> <86802c441001172230y137b4916h7d744a96ab75873d@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Jan 2010, Yinghai Lu wrote:

> > There're a couple of issues with this patch:
> >
> > - it breaks CONFIG_MEMORY_HOTPLUG_SPARSE kernels when the SRAT reports
> >  more than one entry for a single node id and the later entry does not
> >  specify an address range, and
> 
> not sure this one.
> 

The old code would preserve the address range from the preceding SRAT 
entry for that node to pass to e820_register_active_regions() when 
CONFIG_MEMORY_HOTPLUG_SPARSE is enabled, this patch incorrectly clears 
that data.

> > - carrying the bit for the node over in nodes_parsed is inappropriate
> >  since other x86 code depends on that map including only nodes with
> >  memory such as e820_register_active_regions() and nodes_cover_memory().
> 
> assume if e820 is right, even srat table have a range for hot plug
> aka the e820 have hole already. then e820_register_active_regions()
> and nodes_cover_memory
> should be ok even bootnode have some pre reserved range.
> 

cpu_nodes_parsed handles nodes without memory, there's no reason why a bit 
should be set in nodes_parsed if its corresponding node does not have a 
valid address range.  We have a reasonable expectation that nodes_parsed 
represents memory nodes given its use for e820_register_active_regions() 
and nodes_cover_memory() as well as acpi_get_nodes() for NUMA emulation, 
for example, which would be broken with this patch.  See dc0985519.
