Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515Ab0BJDVr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 22:21:47 -0500
Received: from mail-iw0-f201.google.com ([209.85.223.201]:44652 "EHLO
	mail-iw0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab0BJDVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 22:21:46 -0500
MIME-Version: 1.0
Date: Wed, 10 Feb 2010 13:21:45 +1000
Message-ID: <1d3f23371002091921m7f47a1fbt1cf7fd2ef0a927fa@mail.gmail.com>
Subject: PPC: Possible bug in prom_parse.c:of_irq_map_raw?
From: John Williams <john.williams@petalogix.com>
To: Linux Kernel list <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       Grant Likely <grant.likely@secretlab.ca>,
       Michal Simek <michal.simek@petalogix.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Perhaps this is my misunderstanding, but I'm looking at the bit of
code in of_irq_map_raw() that iterates the interrupt-map DTS node,
which I am seeing to behave strangely when handling the interrupt-map
property on a PCI bridge node.

Early in the function, we get the #address-cells value from the node -
in this case the PCI bridge, and store it in local var addrsize:

        /* Look for this #address-cells. We have to implement the old linux
         * trick of looking for the parent here as some device-trees rely on it
         */
        old = of_node_get(ipar);
        do {
                tmp = of_get_property(old, "#address-cells", NULL);
                tnode = of_get_parent(old);
                of_node_put(old);
                old = tnode;
        } while(old && tmp == NULL);
        of_node_put(old);
        old = NULL;
        addrsize = (tmp == NULL) ? 2 : *tmp;

        DBG(" -> addrsize=%d\n", addrsize);


Later, once we've found the interrupt-map and are iterating over it
attempting to match on PCI device addresses, there is this little
fragment:

                        /* Get the interrupt parent */
                        if (of_irq_workarounds & OF_IMAP_NO_PHANDLE)
                                newpar = of_node_get(of_irq_dflt_pic);
                        else
                                newpar =
of_find_node_by_phandle((phandle)*imap);
                        imap++;
                        --imaplen;

                        /* Check if not found */
                        if (newpar == NULL) {
                                DBG(" -> imap parent not found !\n");
                                goto fail;
                        }

                        /* Get #interrupt-cells and #address-cells of new
                         * parent
                         */
                        tmp = of_get_property(newpar, "#interrupt-cells", NULL);
                        if (tmp == NULL) {
                                DBG(" -> parent lacks #interrupt-cells !\n");
                                goto fail;
                        }
                        newintsize = *tmp;
                        tmp = of_get_property(newpar, "#address-cells", NULL);
                        newaddrsize = (tmp == NULL) ? 0 : *tmp;

Finally, later in the loop we update addrsize=newaddrsize

As I read this code, and the behaviour I'm seeing, is that if the
interrupt controller parent device doesn't have an #address-cells
entry, then this get_property will return fail, therefore setting
newaddrsize  to zero.  This then means that subsequent match attempts
when iterating the interrupt-map always fail, because the match length
(addrsize) is 0.

Maybe I'm missing something here, but shouldn't this last bit of code
instead be:

                        tmp = of_get_property(newpar, "#address-cells", NULL);
                        newaddrsize = (tmp == NULL) ? addrsize : *tmp;

 ^^^^^^^^^
?

In other words, if the parent node has an #address-cells value, then
use it, otherwise stick to the #address-cells value we picked up for
the actual node in question (ie the PCI bridge).

The way this is manifesting itself in the system I'm looking at is
that only the PCI device matching the first entry in the PCI bridge
interrupt-map property is correctly matching. For PCI devices that
require more than one pass through the interrupt-map loop, addrsize
goes to zero and no further match is possible.

I might be able to hack around this in the device-tree by setting
#address-cells=<3> in the interrupt controller node, but that doesn't
smell right either - it's only true for PCI devices for a start,
whereas this controller handles interrupts from many sources on the
32-bit PLB bus as well.  I looked at the ML510 DTS in boot/dts and
it's not doing anything like this.

As a footnote, I'm actually doing this in MicroBlaze whose PCI
infrastructure is not yet in mainline, however we copied this bit of
code directly from PPC and the logic is the same.

Thanks,

John
-- 
John Williams
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com  p: +61-7-30090663  f: +61-7-30090663
