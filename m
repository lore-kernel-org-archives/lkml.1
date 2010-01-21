Return-Path: <linux-kernel-owner+w=401wt.eu-S1753773Ab0AUIdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773Ab0AUIdk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 03:33:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752146Ab0AUIdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 03:33:39 -0500
Received: from mga05.intel.com ([192.55.52.89]:31163 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752008Ab0AUIdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 03:33:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,316,1262592000"; 
   d="scan'208";a="533173461"
Message-ID: <4B581160.2090209@linux.intel.com>
Date: Thu, 21 Jan 2010 16:33:36 +0800
From: Haicheng Li <haicheng.li@linux.intel.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Ingo Molnar <mingo@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] x86: set hotpluggable nodes in nodes_possible_map
References: <4B501C4D.4080907@linux.intel.com> <alpine.DEB.2.00.1001171338170.16238@chino.kir.corp.google.com> <86802c441001172230y137b4916h7d744a96ab75873d@mail.gmail.com> <alpine.DEB.2.00.1001180231430.20677@chino.kir.corp.google.com> <4B5592B1.9030800@linux.intel.com> <alpine.DEB.2.00.1001191513010.24223@chino.kir.corp.google.com> <4B5731E2.4040207@linux.intel.com> <alpine.DEB.2.00.1001201152040.30528@chino.kir.corp.google.com> <4B57C2DD.3050402@linux.intel.com> <alpine.DEB.2.00.1001202252320.22343@chino.kir.corp.google.com> <4B5802EF.6040603@linux.intel.com> <alpine.DEB.2.00.1001202344580.29982@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1001202344580.29982@chino.kir.corp.google.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:
> On Thu, 21 Jan 2010, Haicheng Li wrote:
> 
>>> Nack, we don't need to add yet another nodemask because you're having
>>> trouble finding a new name for a cpu_nodes_parsed.  It would be perfectly 
>> Hey Dave, why do you think it's just a naming issue?
>>
>> What I'm concerning is that your assumption of cpu_nodes_parsed use is wrong,
>> cpu_nodes_parsed is needed anyway since its semantics represent the node with
>> cpu affinity rather than memless node, that's also why I originally doubted
>> cpu_node_parsed cannot handle hotplug node.
> 
> Wrong, cpu_nodes_parsed (despite its name) solely represents nodes that do 
> not have online address memory ranges.  That's it.  Nothing more, nothing 
> less.  That's why I suggest you rename it to no_mem_nodes or something 
> similar.  Look at the single time that the nodemask is used: to set 
> cleared bits in node_possible_map that were not set in nodes_parsed 
> because THEY DO NOT HAVE ASSOCIATED ONLINE MEMORY RANGES, the _only_ time 
> a node gets set in nodes_parsed.
> 
> Once you rename nodes_parsed to mem_nodes and cpu_nodes_parsed to 
> no_mem_nodes, it may become clearer.
> 
>> we also need hp_nodes_parsed to represent the node with hotpluggable memory
>> region, just like why we need nodes_parsed to repsent node with mem on.
>>
> 
> It's pointless to add another nodemask, the semantics of cpu_nodes_parsed 
> is perfectly legitimate for hotpluggable nodes as well.  Instead of 
> fixating on the name, look at the code that uses it.

I'm not meant to be rude, but it's illogical excuse. that it is now used by a single function 
doesn't mean that it will never be used by others in future or it is only useful for that single 
function.

see the code, we can find such relationships between related data-structures.
- struct bootnode nodes[] -> nodes_parsed
all the node in nodes_parsed should have a relative mem range in nodes[].

- apicid_to_node[] -> cpu_nodes_parsed
all the value of apicid_to_node[] should be valid in cpu_nodes_parsed. If we put hotpluggable node 
into cpu_nodes_parsed, such relationship is broken, right?

- nodes_add[] -> ?? (this is for hotpluggable node)
all the hotplugged mem can find a corresponding node thru nodes_add[].

-haicheng
