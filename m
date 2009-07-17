Return-Path: <linux-kernel-owner+w=401wt.eu-S933756AbZGQAHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933756AbZGQAHc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 20:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933737AbZGQAGC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 20:06:02 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39132 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933734AbZGQAGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 20:06:00 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: [PATCH 16/21] Blackfin: fix bugs in GPIO resume code
Date: Thu, 16 Jul 2009 20:05:41 -0400
Message-Id: <1247789146-18786-17-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1247789146-18786-1-git-send-email-vapier@gentoo.org>
References: <1247789146-18786-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Change the bfin_gpio_pm_hibernate_restore() function to:
1) AND restored DATA with DIR (not OR) to get correct final state
2) Restore DATA before setting DIR to avoid glitches

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/bfin_gpio.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/blackfin/kernel/bfin_gpio.c b/arch/blackfin/kernel/bfin_gpio.c
index beffa00..6b94462 100644
--- a/arch/blackfin/kernel/bfin_gpio.c
+++ b/arch/blackfin/kernel/bfin_gpio.c
@@ -686,14 +686,12 @@ void bfin_gpio_pm_hibernate_restore(void)
 		*port_fer[bank] = gpio_bank_saved[bank].fer;
 #endif
 		gpio_array[bank]->inen  = gpio_bank_saved[bank].inen;
+		gpio_array[bank]->data_set = gpio_bank_saved[bank].data
+						& gpio_bank_saved[bank].dir;
 		gpio_array[bank]->dir   = gpio_bank_saved[bank].dir;
 		gpio_array[bank]->polar = gpio_bank_saved[bank].polar;
 		gpio_array[bank]->edge  = gpio_bank_saved[bank].edge;
 		gpio_array[bank]->both  = gpio_bank_saved[bank].both;
-
-		gpio_array[bank]->data_set = gpio_bank_saved[bank].data
-						| gpio_bank_saved[bank].dir;
-
 		gpio_array[bank]->maska = gpio_bank_saved[bank].maska;
 	}
 	AWA_DUMMY_READ(maska);
-- 
1.6.3.3

