Return-Path: <linux-kernel-owner+w=401wt.eu-S1753133AbYJTLg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133AbYJTLg3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 07:36:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751901AbYJTLgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 07:36:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51011 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719AbYJTLgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 07:36:18 -0400
Date: Mon, 20 Oct 2008 13:36:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@osdl.org>, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>, linux-pci@vger.kernel.org,
       yhlu.kernel@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] x86, ioremap: use %pR in printk
Message-ID: <20081020113602.GA2697@elte.hu>
References: <20081020040823.871BDDDDEC@ozlabs.org> <20081020071203.GB12131@elte.hu> <1224491682.7654.135.camel@pasglop> <20081020090502.GB31710@elte.hu> <20081020110018.GA24579@elte.hu> <1224501352.7654.141.camel@pasglop> <1224501768.7654.144.camel@pasglop> <20081020113143.GB14097@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081020113143.GB14097@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> 
> > > Still not too happy with the pointer thing but that's the best we 
> > > can do I suppose without losing gcc type checking.
> > 
> > Oh, and I didn't like having the brackets around something that isn't 
> > a range too but that's a minor details.
> 
> it looked quite natural in printouts to me, but no strong feelings.

got rid of the brackets, see the patches below.

One open question would be whether to set the width to 8 on 32-bit 
platforms and 16 on 64-bit platforms - right now it's 8 on both. Since 
this is specifically a 'physical address' thing it might make sense to 
extend that on 64-bit systems. (although it's quite a bit of screen real 
estate so i think the current width of 8 should be fine)

	Ingo

---------->
commit b74e806f605f2c3eda181066f60f2bf6585d835a
Author: Ingo Molnar <mingo@elte.hu>
Date:   Mon Oct 20 09:08:57 2008 +0200

    x86, ioremap: use %pP in printk
    
    use the new %pP physical address printk type conversion specifier.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index ae71e11..aaa81d9 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -207,8 +207,8 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
 		return NULL;
 
 	if (!phys_addr_valid(phys_addr)) {
-		printk(KERN_WARNING "ioremap: invalid physical address %llx\n",
-		       (unsigned long long)phys_addr);
+		printk(KERN_WARNING "ioremap: invalid physical address %pP\n",
+		       &phys_addr);
 		WARN_ON_ONCE(1);
 		return NULL;
 	}
