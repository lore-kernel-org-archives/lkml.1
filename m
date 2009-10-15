Return-Path: <linux-kernel-owner+w=401wt.eu-S1752817AbZJOOBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817AbZJOOBz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 10:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751067AbZJOOBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 10:01:55 -0400
Received: from relay3.sgi.com ([192.48.152.1]:45607 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750776AbZJOOBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 10:01:54 -0400
X-Greylist: delayed 564 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Oct 2009 10:01:54 EDT
Date: Thu, 15 Oct 2009 08:50:39 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2] x86/apic: limit irq affinity
Message-ID: <20091015135039.GA24455@sgi.com>
References: <20090930160259.GA7822@sgi.com> <20091012193433.GB2691@elte.hu> <20091012193704.GA8708@sgi.com> <20091014071014.GK784@elte.hu> <20091014120225.GA9674@sgi.com> <20091014122653.GA15048@elte.hu> <20091015011339.GA17374@sgi.com> <4AD6B364.2050801@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AD6B364.2050801@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 14, 2009 at 10:30:12PM -0700, Yinghai Lu wrote:
> Dimitri Sivanich wrote:
> > This patch allows for hard restrictions to irq affinity via a new cpumask and
> > device node value in the irq_cfg structure.
> > 
> > The mask forces IRQ affinity to remain within the specified cpu domain.
> > On some UV systems, this domain will be limited to the nodes accessible
> > to the given node.  Currently other X86 systems will have all bits in
> > the cpumask set, so non-UV systems will remain unaffected at this time.
> > 
> 
> can you check if we can reuse target_cpus for this purpose?
>
 
Yinghai,

The 'target_cpus' mask is in struct 'apic'.  It is a platform level mask
(only one mask per platform).

The 'allowed' mask that I am adding is a per irq level mask (one mask per irq).
Each irq might be coming from a device attached to a different node, and each
of those nodes might require its irqs to have a different mask.

For example, say there is a pci device attached to node 2.  Node 2 might only
want (or be able) to route its interrupts to nodes 0-127.  It would have
'allowed' mask allowing only processors existing on the first 128 nodes.  A
pci device attached to node 150 would have a different allowed mask, since it
would route its interrupts to a different set of nodes.

Use of something like 'target_cpus' would require recalculating this every
time someone changes affinity, instead of just 'and'ing in the mask.

Dimitri
