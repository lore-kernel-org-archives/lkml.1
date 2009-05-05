Return-Path: <linux-kernel-owner+w=401wt.eu-S1755969AbZEETu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969AbZEETu0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 15:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754007AbZEETuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 15:50:12 -0400
Received: from smtp-out.google.com ([216.239.33.17]:16907 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916AbZEETuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 15:50:11 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=SBoCTQks1mHGwDlrNy32oz5WT4qKqQgfismYxPKr0Bs1bc0IvhKaBbexaBz7icDVP
	T9aWTPQ7qGnN5V0xC+L9g==
Date: Tue, 5 May 2009 12:50:02 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@elte.hu>
cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>, alex.shi@intel.com,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Jack Steiner <steiner@sgi.com>
Subject: [patch] srat: do not register nodes beyond e820 map
In-Reply-To: <20090505163608.GA20385@sgi.com>
Message-ID: <alpine.DEB.2.00.0905051248150.20021@chino.kir.corp.google.com>
References: <1241493327.27664.17.camel@ymzhang> <alpine.DEB.2.00.0905042026010.29856@chino.kir.corp.google.com> <20090505163608.GA20385@sgi.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mem= option will truncate the memory map at a specified address so 
it's not possible to register nodes with memory beyond the e820 upper 
bound.

unparse_node() is only called when then node had memory associated with 
it, although with the mem= option it is no longer addressable.

Reported-by: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 Ingo, this fixes the problem reported by "Zhang, Yanmin" and is needed
 for 2.6.30-rc5.

 arch/x86/mm/srat_64.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -361,6 +361,7 @@ static void __init unparse_node(int node)
 {
 	int i;
 	node_clear(node, nodes_parsed);
+	node_clear(node, cpu_nodes_parsed);
 	for (i = 0; i < MAX_LOCAL_APIC; i++) {
 		if (apicid_to_node[i] == node)
 			apicid_to_node[i] = NUMA_NO_NODE;
