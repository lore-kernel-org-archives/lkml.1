Return-Path: <linux-kernel-owner+w=401wt.eu-S1761426AbXEOCgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761426AbXEOCgx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 22:36:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759100AbXEOCgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 22:36:46 -0400
Received: from smtp111.sbc.mail.re2.yahoo.com ([68.142.229.94]:37163 "HELO
	smtp111.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758975AbXEOCgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 22:36:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=dGxEok2FpoXB0jvtlgBOvprXnYWttcFlwjbWxVhExz3Bsj5iAuVqbkDHNlQ7EPH83Xjz0Rt+x34x/Z5kXCrPdG4a/2PuVqTvh57Bld2R0txihSK8zii6aHx93eIsDME/BXv0HnjEU23prmDe+5T4Apdf/aTLgN1MnYPF2cqmc9c=  ;
X-YMail-OSG: lzahk38VM1lhv_mFYjJIKb5csCV0KRWpshIAHsq2kQ9Rdt._Vv3WVL12iytE7YphICaWe8gtdw--
From: David Brownell <david-b@pacbell.net>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [patch 2.6.22-rc1] gpio interface loosens call restrictions
Date: Mon, 14 May 2007 19:16:28 -0700
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705141916.29070.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Loosen gpio_{request,free}() and gpio_direction_{in,out}put() call context
restrictions slightly, so a common idiom is no longer an error:  board init
code setting up spinlock-safe GPIOs before tasking is enabled.

The issue was caught by some paranoid code with might_sleep() checks.  The
legacy platform-specific GPIO interfaces stick to spinlock-safe GPIOs, so
this change reflects current implementations and won't break anything.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>

---
 Documentation/gpio.txt |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

--- osk.orig/Documentation/gpio.txt	2007-05-12 21:18:56.000000000 -0700
+++ osk/Documentation/gpio.txt	2007-05-13 09:35:27.000000000 -0700
@@ -113,7 +113,9 @@ setting up a platform_device using the G
 
 The return value is zero for success, else a negative errno.  It should
 be checked, since the get/set calls don't have error returns and since
-misconfiguration is possible.  (These calls could sleep.)
+misconfiguration is possible.  You should normally issue these calls from
+a task context.  However, for spinlock-safe GPIOs it's OK to use them
+before tasking is enabled, as part of early board setup.
 
 For output GPIOs, the value provided becomes the initial output value.
 This helps avoid signal glitching during system startup.
@@ -199,7 +201,9 @@ However, many platforms don't currently 
 
 Passing invalid GPIO numbers to gpio_request() will fail, as will requesting
 GPIOs that have already been claimed with that call.  The return value of
-gpio_request() must be checked.  (These calls could sleep.)
+gpio_request() must be checked.  You should normally issue these calls from
+a task context.  However, for spinlock-safe GPIOs it's OK to request GPIOs
+before tasking is enabled, as part of early board setup.
 
 These calls serve two basic purposes.  One is marking the signals which
 are actually in use as GPIOs, for better diagnostics; systems may have
