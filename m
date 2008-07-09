Return-Path: <linux-kernel-owner+w=401wt.eu-S1755944AbYGINU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944AbYGINU0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 09:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753551AbYGINUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 09:20:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43641 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753118AbYGINUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 09:20:16 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Fix the epca driver to permit epca_setup() to be invoked from
	the kernel cmdline
To: alan@redhat.com, akpm@linux-foundation.org
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Date: Wed, 09 Jul 2008 14:19:28 +0100
Message-ID: <20080709131927.639.72528.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the epca driver to call epca_setup() if digiepca=xxx is included on the
command line and the epca driver is built in.

epca_setup() used to be called from init/main.c in 2.2 kernels, but somewhere
along the way that call was removed but not replaced.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 drivers/char/epca.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)


diff --git a/drivers/char/epca.c b/drivers/char/epca.c
index 60a4df7..96a4b6b 100644
--- a/drivers/char/epca.c
+++ b/drivers/char/epca.c
@@ -186,7 +186,6 @@ static void pc_throttle(struct tty_struct *tty);
 static void pc_unthrottle(struct tty_struct *tty);
 static void digi_send_break(struct channel *ch, int msec);
 static void setup_empty_event(struct tty_struct *tty, struct channel *ch);
-static void epca_setup(char *, int *);
 
 static int pc_write(struct tty_struct *, const unsigned char *, int);
 static int pc_init(void);
@@ -2538,7 +2537,8 @@ static void setup_empty_event(struct tty_struct *tty, struct channel *ch)
 	memoff(ch);
 }
 
-static void epca_setup(char *str, int *ints)
+#ifndef MODULE
+static void __init epca_setup(char *str, int *ints)
 {
 	struct board_info board;
 	int               index, loop, last;
@@ -2792,6 +2792,17 @@ static void epca_setup(char *str, int *ints)
 	num_cards++;
 }
 
+static int __init epca_real_setup(char *str)
+{
+	int ints[11];
+
+	epca_setup(get_options(str, 11, ints), ints);
+	return 1;
+}
+
+__setup("digiepca", epca_real_setup);
+#endif
+
 enum epic_board_types {
 	brd_xr = 0,
 	brd_xem,

