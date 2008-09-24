Return-Path: <linux-kernel-owner+w=401wt.eu-S1754489AbYIXRky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489AbYIXRky (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 13:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbYIXRkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 13:40:47 -0400
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:20258 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751517AbYIXRkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 13:40:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=mq1kuTRXsN8Ra1S7QZHTtIsg0llm701QBZn3gbXCT7BJzi321Wz5kbwsHsQAzB3Fuh6EKWhg2kgnxc1fZ45U5aLgiLjkkUN1WmkYMp8W8pDOdm3Ic6B0Y3LBo3acSE1UeY/kgLvHIdFs8fWXGUiw+s8GMuKtC3BojcHPpuEaUxU=  ;
X-YMail-OSG: imhnkFcVM1m2YOCWDSDME_C6nctesWXCgs8RBKGygBmZjDWarS7t.hCbox0WwSidPKLyB8GSGg7dfbjS.INnVRlZy_hET5WrsgwsRQMhNRAStQvmyzLp0yD.yuD23WUQiMKy95kWHAFzer_pzFIE5_yQ
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Jean Delvare <khali@linux-fr.org>
Subject: [patch 2.6.27-rc7] gpio: i2c expanders use subsys_init
Date: Wed, 24 Sep 2008 10:40:43 -0700
User-Agent: KMail/1.9.9
Cc: lkml <linux-kernel@vger.kernel.org>, i2c@lm-sensors.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809241040.43943.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Make the I2C external GPIO expander drivers register themselves
at subsys_initcall() time when they're statically linked.

SOC-integrated GPIOs are available starting very early -- early
in arch_initcall() at latest, but often even before initcalls
start to run -- so this improves consistency, so more subsystems
can rely on GPIOs in their own subsys_initcall() code.

(This isn't a theoretical problem.  This is one of several patches
needed to resolve oopsing observed when statically linking kernels
on a DaVinci EVM.  Its pcf857x GPIOs needed to be available well
before some other drivers initialized.)

This depends on a patch moving I2C's driver model init earlier
in the boot sequence; otherwise this change would cause oopsing.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
For the 2.6.28-rc0 merge window.  Jean, can you include this
in your I2C tree, so it only merges after the I2C init patch
on which it depends?  We want "git bisect" to work.  ;)

 drivers/gpio/max732x.c |    5 ++++-
 drivers/gpio/pca953x.c |    5 ++++-
 drivers/gpio/pcf857x.c |    5 ++++-
 3 files changed, 12 insertions(+), 3 deletions(-)

--- a/drivers/gpio/max732x.c
+++ b/drivers/gpio/max732x.c
@@ -372,7 +372,10 @@ static int __init max732x_init(void)
 {
 	return i2c_add_driver(&max732x_driver);
 }
-module_init(max732x_init);
+/* register after i2c postcore initcall and before
+ * subsys initcalls that may rely on these GPIOs
+ */
+subsys_initcall(max732x_init);
 
 static void __exit max732x_exit(void)
 {
--- a/drivers/gpio/pca953x.c
+++ b/drivers/gpio/pca953x.c
@@ -289,7 +289,10 @@ static int __init pca953x_init(void)
 {
 	return i2c_add_driver(&pca953x_driver);
 }
-module_init(pca953x_init);
+/* register after i2c postcore initcall and before
+ * subsys initcalls that may rely on these GPIOs
+ */
+subsys_initcall(pca953x_init);
 
 static void __exit pca953x_exit(void)
 {
--- a/drivers/gpio/pcf857x.c
+++ b/drivers/gpio/pcf857x.c
@@ -351,7 +351,10 @@ static int __init pcf857x_init(void)
 {
 	return i2c_add_driver(&pcf857x_driver);
 }
-module_init(pcf857x_init);
+/* register after i2c postcore initcall and before
+ * subsys initcalls that may rely on these GPIOs
+ */
+subsys_initcall(pcf857x_init);
 
 static void __exit pcf857x_exit(void)
 {
