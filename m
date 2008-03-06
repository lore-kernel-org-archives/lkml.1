Return-Path: <linux-kernel-owner+w=401wt.eu-S1764794AbYCEWwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764794AbYCEWwt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 17:52:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758718AbYCEWwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 17:52:10 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:55897 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756865AbYCEWwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 17:52:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:user-agent:references:in-reply-to:mime-version:content-disposition:cc:date:content-type:content-transfer-encoding:message-id;
        b=nxW4PXFYsUqJmlH8ABcR+EfKkF++pbia6zjrnHE659eG/h1XiXKEbOcNFR7HR6SNmJ+5i9A0AesV3YL87H56WSZTcKAE5pBVsGcWPeSQVTi98eZW2pKMb0oT1/t2wazxyaKjbBxGcwoSc9hhqwqLO4ASjkFHQjYepHjt2wE28qU=
From: Pawel Plociennik <paplociennik@gmail.com>
To: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] chroot= as a new kernel parameter
User-Agent: KMail/1.9.5
References: <200803011409.59526.paplociennik@gmail.com> <200803050838.03452.paplociennik@gmail.com> <3d8471ca0803050523r2a55c91em68021a7b078ef48c@mail.gmail.com>
In-Reply-To: <3d8471ca0803050523r2a55c91em68021a7b078ef48c@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Cc: linux-kernel@vger.kernel.org
Date: Wed, 5 Mar 2008 23:51:50 -0500
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200803052351.50500.paplociennik@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew and other *real* hackers,

I have sent a *last* version of a patch which it has added a new kernel parameter chroot=
It were discusioned a *long time* on a lkml so I hope that it will has been applied.

Thanks,
Pawel 

Acked-by: Pavel Machek <pavel@suse.cz>
Signed-off-by: Pawel Plociennik <paplociennik@gmail.com>

---
diff -urp linux-2.6.24-orig/Documentation/kernel-parameters.txt linux-2.6.24/Documentation/kernel-parameters.txt
--- linux-2.6.24-orig/Documentation/kernel-parameters.txt	2008-02-25 20:53:26.000000000 -0500
+++ linux-2.6.24/Documentation/kernel-parameters.txt	2008-03-04 09:51:52.000000000 -0500
@@ -381,6 +381,8 @@ and is between 256 and 4096 characters. 
 			Value can be changed at runtime via
 				/selinux/checkreqprot.
 	
+	chroot=		[KNL] change a root for init process.
+
 	clock=		[BUGS=X86-32, HW] gettimeofday clocksource override.
 			[Deprecated]
 			Forces specified clocksource (if available) to be used
diff -urp linux-2.6.24-orig/init/main.c linux-2.6.24/init/main.c
--- linux-2.6.24-orig/init/main.c	2008-03-01 12:58:37.000000000 -0500
+++ linux-2.6.24/init/main.c	2008-03-05 15:08:20.000000000 -0500
@@ -755,8 +755,20 @@ static void __init do_pre_smp_initcalls(
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
+	if (chroot_str)
+		if (sys_chroot(chroot_str) < 0)
+			panic("chroot=%s failed\n", chroot_str);
+
 	argv_init[0] = init_filename;
 	kernel_execve(init_filename, argv_init, envp_init);
 }