@@ -267,9 +267,9 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
 		    (prot_val == _PAGE_CACHE_WC &&
 		     new_prot_val == _PAGE_CACHE_WB)) {
 			pr_debug(
-		"ioremap error for 0x%llx-0x%llx, requested 0x%lx, got 0x%lx\n",
-				(unsigned long long)phys_addr,
-				(unsigned long long)(phys_addr + size),
+		"ioremap error for %pP [%lx], requested 0x%lx, got 0x%lx\n",
+				&phys_addr,
+				size,
 				prot_val, new_prot_val);
 			free_memtype(phys_addr, phys_addr + size);
 			return NULL;

commit 075279167da29f6bb701597a32e6b7311faa1782
Author: Ingo Molnar <mingo@elte.hu>
Date:   Mon Oct 20 12:39:17 2008 +0200

    vsprintf: implement %pP to print phys_addr_t
    
    Add %pP to print addresses in phys_addr_t variables. Passed by reference.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index a013bbc..aac4fff 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -581,6 +581,19 @@ static char *resource_string(char *buf, char *end, struct resource *res, int fie
 	return string(buf, end, sym, field_width, precision, flags);
 }
 
+static char *phys_addr_string(char *buf, char *end, phys_addr_t *val, int field_width, int precision, int flags)
+{
+	/* room for the actual number, the "0x" and the final zero */
+	char sym[2*sizeof(phys_addr_t) + 2];
+	char *p = sym, *pend = sym + sizeof(sym);
+	int size = 8;
+
+	p = number(p, pend, *val, 16, size, -1, SPECIAL | SMALL | ZEROPAD);
+	*p = 0;
+
+	return string(buf, end, sym, field_width, precision, flags);
+}
+
 /*
  * Show a '%p' thing.  A kernel extension is that the '%p' is followed
  * by an extra set of alphanumeric characters that are extended format
@@ -592,6 +605,8 @@ static char *resource_string(char *buf, char *end, struct resource *res, int fie
  * - 'S' For symbolic direct pointers
  * - 'R' For a struct resource pointer, it prints the range of
  *       addresses (not the name nor the flags)
+ * - 'P' For a phys_addr_t pointer, it prints the physical
+ *       addresses (with a minimum width of 8 characters)
  *
  * Note: The difference between 'S' and 'F' is that on ia64 and ppc64
  * function pointers are really function descriptors, which contain a
@@ -607,6 +622,8 @@ static char *pointer(const char *fmt, char *buf, char *end, void *ptr, int field
 		return symbol_string(buf, end, ptr, field_width, precision, flags);
 	case 'R':
 		return resource_string(buf, end, ptr, field_width, precision, flags);
+	case 'P':
+		return phys_addr_string(buf, end, ptr, field_width, precision, flags);
 	}
 	flags |= SMALL;
 	if (field_width == -1) {
@@ -627,6 +644,7 @@ static char *pointer(const char *fmt, char *buf, char *end, void *ptr, int field
  * %pS output the name of a text symbol
  * %pF output the name of a function pointer
  * %pR output the address range in a struct resource
+ * %pP output the address in a pointer to a phys_addr_t type
  *
  * The return value is the number of characters which would
  * be generated for the given input, excluding the trailing

commit 0d391458be88baf3c079e60c3ea331ebe12902c0
Author: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date:   Mon Oct 20 15:07:37 2008 +1100

    pci: use new %pR to print resource ranges
    
    This converts things in drivers/pci to use %pR to printout the
    content of a struct resource instead of hand-casted %llx or
    other variants.
    
    Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index c9884bb..dbe9f39 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1358,11 +1358,10 @@ int pci_request_region(struct pci_dev *pdev, int bar, const char *res_name)
 	return 0;
 
 err_out:
-	dev_warn(&pdev->dev, "BAR %d: can't reserve %s region [%#llx-%#llx]\n",
+	dev_warn(&pdev->dev, "BAR %d: can't reserve %s region %pR\n",
 		 bar,
 		 pci_resource_flags(pdev, bar) & IORESOURCE_IO ? "I/O" : "mem",
-		 (unsigned long long)pci_resource_start(pdev, bar),
-		 (unsigned long long)pci_resource_end(pdev, bar));
+		 &pdev->resource[bar]);
 	return -EBUSY;
 }
 
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index dd9161a..d3db8b2 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -304,9 +304,8 @@ static int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 		} else {
 			res->start = l64;
 			res->end = l64 + sz64;
-			printk(KERN_DEBUG "PCI: %s reg %x 64bit mmio: [%llx, %llx]\n",
-				pci_name(dev), pos, (unsigned long long)res->start,
-				(unsigned long long)res->end);
+			printk(KERN_DEBUG "PCI: %s reg %x 64bit mmio: %pR\n",
+				pci_name(dev), pos, res);
 		}
 	} else {
 		sz = pci_size(l, sz, mask);
@@ -316,9 +315,10 @@ static int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 
 		res->start = l;
 		res->end = l + sz;
-		printk(KERN_DEBUG "PCI: %s reg %x %s: [%llx, %llx]\n", pci_name(dev),
-			pos, (res->flags & IORESOURCE_IO) ? "io port":"32bit mmio",
-			(unsigned long long)res->start, (unsigned long long)res->end);
+		printk(KERN_DEBUG "PCI: %s reg %x %s: %pR\n",
+		       pci_name(dev), pos,
+		       (res->flags & IORESOURCE_IO) ? "io port":"32bit mmio",
+		       res);
 	}
 
  out:
@@ -389,9 +389,8 @@ void __devinit pci_read_bridge_bases(struct pci_bus *child)
 			res->start = base;
 		if (!res->end)
 			res->end = limit + 0xfff;
-		printk(KERN_DEBUG "PCI: bridge %s io port: [%llx, %llx]\n",
-			pci_name(dev), (unsigned long long) res->start,
-			(unsigned long long) res->end);
+		printk(KERN_DEBUG "PCI: bridge %s io port: %pR\n",
+		       pci_name(dev), res);
 	}
 
 	res = child->resource[1];
@@ -403,9 +402,8 @@ void __devinit pci_read_bridge_bases(struct pci_bus *child)
 		res->flags = (mem_base_lo & PCI_MEMORY_RANGE_TYPE_MASK) | IORESOURCE_MEM;
 		res->start = base;
 		res->end = limit + 0xfffff;
-		printk(KERN_DEBUG "PCI: bridge %s 32bit mmio: [%llx, %llx]\n",
-			pci_name(dev), (unsigned long long) res->start,
-			(unsigned long long) res->end);
+		printk(KERN_DEBUG "PCI: bridge %s 32bit mmio: %pR\n",
+		       pci_name(dev), res);
 	}
 
 	res = child->resource[2];
@@ -441,9 +439,9 @@ void __devinit pci_read_bridge_bases(struct pci_bus *child)
 		res->flags = (mem_base_lo & PCI_MEMORY_RANGE_TYPE_MASK) | IORESOURCE_MEM | IORESOURCE_PREFETCH;
 		res->start = base;
 		res->end = limit + 0xfffff;
-		printk(KERN_DEBUG "PCI: bridge %s %sbit mmio pref: [%llx, %llx]\n",
-			pci_name(dev), (res->flags & PCI_PREF_RANGE_TYPE_64) ? "64" : "32",
-			(unsigned long long) res->start, (unsigned long long) res->end);
+		printk(KERN_DEBUG "PCI: bridge %s %sbit mmio pref: %pR\n",
+		       pci_name(dev),
+		       (res->flags & PCI_PREF_RANGE_TYPE_64) ? "64":"32", res);
 	}
 }
 
diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index d5e2106..471a429 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -356,10 +356,7 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask, unsigned long
 			order = __ffs(align) - 20;
 			if (order > 11) {
 				dev_warn(&dev->dev, "BAR %d bad alignment %llx: "
-				       "%#016llx-%#016llx\n", i,
-				       (unsigned long long)align,
-				       (unsigned long long)r->start,
-				       (unsigned long long)r->end);
+					 "%pR\n", i, (unsigned long long)align, r);
 				r->flags = 0;
 				continue;
 			}
@@ -539,11 +536,9 @@ static void pci_bus_dump_res(struct pci_bus *bus)
                 if (!res)
                         continue;
 
-		printk(KERN_INFO "bus: %02x index %x %s: [%llx, %llx]\n",
-			bus->number, i,
-			(res->flags & IORESOURCE_IO) ? "io port" : "mmio",
-			(unsigned long long) res->start,
-			(unsigned long long) res->end);
+		printk(KERN_INFO "bus: %02x index %x %s: %pR\n",
+		       bus->number, i,
+		       (res->flags & IORESOURCE_IO) ? "io port" : "mmio", res);
         }
 }
 
diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index 1a5fc83..d4b5c69 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -49,10 +49,8 @@ void pci_update_resource(struct pci_dev *dev, struct resource *res, int resno)
 
 	pcibios_resource_to_bus(dev, &region, res);
 
-	dev_dbg(&dev->dev, "BAR %d: got res [%#llx-%#llx] bus [%#llx-%#llx] "
-		"flags %#lx\n", resno,
-		 (unsigned long long)res->start,
-		 (unsigned long long)res->end,
+	dev_dbg(&dev->dev, "BAR %d: got res %pR bus [%#llx-%#llx] "
+		"flags %#lx\n", resno, res,
 		 (unsigned long long)region.start,
 		 (unsigned long long)region.end,
 		 (unsigned long)res->flags);
@@ -114,13 +112,11 @@ int pci_claim_resource(struct pci_dev *dev, int resource)
 		err = insert_resource(root, res);
 
 	if (err) {
-		dev_err(&dev->dev, "BAR %d: %s of %s [%#llx-%#llx]\n",
+		dev_err(&dev->dev, "BAR %d: %s of %s %pR\n",
 			resource,
 			root ? "address space collision on" :
 				"no parent found for",
-			dtype,
-			(unsigned long long)res->start,
-			(unsigned long long)res->end);
+			dtype, res);
 	}
 
 	return err;
@@ -139,9 +135,8 @@ int pci_assign_resource(struct pci_dev *dev, int resno)
 	align = resource_alignment(res);
 	if (!align) {
 		dev_err(&dev->dev, "BAR %d: can't allocate resource (bogus "
-			"alignment) [%#llx-%#llx] flags %#lx\n",
-			resno, (unsigned long long)res->start,
-			(unsigned long long)res->end, res->flags);
+			"alignment) %pR flags %#lx\n",
+			resno, res, res->flags);
 		return -EINVAL;
 	}
 
@@ -162,11 +157,8 @@ int pci_assign_resource(struct pci_dev *dev, int resno)
 	}
 
 	if (ret) {
-		dev_err(&dev->dev, "BAR %d: can't allocate %s resource "
-			"[%#llx-%#llx]\n", resno,
-			res->flags & IORESOURCE_IO ? "I/O" : "mem",
-			(unsigned long long)res->start,
-			(unsigned long long)res->end);
+		dev_err(&dev->dev, "BAR %d: can't allocate %s resource %pR\n",
+			resno, res->flags & IORESOURCE_IO ? "I/O" : "mem", res);
 	} else {
 		res->flags &= ~IORESOURCE_STARTALIGN;
 		if (resno < PCI_BRIDGE_RESOURCES)
@@ -202,11 +194,8 @@ int pci_assign_resource_fixed(struct pci_dev *dev, int resno)
 	}
 
 	if (ret) {
-		dev_err(&dev->dev, "BAR %d: can't allocate %s resource "
-			"[%#llx-%#llx\n]", resno,
-			res->flags & IORESOURCE_IO ? "I/O" : "mem",
-			(unsigned long long)res->start,
-			(unsigned long long)res->end);
+		dev_err(&dev->dev, "BAR %d: can't allocate %s resource %pR\n",
+			resno, res->flags & IORESOURCE_IO ? "I/O" : "mem", res);
 	} else if (resno < PCI_BRIDGE_RESOURCES) {
 		pci_update_resource(dev, res, resno);
 	}
@@ -237,9 +226,8 @@ void pdev_sort_resources(struct pci_dev *dev, struct resource_list *head)
 		r_align = resource_alignment(r);
 		if (!r_align) {
 			dev_warn(&dev->dev, "BAR %d: bogus alignment "
-				"[%#llx-%#llx] flags %#lx\n",
-				i, (unsigned long long)r->start,
-				(unsigned long long)r->end, r->flags);
+				"%pR flags %#lx\n",
+				i, r, r->flags);
 			continue;
 		}
 		for (list = head; ; list = list->next) {
@@ -287,9 +275,7 @@ int pci_enable_resources(struct pci_dev *dev, int mask)
 
 		if (!r->parent) {
 			dev_err(&dev->dev, "device not available because of "
-				"BAR %d [%#llx-%#llx] collisions\n", i,
-				(unsigned long long) r->start,
-				(unsigned long long) r->end);
+				"BAR %d %pR collisions\n", i, r);
 			return -EINVAL;
 		}
 

commit c21f132b1eca94808fe72b31aa159c7f0ad61d25
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon Oct 20 15:07:34 2008 +1100

    vsprintf: implement %pR to print struct resource content
    
    Add a %pR option to the kernel vsnprintf that prints the range of
    addresses inside a struct resource passed by pointer.
    
    Padding now defaults to 4 digits for IO and 8 for MEM
    
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
    Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index cceecb6..a013bbc 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -24,6 +24,7 @@
 #include <linux/kernel.h>
 #include <linux/kallsyms.h>
 #include <linux/uaccess.h>
+#include <linux/ioport.h>
 
 #include <asm/page.h>		/* for PAGE_SIZE */
 #include <asm/div64.h>
@@ -550,18 +551,51 @@ static char *symbol_string(char *buf, char *end, void *ptr, int field_width, int
 #endif
 }
 
+static char *resource_string(char *buf, char *end, struct resource *res, int field_width, int precision, int flags)
+{
+#ifndef IO_RSRC_PRINTK_SIZE
+#define IO_RSRC_PRINTK_SIZE	4
+#endif
+
+#ifndef MEM_RSRC_PRINTK_SIZE
+#define MEM_RSRC_PRINTK_SIZE	8
+#endif
+
+	/* room for the actual numbers, the two "0x", -, [, ] and the final zero */
+	char sym[4*sizeof(resource_size_t) + 8];
+	char *p = sym, *pend = sym + sizeof(sym);
+	int size = -1;
+
+	if (res->flags & IORESOURCE_IO)
+		size = IO_RSRC_PRINTK_SIZE;
+	else if (res->flags & IORESOURCE_MEM)
+		size = MEM_RSRC_PRINTK_SIZE;
+
+	*p++ = '[';
+	p = number(p, pend, res->start, 16, size, -1, SPECIAL | SMALL | ZEROPAD);
+	*p++ = '-';
+	p = number(p, pend, res->end, 16, size, -1, SPECIAL | SMALL | ZEROPAD);
+	*p++ = ']';
+	*p = 0;
+
+	return string(buf, end, sym, field_width, precision, flags);
+}
+
 /*
  * Show a '%p' thing.  A kernel extension is that the '%p' is followed
  * by an extra set of alphanumeric characters that are extended format
  * specifiers.
  *
- * Right now we just handle 'F' (for symbolic Function descriptor pointers)
- * and 'S' (for Symbolic direct pointers), but this can easily be
- * extended in the future (network address types etc).
+ * Right now we handle:
+ *
+ * - 'F' For symbolic function descriptor pointers
+ * - 'S' For symbolic direct pointers
+ * - 'R' For a struct resource pointer, it prints the range of
+ *       addresses (not the name nor the flags)
  *
- * The difference between 'S' and 'F' is that on ia64 and ppc64 function
- * pointers are really function descriptors, which contain a pointer the
- * real address. 
+ * Note: The difference between 'S' and 'F' is that on ia64 and ppc64
+ * function pointers are really function descriptors, which contain a
+ * pointer to the real address.
  */
 static char *pointer(const char *fmt, char *buf, char *end, void *ptr, int field_width, int precision, int flags)
 {
@@ -571,6 +605,8 @@ static char *pointer(const char *fmt, char *buf, char *end, void *ptr, int field
 		/* Fallthrough */
 	case 'S':
 		return symbol_string(buf, end, ptr, field_width, precision, flags);
+	case 'R':
+		return resource_string(buf, end, ptr, field_width, precision, flags);
 	}
 	flags |= SMALL;
 	if (field_width == -1) {
@@ -590,6 +626,7 @@ static char *pointer(const char *fmt, char *buf, char *end, void *ptr, int field
  * This function follows C99 vsnprintf, but has some extensions:
  * %pS output the name of a text symbol
  * %pF output the name of a function pointer
+ * %pR output the address range in a struct resource
  *
  * The return value is the number of characters which would
  * be generated for the given input, excluding the trailing
