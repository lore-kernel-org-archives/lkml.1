Return-Path: <linux-kernel-owner+w=401wt.eu-S1757621AbZKKPxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757621AbZKKPxs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 10:53:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757564AbZKKPxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 10:53:47 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:46112 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757518AbZKKPxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 10:53:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=rwg1sGYHITALl1ehsIejhhod+VNhXX8cpQOCGUJi4u7zELk/2xkOzOYnvw1rf11/0c
         6AsKBjcyKoJyRsNkMNvdmFLamZKhv62RRNgwPZZbtmUfrbIh6qxsQ0kTrjyWfho94fUK
         yaEj8XouW8sY0PiImpAtz4xINLiZvwv2HuwpU=
Message-ID: <4AFAE0DA.6040300@gmail.com>
Date: Wed, 11 Nov 2009 17:05:46 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Russell King <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.infradead.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] pxa: make index mfp unsigned in mfp_read() and write()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When signed, it is possible in theory to pass a negative mfp,
and read/write outside the array bounds.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 arch/arm/plat-pxa/include/plat/mfp.h |    4 ++--
 arch/arm/plat-pxa/mfp.c              |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

I did not observe the passing of a negative mfp anywhere so this
can be considered as a cleanup. Alternatively I could introduce
a `mfp < 0' check in mfp_{read,write} instead if desired.

diff --git a/arch/arm/plat-pxa/include/plat/mfp.h b/arch/arm/plat-pxa/include/plat/mfp.h
index 22086e6..0743f4a 100644
--- a/arch/arm/plat-pxa/include/plat/mfp.h
+++ b/arch/arm/plat-pxa/include/plat/mfp.h
@@ -458,8 +458,8 @@ void __init mfp_init_addr(struct mfp_addr_map *map);
  * mfp_config_lpm()	- configuring all low power MFPR registers for suspend
  * mfp_config_run()	- configuring all run time  MFPR registers after resume
  */
-unsigned long mfp_read(int mfp);
-void mfp_write(int mfp, unsigned long mfpr_val);
+unsigned long mfp_read(unsigned mfp);
+void mfp_write(unsigned mfp, unsigned long mfpr_val);
 void mfp_config(unsigned long *mfp_cfgs, int num);
 void mfp_config_run(void);
 void mfp_config_lpm(void);
diff --git a/arch/arm/plat-pxa/mfp.c b/arch/arm/plat-pxa/mfp.c
index 9405d03..c80d0db 100644
--- a/arch/arm/plat-pxa/mfp.c
+++ b/arch/arm/plat-pxa/mfp.c
@@ -203,7 +203,7 @@ void mfp_config(unsigned long *mfp_cfgs, int num)
 	spin_unlock_irqrestore(&mfp_spin_lock, flags);
 }
 
-unsigned long mfp_read(int mfp)
+unsigned long mfp_read(unsigned mfp)
 {
 	unsigned long val, flags;
 
@@ -216,7 +216,7 @@ unsigned long mfp_read(int mfp)
 	return val;
 }
 
-void mfp_write(int mfp, unsigned long val)
+void mfp_write(unsigned mfp, unsigned long val)
 {
 	unsigned long flags;
 
