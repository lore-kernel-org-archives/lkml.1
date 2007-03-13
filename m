Return-Path: <linux-kernel-owner+w=401wt.eu-S1751278AbXCMWcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751278AbXCMWcr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 18:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933347AbXCMWcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 18:32:47 -0400
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:56318 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751278AbXCMWcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 18:32:46 -0400
Date: Tue, 13 Mar 2007 18:32:46 -0400
To: linux-kernel@vger.kernel.org
Subject: jsm driver fix for linuxpps support
Message-ID: <20070313223246.GE22466@csclub.uwaterloo.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The jsm driver doesn't currently use the uart_handle_*_change helper
functions, which are the obvious place for things like linuxpps to tie
into (which it now does of course), and as a result the jsm driver can
not be used with linuxpps and anything else that ties into the
serial_core helper functions.  This patch adds calls to these helper
functions whenever the value they manage changes.  That actual storage
of the state is not modified since the jsm driver caches the current
settings (The 8250 driver reads them everytime a user asks for the
state), and only updates them whenever they change.

Signed-off-by: Len Sorensen <lsorense@csclub.uwaterloo.ca>

--- a/drivers/serial/jsm/jsm_neo.c	2007-03-01 10:31:28.000000000 -0500
+++ b/drivers/serial/jsm/jsm_neo.c	2007-03-01 10:18:16.000000000 -0500
@@ -592,8 +592,13 @@
 		return;
 
 	/* Scrub off lower bits. They signify delta's, which I don't care about */
-	msignals &= 0xf0;
+	/* Keep DDCD and DDSR though */
+	msignals &= 0xf8;
 
+	if (msignals & UART_MSR_DDCD)
+		uart_handle_dcd_change(&ch->uart_port, msignals & UART_MSR_DCD);
+	if (msignals & UART_MSR_DDSR)
+		uart_handle_cts_change(&ch->uart_port, msignals & UART_MSR_CTS);
 	if (msignals & UART_MSR_DCD)
 		ch->ch_mistat |= UART_MSR_DCD;
 	else
