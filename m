Return-Path: <linux-kernel-owner+w=401wt.eu-S1756866AbZIRRKO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866AbZIRRKO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 13:10:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755780AbZIRRKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 13:10:13 -0400
Received: from outbound-mail-142.bluehost.com ([67.222.38.32]:33076 "HELO
	outbound-mail-142.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753663AbZIRRKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 13:10:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=IRtjBwSPi85nwuVhN5XvxRef1Ow4MWCKuBAGL0OjQe3xGbl0/ghrpY9xkvQc1TwcvmM4zWgJnFohdOf0NSKR567OMCD2jZyn71Q468bfxL9b3MWgNvbr0Ua5IOyqUuA+;
Date: Fri, 18 Sep 2009 10:10:05 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [crash] BUG: unable to handle kernel NULL pointer dereference
 at (null), last sysfs file: /sys/devices/pci0000:00/0000:00:01.0/local_cpus
Message-ID: <20090918101005.6e1ae14e@jbarnes-g45>
In-Reply-To: <alpine.LFD.2.01.0909180949420.4950@localhost.localdomain>
References: <20090915132105.2fdd1d45@jbarnes-g45>
	<20090917173012.GA11155@elte.hu>
	<20090917103614.6ab1385f@jbarnes-g45>
	<20090917175944.GA17304@elte.hu>
	<20090917114614.35aeb6b8@jbarnes-g45>
	<20090918075952.GA29026@elte.hu>
	<4AB3B430.3030905@kernel.org>
	<alpine.LFD.2.01.0909180949420.4950@localhost.localdomain>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Sep 2009 09:51:01 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Fri, 18 Sep 2009, Yinghai Lu wrote:
> > 
> > exposed by Jesse's patch too.
> > 
> > please check
> > 
> > ---
> >  arch/x86/include/asm/pci.h |    9 ++++++++-
> >  1 file changed, 8 insertions(+), 1 deletion(-)
> > 
> > Index: linux-2.6/arch/x86/include/asm/pci.h
> > ===================================================================
> > --- linux-2.6.orig/arch/x86/include/asm/pci.h
> > +++ linux-2.6/arch/x86/include/asm/pci.h
> > @@ -143,7 +143,14 @@ static inline int __pcibus_to_node(const
> >  static inline const struct cpumask *
> >  cpumask_of_pcibus(const struct pci_bus *bus)
> >  {
> > -	return cpumask_of_node(__pcibus_to_node(bus));
> > +	int node;
> > +
> > +	node = __pcibus_to_node(bus);
> > +
> > +	if (node == -1)
> > +		node = numa_node_id();
> > +
> > +	return cpumask_of_node(node);
> 
> This looks like the wrong fix. Why would the pcibus cpumask depend on
> the node we happen to run on right now? All the other code says "no
> node means all online cpus", which makes much more sense.

Yeah, the fix I applied has the latter logic.

-- 
Jesse Barnes, Intel Open Source Technology Center
