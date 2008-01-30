Return-Path: <linux-kernel-owner+w=401wt.eu-S1756622AbYA3ALp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622AbYA3ALp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 19:11:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752970AbYA3ALh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 19:11:37 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:58784 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300AbYA3ALg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 19:11:36 -0500
Message-ID: <479FC0B6.8000607@web.de>
Date: Wed, 30 Jan 2008 01:11:34 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Jason Wessel <jason.wessel@windriver.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] don't prefer unsuited consoles on registration
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18DpnqQlBPdMTeVROYxBxzQ2NMVu5rf24X5Y0OX
	CwFuxIBdxqbxOIgiME3O5GYgEgTM+wm/IGLH1+Qn62NrMj9+g0
	EOKPrtYlI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KGDB triggers a (probably so far theoretical) issue of the automatic
init console election: If some console happens to be registered first
which does not provide a tty binding (!console->device), it prevents
that more suited consoles which are registered later on can enter the
candidate pool for console_device(). This is observable with KGDB's
console which may already be registered (and exploited!) during early
debugger connections, that is before any regular console registration.

This patch fixes the issue by postponing the final, automated
preferred_console selection until someone with a non-NULL device
handler comes around.

Signed-off-by: Jan Kiszka <jan.kiszka@web.de>

---
 kernel/printk.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: b/kernel/printk.c
===================================================================
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1126,8 +1126,11 @@ void register_console(struct console *co
 			console->index = 0;
 		if (console->setup == NULL ||
 		    console->setup(console, NULL) == 0) {
-			console->flags |= CON_ENABLED | CON_CONSDEV;
-			preferred_console = 0;
+			console->flags |= CON_ENABLED;
+			if (console->device) {
+				console->flags |= CON_CONSDEV;
+				preferred_console = 0;
+			}
 		}
 	}
 
