Return-Path: <linux-kernel-owner+w=401wt.eu-S1753261AbZKLQFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbZKLQFY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 11:05:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753162AbZKLQFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 11:05:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65273 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753160AbZKLQFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 11:05:22 -0500
Date: Thu, 12 Nov 2009 14:05:04 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eran Liberty <liberty@extricom.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] serial_core: avoid Break bouncing
Message-ID: <20091112140504.6daf3824@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eran Liberty <liberty@extricom.com>

On some boxes, Break signal bounces, causing sysrq code to fail with some
serial interfaces.

A solution were posted on LKML in 2008:
http://lkml.indiana.edu/hypermail/linux/kernel/0809.2/0730.html

However, the fix weren't applied upstream.

This bug keeps happening, as shown at:
	https://bugzilla.redhat.com/show_bug.cgi?id=518120

The original patch from Eran adds a debouncing logic that avoids that
multiple breaks to be badly handled by the serial code.

[mchehab@redhat.com: port the patch upstream and fix CodingStyle]

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index db532ce..765e169 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -443,8 +443,8 @@ static inline int
 uart_handle_sysrq_char(struct uart_port *port, unsigned int ch)
 {
 #ifdef SUPPORT_SYSRQ
-	if (port->sysrq) {
-		if (ch && time_before(jiffies, port->sysrq)) {
+	if (port->sysrq && time_after(jiffies, port->sysrq + HZ / 50)) {
+		if (ch && time_before(jiffies, port->sysrq + HZ * 5)) {
 			handle_sysrq(ch, port->state->port.tty);
 			port->sysrq = 0;
 			return 1;
@@ -464,18 +464,17 @@ uart_handle_sysrq_char(struct uart_port *port, unsigned int ch)
 static inline int uart_handle_break(struct uart_port *port)
 {
 	struct uart_state *state = port->state;
+	int ret = 0;
+
 #ifdef SUPPORT_SYSRQ
 	if (port->cons && port->cons->index == port->line) {
-		if (!port->sysrq) {
-			port->sysrq = jiffies + HZ*5;
-			return 1;
-		}
-		port->sysrq = 0;
+		port->sysrq = jiffies;
+		ret = 1;
 	}
 #endif
 	if (port->flags & UPF_SAK)
 		do_SAK(state->port.tty);
-	return 0;
+	return ret;
 }
 
 /**

