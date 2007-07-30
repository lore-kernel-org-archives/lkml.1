Return-Path: <linux-kernel-owner+w=401wt.eu-S967717AbXG3Sf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967717AbXG3Sf1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 14:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935227AbXG3SfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 14:35:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39685 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934913AbXG3SfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 14:35:15 -0400
Date: Mon, 30 Jul 2007 20:35:13 +0200 (CEST)
From: Bernhard Kaindl <bk@suse.de>
To: linux-pci@atrey.karlin.mff.cuni.cz, Adrian Bunk <bunk@stusta.de>
Cc: Alois =?utf-8?Q?Ne=C5=A1por?= <alois.nespor@gmail.com>,
       linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Ok, lets kill the 'PCI hidden behind bridge' message (was:
 pci=assign-busses)
In-Reply-To: <20070730115331.GO16817@stusta.de>
Message-ID: <Pine.LNX.4.64.0707301932440.25292@jbgna.fhfr.qr>
References: <6c9774880707300129if10dbf4n25c5077f02c940e3@mail.gmail.com>
 <20070730115331.GO16817@stusta.de>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="168427776-10131842-1185820513=:25292"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--168427776-10131842-1185820513=:25292
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

Adrian Bunk wrote:
> Alois Nešpor wrote
>> PCI: Bus #0b (-#0e) is hidden behind transparent bridge #0a (-#0b) (try 'pci=assign-busses')
>> Please report the result to linux-kernel to fix this permanently"
>>
>> dmesg:
>> "Yenta: Raising subordinate bus# of parent bus (#0a) from #0b to #0e"
>> without pci=assign-busses and nothing with pci=assign-busses.
> 
> Bernhard?

Ok, lets kill the message. As Alois Nešpor also saw, that's fixed up by Yenta,
so PCI does not have to warn about it. PCI could still warn about it if
is_cardbus is 0 in that instance of pci_scan_bridge(), but so far I have
not seen a report where this would have been the case so I think we can
spare the kernel of that check (removes ~300 lines of asm) unless debugging
is done.

History: The whole check was added in the days before we had the fixup
for this in Yenta and pci=assign-busses was the only way to get CardBus
cards detected on many (not all) of the machines which give this warning.

In theory, there could be cases when this warning would be triggered and
it's not cardbus, then the warning should still apply, but I think this
should only be the case when working on a completely broken PCI setup,
but one may have already enabled the debug code in drivers/pci and the
patched check would then trigger.

I do not sign this off yet because it's completely untested so far, but
everyone is free to test it (with the #ifdef DEBUG replaced by #if 1 and
pr_debug( changed to printk(.

We may also dump the whole check (remove everything within the #ifdef from
the source) if that's perferred.

On Alois Nešpor's machine this would then (only when debugging) this message:

"PCI: Bus #0b (-#0e) is partially hidden behind transparent bridge #0a (-#0b)"

"partially" should be in the message on his machine because #0b of #0b-#0e 
is reachable behind #0a-#0b, but not #0c-#0e.

But that differentiation is now moot anyway because the fixup in Yenta takes
care of it as far as I could see so far, which means that unless somebody
is debugging a totally broken PCI setup, this message is not needed anymore,
not even for debugging PCI.

What do the PCI people think?

Best regards,
Bernhard

PS: Ok, here the patch with the following changes:

* Check not compiled unless debugging
* Refined to say that the bus is only partially hidden when the parent
   bus numbers are not totally way off (outside of) the child bus range
* remove the reference to pci=assign-busses and the plea to report it

We could add a pure source code-only comment to keep a reference to
pci=assign-busses the in case when this is triggered by someone who
is debugging the cause of this message and looking the way to solve it.

Author: Bernhard Kaindl <bk@suse.de>

--- linux-2.6.22/drivers/pci/probe.c
+++ linux-2.6.22/drivers/pci/probe.c
@@ -643,23 +643,24 @@ int pci_scan_bridge(struct pci_bus *bus,

  	sprintf(child->name, (is_cardbus ? "PCI CardBus #%02x" : "PCI Bus #%02x"), child->number);

+#ifdef DEBUG /* Has only triggered on CardBus, fixup is in yenta_socket */
  	while (bus->parent) {
  		if ((child->subordinate > bus->subordinate) ||
  		    (child->number > bus->subordinate) ||
  		    (child->number < bus->number) ||
  		    (child->subordinate < bus->number)) {
-			printk(KERN_WARNING "PCI: Bus #%02x (-#%02x) is "
-			       "hidden behind%s bridge #%02x (-#%02x)%s\n",
+		      pr_debug("PCI: Bus #%02x (-#%02x) is %s"
+			       "hidden behind%s bridge #%02x (-#%02x)\n",
  			       child->number, child->subordinate,
+			       (bus->number > child->subordinate &&
+			        bus->subordinate < child->number) ?
+					"wholly " : " partially",
  			       bus->self->transparent ? " transparent" : " ",
-			       bus->number, bus->subordinate,
-			       pcibios_assign_all_busses() ? " " :
-			       " (try 'pci=assign-busses')");
-			printk(KERN_WARNING "Please report the result to "
-			       "linux-kernel to fix this permanently\n");
+			       bus->number, bus->subordinate);
  		}
  		bus = bus->parent;
  	}
+#endif

  out:
  	pci_write_config_word(dev, PCI_BRIDGE_CONTROL, bctl);

--168427776-10131842-1185820513=:25292--
