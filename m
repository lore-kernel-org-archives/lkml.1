Return-Path: <linux-kernel-owner+w=401wt.eu-S1754066AbYBDF7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbYBDF7q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 00:59:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751263AbYBDF7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 00:59:39 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:42167 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132AbYBDF7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 00:59:38 -0500
Date: Mon, 4 Feb 2008 06:59:42 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Peter Teoh <htmldeveloper@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Section mismatch: kernel/cpu.c
Message-ID: <20080204055942.GB11435@uranus.ravnborg.org>
References: <804dabb00802031816s29033043vb04b65970e7fb37@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <804dabb00802031816s29033043vb04b65970e7fb37@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2008 at 10:16:23AM +0800, Peter Teoh wrote:
> Compiling the latest linus tree will encounter the following warning:
> 
> WARNING: kernel/built-in.o(.text+0x2f5e2): Section mismatch in
> reference from the function enable_nonboot_cpus() to the function
> .cpuinit.text:_cpu_up()
> The function  enable_nonboot_cpus() references
> the function __cpuinit _cpu_up().
> This is often because enable_nonboot_cpus lacks a __cpuinit
> annotation or the annotation of _cpu_up is wrong.
> 
> WARNING: kernel/built-in.o(.text+0x2f638): Section mismatch in
> reference from the function take_cpu_down() to the variable
> .cpuinit.data:cpu_chain
> The function  take_cpu_down() references
> the variable __cpuinitdata cpu_chain.
> This is often because take_cpu_down lacks a __cpuinitdata
> annotation or the annotation of cpu_chain is wrong.
> 
> WARNING: kernel/built-in.o(.text+0x2f6bb): Section mismatch in
> reference from the function _cpu_down() to the variable
> .cpuinit.data:cpu_chain
> The function  _cpu_down() references
> the variable __cpuinitdata cpu_chain.
> This is often because _cpu_down lacks a __cpuinitdata
> annotation or the annotation of cpu_chain is wrong.
> 
> WARNING: kernel/built-in.o(.text+0x2f6e1): Section mismatch in
> reference from the function _cpu_down() to the variable
> .cpuinit.data:cpu_chain
> The function  _cpu_down() references
> the variable __cpuinitdata cpu_chain.
> This is often because _cpu_down lacks a __cpuinitdata
> annotation or the annotation of cpu_chain is wrong.
> 
> WARNING: kernel/built-in.o(.text+0x2f762): Section mismatch in
> reference from the function _cpu_down() to the variable
> .cpuinit.data:cpu_chain
> The function  _cpu_down() references
> the variable __cpuinitdata cpu_chain.
> This is often because _cpu_down lacks a __cpuinitdata
> annotation or the annotation of cpu_chain is wrong.
> 
> WARNING: kernel/built-in.o(.text+0x2f7a2): Section mismatch in
> reference from the function _cpu_down() to the variable
> .cpuinit.data:cpu_chain
> The function  _cpu_down() references
> the variable __cpuinitdata cpu_chain.
> This is often because _cpu_down lacks a __cpuinitdata
> annotation or the annotation of cpu_chain is wrong.
> 
> WARNING: kernel/built-in.o(.text+0x2f88b): Section mismatch in
> reference from the function unregister_cpu_notifier() to the variable
> .cpuinit.data:cpu_chain
> The function  unregister_cpu_notifier() references
> the variable __cpuinitdata cpu_chain.
> This is often because unregister_cpu_notifier lacks a __cpuinitdata
> annotation or the annotation of cpu_chain is wrong.
> 
> WARNING: kernel/built-in.o(__ksymtab+0x7f0): Section mismatch in
> reference from the variable __ksymtab_register_cpu_notifier to the
> function .cpuinit.text:register_cpu_notifier()
> The symbol register_cpu_notifier is exported and annotated __cpuinit
> Fix this by removing the __cpuinit annotation of register_cpu_notifier
> or drop the export.
> 
> It is basically a mismatch between __init and non-__init sections of
> the object module.   It is also caused by casting an exported symbol
> (which have its own section called __ksymtabXXX) with __cpuinit.   Not
> sure if a variable or function can reincarnate as two different
> section naming????  If not possible, then the following is the fix to
> correct all the above warning:
> 
> Signed-off-by: Peter Teoh <htmldeveloper@gmail.com>
> 
> --- cpu.c.orig  2008-02-04 09:36:35.000000000 +0800
> +++ cpu.c       2008-02-04 10:04:35.000000000 +0800
> @@ -18,7 +18,7 @@
>  /* Serializes the updates to cpu_online_map, cpu_present_map */
>  static DEFINE_MUTEX(cpu_add_remove_lock);
> 
> -static __cpuinitdata RAW_NOTIFIER_HEAD(cpu_chain);
> +static RAW_NOTIFIER_HEAD(cpu_chain);


I have the same fix queued up. Patch attached.
But I have my doughts it is correct and I need to investigate
a bit more.

The rest of your changes I am not certain about and I need
to study the uses of the various *cpu* primitives from
all archs better before I judge on them.

In general kernel/cpu.c is tricky. Fixing up drivers
is many times easier.

	Sam

>From 3d0b6b17164ce8943c1fa5deec3b87f69c51b75e Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Thu, 31 Jan 2008 21:10:29 +0100
Subject: [PATCH] cpu: fix section mismatch related to cpu_chain

Fix following warnings:
WARNING: o-x86_64/kernel/built-in.o(.text+0x36de9): Section mismatch in reference from the function take_cpu_down() to the variable .cpuinit.data:cpu_chain
WARNING: o-x86_64/kernel/built-in.o(.text+0x36e86): Section mismatch in reference from the function _cpu_down() to the variable .cpuinit.data:cpu_chain
WARNING: o-x86_64/kernel/built-in.o(.text+0x36ea9): Section mismatch in reference from the function _cpu_down() to the variable .cpuinit.data:cpu_chain
WARNING: o-x86_64/kernel/built-in.o(.text+0x36f40): Section mismatch in reference from the function _cpu_down() to the variable .cpuinit.data:cpu_chain
WARNING: o-x86_64/kernel/built-in.o(.text+0x36f8f): Section mismatch in reference from the function _cpu_down() to the variable .cpuinit.data:cpu_chain
WARNING: o-x86_64/kernel/built-in.o(.text+0x370aa): Section mismatch in reference from the function unregister_cpu_notifier() to the variable .cpuinit.data:cpu_chain

cpu_chain is used by unregister_cpu_notifier() that is used
by the kvm module. So we can call the unregister_cpu_notifier() long
after init completed.
Drop the __cpuinitdata annotation to avoid freeing cpu_chain.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Gautham R Shenoy <ego@in.ibm.com>
---
 kernel/cpu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 2eff3f6..df9430f 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -18,7 +18,7 @@
 /* Serializes the updates to cpu_online_map, cpu_present_map */
 static DEFINE_MUTEX(cpu_add_remove_lock);
 
-static __cpuinitdata RAW_NOTIFIER_HEAD(cpu_chain);
+static RAW_NOTIFIER_HEAD(cpu_chain);
 
 /* If set, cpu_up and cpu_down will return -EBUSY and do nothing.
  * Should always be manipulated under cpu_add_remove_lock
-- 
1.5.4.rc3.14.g44397

