Return-Path: <linux-kernel-owner+w=401wt.eu-S1756714AbYBAO65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714AbYBAO65 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 09:58:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753805AbYBAO6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 09:58:50 -0500
Received: from triton.rz.uni-saarland.de ([134.96.7.25]:20666 "EHLO
	triton.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753782AbYBAO6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 09:58:49 -0500
Date: Fri, 1 Feb 2008 15:56:50 +0100
From: Alexander van Heukelum <heukelum@mailshack.com>
To: linux-kernel@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Alexander van Heukelum <heukelum@fastmail.fm>
Subject: Avoid section mismatch involving arch_register_cpu
Message-ID: <20080201145649.GA12318@mailshack.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (triton.rz.uni-saarland.de [134.96.7.25]); Fri, 01 Feb 2008 15:58:44 +0100 (CET)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.6.0.61; VDF: 7.0.2.80; host: AntiVir3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid section mismatch involving arch_register_cpu.

Marking arch_register_cpu as __init and removing the export
for non-hotplug-cpu configurations makes the following warning
go away:

Section mismatch in reference from the function 
arch_register_cpu() to the function .devinit.text:register_cpu()
The function  arch_register_cpu() references
the function __devinit register_cpu().
This is often because arch_register_cpu lacks a __devinit 
annotation or the annotation of register_cpu is wrong.

The only external user of arch_register_cpu in the tree is
in drivers/acpi/processor_core.c where it is guarded by
ACPI_HOTPLUG_CPU (which depends on HOTPLUG_CPU).

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
CC: Sam Ravnborg <sam@ravnborg.org>


diff --git a/arch/x86/kernel/topology.c b/arch/x86/kernel/topology.c
index 78cbb65..e6757aa 100644
--- a/arch/x86/kernel/topology.c
+++ b/arch/x86/kernel/topology.c
@@ -57,11 +57,10 @@ void arch_unregister_cpu(int num)
 }
 EXPORT_SYMBOL(arch_unregister_cpu);
 #else
-int arch_register_cpu(int num)
+static int __init arch_register_cpu(int num)
 {
 	return register_cpu(&per_cpu(cpu_devices, num).cpu, num);
 }
-EXPORT_SYMBOL(arch_register_cpu);
 #endif /*CONFIG_HOTPLUG_CPU*/
 
 static int __init topology_init(void)
diff --git a/include/asm-x86/cpu.h b/include/asm-x86/cpu.h
index 85ece5f..73f2ea8 100644
--- a/include/asm-x86/cpu.h
+++ b/include/asm-x86/cpu.h
@@ -10,8 +10,9 @@
 struct x86_cpu {
 	struct cpu cpu;
 };
-extern int arch_register_cpu(int num);
+
 #ifdef CONFIG_HOTPLUG_CPU
+extern int arch_register_cpu(int num);
 extern void arch_unregister_cpu(int);
 #endif

