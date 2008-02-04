Return-Path: <linux-kernel-owner+w=401wt.eu-S1755871AbYBDCQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871AbYBDCQb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 21:16:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754887AbYBDCQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 21:16:24 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:15141 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754728AbYBDCQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 21:16:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ppMXpojrxX6E4t/8SbkitzfWZv0orCAlhD7yWa7+CLFHRnEj3M3KYwU6XluNmesvQZQmAq0Wg1GWypKFsLvEkye/QOoFqssCPo4kX5+P8axNT2A1ULNHNC0CyfBJcaRoaVWSuGoRuObH/tZndDgQX7XlUTtm1dCseKSYYj+Llcs=
Message-ID: <804dabb00802031816s29033043vb04b65970e7fb37@mail.gmail.com>
Date: Mon, 4 Feb 2008 10:16:23 +0800
From: "Peter Teoh" <htmldeveloper@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Section mismatch: kernel/cpu.c
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compiling the latest linus tree will encounter the following warning:

WARNING: kernel/built-in.o(.text+0x2f5e2): Section mismatch in
reference from the function enable_nonboot_cpus() to the function
.cpuinit.text:_cpu_up()
The function  enable_nonboot_cpus() references
the function __cpuinit _cpu_up().
This is often because enable_nonboot_cpus lacks a __cpuinit
annotation or the annotation of _cpu_up is wrong.

WARNING: kernel/built-in.o(.text+0x2f638): Section mismatch in
reference from the function take_cpu_down() to the variable
.cpuinit.data:cpu_chain
The function  take_cpu_down() references
the variable __cpuinitdata cpu_chain.
This is often because take_cpu_down lacks a __cpuinitdata
annotation or the annotation of cpu_chain is wrong.

WARNING: kernel/built-in.o(.text+0x2f6bb): Section mismatch in
reference from the function _cpu_down() to the variable
.cpuinit.data:cpu_chain
The function  _cpu_down() references
the variable __cpuinitdata cpu_chain.
This is often because _cpu_down lacks a __cpuinitdata
annotation or the annotation of cpu_chain is wrong.

WARNING: kernel/built-in.o(.text+0x2f6e1): Section mismatch in
reference from the function _cpu_down() to the variable
.cpuinit.data:cpu_chain
The function  _cpu_down() references
the variable __cpuinitdata cpu_chain.
This is often because _cpu_down lacks a __cpuinitdata
annotation or the annotation of cpu_chain is wrong.

WARNING: kernel/built-in.o(.text+0x2f762): Section mismatch in
reference from the function _cpu_down() to the variable
.cpuinit.data:cpu_chain
The function  _cpu_down() references
the variable __cpuinitdata cpu_chain.
This is often because _cpu_down lacks a __cpuinitdata
annotation or the annotation of cpu_chain is wrong.

WARNING: kernel/built-in.o(.text+0x2f7a2): Section mismatch in
reference from the function _cpu_down() to the variable
.cpuinit.data:cpu_chain
The function  _cpu_down() references
the variable __cpuinitdata cpu_chain.
This is often because _cpu_down lacks a __cpuinitdata
annotation or the annotation of cpu_chain is wrong.

WARNING: kernel/built-in.o(.text+0x2f88b): Section mismatch in
reference from the function unregister_cpu_notifier() to the variable
.cpuinit.data:cpu_chain
The function  unregister_cpu_notifier() references
the variable __cpuinitdata cpu_chain.
This is often because unregister_cpu_notifier lacks a __cpuinitdata
annotation or the annotation of cpu_chain is wrong.

WARNING: kernel/built-in.o(__ksymtab+0x7f0): Section mismatch in
reference from the variable __ksymtab_register_cpu_notifier to the
function .cpuinit.text:register_cpu_notifier()
The symbol register_cpu_notifier is exported and annotated __cpuinit
Fix this by removing the __cpuinit annotation of register_cpu_notifier
or drop the export.

It is basically a mismatch between __init and non-__init sections of
the object module.   It is also caused by casting an exported symbol
(which have its own section called __ksymtabXXX) with __cpuinit.   Not
sure if a variable or function can reincarnate as two different
section naming????  If not possible, then the following is the fix to
correct all the above warning:

Signed-off-by: Peter Teoh <htmldeveloper@gmail.com>

--- cpu.c.orig  2008-02-04 09:36:35.000000000 +0800
+++ cpu.c       2008-02-04 10:04:35.000000000 +0800
@@ -18,7 +18,7 @@
 /* Serializes the updates to cpu_online_map, cpu_present_map */
 static DEFINE_MUTEX(cpu_add_remove_lock);

-static __cpuinitdata RAW_NOTIFIER_HEAD(cpu_chain);
+static RAW_NOTIFIER_HEAD(cpu_chain);

 /* If set, cpu_up and cpu_down will return -EBUSY and do nothing.
  * Should always be manipulated under cpu_add_remove_lock
@@ -136,7 +136,7 @@ static void cpu_hotplug_done(void)
        mutex_unlock(&cpu_hotplug.lock);
 }
 /* Need to know about CPUs going up/down? */
-int __cpuinit register_cpu_notifier(struct notifier_block *nb)
+int register_cpu_notifier(struct notifier_block *nb)
 {
        int ret;
        cpu_maps_update_begin();
@@ -290,7 +290,7 @@ int cpu_down(unsigned int cpu)
 #endif /*CONFIG_HOTPLUG_CPU*/

 /* Requires cpu_add_remove_lock to be held */
-static int __cpuinit _cpu_up(unsigned int cpu, int tasks_frozen)
+static int _cpu_up(unsigned int cpu, int tasks_frozen)
 {
        int ret, nr_calls = 0;
        void *hcpu = (void *)(long)cpu;
@@ -328,7 +328,7 @@ out_notify:
        return ret;
 }

-int __cpuinit cpu_up(unsigned int cpu)
+int cpu_up(unsigned int cpu)
 {
        int err = 0;
        if (!cpu_isset(cpu, cpu_possible_map)) {
