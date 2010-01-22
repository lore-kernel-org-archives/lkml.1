Return-Path: <linux-kernel-owner+w=401wt.eu-S1752406Ab0AVInk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406Ab0AVInk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 03:43:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752366Ab0AVInk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 03:43:40 -0500
Received: from mga10.intel.com ([192.55.52.92]:6025 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750742Ab0AVInj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 03:43:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,322,1262592000"; 
   d="scan'208";a="533574056"
Message-ID: <4B596539.1050207@linux.intel.com>
Date: Fri, 22 Jan 2010 16:43:37 +0800
From: Haicheng Li <haicheng.li@linux.intel.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
       x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/mm/srat_64.c: make node_possible_map include hotpluggable
 node
References: <4B501C4D.4080907@linux.intel.com> <alpine.DEB.2.00.1001171338170.16238@chino.kir.corp.google.com> <86802c441001172230y137b4916h7d744a96ab75873d@mail.gmail.com> <alpine.DEB.2.00.1001180231430.20677@chino.kir.corp.google.com> <4B5592B1.9030800@linux.intel.com> <alpine.DEB.2.00.1001191513010.24223@chino.kir.corp.google.com> <4B5731E2.4040207@linux.intel.com> <alpine.DEB.2.00.1001201152040.30528@chino.kir.corp.google.com> <4B57C2DD.3050402@linux.intel.com> <alpine.DEB.2.00.1001202252320.22343@chino.kir.corp.google.com> <4B5802EF.6040603@linux.intel.com> <alpine.DEB.2.00.1001202344580.29982@chino.kir.corp.google.com> <4B581160.2090209@linux.intel.com> <alpine.DEB.2.00.1001211500290.31073@chino.kir.corp.google.com> <4B592437.9060508@linux.intel.com> <4B5954C6.6010102@zytor.com>
In-Reply-To: <4B5954C6.6010102@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
 > I have to say I agree with David Rientjes that we need the minimal patch
 > for upstream and stable.  If you need the additional bitmask in the
 > future it should be added later.
 >
 > Haicheng, would you be willing to prepare a minimal patch so we can
 > close the issue in the release trees as quickly as possible?

Peter,

Okay, let's close it. then please take the patch pasted below, which is the one without additional 
bitmask added.

---
x86: set hotpluggable nodes in nodes_possible_map

nodes_possible_map does not currently include nodes that have SRAT
entries that are all ACPI_SRAT_MEM_HOT_PLUGGABLE since the bit is cleared
in nodes_parsed if it does not have an online address range.

Unequivocally setting the bit in nodes_parsed is insufficient since
existing code, such as acpi_get_nodes(), assumes all nodes in the map
have online address ranges.  In fact, all code using nodes_parsed assumes
such nodes represent an address range of online memory.

nodes_possible_map is created by unioning nodes_parsed and
cpu_nodes_parsed; the former represents nodes with online memory and the
latter represents memoryless nodes.  We now set the bit for hotpluggable
nodes in cpu_nodes_parsed so that it also gets set in nodes_possible_map.

Signed-off-by: David Rientjes <rientjes@google.com>
---
  arch/x86/mm/srat_64.c |    4 +++-
  1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -229,9 +229,11 @@ update_nodes_add(int node, unsigned long start, unsigned long end)
  			printk(KERN_ERR "SRAT: Hotplug zone not continuous. Partly ignored\n");
  	}

-	if (changed)
+	if (changed) {
+		node_set(node, cpu_nodes_parsed);
  		printk(KERN_INFO "SRAT: hot plug zone found %Lx - %Lx\n",
  				 nd->start, nd->end);
+	}
  }

  /* Callback for parsing of the Proximity Domain <-> Memory Area mappings */
