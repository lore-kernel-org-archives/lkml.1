Return-Path: <linux-kernel-owner+w=401wt.eu-S1756382AbZIRQw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756382AbZIRQw7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 12:52:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755376AbZIRQw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 12:52:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41135 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754782AbZIRQw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 12:52:58 -0400
Date: Fri, 18 Sep 2009 09:51:01 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Yinghai Lu <yinghai@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [crash] BUG: unable to handle kernel NULL pointer dereference
 at (null), last sysfs file:
 /sys/devices/pci0000:00/0000:00:01.0/local_cpus
In-Reply-To: <4AB3B430.3030905@kernel.org>
Message-ID: <alpine.LFD.2.01.0909180949420.4950@localhost.localdomain>
References: <20090915132105.2fdd1d45@jbarnes-g45> <20090917173012.GA11155@elte.hu> <20090917103614.6ab1385f@jbarnes-g45> <20090917175944.GA17304@elte.hu> <20090917114614.35aeb6b8@jbarnes-g45> <20090918075952.GA29026@elte.hu> <4AB3B430.3030905@kernel.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 18 Sep 2009, Yinghai Lu wrote:
> 
> exposed by Jesse's patch too.
> 
> please check
> 
> ---
>  arch/x86/include/asm/pci.h |    9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/arch/x86/include/asm/pci.h
> ===================================================================
> --- linux-2.6.orig/arch/x86/include/asm/pci.h
> +++ linux-2.6/arch/x86/include/asm/pci.h
> @@ -143,7 +143,14 @@ static inline int __pcibus_to_node(const
>  static inline const struct cpumask *
>  cpumask_of_pcibus(const struct pci_bus *bus)
>  {
> -	return cpumask_of_node(__pcibus_to_node(bus));
> +	int node;
> +
> +	node = __pcibus_to_node(bus);
> +
> +	if (node == -1)
> +		node = numa_node_id();
> +
> +	return cpumask_of_node(node);

This looks like the wrong fix. Why would the pcibus cpumask depend on the 
node we happen to run on right now? All the other code says "no node means 
all online cpus", which makes much more sense.

		Linus
