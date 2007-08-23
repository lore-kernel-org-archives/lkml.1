Return-Path: <linux-kernel-owner+w=401wt.eu-S1765887AbXHWWiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765887AbXHWWiI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 18:38:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932628AbXHWW3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 18:29:24 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33203 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932653AbXHWW3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 18:29:23 -0400
Date: Thu, 23 Aug 2007 15:27:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [patch 21/28] PCI: lets kill the PCI hidden behind bridge message
Message-ID: <20070823222733.GU18559@kroah.com>
References: <20070823220656.101239233@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline; filename="pci-lets-kill-the-pci-hidden-behind-bridge-message.patch"
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070823221811.GA18559@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Bernhard Kaindl <bk@suse.de>

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


Ok, here the patch with the following changes:

* Refined to say that the bus is only partially hidden when the parent
  bus numbers are not totally way off (outside of) the child bus range
* remove the reference to pci=assign-busses and the plea to report it

We could add a pure source code-only comment to keep a reference to
pci=assign-busses the in case when this is triggered by someone who
is debugging the cause of this message and looking the way to solve it.

From: Bernhard Kaindl <bk@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/probe.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -643,20 +643,20 @@ int pci_scan_bridge(struct pci_bus *bus,
 
 	sprintf(child->name, (is_cardbus ? "PCI CardBus #%02x" : "PCI Bus #%02x"), child->number);
 
+	/* Has only triggered on CardBus, fixup is in yenta_socket */
 	while (bus->parent) {
 		if ((child->subordinate > bus->subordinate) ||
 		    (child->number > bus->subordinate) ||
 		    (child->number < bus->number) ||
 		    (child->subordinate < bus->number)) {
-			printk(KERN_WARNING "PCI: Bus #%02x (-#%02x) is "
-			       "hidden behind%s bridge #%02x (-#%02x)%s\n",
-			       child->number, child->subordinate,
-			       bus->self->transparent ? " transparent" : " ",
-			       bus->number, bus->subordinate,
-			       pcibios_assign_all_busses() ? " " :
-			       " (try 'pci=assign-busses')");
-			printk(KERN_WARNING "Please report the result to "
-			       "linux-kernel to fix this permanently\n");
+			pr_debug("PCI: Bus #%02x (-#%02x) is %s"
+				"hidden behind%s bridge #%02x (-#%02x)\n",
+				child->number, child->subordinate,
+				(bus->number > child->subordinate &&
+				 bus->subordinate < child->number) ?
+					"wholly " : " partially",
+				bus->self->transparent ? " transparent" : " ",
+				bus->number, bus->subordinate);
 		}
 		bus = bus->parent;
 	}

-- 
