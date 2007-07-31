Return-Path: <linux-kernel-owner+w=401wt.eu-S933826AbXGaShf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933826AbXGaShf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 14:37:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765478AbXGaSh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 14:37:26 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49489 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764616AbXGaShZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 14:37:25 -0400
Date: Tue, 31 Jul 2007 11:36:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Mike Frysinger" <vapier.adi@gmail.com>
Cc: "Robin Getz" <rgetz@blackfin.uclinux.org>, linux-kernel@vger.kernel.org,
       "Greg Ungerer" <gerg@snapgear.com>,
       "Russell King" <rmk@arm.linux.org.uk>,
       "Paul Mundt" <lethal@linux-sh.org>, "Tim Bird" <tim.bird@am.sony.com>,
       bryan.wu@analog.com
Subject: Re: early_printk accessing __log_buf
Message-Id: <20070731113608.f2c5d8b6.akpm@linux-foundation.org>
In-Reply-To: <8bd0f97a0707310047u51c6e46l7e57e8f7bfc4e858@mail.gmail.com>
References: <200707181756.44074.rgetz@blackfin.uclinux.org>
	<200707241350.45086.rgetz@blackfin.uclinux.org>
	<20070724111215.8d91dc7c.akpm@linux-foundation.org>
	<200707241612.56509.rgetz@blackfin.uclinux.org>
	<20070724143004.6325a511.akpm@linux-foundation.org>
	<8bd0f97a0707310047u51c6e46l7e57e8f7bfc4e858@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2007 03:47:59 -0400
"Mike Frysinger" <vapier.adi@gmail.com> wrote:

> attached
> -mike
> 
> 
> [linux-log_buf_read.patch  application/octet-stream (2.4KB)]

Please sort out the email thing if you plan on sending more kernel patches?

Incremental:


From: Andrew Morton <akpm@linux-foundation.org>

- compile fix

- Race fix: oops_in_progress can change at any time

- coding-style fixlets.

Cc: Greg Ungerer <gerg@snapgear.com>
Cc: Mike Frysinger <vapier.adi@gmail.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Tim Bird <tim.bird@am.sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    2 +-
 kernel/printk.c        |   12 ++++++++----
 2 files changed, 9 insertions(+), 5 deletions(-)

diff -puN include/linux/kernel.h~early_printk-accessing-__log_buf-fix include/linux/kernel.h
--- a/include/linux/kernel.h~early_printk-accessing-__log_buf-fix
+++ a/include/linux/kernel.h
@@ -168,7 +168,7 @@ static inline int printk(const char *s, 
 	__attribute__ ((format (printf, 1, 2)));
 static inline int __cold printk(const char *s, ...) { return 0; }
 static inline int log_buf_get_len(void) { return 0; }
-static inline int log_buf_read(int idx); { return 0; }
+static inline int log_buf_read(int idx) { return 0; }
 static inline int log_buf_copy(char *dest, int idx, int len) { return 0; }
 #endif
 
diff -puN kernel/printk.c~early_printk-accessing-__log_buf-fix kernel/printk.c
--- a/kernel/printk.c~early_printk-accessing-__log_buf-fix
+++ a/kernel/printk.c
@@ -233,14 +233,17 @@ int log_buf_get_len(void)
 int log_buf_copy(char *dest, int idx, int len)
 {
 	int ret, max;
+	bool took_lock = false;
 
-	if (!oops_in_progress)
+	if (!oops_in_progress) {
 		spin_lock_irq(&logbuf_lock);
+		took_lock = true;
+	}
 
 	max = log_buf_get_len();
-	if (idx < 0 || idx >= max)
+	if (idx < 0 || idx >= max) {
 		ret = -1;
-	else {
+	} else {
 		if (len > max)
 			len = max;
 		ret = len;
@@ -250,7 +253,7 @@ int log_buf_copy(char *dest, int idx, in
 		}
 	}
 
-	if (!oops_in_progress)
+	if (took_lock)
 		spin_unlock_irq(&logbuf_lock);
 
 	return ret;
@@ -262,6 +265,7 @@ int log_buf_copy(char *dest, int idx, in
 int log_buf_read(int idx)
 {
 	char ret;
+
 	if (log_buf_copy(&ret, idx, 1) == 1)
 		return ret;
 	else
_

