Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932442Ab0BCPnO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 10:43:14 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:44044 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932306Ab0BCPnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 10:43:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=EWBfk+qSbzEONSThgDuF1WJECxKttXObUZq7ti2KOnS1Sp/ZhsLUG01hRd1yeymLAE
         WQXKz/EvIOn07zdfe2uk4Xn72RkECGh6YrterK2lUCOznyhcIW1C+o8iYrk3rjpMvLtl
         2GhtcPcxQR+VDgrQnvRYN/QA1xdxfgaZIBk6g=
Message-ID: <4B699B06.2040202@gmail.com>
Date: Wed, 03 Feb 2010 16:49:26 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Matt Turner <mattst88@gmail.com>, linux-alpha@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] alpha: PTR_ERR overwrites -EINVAL in syscall osf_mount
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The initial -EINVAL value is overwritten by `retval = PTR_ERR(name)'.
If this isn't an error pointer and typenr is not 1, 6 or 9, then
this retval, a pointer cast to a long, is returned.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Was this intended? Not sure whether this can occur, found by code
analysis.

diff --git a/arch/alpha/kernel/osf_sys.c b/arch/alpha/kernel/osf_sys.c
index 62619f2..53c213f 100644
--- a/arch/alpha/kernel/osf_sys.c
+++ b/arch/alpha/kernel/osf_sys.c
@@ -361,7 +361,7 @@ osf_procfs_mount(char *dirname, struct procfs_args __user *args, int flags)
 SYSCALL_DEFINE4(osf_mount, unsigned long, typenr, char __user *, path,
 		int, flag, void __user *, data)
 {
-	int retval = -EINVAL;
+	int retval;
 	char *name;
 
 	name = getname(path);
@@ -379,6 +379,7 @@ SYSCALL_DEFINE4(osf_mount, unsigned long, typenr, char __user *, path,
 		retval = osf_procfs_mount(name, data, flag);
 		break;
 	default:
+		retval = -EINVAL;
 		printk("osf_mount(%ld, %x)\n", typenr, flag);
 	}
 	putname(name);
