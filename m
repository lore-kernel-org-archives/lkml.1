Return-Path: <linux-kernel-owner+w=401wt.eu-S1759948AbXKTRv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759948AbXKTRv4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 12:51:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752459AbXKTRvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 12:51:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58137 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754815AbXKTRvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 12:51:47 -0500
Subject: [PATCH 0/3] PNP cleanups - Version 2
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "yakui.zhao" <yakui.zhao@intel.com>,
       Rene Herman <rene.herman@keyaccess.nl>, alsa-devel@alsa-project.org
Content-Type: text/plain
Organization: Novell/SUSE
Date: Tue, 20 Nov 2007 18:51:44 +0100
Message-Id: <1195581105.23700.259.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Changes:
  - Introduce pnp_irq_no instead of pnp_irq_start (same for dma).
  - Let irq and dma resource structs never access .end.
    .end was always only a copy of .start for dma and irq

Some background what I want to do next to allocate resources on the fly:

I want to use pnp_{port,dma,irq,mem} macros mainly in loops to check
whether a resource got allocated:

e.g.:
-       if (idx >= PNP_MAX_DMA) {
+       if (!pnp_dma(dev, idx)) {
or:
-       for (idx = 0; idx < PNP_MAX_IRQ; idx++) {
+       for (idx = 0; pnp_irq(dev, idx); idx++) {

that would look like this in pnp.h:
+#define pnp_port(dev,bar)      ((dev)->res.allocated_ports > (bar) \
+       ? (&(dev)->res.port_resource[(bar)]) : NULL)

I'd like to use krealloc to realloc portions of e.g. 8 port resources on
the fly. As krealloc modifies the addresses of the array, it must be
insured that these are only used at pnp parse time.

This seem to work fine for pnpacpi, were most of the:
echo {get,fill,clean,...} >/sys/devices/pnp0/*/resources
interface does not work for me :)
It should be possible to get this working, if I could get some testing
help with these interfaces, that would be great.
Is any tool making use of this?
The "get" looks evil. It reparses the devices' BIOS information.
This should work as long as not more resources are attached to a device
compared to the initial parse and krealloc must pop in, this should be
the case...
I wonder whether this get and possibly other sysfs interfaces in
drivers/pnp/interface.c can be reverted (it's debug only?). Then the
whole parsing code could theoretically be made __init data. Bjorn?

Also the pnp_resource_change exported symbol could be a problem, if
resources are simply defined by the driver, even there were none
(allocated) found by the pnp{isa,bios,acpi} parser. But this should be
"workaroundable" by doing one malloc/krealloc portion there. It must be
called before insert_resource(..) got called anyway (which passes the
address of a struct resource to be registered as global used IO/System
Memory). Invalidating the passed struct resource pointers afterwards
would be fatal. Just found that problem, I haven't looked at it in
detail.

Any help, comments, etc. are very much appreciated,

    Thomas

