Return-Path: <linux-kernel-owner+w=401wt.eu-S1756189AbZIRKlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189AbZIRKlQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 06:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbZIRKlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 06:41:16 -0400
Received: from smtp-out.google.com ([216.239.45.13]:21597 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbZIRKlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 06:41:15 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=nxHxwAElyNv3GahSc0u9j8qtz4JyAOqsNygGfq3nIfatGYJl9fTMsVcOGeSzzmOp8
	R1Wjo/3GJrd9izjDLT7OQ==
Date: Fri, 18 Sep 2009 03:41:10 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Suresh Jayaram <sureshjayaram@gmail.com>, Ingo Molnar <mingo@elte.hu>
cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Yinghai Lu <yinghai@kernel.org>,
       Jesse Brandeburg <jesse.brandeburg@gmail.com>
Subject: Re: mmotm 2009-09-09-22-56 uploaded
In-Reply-To: <alpine.DEB.1.00.0909180245030.24690@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.00.0909180339200.6267@chino.kir.corp.google.com>
References: <200909100601.n8A61Eju002109@imap1.linux-foundation.org> <38c3c4860909132302j3fd7afe1p984b91d74eb1d782@mail.gmail.com> <alpine.DEB.1.00.0909142147220.30373@chino.kir.corp.google.com> <38c3c4860909150320qc4a203eu7552294ef0aafd2c@mail.gmail.com>
 <alpine.DEB.1.00.0909151535150.17284@chino.kir.corp.google.com> <38c3c4860909180238x7c9f305dsbce1492e2018c5a5@mail.gmail.com> <alpine.DEB.1.00.0909180245030.24690@chino.kir.corp.google.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Sep 2009, David Rientjes wrote:

> This seems to be related to 2547089 "x86/PCI: initialize PCI bus node 
> numbers early" since cpumask_of_pcibus() on x86 doesn't check for -1 
> pcibus_to_node() like most other architectures.  It'll simply index into 
> cpumask_of_node for whatever the pci_sysdata's node is, and in this case 
> that's -1.
> 

Suresh, could you give this patch a try?  It turns out that the 
mp_bus_to_node map simply leaves all busses that don't have memory 
affinity to -1, so cpu_online_mask is actually the appropriate cpumask to 
return and x86 doesn't catch this.


x86: default pcibus cpumask to all cpus if it lacks affinity

The early initialization of the pci bus to node mapping leaves all busses
with a node id of -1 if it lacks memory affinity.  Thus, cpumask_of_pcibus
must return all online cpus for such busses.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/x86/include/asm/pci.h |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
--- a/arch/x86/include/asm/pci.h
+++ b/arch/x86/include/asm/pci.h
@@ -143,7 +143,11 @@ static inline int __pcibus_to_node(const struct pci_bus *bus)
 static inline const struct cpumask *
 cpumask_of_pcibus(const struct pci_bus *bus)
 {
-	return cpumask_of_node(__pcibus_to_node(bus));
+	int node;
+
+	node = __pcibus_to_node(bus);
+	return (node == -1) ? cpu_online_mask :
+			      cpumask_of_node(node);
 }
 #endif
 
