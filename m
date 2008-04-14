Return-Path: <linux-kernel-owner+w=401wt.eu-S1761636AbYDNW3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761636AbYDNW3e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 18:29:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752671AbYDNW30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 18:29:26 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:61669 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927AbYDNW3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 18:29:25 -0400
Date: Mon, 14 Apr 2008 15:28:31 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jakub Jelinek <jakub@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>,
       mingo <mingo@redhat.com>, tglx <tglx@linutronix.de>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for April 10 (arch/x86)
Message-Id: <20080414152831.9b9753c1.randy.dunlap@oracle.com>
In-Reply-To: <20080414084048.GD23259@devserv.devel.redhat.com>
References: <20080410181404.b76939a6.sfr@canb.auug.org.au>
	<20080410150950.5913b16a.randy.dunlap@oracle.com>
	<20080411074631.GB6410@elte.hu>
	<20080411081901.f56f5180.randy.dunlap@oracle.com>
	<20080414084048.GD23259@devserv.devel.redhat.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2008 04:40:49 -0400 Jakub Jelinek wrote:

> On Fri, Apr 11, 2008 at 08:19:01AM -0700, Randy Dunlap wrote:
> > On Fri, 11 Apr 2008 09:46:31 +0200 Ingo Molnar wrote:
> > 
> > > 
> > > * Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > > 
> > > > Fix printk formats in x86/mm/ioremap.c:
> > > > 
> > > > next-20080410/arch/x86/mm/ioremap.c:137: warning: format '%llx' expects type 'long long unsigned int', but argument 2 has type 'resource_size_t'
> > > > next-20080410/arch/x86/mm/ioremap.c:188: warning: format '%llx' expects type 'long long unsigned int', but argument 2 has type 'resource_size_t'
> > > > next-20080410/arch/x86/mm/ioremap.c:188: warning: format '%llx' expects type 'long long unsigned int', but argument 3 has type 'long unsigned int'
> > > 
> > > thanks, applied.
> > > 
> > > >  	if (!phys_addr_valid(phys_addr)) {
> > > >  		printk(KERN_WARNING "ioremap: invalid physical address %llx\n",
> > > > -		       phys_addr);
> > > > +		       (unsigned long long)phys_addr);
> > > 
> > > is there really no way to solve this more cleanly than a forced cast?
> > 
> > I haven't seen any other decent solutions.  This is what we do
> > all over the kernel.
> 
> You can define macros and use them in the format string.
> In this case
> 		printk(KERN_WARNING "ioremap: invalid physical address %" PRIRESOURCESZ "\n",
> 		       phys_addr);
> (see the PRI* macros in
> http://www.opengroup.org/onlinepubs/009695399/basedefs/inttypes.h.html
> and e.g. glibc inttypes.h to see how it is defined).  Other alternative is
> custom format length modifiers, but unfortunately there is no easy way ATM
> to teach GCC about them.

Hi,
I tried this.

In this particular case, phys_addr is a type(def) of resource_size_t,
so we still get gcc warnings:

next-20080410/arch/x86/mm/ioremap.c: In function '__ioremap':
next-20080410/arch/x86/mm/ioremap.c:137: warning: format '%lx' expects type 'long unsigned int', but argument 2 has type 'resource_size_t'
next-20080410/arch/x86/mm/ioremap.c:188: warning: format '%lx' expects type 'long unsigned int', but argument 2 has type 'resource_size_t'

so we still need to cast phys_addr either to (unsigned long) or
(unsigned long long).  Rigth?  or am I missing something?  if so, what?

Thanks,
---
~Randy
