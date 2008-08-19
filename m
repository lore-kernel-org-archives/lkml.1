Return-Path: <linux-kernel-owner+w=401wt.eu-S1755948AbYHSAev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948AbYHSAev (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 20:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753258AbYHSAen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 20:34:43 -0400
Received: from web82104.mail.mud.yahoo.com ([209.191.84.217]:20386 "HELO
	web82104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752314AbYHSAem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 20:34:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=OywTRfgdY8qEnccgZBo6BgEoIwGbf62rF40cT+ClkJsWVbxA2JDBGWFkA0C9JwutjhN/6pRS4zSThTXl6wb/zbxrx6UnosC4X7i4INRDL4N17/oFU69+v5hIXjswPMJG6oG755cKXI0KlB5LyfJlyWxmTLBVgMp9/p1j8zwdjt0=;
X-Mailer: YahooMailRC/1042.40 YahooMailWebService/0.7.218
Date: Mon, 18 Aug 2008 17:34:41 -0700 (PDT)
From: David Witbrodt <dawitbro@sbcglobal.net>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- connection between HPET and lockups found
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       netdev <netdev@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <887650.67133.qm@web82104.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


As part of my experiments to determine the root cause of my lockups,
I was searching through the kernel sources trying to discover any
connection between the changes in the commits introducing the lockups
(3def3d6d... and 1e934dda...) and the fact that "hpet=disable" 
alleviates the lockups.

I finally discovered something that looks promising!


Both of those commits introduce changes involving insert_resource(),
and I found the function hpet_insert_resource() in
arch/x86/kernel/acpi/boot.c that also uses insert_resource():

static __init int hpet_insert_resource(void)
{
        if (!hpet_res)
                return 1;

        return insert_resource(&iomem_resource, hpet_res);
}


The effect of "hpet=disable" is to prevent the hpet_res pointer,

    static struct __initdata resource *hpet_res;

from being attached to memory, keeping it NULL and causing the
return value to indicate that the HPET resource was not assigned.

When not using "hpet=disable", the memory location of hpet_res
is added to the iomem_resource tree.  The code that obtains the
memory for hpet_res is in the same file, in the lines immediately
preceding:

static int __init acpi_parse_hpet(struct acpi_table_header *table)
{
        struct acpi_table_hpet *hpet_tbl;

...
#define HPET_RESOURCE_NAME_SIZE 9
        hpet_res = alloc_bootmem(sizeof(*hpet_res) + HPET_RESOURCE_NAME_SIZE);

...
        return 0;
}


Trying to discover if something was going haywire in this part of the code,
I tried to capture some data which I could save until just before the kernel
locks so that I could printk() it and still see it without having it scroll
off the top:

===== BEGIN DIFF ==========
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 9d3528c..c4670a6 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -644,6 +644,11 @@ static int __init acpi_parse_sbf(struct acpi_table_header *table)
 
 static struct __initdata resource *hpet_res;
 
+extern void *dw_hpet_res;
+extern int dw_broken_bios;
+extern unsigned dw_seq;
+extern unsigned dw_req_size;
+
 static int __init acpi_parse_hpet(struct acpi_table_header *table)
 {
     struct acpi_table_hpet *hpet_tbl;
@@ -672,6 +677,9 @@ static int __init acpi_parse_hpet(struct acpi_table_header *table)
                hpet_tbl->id, hpet_address);
         return 0;
     }
+
+    dw_broken_bios = 0;
+
 #ifdef CONFIG_X86_64
     /*
      * Some even more broken BIOSes advertise HPET at
@@ -679,6 +687,8 @@ static int __init acpi_parse_hpet(struct acpi_table_header *table)
      * some noise:
      */
     if (hpet_address == 0xfed0000000000000UL) {
+            dw_broken_bios = 1;
+
         if (!hpet_force_user) {
             printk(KERN_WARNING PREFIX "HPET id: %#x "
                    "base: 0xfed0000000000000 is bogus\n "
@@ -702,12 +712,15 @@ static int __init acpi_parse_hpet(struct acpi_table_header *table)
      */
 #define HPET_RESOURCE_NAME_SIZE 9
     hpet_res = alloc_bootmem(sizeof(*hpet_res) + HPET_RESOURCE_NAME_SIZE);
+    dw_hpet_res = hpet_res;
+    dw_req_size = sizeof (*hpet_res) + HPET_RESOURCE_NAME_SIZE;
 
     hpet_res->name = (void *)&hpet_res[1];
     hpet_res->flags = IORESOURCE_MEM;
     snprintf((char *)hpet_res->name, HPET_RESOURCE_NAME_SIZE, "HPET %u",
          hpet_tbl->sequence);
 
+    dw_seq = hpet_tbl->sequence;
     hpet_res->start = hpet_address;
     hpet_res->end = hpet_address + (1 * 1024) - 1;
 
@@ -718,12 +731,19 @@ static int __init acpi_parse_hpet(struct acpi_table_header *table)
  * hpet_insert_resource inserts the HPET resources used into the resource
  * tree.
  */
+extern int dw_ir_retval;
+
 static __init int hpet_insert_resource(void)
 {
+        int retval;
+
     if (!hpet_res)
         return 1;
 
-    return insert_resource(&iomem_resource, hpet_res);
+    retval = insert_resource(&iomem_resource, hpet_res);
+    dw_ir_retval = retval;
+
+    return retval;
 }
 
 late_initcall(hpet_insert_resource);
diff --git a/net/core/dev.c b/net/core/dev.c
index 600bb23..fe27b94 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4304,10 +4304,21 @@ void free_netdev(struct net_device *dev)
     put_device(&dev->dev);
 }
 
+void *dw_hpet_res;
+int dw_broken_bios;
+unsigned dw_seq;
+int dw_ir_retval;
+unsigned dw_req_size;
+
 /* Synchronize with packet receive processing. */
 void synchronize_net(void)
 {
     might_sleep();
+
+    printk ("Data from arch/x86/kernel/acpi/boot.c:\n");
+    printk ("  hpet_res = %p    requested size: %u\n", dw_hpet_res, dw_req_size);
+    printk ("  sequence = %u    insert_resource() returned:  %d\n", dw_seq, dw_ir_retval);
+        printk ("  broken_bios: %d\n", dw_broken_bios);
     synchronize_rcu();
 }
===== END DIFF ==========


The output I get when the kernel locks up looks perfectly OK, except
maybe for the address of hpet_res (which I am not knowledgeable enough
to judge):

Data from arch/x86/kernel/acpi/boot.c:
  hpet_res = ffff88000100f000    broken_bios: 0
  sequence = 0    insert_resource() returned: 0


I see some recent (Aug. 2008) discussion of alloc_bootmem() being 
broken, so maybe that is related to my problem.

Does this connection between HPET and insert_resource() look meaningful,
or is this a coincidence?


Thanks,
Dave W.
