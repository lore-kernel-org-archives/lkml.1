Return-Path: <linux-kernel-owner+w=401wt.eu-S1754688AbYJAICf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688AbYJAICf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 04:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753030AbYJAICK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 04:02:10 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:1149 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631AbYJAICI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 04:02:08 -0400
Message-ID: <f488382f0810010102y551f4a3bs64524fa70ef04ca3@mail.gmail.com>
Date: Wed, 1 Oct 2008 01:02:06 -0700
From: "Steven Noonan" <steven@uplinklabs.net>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: drivers/pci/probe.c compile warnings on -tip
Cc: linux-kernel@vger.kernel.org, "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Hugh Dickins" <hugh@veritas.com>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was hunting down some warnings I got when compiling -tip, and with
one of them, I'm not sure what would be a proper way to handle it.

If CONFIG_PHYS_ADDR_T_64BIT is not enabled, these warnings show up:

drivers/pci/probe.c: In function '__pci_read_base':
drivers/pci/probe.c:308: warning: format '%llx' expects type 'long
long unsigned int', but argument 4 has type 'resource_size_t'
drivers/pci/probe.c:308: warning: format '%llx' expects type 'long
long unsigned int', but argument 5 has type 'resource_size_t'
drivers/pci/probe.c:320: warning: format '%llx' expects type 'long
long unsigned int', but argument 5 has type 'resource_size_t'
drivers/pci/probe.c:320: warning: format '%llx' expects type 'long
long unsigned int', but argument 6 has type 'resource_size_t'
drivers/pci/probe.c: In function 'pci_read_bridge_bases':
drivers/pci/probe.c:392: warning: format '%llx' expects type 'long
long unsigned int', but argument 3 has type 'resource_size_t'
drivers/pci/probe.c:392: warning: format '%llx' expects type 'long
long unsigned int', but argument 4 has type 'resource_size_t'
drivers/pci/probe.c:405: warning: format '%llx' expects type 'long
long unsigned int', but argument 3 has type 'resource_size_t'
drivers/pci/probe.c:405: warning: format '%llx' expects type 'long
long unsigned int', but argument 4 has type 'resource_size_t'
drivers/pci/probe.c:443: warning: format '%llx' expects type 'long
long unsigned int', but argument 4 has type 'resource_size_t'
drivers/pci/probe.c:443: warning: format '%llx' expects type 'long
long unsigned int', but argument 5 has type 'resource_size_t'


Each of the lines is something like this:

printk(KERN_DEBUG "PCI: %s reg %x 64bit mmio: [%llx, %llx]\n",
pci_name(dev), pos, res->start, res->end);

res->start and res->end are resource_size_t (which is phys_addr_t),
and are sized either 32-bit or 64-bit, based on whether
CONFIG_PHYS_ADDR_T_64BIT is set. So, it seems to me that something
like these would be horrendously bad solutions (for obvious reasons,
like readability):

#ifdef CONFIG_PHYS_ADDR_T_64BIT
printk(KERN_DEBUG "PCI: %s reg %x 64bit mmio: [%llx, %llx]\n",
pci_name(dev), pos, res->start, res->end);
#else
printk(KERN_DEBUG "PCI: %s reg %x 64bit mmio: [%lx, %lx]\n",
pci_name(dev), pos, res->start, res->end);
#endif

or

#ifdef CONFIG_PHYS_ADDR_T_64BIT
printk(KERN_DEBUG "PCI: %s reg %x 64bit mmio: [%llx, %llx]\n",
pci_name(dev), pos, res->start, res->end);
#endif

What's the appropriate way to handle it? Moreover, are those printk's
even truly necessary?

- Steven
