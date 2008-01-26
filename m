Return-Path: <linux-kernel-owner+w=401wt.eu-S1753940AbYAZHNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbYAZHNy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 02:13:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751338AbYAZHNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 02:13:48 -0500
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:56190 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbYAZHNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 02:13:46 -0500
Date: Sat, 26 Jan 2008 12:43:39 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: linuxppc-dev@ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] Fake NUMA emulation for PowerPC (Take 2)
Message-ID: <20080126071339.GA25328@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: Michael Ellerman <michael@ellerman.id.au>,
	linuxppc-dev@ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
	Paul Mackerras <paulus@samba.org>
References: <20071207223714.11448.91386.sendpatchset@balbir-laptop> <1200634493.7806.0.camel@concordia.ozlabs.ibm.com> <1200635099.7806.3.camel@concordia.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1200635099.7806.3.camel@concordia.ozlabs.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Michael Ellerman <michael@ellerman.id.au> [2008-01-18 16:44:58]:

> 
> This fixes it, although I'm a little worried about some of the
> removals/movings of node_set_online() in the patch.
> 
> 
> diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
> index 1666e7d..dcedc26 100644
> --- a/arch/powerpc/mm/numa.c
> +++ b/arch/powerpc/mm/numa.c
> @@ -49,7 +49,6 @@ static int __cpuinit fake_numa_create_new_node(unsigned long end_pfn,
>  	static unsigned int fake_nid = 0;
>  	static unsigned long long curr_boundary = 0;
>  
> -	*nid = fake_nid;
>  	if (!p)
>  		return 0;
>  
> @@ -60,6 +59,7 @@ static int __cpuinit fake_numa_create_new_node(unsigned long end_pfn,
>  	if (mem < curr_boundary)
>  		return 0;
>  
> +	*nid = fake_nid;
>  	curr_boundary = mem;
>  
>  	if ((end_pfn << PAGE_SHIFT) > mem) {
> 

Hi, Michael,

Here's a better and more complete fix for the problem. Could you
please see if it works for you? I tested it on a real NUMA box and it
seemed to work fine there.

Description
-----------

This patch provides a fix for the problem found by
Michael Ellerman <michael@ellerman.id.au> while using fake NUMA nodes
on a cell box. The code modifies node id iff (as in if and only if)
fake NUMA nodes are created.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 arch/powerpc/mm/numa.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN arch/powerpc/mm/numa.c~fix-fake-numa-nid-on-numa arch/powerpc/mm/numa.c
--- linux-2.6.24-rc8/arch/powerpc/mm/numa.c~fix-fake-numa-nid-on-numa	2008-01-26 12:20:29.000000000 +0530
+++ linux-2.6.24-rc8-balbir/arch/powerpc/mm/numa.c	2008-01-26 12:27:53.000000000 +0530
@@ -49,7 +49,12 @@ static int __cpuinit fake_numa_create_ne
 	static unsigned int fake_nid = 0;
 	static unsigned long long curr_boundary = 0;
 
-	*nid = fake_nid;
+	/*
+	 * If we did enable fake nodes and cross a node,
+	 * remember the last node and start from there.
+	 */
+	if (fake_nid)
+		*nid = fake_nid;
 	if (!p)
 		return 0;
 
_

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
