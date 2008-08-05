Return-Path: <linux-kernel-owner+w=401wt.eu-S1756681AbYHEOZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681AbYHEOZM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 10:25:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754475AbYHEOZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 10:25:00 -0400
Received: from ik-out-1112.google.com ([66.249.90.177]:41117 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495AbYHEOY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 10:24:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:date:user-agent:mime-version:content-disposition:to
         :content-type:message-id;
        b=nM5zZ6byvpkOhaHEEksVcAPGS+7GUEKsQXhTPSOTk0vPxDrmKuvRewYRrAcGzZ5yuo
         8OCHCzmEnIHfACg7b6zsz2xO1oUAQfamJIj/zpH7eTTdt52A41BfCtclE/Pq3tDoXgsN
         f+wJunzHqMqWRGM2sBpu9BoLpqPh86jiLMiLg=
From: Jordi Pujol <jordipujolp@gmail.com>
Subject: Checking versions of the symbols in modules
Date: Tue, 5 Aug 2008 16:24:52 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Disposition: inline
To: linux-kernel@vger.kernel.org
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_0KGmIX3zVXlg9tW"
Message-Id: <200808051624.52983.jordipujolp@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_0KGmIX3zVXlg9tW
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello,

summary:
In a kernel already compiled, we install new modules, some of that depend of 
the others. after charging the first module the next one can not find the 
symbols that uses from the first.

Kernel version:
Linux version 2.6.26.1-686-jp2 (root@pcjordi) (gcc version 4.3.1 (Debian 
4.3.1-2) ) #1 SMP PREEMPT Tue Aug 5 11:34:33 CEST 2008

Full description:  
In a kernel already compiled, we install new modules, some of them depending 
from the others.  In this case the modules are lzma and squashfs-lzma 
after charging the module lzma we verify in /proc/kallsyms that the symbols 
have been exported and correctly noted. 
When we charge the module squashfs that depends on the symbols of sqlzma, the 
kernel responds:
no symbol version for sqlzma_init
Unknown symbol sqlzma_init 
no symbol version for sqlzma_un 
Unknown symbol sqlzma_un 
no symbol version for sqlzma_fin 
Unknown symbol sqlzma_fin

Keywords:
modules, symbols

workaround:
my first solution was to compile a kernel with MODULE_FORCE_LOADING enabled, 
and forcing modprobe to do that. That works,

the solution,
inspecting the module.c source, 
can be appreciated differences with the version 2.6.25 in the routine 
check_version, so that previously has returned correct when the version for a 
symbol was not found, but in this routine, version 2.6.26 returns error.  
Works well after modifying some lines of module.c

Attached is the patch to module.c

P.D. if the source of that modules is needed, lzma is from the sid repository 
of Debian, and squashfs-lzma is my own develop, I can provide the Debian 
package for it, 

Thanks for that good kernel,

Jordi Pujol

--Boundary-00=_0KGmIX3zVXlg9tW
Content-Type: text/x-diff;
  charset="iso 8859-15";
  name="linux-2.6.26-kernel-module.c.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="linux-2.6.26-kernel-module.c.diff"

--- linux-2.6.26.1-old/kernel/module.c	2008-08-02 00:58:24.000000000 +0200
+++ linux-2.6.26.1/kernel/module.c	2008-08-05 14:48:13.000000000 +0200
@@ -936,9 +936,11 @@
 		goto bad_version;
 	}
 
+	/* Not in module's version table.  OK, but that taints the kernel. */
 	printk(KERN_WARNING "%s: no symbol version for %s\n",
 	       mod->name, symname);
-	return 0;
+	add_taint_module(mod, TAINT_FORCED_MODULE);
+	return 1;
 
 bad_version:
 	printk("%s: disagrees about version of symbol %s\n",

--Boundary-00=_0KGmIX3zVXlg9tW--
