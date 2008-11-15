Return-Path: <linux-kernel-owner+w=401wt.eu-S1755487AbYKOKAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbYKOKAk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 05:00:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbYKOKAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 05:00:31 -0500
Received: from fk-out-0910.google.com ([209.85.128.189]:50483 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015AbYKOKAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 05:00:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=subject:to:cc:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding:from;
        b=bezQqk0IGzrNK5jUgbwY6I8wzgglZUOjfPeorH+zPbu4xosAzvZ4KcEydMLTPoESnO
         xHamNKMvHWgTLVRRCoJqtsdTwHe0dGbS3sanWFmSEPWiZUVjdkgZNYagvcV8UHYlxCGP
         Y3Son9uEgg9CkgGhNzhUz5JoXztrUJ/V9CXNo=
Subject: [patch] x86, bts: fix unlock problem in ds.c
To: lkml <linux-kernel@vger.kernel.org>
Cc: work <markus.t.metzger@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
       stephane eranian <eranian@googlemail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain
Date: Sat, 15 Nov 2008 11:00:17 +0100
Message-Id: <1226743217.6162.4.camel@raistlin>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
From: Markus Metzger <markus.t.metzger@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a problem where ds_request() returned an error without releasing the
ds lock.

Reported-by: Stephane Eranian <eranian@gmail.com>
Signed-off-by: Markus Metzger <markus.t.metzger@gmail.com>
---

Index: gits/arch/x86/kernel/ds.c
===================================================================
--- gits.orig/arch/x86/kernel/ds.c	2008-11-15 10:51:51.000000000 +0100
+++ gits/arch/x86/kernel/ds.c	2008-11-15 10:53:43.000000000 +0100
@@ -384,8 +384,9 @@
 
 	spin_lock(&ds_lock);
 
+	error = -EPERM;
 	if (!check_tracer(task))
-		return -EPERM;
+		goto out_unlock;
 
 	error = -ENOMEM;
 	context = ds_alloc_context(task);


