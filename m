Return-Path: <linux-kernel-owner+w=401wt.eu-S1754216AbZBOWH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216AbZBOWH0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 17:07:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752571AbZBOWHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 17:07:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:55015 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751666AbZBOWHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 17:07:08 -0500
Message-ID: <499891D5.1080804@kernel.org>
Date: Sun, 15 Feb 2009 14:06:13 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: state of some x86 acpi patches
References: <20081216192534.GB843@elte.hu> <alpine.LFD.2.00.0812311821110.3854@localhost.localdomain> <495C677F.6080707@goop.org> <20090102153957.GA1180@elte.hu> <4980EE0C.4070308@goop.org> <49810211.9030808@kernel.org> <498CF8DA.30004@goop.org> <498CFD95.5070004@kernel.org> <498E229C.5030205@goop.org> <20090209123711.GK17782@elte.hu> <20090215193655.GA18674@elte.hu>
In-Reply-To: <20090215193655.GA18674@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
>> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>>
>>> Yinghai Lu wrote:
>>>> Ingo is too busy...
>>>> It seems Len already agreed those patches can go through tip.
>>>>   
>>> OK, I have them prepared as a branch off tip/git pullable from:
>>>
>>> The following changes since commit 82eda818f26cbef2b0a6bf6580e52645af62e4fd:
>>>  Ingo Molnar (1):
>>>        Merge branch 'core/locking'
>>>
>>> are available in the git repository at:
>>>
>>>  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git acpi/map
>>>
>>> Jeremy Fitzhardinge (3):
>>>      x86: use early_ioremap in __acpi_map_table
>>>      x86: always explicitly map acpi memory
>>>      acpi: remove final __acpi_map_table mapping before setting acpi_gbl_permanent_mmap
>>>
>>> Yinghai Lu (2):
>>>      acpi/x86: introduce __apci_map_table, v4
>>>      revert_fix_es7000_compiling
>>>
>>> arch/ia64/kernel/acpi.c          |    4 ++++
>>> arch/x86/include/asm/acpi.h      |    3 ---
>>> arch/x86/include/asm/fixmap_32.h |    4 ----
>>> arch/x86/include/asm/fixmap_64.h |    4 ----
>>> arch/x86/kernel/acpi/boot.c      |   33 ++++++++-------------------------
>>> arch/x86/kernel/es7000_32.c      |    9 ++++++++-
>>> drivers/acpi/acpica/tbxface.c    |   17 ++++++++++++++---
>>> drivers/acpi/osl.c               |   11 +++++++++--
>>> drivers/acpi/tables.c            |   20 ++++++++++++++------
>>> include/acpi/acpiosxf.h          |    1 +
>>> include/acpi/acpixf.h            |    4 ++++
>>> include/linux/acpi.h             |    1 +
>>> 12 files changed, 63 insertions(+), 48 deletions(-)
>> Ok, pulled into tip:x86/acpi, thanks guys!
> 
> Note, there's a new ia64 build failure due to these patches:

please check

[PATCH] ia64: fix __apci_unmap_table

Impact: fix wrong proto with compiling

to fix:
/home/mingo/tip/arch/ia64/kernel/acpi.c:203: error: conflicting types for '__acpi_unmap_table'
/home/mingo/tip/include/linux/acpi.h:82: error: previous declaration of '__acpi_unmap_table' was here
/home/mingo/tip/arch/ia64/kernel/acpi.c:203: error: conflicting types for '__acpi_unmap_table'
/home/mingo/tip/include/linux/acpi.h:82: error: previous declaration of '__acpi_unmap_table' was here

Signed-off-by: Yinghai Lu <yinghai@kenrel.org>

---
 arch/ia64/kernel/acpi.c |    2 +-
 include/linux/acpi.h    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/ia64/kernel/acpi.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/acpi.c
+++ linux-2.6/arch/ia64/kernel/acpi.c
@@ -199,7 +199,7 @@ char *__init __acpi_map_table(unsigned l
 	return __va(phys_addr);
 }
 
-char *__init __acpi_unmap_table(unsigned long virt_addr, unsigned long size)
+void __init __acpi_unmap_table(unsigned long virt_addr, unsigned long size)
 {
 }
 
Index: linux-2.6/include/linux/acpi.h
===================================================================
--- linux-2.6.orig/include/linux/acpi.h
+++ linux-2.6/include/linux/acpi.h
@@ -79,7 +79,7 @@ typedef int (*acpi_table_handler) (struc
 typedef int (*acpi_table_entry_handler) (struct acpi_subtable_header *header, const unsigned long end);
 
 char * __acpi_map_table (unsigned long phys_addr, unsigned long size);
-void __init __acpi_unmap_table(char *map, unsigned long size);
+void __acpi_unmap_table(char *map, unsigned long size);
 int early_acpi_boot_init(void);
 int acpi_boot_init (void);
 int acpi_boot_table_init (void);
