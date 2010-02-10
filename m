Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939Ab0BJPkK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 10:40:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53229 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754245Ab0BJPkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 10:40:09 -0500
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Haicheng Li <haicheng.li@linux.intel.com>
Subject: Re: [PATCH] x86, acpi: map hotadded cpu to correct node.
Date: Wed, 10 Feb 2010 16:40:01 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32.1-0.0.14.f17927a-desktop; KDE/4.3.1; x86_64; ; )
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Suresh.b.siddha@intel.com, lenb@kernel.org,
       "Zheng, Shaohui" <shaohui.zheng@intel.com>,
       linux-kernel@vger.kernel.org, "Chen, Gong" <gong.chen@intel.com>,
       "Lv, Jane" <jane.lv@intel.com>, "Li, Haicheng" <haicheng.li@intel.com>
References: <C8EDE645B81E5141A8C6B2F73FD9265117C58A3504@shzsmsx501.ccr.corp.intel.com> <4B6AAA39.6000300@linux.intel.com> <4B6F7B66.5060404@linux.intel.com>
In-Reply-To: <4B6F7B66.5060404@linux.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002101640.01997.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 February 2010 03:48:06 Haicheng Li wrote:
> hello,
> 
> any comments on this patch? in fact, it's a straightforward bug fix: with existing
> CPU hotadd code, new added CPUs won't be mapped to its own node. especially for hotadding
> a new node with CPU and MEM, new added memories can be mapped to this new node, but new added
> CPUs are always mapped to old nodes. This patch is to fix this obvious bug. thanks.
> 
I can confirm that this patch works as expected:
Tested-by: Thomas Renninger <trenn@suse.de>

While the cores previously showed up on the wrong, already existing
node, they are now added to the correct one.

Be aware that there seem to be other issues (Andi posted some
slab memory hot plug fixes recently).

Find one "nit pick" below:

> -haicheng
> 
> Haicheng Li wrote:
> > x86: map hotadded cpu to correct node.
> > 
> > When hotadd new cpu to system, if its affinitive node is online, should 
> > map the cpu to its own node. otherwise, let kernel select one online 
> > node for the new cpu later.
> > 
> > Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
> > ---
> >  arch/x86/kernel/acpi/boot.c |   21 +++++++++++++++++++++
> >  1 files changed, 21 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
> > index 67e929b..92a4861 100644
> > --- a/arch/x86/kernel/acpi/boot.c
> > +++ b/arch/x86/kernel/acpi/boot.c
> > @@ -49,6 +49,7 @@ EXPORT_SYMBOL(acpi_disabled);
> > 
> >  #ifdef    CONFIG_X86_64
> >  # include <asm/proto.h>
> > +# include <asm/numa_64.h>
> >  #endif                /* X86 */
> > 
> >  #define BAD_MADT_ENTRY(entry, end) (                        \
> > @@ -482,6 +483,25 @@ int acpi_register_gsi(struct device *dev, u32 gsi, 
> > int trigger, int polarity)
> >   */
> >  #ifdef CONFIG_ACPI_HOTPLUG_CPU
> > 
> > +static void acpi_map_cpu2node(acpi_handle handle, int cpu, int physid)
> > +{
> > +#ifdef CONFIG_ACPI_NUMA
> > +    int nid;
> > +
> > +    nid = acpi_get_node(handle);
> > +    if (!node_online(nid))
if (nid == -1 || !node_online(nid))
would avoid passing an invalid param to node_online(..)
node_online() probably already can handle this...
A maintainer eventually could fiddle this into the patch/line
without the need of re-posting.

I am not that familiar with numa node handling, but went the code and
spec up and down a bit. Also assigning a node no. is rather straight
forward, thus I can give this a:
Reviewed-by: Thomas Renninger <trenn@suse.de>

Thanks,

   Thomas
