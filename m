Return-Path: <linux-kernel-owner+w=401wt.eu-S936992AbXGZURv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936992AbXGZURv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 16:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936853AbXGZURD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 16:17:03 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:33242 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936957AbXGZURB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 16:17:01 -0400
Date: Thu, 26 Jul 2007 22:18:15 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Christoph Lameter <clameter@sgi.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] x86_64: get mp_bus_to_node as early v2
Message-ID: <20070726201815.GB6387@uranus.ravnborg.org>
References: <86802c440707261305t13bce632r7d82d598b9f8a308@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440707261305t13bce632r7d82d598b9f8a308@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2007 at 01:05:09PM -0700, Yinghai Lu wrote:
> 
+#ifdef CONFIG_ACPI_NUMA
        int pxm;
-
-       /* Allocate per-root-bus (not per bus) arch-specific data.
-        * TODO: leak; this memory is never freed.
-        * It's arguable whether it's worth the trouble to care.
-        */
-       sd = kzalloc(sizeof(*sd), GFP_KERNEL);
-       if (!sd) {
-               printk(KERN_ERR "PCI: OOM, not probing PCI bus %02x\n", busnum);
-               return NULL;
-       }
+       int node;
+#endif

        if (domain != 0) {
                printk(KERN_WARNING "PCI: Multiple domains not supported\n");
-               kfree(sd);
                return NULL;
        }

-       sd->node = -1;
-
-       pxm = acpi_get_pxm(device->handle);
 #ifdef CONFIG_ACPI_NUMA
-       if (pxm >= 0)
-               sd->node = pxm_to_node(pxm);
+       pxm = acpi_get_pxm(device->handle);
+       if (pxm >= 0) {
+               node = pxm_to_node(pxm);
+               printk(KERN_INFO "bus %02x -> pxm %d -> node %02x\n",
+                       busnum, pxm, node);
+               set_mp_bus_to_node(busnum, node);
+       }
 #endif
The local variable 'node' is only used in the above if statement.
So moving the definition inside the if statement will save one pair
of ugly #ifdef/#endif

	Sam


