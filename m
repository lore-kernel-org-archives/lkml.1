Return-Path: <linux-kernel-owner+w=401wt.eu-S1757634AbYCANKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757634AbYCANKv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 08:10:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755428AbYCANKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 08:10:40 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:61767 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755136AbYCANK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 08:10:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=ibvm+vsRwdyYG61rTwLe8r6qFSQ6zgxlcEeEX3+V7GWR/GmcJgsN8rbBP3oaK7m48fhfmj+XgRfo6T6oeO9grpiB/cLzijhVJ1NVlckLh/pmdauUXqGop4Y79+Aord1YNNdNcj+kpnMV2OGvMhGTdTLctx1MuEsh8Aq+EL6B01A=
From: Pawel Plociennik <paplociennik@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] chroot= as a new kernel parameter
Date: Sat, 1 Mar 2008 14:09:59 -0500
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200803011409.59526.paplociennik@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi *real* hackers,

it is a my first post to lkml and I hope that you will have not been
ignored me if I have done some incorrect thing.

In the short this patch has added a new chroot= kernel parameter which can be used
to changing a chroot of an init process before it will has been runed.
I use that for testing variouses distroes without making a separate partition but
by copied a new root-fs to a new subdirectory on the my *base* filesystem.

PS: be sure that you have added my e-mail in a CC because I am not subscribed
to the lkml and ...
I sorry but my English can be little incorrect because it is not my *native* language :-(      
please do not ignore me if I have been done some inccorect thing.

diff -urp linux-2.6.24-orig/Documentation/kernel-parameters.txt linux-2.6.24/Documentation/kernel-parameters.txt
--- linux-2.6.24-orig/Documentation/kernel-parameters.txt	2008-02-25 20:53:26.000000000 -0500
+++ linux-2.6.24/Documentation/kernel-parameters.txt	2008-02-25 20:51:21.000000000 -0500
@@ -381,6 +381,8 @@ and is between 256 and 4096 characters. 
 			Value can be changed at runtime via
 				/selinux/checkreqprot.
 	
+	chroot=		[KNL] call chroot() for init proccess.
+
 	clock=		[BUGS=X86-32, HW] gettimeofday clocksource override.
 			[Deprecated]
 			Forces specified clocksource (if available) to be used
diff -urp linux-2.6.24-orig/init/main.c linux-2.6.24/init/main.c
--- linux-2.6.24-orig/init/main.c	2008-03-01 12:58:37.000000000 -0500
+++ linux-2.6.24/init/main.c	2008-02-25 20:36:06.000000000 -0500
@@ -755,8 +755,22 @@ static void __init do_pre_smp_initcalls(
 		spawn_softlockup_task();
 }
 
+static void *chroot_str;
+static int __init chroot_setup(char *str)
+{
+	chroot_str = str;
+	return 1;
+}
+__setup("chroot=", chroot_setup);
+
 static void run_init_process(char *init_filename)
 {
+	if(chroot_str) {
+		if(sys_chroot(chroot_str) < 0)
+			printk("chroot=%s failed\n", chroot_str);
+		else
+			printk("chroot=%s successed\n",chroot_str);
+	}
 	argv_init[0] = init_filename;
 	kernel_execve(init_filename, argv_init, envp_init);
 }
