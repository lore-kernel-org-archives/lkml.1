Return-Path: <linux-kernel-owner+w=401wt.eu-S1752642AbXL0OLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642AbXL0OLv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 09:11:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751854AbXL0OLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 09:11:41 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:53332 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbXL0OLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 09:11:40 -0500
Date: Thu, 27 Dec 2007 06:09:13 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>, gregkh@suse.de,
       inux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Mares <mj@ucw.cz>, Matthew Wilcox <matthew@wil.cx>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
 opt-in
Message-ID: <20071227060913.56173f74@laptopd505.fenrus.org>
In-Reply-To: <47739203.3060809@garzik.org>
References: <20071225032605.29147200@laptopd505.fenrus.org>
	<47739203.3060809@garzik.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Dec 2007 06:52:35 -0500
Jeff Garzik <jeff@garzik.org> wrote:

> Arjan van de Ven wrote:
> > This patch also adds a sysfs property for each device into which
> > root can write a '1' to enable extended configuration space. The
> > kernel will print a notice into dmesg when this happens (including
> > the name of the app) so that if the system crashes as a result of
> > this action, the user can know what action/tool caused it.
> 
> 
> Comments:
> 
> 1) [minor] With a bit in struct pci_dev, 

I have this

> there is no need for
> separate raw_pci_ops.  That will simplify your patch, with no
> functionality change.

but sadly your second statement is not correct. Part of the complication is that all PCI config ops
operate on busses not devices; at first I thought "just add a bit and be done with it", but sadly it's
not quite the case. Due to the per-bus nature of the ops, you end up having 2 type of bus operations, 
and that's just boilerplate (prototypes, exports and stuff) but it makes up most of the lines of the patch

In addition, a separate raw_pci_ops (for x86 only!) is needed anyway since it's quite likely that 
we'll have various options of each case (extended or not) and we want to pick the best one for each case,
at which point you really do need the 2 variables.

> 
> "golden" arches (no pun intended) may implement raw_pci_ops that 
> _always_ work with extended config space, and simply ignore that bit,
> if that is how their underlying non-mmconfig-nor-type1 hardware is
> implemented.

that is what I implemented already in the patch that you commented on ;-)

> 
> 
> 2) [non-minor] hmmmm.
> 
> 	[jgarzik@core ~]$ lspci -n | wc -l
> 	23
> 
> So I would have to perform 23 sysfs twiddles, before I could obtain a 
> full and unabridged 'lspci -vvvxxx'?

not you as human, but "lspci" ought to yes.

> 
> For the userspace interface, the most-often-used knob for diagnostic 
> purposes will be the easiest one.  And that's

the easiest one is an option to lspci. Nothing more nothing less.

Making a global knob in kernel space is a lot more tricky, and in addition
really there's enough cases where userspace wants the one device anyway
Doing the "for each device I'm about to dump" in lspci is pretty much as hard as doing
the global one (if not simpler)

> 
> 3) [minor] architectures must be able to override 
> pci_enable_ext_config().  see "golden arches".

see the patch. All pci_enable_ext_config() does is set a flag.
The architecture decides what to do with that flag. Golden
architectures can just totally ignore the flag and always expose
the full space. 
(In fact, the patch assumes all-but-x86 to be golden here; which is fair)



-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
