Return-Path: <linux-kernel-owner+w=401wt.eu-S933761AbYA2Ttn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933761AbYA2Ttn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 14:49:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765286AbYA2TtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 14:49:25 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:37366 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764672AbYA2TtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 14:49:23 -0500
Date: Tue, 29 Jan 2008 20:49:20 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: sections mismatches: How to mark new false positives?
Message-ID: <20080129194920.GC14056@uranus.ravnborg.org>
References: <20080129170255.GP8767@does.not.exist> <20080129181305.GB14056@uranus.ravnborg.org> <20080129190046.GR8767@does.not.exist>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080129190046.GR8767@does.not.exist>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Greg added to cc: as I guess he is most familiar with this code base]
> 
> WARNING: drivers/pci/built-in.o(.text+0xa385): Section mismatch in 
> reference from the function cpci_configure_slot() to the function 
> .devinit.text:pci_do_scan_bus()
> WARNING: drivers/pci/built-in.o(.text+0x13052): Section mismatch in 
> reference from the function cpqhp_configure_device() to the function 
> .devinit.text:pci_do_scan_bus()
> WARNING: drivers/pci/built-in.o(.text+0x1561c): Section mismatch in 
> reference from the function ibm_configure_device() to the function 
> .devinit.text:pci_do_scan_bus()
> WARNING: drivers/pci/built-in.o(.text+0x26176): Section mismatch in 
> reference from the function shpchp_configure_device() to the function 
> .devinit.text:pci_do_scan_bus()
> 
> The code seems to be 100% correct, but how can I silence the warnings 
> without needlessly bloating the kernel in the CONFIG_HOTPLUG=n case?

The recommended way to silence warnings is to use annotation.
Use __ref for functions that may reference any __*init and __*exit
code/data.
Use __refdata for variables, and __refconst for const varibales.

Examples:

static int __ref foo(int bar)
{
	if (use_an_init_var)
		call_an_init_function();
}

The __ref annotation will place the code of the function in a section
named .ref.text and modpost will not check relocation records from
.ref.text to anything.

Likewise for variables:
int my_init_ref_variable[] __refdata = { ...};


But that said I took a closer look at the last warning.
We have pci_do_scan_bus() which is annotated __devinit.
It is a 4 line function that calls pci_scan_child_bus() which
is not annotated and calls pci_bus_add_devices() which
is not annotated.

pci_do_scan_bus() has sole users in drivers/pci/hotplug
and none of the users in drivers/pci/hotplug looks like
functions used during init time.

So it really looks like the __devinit annotation
in this case has been used to say that this is
code that is only relevant for hotplug use.
But the code is NOT restricted to be used in
the init phase and thus the __devinit annotation is *WRONG*.

The right fix is to restrict the code to be used
solely when HOTPLUG is enabled and no annotation can
help us here.

I would suggest the following fix.

Now it is obvious that this is HOTPLUG only code
and no false annotation that this is only used
in the init phase but the init code needs
to be preserved in the hotplug case.

So exactly the same issue as I previously described for
the __cpuinit misuse.

PS. I sneaked in a delete of a forward declaration. That
fix should maybe be factored out.

	Sam

diff --git a/drivers/pci/hotplug.c b/drivers/pci/hotplug.c
index 2b5352a..e0a00bf 100644
--- a/drivers/pci/hotplug.c
+++ b/drivers/pci/hotplug.c
@@ -35,3 +35,17 @@ int pci_uevent(struct device *dev, struct kobj_uevent_env *env)
 		return -ENOMEM;
 	return 0;
 }
+
+unsigned int pci_do_scan_bus(struct pci_bus *bus)
+{
+	unsigned int max;
+
+	max = pci_scan_child_bus(bus);
+
+	/*
+	 * Make the discovered devices available.
+	 */
+	pci_bus_add_devices(bus);
+
+	return max;
+}
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 5fd5852..3a99065 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -471,8 +471,6 @@ static void pci_fixup_parent_subordinate_busnr(struct pci_bus *child, int max)
 	}
 }
 
-unsigned int pci_scan_child_bus(struct pci_bus *bus);
-
 /*
  * If it's a bridge, configure it and scan the bus behind it.
  * For CardBus bridges, we don't scan behind as the devices will
@@ -1050,20 +1048,6 @@ unsigned int pci_scan_child_bus(struct pci_bus *bus)
 	return max;
 }
 
-unsigned int __devinit pci_do_scan_bus(struct pci_bus *bus)
-{
-	unsigned int max;
-
-	max = pci_scan_child_bus(bus);
-
-	/*
-	 * Make the discovered devices available.
-	 */
-	pci_bus_add_devices(bus);
-
-	return max;
-}
-
 struct pci_bus * pci_create_bus(struct device *parent,
 		int bus, struct pci_ops *ops, void *sysdata)
 {

