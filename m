Return-Path: <linux-kernel-owner+w=401wt.eu-S1759117AbYCCQ1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759117AbYCCQ1Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 11:27:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755479AbYCCQ1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 11:27:17 -0500
Received: from gir.skynet.ie ([193.1.99.77]:59401 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045AbYCCQ1Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 11:27:16 -0500
Date: Mon, 3 Mar 2008 16:27:11 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>
Subject: Re: 2.6.24 git2/mm1: cpu_to_node mapping to non-existant nodes causing boot failure
Message-ID: <20080303162711.GD5861@csn.ul.ie>
References: <47B33ACF.5030700@sgi.com> <20080214201727.GC30841@csn.ul.ie> <47B4A774.7050509@sgi.com> <20080215020208.GA6500@csn.ul.ie> <47B77E90.5050809@sgi.com> <47BAFFD3.1070606@sgi.com> <20080219192319.GE12386@csn.ul.ie> <86802c440802262229t37c61c98y45607ba34d7c6417@mail.gmail.com> <20080228154244.GA4038@csn.ul.ie> <86802c440802280945w4dd71038y95936656cd535c9c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <86802c440802280945w4dd71038y95936656cd535c9c@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (28/02/08 09:45), Yinghai Lu didst pronounce:
> On Thu, Feb 28, 2008 at 7:42 AM, Mel Gorman <mel@csn.ul.ie> wrote:
> > On (26/02/08 22:29), Yinghai Lu didst pronounce:
> >
> > > >  >
> >  > >  > Did you get a chance to try out this patch to see if it cleared up the problem
> >  > >  > booting on your x86_64 numa box?
> >  >
> >  > did it fail with x86.git#testing?
> >  >
> >
> >  No, it boots successfully with that git branch. Somewhere in there is a fix.
> >
> 
> can you verify which one fix that ?
> 
> http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-x86.git;a=commitdiff;h=a8de04ce4e4cf0af94aeb3829be8c9f813b2f5de

This one was the fix.

commit a8de04ce4e4cf0af94aeb3829be8c9f813b2f5de
Author: Yinghai Lu <Yinghai.Lu@Sun.COM>
Date:   Tue Feb 19 15:35:54 2008 -0800

    x86_64: not set node to cpu_to_node if the node is not online
    
    numa_init_array will set round-bin to all cpu to online nodes.
    init_cpu_to_node will use cpu->apic (from MADT or mptable) and
    apic->node(from SRAT or AMD config space with k8_bus_64.c) to have cpu->node mapping.
    and later identify_cpu will overwrite them again...(with nearby_node...)
    
    this patch will check if the node is online, otherwise will not update cpu_node map.
    so keep cpu_node map to online node before identify_cpu..., to prevent possible  error.
    
    Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index f744c46..0c9b2bd 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -620,13 +620,17 @@ void __init init_cpu_to_node(void)
 	int i;
 
 	for (i = 0; i < NR_CPUS; i++) {
+		int node;
 		u16 apicid = x86_cpu_to_apicid_init[i];
 
 		if (apicid == BAD_APICID)
 			continue;
-		if (apicid_to_node[apicid] == NUMA_NO_NODE)
+		node = apicid_to_node[apicid];
+		if (node == NUMA_NO_NODE)
 			continue;
-		numa_set_node(i, apicid_to_node[apicid]);
+		if (!node_online(node))
+			continue;
+		numa_set_node(i, node);
 	}
 }
 
-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
