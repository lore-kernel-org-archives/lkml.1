Return-Path: <linux-kernel-owner+w=401wt.eu-S1755451AbXLBLWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbXLBLWt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 06:22:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbXLBLWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 06:22:40 -0500
Received: from asia.telenet-ops.be ([195.130.137.74]:56547 "EHLO
	asia.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbXLBLWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 06:22:37 -0500
Date: Sun, 2 Dec 2007 12:22:31 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Pierre Ossman <drzeus@drzeus.cx>
Cc: Al Viro <viro@ftp.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, Marcel Holtmann <marcel@holtmann.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-arch@vger.kernel.org
Subject: Correct types for mod_devicetable.h (was: Re: m68k build failure)
In-Reply-To: <20071201215602.7a4710d9@poseidon.drzeus.cx>
Message-ID: <Pine.LNX.4.64.0712021219430.29349@anakin>
References: <20071127220723.e2e3d0b4.akpm@linux-foundation.org>
 <20071128094856.056c0a3f@poseidon.drzeus.cx> <20071128010056.85703a34.akpm@linux-foundation.org>
 <20071128092856.GV8181@ftp.linux.org.uk> <20071128132916.125e72ec@poseidon.drzeus.cx>
 <Pine.LNX.4.64.0711281332350.29243@anakin> <20071201215602.7a4710d9@poseidon.drzeus.cx>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Dec 2007, Pierre Ossman wrote:
> On Wed, 28 Nov 2007 13:34:02 +0100 (CET)
> Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> 
> > On Wed, 28 Nov 2007, Pierre Ossman wrote:
> > > 
> > > Is there no directive we can stick in there that forces a reasonable alignment (e.g. alignment == sizeof(type)) independently of arch?
> > 
> > We could use something like is used for compat_*.
> > E.g. compare compat_s64 in <asm/compat.h> for x86 and powerpc.
> > 
> 
> Yeah, that could work. Have a header with stuff like this:
> 
> typedef u16 __attribute__((aligned(2))) aligned_u16;
> typedef u32 __attribute__((aligned(4))) aligned_u32;
> 
> and let all structures in mod_devicetable.h use those types.
> 
> Now does anyone have the time to code and test this?

I gave it a try:
  - Remove existing alignment attributes from some device_id types
  - Introduce kernel_* types with proper size and alignment for
    cross-compilation (sample <asm/kerneltypes.h> for m68k included)
  - Introduce BITS_PER_KERNEL_LONG, to make it clearer it applies to the target

Apart from a cross-compile session for m68k, it's untested.

diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index e9fddb4..e1f98b1 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -10,15 +10,22 @@
 #ifdef __KERNEL__
 #include <linux/types.h>
 typedef unsigned long kernel_ulong_t;
+typedef u8 kernel_u8;
+typedef u16 kernel_u16;
+typedef u32 kernel_u32;
+#define BITS_PER_KERNEL_LONG	BITS_PER_LONG
 #endif
 
 #define PCI_ANY_ID (~0)
 
 struct pci_device_id {
-	__u32 vendor, device;		/* Vendor and device ID or PCI_ANY_ID*/
-	__u32 subvendor, subdevice;	/* Subsystem ID's or PCI_ANY_ID */
-	__u32 class, class_mask;	/* (class,subclass,prog-if) triplet */
-	kernel_ulong_t driver_data;	/* Data private to the driver */
+	kernel_u32	vendor;		/* Vendor ID or PCI_ANY_ID*/
+	kernel_u32	device;		/* Device ID or PCI_ANY_ID*/
+	kernel_u32	subvendor;	/* Subsystem ID or PCI_ANY_ID */
+	kernel_u32	subdevice;	/* Subsystem ID or PCI_ANY_ID */
+	kernel_u32	class;		/* (class,subclass,prog-if) triplet */
+	kernel_u32	class_mask;	/* (class,subclass,prog-if) triplet */
+	kernel_ulong_t	driver_data;	/* Data private to the driver */
 };
 
 
@@ -28,13 +35,12 @@ struct pci_device_id {
 #define IEEE1394_MATCH_VERSION		0x0008
 
 struct ieee1394_device_id {
-	__u32 match_flags;
-	__u32 vendor_id;
-	__u32 model_id;
-	__u32 specifier_id;
-	__u32 version;
-	kernel_ulong_t driver_data
-		__attribute__((aligned(sizeof(kernel_ulong_t))));
+	kernel_u32	match_flags;
+	kernel_u32	vendor_id;
+	kernel_u32	model_id;
+	kernel_u32	specifier_id;
+	kernel_u32	version;
+	kernel_ulong_t	driver_data;
 };
 
 
@@ -97,23 +103,23 @@ struct ieee1394_device_id {
  */
 struct usb_device_id {
 	/* which fields to match against? */
-	__u16		match_flags;
+	kernel_u16	match_flags;
 
 	/* Used for product specific matches; range is inclusive */
-	__u16		idVendor;
-	__u16		idProduct;
-	__u16		bcdDevice_lo;
-	__u16		bcdDevice_hi;
+	kernel_u16	idVendor;
+	kernel_u16	idProduct;
+	kernel_u16	bcdDevice_lo;
+	kernel_u16	bcdDevice_hi;
 
 	/* Used for device class matches */
-	__u8		bDeviceClass;
-	__u8		bDeviceSubClass;
-	__u8		bDeviceProtocol;
+	kernel_u8	bDeviceClass;
+	kernel_u8	bDeviceSubClass;
+	kernel_u8	bDeviceProtocol;
 
 	/* Used for interface class matches */
-	__u8		bInterfaceClass;
-	__u8		bInterfaceSubClass;
-	__u8		bInterfaceProtocol;
+	kernel_u8	bInterfaceClass;
+	kernel_u8	bInterfaceSubClass;
+	kernel_u8	bInterfaceProtocol;
 
 	/* not matched against */
 	kernel_ulong_t	driver_info;
@@ -133,12 +139,12 @@ struct usb_device_id {
 
 /* s390 CCW devices */
 struct ccw_device_id {
-	__u16	match_flags;	/* which fields to match against */
+	kernel_u16	match_flags;	/* which fields to match against */
 
-	__u16	cu_type;	/* control unit type     */
-	__u16	dev_type;	/* device type           */
-	__u8	cu_model;	/* control unit model    */
-	__u8	dev_model;	/* device model          */
+	kernel_u16	cu_type;	/* control unit type     */
+	kernel_u16	dev_type;	/* device type           */
+	kernel_u8	cu_model;	/* control unit model    */
+	kernel_u8	dev_model;	/* device model          */
 
 	kernel_ulong_t driver_info;
 };
@@ -150,11 +156,11 @@ struct ccw_device_id {
 
 /* s390 AP bus devices */
 struct ap_device_id {
-	__u16 match_flags;	/* which fields to match against */
-	__u8 dev_type;		/* device type */
-	__u8 pad1;
-	__u32 pad2;
-	kernel_ulong_t driver_info;
+	kernel_u16	match_flags;	/* which fields to match against */
+	kernel_u8	dev_type;	/* device type */
+	kernel_u8	pad1;
+	kernel_u32	pad2;
+	kernel_ulong_t	driver_info;
 };
 
 #define AP_DEVICE_ID_MATCH_DEVICE_TYPE		0x01
@@ -163,23 +169,23 @@ struct ap_device_id {
 			   /* to workaround crosscompile issues */
 
 struct acpi_device_id {
-	__u8 id[ACPI_ID_LEN];
-	kernel_ulong_t driver_data;
+	kernel_u8	id[ACPI_ID_LEN];
+	kernel_ulong_t	driver_data;
 };
 
 #define PNP_ID_LEN	8
 #define PNP_MAX_DEVICES	8
 
 struct pnp_device_id {
-	__u8 id[PNP_ID_LEN];
-	kernel_ulong_t driver_data;
+	kernel_u8	id[PNP_ID_LEN];
+	kernel_ulong_t	driver_data;
 };
 
 struct pnp_card_device_id {
-	__u8 id[PNP_ID_LEN];
-	kernel_ulong_t driver_data;
+	kernel_u8	id[PNP_ID_LEN];
+	kernel_ulong_t	driver_data;
 	struct {
-		__u8 id[PNP_ID_LEN];
+		kernel_u8	id[PNP_ID_LEN];
 	} devs[PNP_MAX_DEVICES];
 };
 
@@ -187,10 +193,10 @@ struct pnp_card_device_id {
 #define SERIO_ANY	0xff
 
 struct serio_device_id {
-	__u8 type;
-	__u8 extra;
-	__u8 id;
-	__u8 proto;
+	kernel_u8	type;
+	kernel_u8	extra;
+	kernel_u8	id;
+	kernel_u8	proto;
 };
 
 /*
@@ -198,47 +204,45 @@ struct serio_device_id {
  */
 struct of_device_id
 {
-	char	name[32];
-	char	type[32];
-	char	compatible[128];
+	char		name[32];
+	char		type[32];
+	char		compatible[128];
 #ifdef __KERNEL__
-	void	*data;
+	void *		data;
 #else
-	kernel_ulong_t data;
+	kernel_ulong_t	data;
 #endif
 };
 
 /* VIO */
 struct vio_device_id {
-	char type[32];
-	char compat[32];
+	char		type[32];
+	char		compat[32];
 };
 
 /* PCMCIA */
 
 struct pcmcia_device_id {
-	__u16		match_flags;
+	kernel_u16	match_flags;
 
-	__u16		manf_id;
-	__u16 		card_id;
+	kernel_u16	manf_id;
+	kernel_u16	card_id;
 
-	__u8  		func_id;
+	kernel_u8	func_id;
 
 	/* for real multi-function devices */
-	__u8  		function;
+	kernel_u8	function;
 
 	/* for pseudo multi-function devices */
-	__u8  		device_no;
+	kernel_u8	device_no;
 
-	__u32 		prod_id_hash[4]
-		__attribute__((aligned(sizeof(__u32))));
+	kernel_u32	prod_id_hash[4];
 
 	/* not matched against in kernelspace*/
 #ifdef __KERNEL__
 	const char *	prod_id[4];
 #else
-	kernel_ulong_t	prod_id[4]
-		__attribute__((aligned(sizeof(kernel_ulong_t))));
+	kernel_ulong_t	prod_id[4];
 #endif
 
 	/* not matched against */
@@ -291,24 +295,24 @@ struct pcmcia_device_id {
 
 struct input_device_id {
 
-	kernel_ulong_t flags;
+	kernel_ulong_t	flags;
 
-	__u16 bustype;
-	__u16 vendor;
-	__u16 product;
-	__u16 version;
+	kernel_u16	bustype;
+	kernel_u16	vendor;
+	kernel_u16	product;
+	kernel_u16	version;
 
-	kernel_ulong_t evbit[INPUT_DEVICE_ID_EV_MAX / BITS_PER_LONG + 1];
-	kernel_ulong_t keybit[INPUT_DEVICE_ID_KEY_MAX / BITS_PER_LONG + 1];
-	kernel_ulong_t relbit[INPUT_DEVICE_ID_REL_MAX / BITS_PER_LONG + 1];
-	kernel_ulong_t absbit[INPUT_DEVICE_ID_ABS_MAX / BITS_PER_LONG + 1];
-	kernel_ulong_t mscbit[INPUT_DEVICE_ID_MSC_MAX / BITS_PER_LONG + 1];
-	kernel_ulong_t ledbit[INPUT_DEVICE_ID_LED_MAX / BITS_PER_LONG + 1];
-	kernel_ulong_t sndbit[INPUT_DEVICE_ID_SND_MAX / BITS_PER_LONG + 1];
-	kernel_ulong_t ffbit[INPUT_DEVICE_ID_FF_MAX / BITS_PER_LONG + 1];
-	kernel_ulong_t swbit[INPUT_DEVICE_ID_SW_MAX / BITS_PER_LONG + 1];
+	kernel_ulong_t	evbit[INPUT_DEVICE_ID_EV_MAX / BITS_PER_KERNEL_LONG + 1];
+	kernel_ulong_t	keybit[INPUT_DEVICE_ID_KEY_MAX / BITS_PER_KERNEL_LONG + 1];
+	kernel_ulong_t	relbit[INPUT_DEVICE_ID_REL_MAX / BITS_PER_KERNEL_LONG + 1];
+	kernel_ulong_t	absbit[INPUT_DEVICE_ID_ABS_MAX / BITS_PER_KERNEL_LONG + 1];
+	kernel_ulong_t	mscbit[INPUT_DEVICE_ID_MSC_MAX / BITS_PER_KERNEL_LONG + 1];
+	kernel_ulong_t	ledbit[INPUT_DEVICE_ID_LED_MAX / BITS_PER_KERNEL_LONG + 1];
+	kernel_ulong_t	sndbit[INPUT_DEVICE_ID_SND_MAX / BITS_PER_KERNEL_LONG + 1];
+	kernel_ulong_t	ffbit[INPUT_DEVICE_ID_FF_MAX / BITS_PER_KERNEL_LONG + 1];
+	kernel_ulong_t	swbit[INPUT_DEVICE_ID_SW_MAX / BITS_PER_KERNEL_LONG + 1];
 
-	kernel_ulong_t driver_info;
+	kernel_ulong_t	driver_info;
 };
 
 /* EISA */
@@ -317,17 +321,17 @@ struct input_device_id {
 
 /* The EISA signature, in ASCII form, null terminated */
 struct eisa_device_id {
-	char          sig[EISA_SIG_LEN];
-	kernel_ulong_t driver_data;
+	char		sig[EISA_SIG_LEN];
+	kernel_ulong_t	driver_data;
 };
 
 #define EISA_DEVICE_MODALIAS_FMT "eisa:s%s"
 
 struct parisc_device_id {
-	__u8	hw_type;	/* 5 bits used */
-	__u8	hversion_rev;	/* 4 bits */
-	__u16	hversion;	/* 12 bits */
-	__u32	sversion;	/* 20 bits */
+	kernel_u8	hw_type;	/* 5 bits used */
+	kernel_u8	hversion_rev;	/* 4 bits */
+	kernel_u16	hversion;	/* 12 bits */
+	kernel_u32	sversion;	/* 20 bits */
 };
 
 #define PA_HWTYPE_ANY_ID	0xff
@@ -340,17 +344,17 @@ struct parisc_device_id {
 #define SDIO_ANY_ID (~0)
 
 struct sdio_device_id {
-	__u8	class;			/* Standard interface or SDIO_ANY_ID */
-	__u16	vendor;			/* Vendor or SDIO_ANY_ID */
-	__u16	device;			/* Device ID or SDIO_ANY_ID */
-	kernel_ulong_t driver_data;	/* Data private to the driver */
+	kernel_u8	class;		/* Standard interface or SDIO_ANY_ID */
+	kernel_u16	vendor;		/* Vendor or SDIO_ANY_ID */
+	kernel_u16	device;		/* Device ID or SDIO_ANY_ID */
+	kernel_ulong_t	driver_data;	/* Data private to the driver */
 };
 
 /* SSB core, see drivers/ssb/ */
 struct ssb_device_id {
-	__u16	vendor;
-	__u16	coreid;
-	__u8	revision;
+	kernel_u16	vendor;
+	kernel_u16	coreid;
+	kernel_u8	revision;
 };
 #define SSB_DEVICE(_vendor, _coreid, _revision)  \
 	{ .vendor = _vendor, .coreid = _coreid, .revision = _revision, }
@@ -362,8 +366,8 @@ struct ssb_device_id {
 #define SSB_ANY_REV		0xFF
 
 struct virtio_device_id {
-	__u32 device;
-	__u32 vendor;
+	kernel_u32	device;
+	kernel_u32	vendor;
 };
 #define VIRTIO_DEV_ANY_ID	0xffffffff
 
diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index d802b5a..4c95e53 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -12,15 +12,6 @@
 
 #include "modpost.h"
 
-/* We use the ELF typedefs for kernel_ulong_t but bite the bullet and
- * use either stdint.h or inttypes.h for the rest. */
-#if KERNEL_ELFCLASS == ELFCLASS32
-typedef Elf32_Addr	kernel_ulong_t;
-#define BITS_PER_LONG 32
-#else
-typedef Elf64_Addr	kernel_ulong_t;
-#define BITS_PER_LONG 64
-#endif
 #ifdef __sun__
 #include <inttypes.h>
 #else
@@ -29,13 +20,10 @@ typedef Elf64_Addr	kernel_ulong_t;
 
 #include <ctype.h>
 
-typedef uint32_t	__u32;
-typedef uint16_t	__u16;
-typedef unsigned char	__u8;
-
 /* Big exception to the "don't include kernel headers into userspace, which
  * even potentially has different endianness and word sizes, since
  * we handle those differences explicitly below */
+#include "../../include/asm/kerneltypes.h"
 #include "../../include/linux/mod_devicetable.h"
 
 #define ADD(str, sep, cond, field)                              \
@@ -422,7 +410,8 @@ static void do_input(char *alias,
 	unsigned int i;
 
 	for (i = min; i < max; i++)
-		if (arr[i / BITS_PER_LONG] & (1L << (i%BITS_PER_LONG)))
+		if (arr[i / BITS_PER_KERNEL_LONG] &
+		    (1L << (i%BITS_PER_KERNEL_LONG)))
 			sprintf(alias + strlen(alias), "%X,*", i);
 }
 
@@ -504,9 +493,9 @@ static int do_sdio_entry(const char *filename,
 	id->device = TO_NATIVE(id->device);
 
 	strcpy(alias, "sdio:");
-	ADD(alias, "c", id->class != (__u8)SDIO_ANY_ID, id->class);
-	ADD(alias, "v", id->vendor != (__u16)SDIO_ANY_ID, id->vendor);
-	ADD(alias, "d", id->device != (__u16)SDIO_ANY_ID, id->device);
+	ADD(alias, "c", id->class != (kernel_u8)SDIO_ANY_ID, id->class);
+	ADD(alias, "v", id->vendor != (kernel_u16)SDIO_ANY_ID, id->vendor);
+	ADD(alias, "d", id->device != (kernel_u16)SDIO_ANY_ID, id->device);
 	return 1;
 }
 
--- /dev/null	2007-11-25 11:21:46.692011602 +0100
+++ b/include/asm-m68k/kerneltypes.h	2007-12-02 12:03:25.000000000 +0100
@@ -0,0 +1,17 @@
+#ifndef _ASM_M68K_KERNELTYPES_H
+#define _ASM_M68K_KERNELTYPES_H
+
+/*
+ * Architecture specific types and alignment, suitable for cross-compiling
+ */
+
+#include <stdint.h>
+
+typedef uint32_t __attribute__((aligned(2))) kernel_ulong_t;
+typedef uint8_t __attribute__((aligned(1))) kernel_u8;
+typedef uint16_t __attribute__((aligned(2))) kernel_u16;
+typedef uint32_t __attribute__((aligned(2))) kernel_u32;
+
+#define BITS_PER_KERNEL_LONG	32
+
+#endif /* _ASM_M68K_KERNELTYPES_H */

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
