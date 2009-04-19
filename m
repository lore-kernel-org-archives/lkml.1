Return-Path: <linux-kernel-owner+w=401wt.eu-S1759616AbZDSCl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759616AbZDSCl2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 22:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753870AbZDSClU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 22:41:20 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:37674 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436AbZDSClT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 22:41:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=esn+aHgqGEV1vHxi5b5qGzbIXvVmpE9VmcIC27GO8UdifK0WCY3rWQ8vczywmYIwgN
         fLDHhununlsvP0rmPbOGmuSdUv0ct44/7aLkfctiXcIrRbYG5nJ4C/CS/Wc5UELQ5eWo
         3dLKrm1zukmqMIVD0eqwoxg7Pnb3Sm9cq6cUo=
MIME-Version: 1.0
Date: Sun, 19 Apr 2009 08:41:17 +0600
Message-ID: <b9df5fa10904181941u4a73fc97i80dfa90a50b8daf5@mail.gmail.com>
Subject: [PATCH] x86: Fix section mismatches in apic.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Impact: Fix section mismatch

find_unisys_acpi_oem_table() and unmap_unisys_acpi_oem_table() are non
init functions, but these functions calls some init functions. But we
need these functions as non-init functions.

WARNING: vmlinux.o(.text+0x16250): Section mismatch in reference from
the function find_unisys_acpi_oem_table() to the function
.init.text:early_acpi_os_unmap_memory()
The function find_unisys_acpi_oem_table() references
the function __init early_acpi_os_unmap_memory().
This is often because find_unisys_acpi_oem_table lacks a __init
annotation or the annotation of early_acpi_os_unmap_memory is wrong.

WARNING: vmlinux.o(.text+0x16269): Section mismatch in reference from
the function find_unisys_acpi_oem_table() to the function
.init.text:early_acpi_os_unmap_memory()
The function find_unisys_acpi_oem_table() references
the function __init early_acpi_os_unmap_memory().
This is often because find_unisys_acpi_oem_table lacks a __init
annotation or the annotation of early_acpi_os_unmap_memory is wrong.

WARNING: vmlinux.o(.text+0x16279): Section mismatch in reference from
the function find_unisys_acpi_oem_table() to the function
.init.text:__acpi_map_table()
The function find_unisys_acpi_oem_table() references
the function __init __acpi_map_table().
This is often because find_unisys_acpi_oem_table lacks a __init
annotation or the annotation of __acpi_map_table is wrong.

WARNING: vmlinux.o(.text+0x16297): Section mismatch in reference from
the function unmap_unisys_acpi_oem_table() to the function
.init.text:__acpi_unmap_table()
The function unmap_unisys_acpi_oem_table() references
the function __init __acpi_unmap_table().
This is often because unmap_unisys_acpi_oem_table lacks a __init
annotation or the annotation of __acpi_unmap_table is wrong.

----
Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>

--- linus/arch/x86/kernel/apic/es7000_32.c	2009-04-10 22:28:47.000000000 +0600
+++ rakib/arch/x86/kernel/apic/es7000_32.c	2009-04-14 10:19:21.000000000 +0600
@@ -254,7 +254,7 @@ static int parse_unisys_oem(char *oemptr
 }

 #ifdef CONFIG_ACPI
-static int find_unisys_acpi_oem_table(unsigned long *oem_addr)
+static int __ref find_unisys_acpi_oem_table(unsigned long *oem_addr)
 {
 	struct acpi_table_header *header = NULL;
 	struct es7000_oem_table *table;
@@ -285,7 +285,7 @@ static int find_unisys_acpi_oem_table(un
 	return 0;
 }

-static void unmap_unisys_acpi_oem_table(unsigned long oem_addr)
+static void __ref unmap_unisys_acpi_oem_table(unsigned long oem_addr)
 {
 	if (!oem_addr)
 		return;
