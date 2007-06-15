Return-Path: <linux-kernel-owner+w=401wt.eu-S1754858AbXFOR5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858AbXFOR5e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 13:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754136AbXFOR5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 13:57:21 -0400
Received: from server001.webpack.hosteurope.de ([80.237.130.9]:44058 "EHLO
	server001.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754024AbXFOR5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 13:57:19 -0400
From: Andi Drebes <lists-receive@programmierforen.de>
To: Len Brown <lenb@kernel.org>
Subject: Re: [KJ] [PATCH] drivers/acpi: sizeof/sizeof array size calculations replaced with ARRAY_SIZE
Date: Fri, 15 Jun 2007 19:56:34 +0200
User-Agent: KMail/1.9.5
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, Pavel Machek <pavel@ucw.cz>,
       Christoph Hellwig <hch@infradead.org>, kernel-janitors@lists.osdl.org,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200705261239.27485.lists-receive@programmierforen.de> <200706122041.06252.lists-receive@programmierforen.de> <200706121253.07395.bjorn.helgaas@hp.com>
In-Reply-To: <200706121253.07395.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706151956.34968.lists-receive@programmierforen.de>
X-bounce-key: webpack.hosteurope.de;lists-receive@programmierforen.de;1181930238;e18ac605;
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

<snip>
> You found the right one.  The ACPI CA in Linux is really the same
> as the one from Intel.
Hmmm. The file that I downloaded recently is acpica-unix-20061109. It seems
to be quite old. There are some differences between the contents
of that archive and the acpi files in the kernel. I hope I really got the right version.

> So it might be a bit easier for
> him if you generated a diff against the Intel version.  Then it
> would show up in Linux, too, in the fullness of time.
Ok. The new patch can be found in this message.
I tried to figure out where to put the definition of the ARRAY_SIZE macro.
I searched a little bit in the include directory, but I couldn't find a place
that satisfied me to a hundred percent. I chose acpi.h, because this
seems to be file that is most general. The problem is, that the file
only consists of lines that include other header files and the newly added
definition for ARRAY_SIZE breaks this consistency in some way. Perhaps
Len could give me a hint where to put it.

Ok, here's the new patch:

Diffed against the intel acpica implementation "acpica-unix-20061109".
Tested by compilation.

Signed-off-by: Andi Drebes <lists-receive@programmierforen.de>
---
diff --git a/include/acpi.h b/include/acpi.h
index ddaeec4..9de744c 100644
--- a/include/acpi.h
+++ b/include/acpi.h
@@ -139,5 +139,11 @@
 #include "achware.h"            /* Hardware defines and interfaces */
 #include "acutils.h"            /* Utility interfaces */
 
+#ifndef ARRAY_SIZE
+/*
+ * ARRAY_SIZE calculates the size of a statically initialized array
+ */
+#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
+#endif
 
 #endif /* __ACPI_H__ */
diff --git a/resources/rsdump.c b/resources/rsdump.c
index 1f90cf7..4eea301 100644
--- a/resources/rsdump.c
+++ b/resources/rsdump.c
@@ -188,8 +188,6 @@ AcpiRsDumpDescriptor (
 
 #define ACPI_RSD_OFFSET(f)          (UINT8) ACPI_OFFSET (ACPI_RESOURCE_DATA,f)
 #define ACPI_PRT_OFFSET(f)          (UINT8) ACPI_OFFSET (ACPI_PCI_ROUTING_TABLE,f)
-#define ACPI_RSD_TABLE_SIZE(name)   (sizeof(name) / sizeof (ACPI_RSDUMP_INFO))
-
 
 /*******************************************************************************
  *
@@ -202,7 +200,7 @@ AcpiRsDumpDescriptor (
 
 ACPI_RSDUMP_INFO        AcpiRsDumpIrq[6] =
 {
-    {ACPI_RSD_TITLE,    ACPI_RSD_TABLE_SIZE (AcpiRsDumpIrq),                "IRQ",                      NULL},
+    {ACPI_RSD_TITLE,    ARRAY_SIZE (AcpiRsDumpIrq),                         "IRQ",                      NULL},
     {ACPI_RSD_1BITFLAG, ACPI_RSD_OFFSET (Irq.Triggering),                   "Triggering",               AcpiGbl_HeDecode},
     {ACPI_RSD_1BITFLAG, ACPI_RSD_OFFSET (Irq.Polarity),                     "Polarity",                 AcpiGbl_LlDecode},
     {ACPI_RSD_1BITFLAG, ACPI_RSD_OFFSET (Irq.Sharable),                     "Sharing",                  AcpiGbl_ShrDecode},
@@ -212,7 +210,7 @@ ACPI_RSDUMP_INFO        AcpiRsDumpIrq[6] =
 
 ACPI_RSDUMP_INFO        AcpiRsDumpDma[6] =
 {
-    {ACPI_RSD_TITLE,    ACPI_RSD_TABLE_SIZE (AcpiRsDumpDma),                "DMA",                      NULL},
+    {ACPI_RSD_TITLE,    ARRAY_SIZE (AcpiRsDumpDma),                         "DMA",                      NULL},
     {ACPI_RSD_2BITFLAG, ACPI_RSD_OFFSET (Dma.Type),                         "Speed",                    AcpiGbl_TypDecode},
     {ACPI_RSD_1BITFLAG, ACPI_RSD_OFFSET (Dma.BusMaster),                    "Mastering",                AcpiGbl_BmDecode},
     {ACPI_RSD_2BITFLAG, ACPI_RSD_OFFSET (Dma.Transfer),                     "Transfer Type",            AcpiGbl_SizDecode},
@@ -222,19 +220,19 @@ ACPI_RSDUMP_INFO        AcpiRsDumpDma[6] =
 
 ACPI_RSDUMP_INFO        AcpiRsDumpStartDpf[3] =
 {
-    {ACPI_RSD_TITLE,    ACPI_RSD_TABLE_SIZE (AcpiRsDumpStartDpf),           "Start-Dependent-Functions",NULL},
+    {ACPI_RSD_TITLE,    ARRAY_SIZE (AcpiRsDumpStartDpf),                    "Start-Dependent-Functions",NULL},
     {ACPI_RSD_2BITFLAG, ACPI_RSD_OFFSET (StartDpf.CompatibilityPriority),   "Compatibility Priority",   AcpiGbl_ConfigDecode},
     {ACPI_RSD_2BITFLAG, ACPI_RSD_OFFSET (StartDpf.PerformanceRobustness),   "Performance/Robustness",   AcpiGbl_ConfigDecode}
 };
 
 ACPI_RSDUMP_INFO        AcpiRsDumpEndDpf[1] =
 {
-    {ACPI_RSD_TITLE,    ACPI_RSD_TABLE_SIZE (AcpiRsDumpEndDpf),             "End-Dependent-Functions",  NULL}
+    {ACPI_RSD_TITLE,    ARRAY_SIZE (AcpiRsDumpEndDpf),                      "End-Dependent-Functions",  NULL}
 };
 
 ACPI_RSDUMP_INFO        AcpiRsDumpIo[6] =
 {
-    {ACPI_RSD_TITLE,    ACPI_RSD_TABLE_SIZE (AcpiRsDumpIo),                 "I/O",                      NULL},
+    {ACPI_RSD_TITLE,    ARRAY_SIZE (AcpiRsDumpIo),                          "I/O",                      NULL},
     {ACPI_RSD_1BITFLAG, ACPI_RSD_OFFSET (Io.IoDecode),                      "Address Decoding",         AcpiGbl_IoDecode},
     {ACPI_RSD_UINT16,   ACPI_RSD_OFFSET (Io.Minimum),                       "Address Minimum",          NULL},
     {ACPI_RSD_UINT16,   ACPI_RSD_OFFSET (Io.Maximum),                       "Address Maximum",          NULL},
@@ -244,26 +242,26 @@ ACPI_RSDUMP_INFO        AcpiRsDumpIo[6] =
 
 ACPI_RSDUMP_INFO        AcpiRsDumpFixedIo[3] =
 {
-    {ACPI_RSD_TITLE,    ACPI_RSD_TABLE_SIZE (AcpiRsDumpFixedIo),            "Fixed I/O",                NULL},
+    {ACPI_RSD_TITLE,    ARRAY_SIZE (AcpiRsDumpFixedIo),                     "Fixed I/O",                NULL},
     {ACPI_RSD_UINT16,   ACPI_RSD_OFFSET (FixedIo.Address),                  "Address",                  NULL},
     {ACPI_RSD_UINT8,    ACPI_RSD_OFFSET (FixedIo.AddressLength),            "Address Length",           NULL}
 };
 
 ACPI_RSDUMP_INFO        AcpiRsDumpVendor[3] =
 {
-    {ACPI_RSD_TITLE,    ACPI_RSD_TABLE_SIZE (AcpiRsDumpVendor),             "Vendor Specific",          NULL},
+    {ACPI_RSD_TITLE,    ARRAY_SIZE (AcpiRsDumpVendor),                      "Vendor Specific",          NULL},
     {ACPI_RSD_UINT16,   ACPI_RSD_OFFSET (Vendor.ByteLength),                "Length",                   NULL},
     {ACPI_RSD_LONGLIST, ACPI_RSD_OFFSET (Vendor.ByteData[0]),               "Vendor Data",              NULL}
 };
 
 ACPI_RSDUMP_INFO        AcpiRsDumpEndTag[1] =
 {
-    {ACPI_RSD_TITLE,    ACPI_RSD_TABLE_SIZE (AcpiRsDumpEndTag),             "EndTag",                   NULL}
+    {ACPI_RSD_TITLE,    ARRAY_SIZE (AcpiRsDumpEndTag),                      "EndTag",                   NULL}
 };
 
 ACPI_RSDUMP_INFO        AcpiRsDumpMemory24[6] =
 {
-    {ACPI_RSD_TITLE,    ACPI_RSD_TABLE_SIZE (AcpiRsDumpMemory24),           "24-Bit Memory Range",      NULL},
+    {ACPI_RSD_TITLE,    ARRAY_SIZE (AcpiRsDumpMemory24),                    "24-Bit Memory Range",      NULL},
     {ACPI_RSD_1BITFLAG, ACPI_RSD_OFFSET (Memory24.WriteProtect),            "Write Protect",            AcpiGbl_RwDecode},
     {ACPI_RSD_UINT16,   ACPI_RSD_OFFSET (Memory24.Minimum),                 "Address Minimum",          NULL},
     {ACPI_RSD_UINT16,   ACPI_RSD_OFFSET (Memory24.Maximum),                 "Address Maximum",          NULL},
@@ -273,7 +271,7 @@ ACPI_RSDUMP_INFO        AcpiRsDumpMemory24[6] =
 
 ACPI_RSDUMP_INFO        AcpiRsDumpMemory32[6] =
 {
-    {ACPI_RSD_TITLE,    ACPI_RSD_TABLE_SIZE (AcpiRsDumpMemory32),           "32-Bit Memory Range",      NULL},
+    {ACPI_RSD_TITLE,    ARRAY_SIZE (AcpiRsDumpMemory32),                    "32-Bit Memory Range",      NULL},
     {ACPI_RSD_1BITFLAG, ACPI_RSD_OFFSET (Memory32.WriteProtect),            "Write Protect",            AcpiGbl_RwDecode},
     {ACPI_RSD_UINT32,   ACPI_RSD_OFFSET (Memory32.Minimum),                 "Address Minimum",          NULL},
     {ACPI_RSD_UINT32,   ACPI_RSD_OFFSET (Memory32.Maximum),                 "Address Maximum",          NULL},
@@ -283,7 +281,7 @@ ACPI_RSDUMP_INFO        AcpiRsDumpMemory32[6] =
 
 ACPI_RSDUMP_INFO        AcpiRsDumpFixedMemory32[4] =
 {
-    {ACPI_RSD_TITLE,    ACPI_RSD_TABLE_SIZE (AcpiRsDumpFixedMemory32),      "32-Bit Fixed Memory Range",NULL},
+    {ACPI_RSD_TITLE,    ARRAY_SIZE (AcpiRsDumpFixedMemory32),               "32-Bit Fixed Memory Range",NULL},
     {ACPI_RSD_1BITFLAG, ACPI_RSD_OFFSET (FixedMemory32.WriteProtect),       "Write Protect",            AcpiGbl_RwDecode},
     {ACPI_RSD_UINT32,   ACPI_RSD_OFFSET (FixedMemory32.Address),            "Address",                  NULL},
     {ACPI_RSD_UINT32,   ACPI_RSD_OFFSET (FixedMemory32.AddressLength),      "Address Length",           NULL}
@@ -291,7 +289,7 @@ ACPI_RSDUMP_INFO        AcpiRsDumpFixedMemory32[4] =
 
 ACPI_RSDUMP_INFO        AcpiRsDumpAddress16[8] =
 {
-    {ACPI_RSD_TITLE,    ACPI_RSD_TABLE_SIZE (AcpiRsDumpAddress16),          "16-Bit WORD Address Space",NULL},
+    {ACPI_RSD_TITLE,    ARRAY_SIZE (AcpiRsDumpAddress16),                   "16-Bit WORD Address Space",NULL},
     {ACPI_RSD_ADDRESS,  0,                                                  NULL,                       NULL},
     {ACPI_RSD_UINT16,   ACPI_RSD_OFFSET (Address16.Granularity),            "Granularity",              NULL},
     {ACPI_RSD_UINT16,   ACPI_RSD_OFFSET (Address16.Minimum),                "Address Minimum",          NULL},
@@ -303,7 +301,7 @@ ACPI_RSDUMP_INFO        AcpiRsDumpAddress16[8] =
 
 ACPI_RSDUMP_INFO        AcpiRsDumpAddress32[8] =
 {
-    {ACPI_RSD_TITLE,    ACPI_RSD_TABLE_SIZE (AcpiRsDumpAddress32),         "32-Bit DWORD Address Space", NULL},
+    {ACPI_RSD_TITLE,    ARRAY_SIZE (AcpiRsDumpAddress32),                   "32-Bit DWORD Address Space", NULL},
     {ACPI_RSD_ADDRESS,  0,                                                  NULL,                       NULL},
     {ACPI_RSD_UINT32,   ACPI_RSD_OFFSET (Address32.Granularity),            "Granularity",              NULL},
     {ACPI_RSD_UINT32,   ACPI_RSD_OFFSET (Address32.Minimum),                "Address Minimum",          NULL},
@@ -315,7 +313,7 @@ ACPI_RSDUMP_INFO        AcpiRsDumpAddress32[8] =
 
 ACPI_RSDUMP_INFO        AcpiRsDumpAddress64[8] =
 {
-    {ACPI_RSD_TITLE,    ACPI_RSD_TABLE_SIZE (AcpiRsDumpAddress64),          "64-Bit QWORD Address Space", NULL},
+    {ACPI_RSD_TITLE,    ARRAY_SIZE (AcpiRsDumpAddress64),                   "64-Bit QWORD Address Space", NULL},
     {ACPI_RSD_ADDRESS,  0,                                                  NULL,                       NULL},
     {ACPI_RSD_UINT64,   ACPI_RSD_OFFSET (Address64.Granularity),            "Granularity",              NULL},
     {ACPI_RSD_UINT64,   ACPI_RSD_OFFSET (Address64.Minimum),                "Address Minimum",          NULL},
@@ -327,7 +325,7 @@ ACPI_RSDUMP_INFO        AcpiRsDumpAddress64[8] =
 
 ACPI_RSDUMP_INFO        AcpiRsDumpExtAddress64[8] =
 {
-    {ACPI_RSD_TITLE,    ACPI_RSD_TABLE_SIZE (AcpiRsDumpExtAddress64),       "64-Bit Extended Address Space", NULL},
+    {ACPI_RSD_TITLE,    ARRAY_SIZE (AcpiRsDumpExtAddress64),                "64-Bit Extended Address Space", NULL},
     {ACPI_RSD_ADDRESS,  0,                                                  NULL,                       NULL},
     {ACPI_RSD_UINT64,   ACPI_RSD_OFFSET (ExtAddress64.Granularity),         "Granularity",              NULL},
     {ACPI_RSD_UINT64,   ACPI_RSD_OFFSET (ExtAddress64.Minimum),             "Address Minimum",          NULL},
@@ -339,7 +337,7 @@ ACPI_RSDUMP_INFO        AcpiRsDumpExtAddress64[8] =
 
 ACPI_RSDUMP_INFO        AcpiRsDumpExtIrq[8] =
 {
-    {ACPI_RSD_TITLE,    ACPI_RSD_TABLE_SIZE (AcpiRsDumpExtIrq),             "Extended IRQ",             NULL},
+    {ACPI_RSD_TITLE,    ARRAY_SIZE (AcpiRsDumpExtIrq),                      "Extended IRQ",             NULL},
     {ACPI_RSD_1BITFLAG, ACPI_RSD_OFFSET (ExtendedIrq.ProducerConsumer),     "Type",                     AcpiGbl_ConsumeDecode},
     {ACPI_RSD_1BITFLAG, ACPI_RSD_OFFSET (ExtendedIrq.Triggering),           "Triggering",               AcpiGbl_HeDecode},
     {ACPI_RSD_1BITFLAG, ACPI_RSD_OFFSET (ExtendedIrq.Polarity),             "Polarity",                 AcpiGbl_LlDecode},
@@ -351,7 +349,7 @@ ACPI_RSDUMP_INFO        AcpiRsDumpExtIrq[8] =
 
 ACPI_RSDUMP_INFO        AcpiRsDumpGenericReg[6] =
 {
-    {ACPI_RSD_TITLE,    ACPI_RSD_TABLE_SIZE (AcpiRsDumpGenericReg),         "Generic Register",         NULL},
+    {ACPI_RSD_TITLE,    ARRAY_SIZE (AcpiRsDumpGenericReg),                  "Generic Register",         NULL},
     {ACPI_RSD_UINT8,    ACPI_RSD_OFFSET (GenericReg.SpaceId),               "Space ID",                 NULL},
     {ACPI_RSD_UINT8,    ACPI_RSD_OFFSET (GenericReg.BitWidth),              "Bit Width",                NULL},
     {ACPI_RSD_UINT8,    ACPI_RSD_OFFSET (GenericReg.BitOffset),             "Bit Offset",               NULL},
@@ -365,7 +363,7 @@ ACPI_RSDUMP_INFO        AcpiRsDumpGenericReg[6] =
  */
 static ACPI_RSDUMP_INFO AcpiRsDumpGeneralFlags[5] =
 {
-    {ACPI_RSD_TITLE,    ACPI_RSD_TABLE_SIZE (AcpiRsDumpGeneralFlags),       NULL,                       NULL},
+    {ACPI_RSD_TITLE,    ARRAY_SIZE (AcpiRsDumpGeneralFlags),                NULL,                       NULL},
     {ACPI_RSD_1BITFLAG, ACPI_RSD_OFFSET (Address.ProducerConsumer),         "Consumer/Producer",        AcpiGbl_ConsumeDecode},
     {ACPI_RSD_1BITFLAG, ACPI_RSD_OFFSET (Address.Decode),                   "Address Decode",           AcpiGbl_DecDecode},
     {ACPI_RSD_1BITFLAG, ACPI_RSD_OFFSET (Address.MinAddressFixed),          "Min Relocatability",       AcpiGbl_MinDecode},
@@ -374,7 +372,7 @@ static ACPI_RSDUMP_INFO AcpiRsDumpGeneralFlags[5] =
 
 static ACPI_RSDUMP_INFO AcpiRsDumpMemoryFlags[5] =
 {
-    {ACPI_RSD_LITERAL,  ACPI_RSD_TABLE_SIZE (AcpiRsDumpMemoryFlags),        "Resource Type",            (void *) "Memory Range"},
+    {ACPI_RSD_LITERAL,  ARRAY_SIZE (AcpiRsDumpMemoryFlags),                 "Resource Type",            (void *) "Memory Range"},
     {ACPI_RSD_1BITFLAG, ACPI_RSD_OFFSET (Address.Info.Mem.WriteProtect),    "Write Protect",            AcpiGbl_RwDecode},
     {ACPI_RSD_2BITFLAG, ACPI_RSD_OFFSET (Address.Info.Mem.Caching),         "Caching",                  AcpiGbl_MemDecode},
     {ACPI_RSD_2BITFLAG, ACPI_RSD_OFFSET (Address.Info.Mem.RangeType),       "Range Type",               AcpiGbl_MtpDecode},
@@ -383,7 +381,7 @@ static ACPI_RSDUMP_INFO AcpiRsDumpMemoryFlags[5] =
 
 static ACPI_RSDUMP_INFO AcpiRsDumpIoFlags[4] =
 {
-    {ACPI_RSD_LITERAL,  ACPI_RSD_TABLE_SIZE (AcpiRsDumpIoFlags),            "Resource Type",            (void *) "I/O Range"},
+    {ACPI_RSD_LITERAL,  ARRAY_SIZE (AcpiRsDumpIoFlags),                     "Resource Type",            (void *) "I/O Range"},
     {ACPI_RSD_2BITFLAG, ACPI_RSD_OFFSET (Address.Info.Io.RangeType),        "Range Type",               AcpiGbl_RngDecode},
     {ACPI_RSD_1BITFLAG, ACPI_RSD_OFFSET (Address.Info.Io.Translation),      "Translation",              AcpiGbl_TtpDecode},
     {ACPI_RSD_1BITFLAG, ACPI_RSD_OFFSET (Address.Info.Io.TranslationType),  "Translation Type",         AcpiGbl_TrsDecode}
@@ -395,7 +393,7 @@ static ACPI_RSDUMP_INFO AcpiRsDumpIoFlags[4] =
  */
 static ACPI_RSDUMP_INFO   AcpiRsDumpPrt[5] =
 {
-    {ACPI_RSD_TITLE,    ACPI_RSD_TABLE_SIZE (AcpiRsDumpPrt),                NULL,                       NULL},
+    {ACPI_RSD_TITLE,    ARRAY_SIZE (AcpiRsDumpPrt),                         NULL,                       NULL},
     {ACPI_RSD_UINT64,   ACPI_PRT_OFFSET (Address),                          "Address",                  NULL},
     {ACPI_RSD_UINT32,   ACPI_PRT_OFFSET (Pin),                              "Pin",                      NULL},
     {ACPI_RSD_STRING,   ACPI_PRT_OFFSET (Source[0]),                        "Source",                   NULL},
diff --git a/tables/tbfadt.c b/tables/tbfadt.c
index a1afd6d..04f2fac 100644
--- a/tables/tbfadt.c
+++ b/tables/tbfadt.c
@@ -189,9 +189,6 @@ static ACPI_FADT_INFO     FadtInfoTable[] =
                             ACPI_FADT_OFFSET (Gpe1BlockLength),     ACPI_FADT_SEPARATE_LENGTH}
 };
 
-#define ACPI_FADT_INFO_ENTRIES        (sizeof (FadtInfoTable) / sizeof (ACPI_FADT_INFO))
-
-
 /*******************************************************************************
  *
  * FUNCTION:    AcpiTbInitGenericAddress
@@ -398,7 +395,7 @@ AcpiTbConvertFadt (
      * Expand the 32-bit V1.0 addresses to the 64-bit "X" generic address
      * structures as necessary.
      */
-    for (i = 0; i < ACPI_FADT_INFO_ENTRIES; i++)
+    for (i = 0; i < ARRAY_SIZE(FadtInfoTable); i++)
     {
         Target = ACPI_ADD_PTR (
             ACPI_GENERIC_ADDRESS, &AcpiGbl_FADT, FadtInfoTable[i].Target);
@@ -471,7 +468,7 @@ AcpiTbValidateFadt (
 
     /* Examine all of the 64-bit extended address fields (X fields) */
 
-    for (i = 0; i < ACPI_FADT_INFO_ENTRIES; i++)
+    for (i = 0; i < ARRAY_SIZE(FadtInfoTable); i++)
     {
         /* Generate pointers to the 32-bit and 64-bit addresses and get the length */
 
