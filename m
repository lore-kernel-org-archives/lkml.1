Return-Path: <linux-kernel-owner+w=401wt.eu-S1761851AbYDNPKF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761851AbYDNPKF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 11:10:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758964AbYDNPJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 11:09:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48446 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755316AbYDNPJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 11:09:53 -0400
Date: Mon, 14 Apr 2008 08:09:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bongani Hlope <bonganilinux@mweb.co.za>
cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Shutdown and Reboot Regression 2.6.25-rc[78]
In-Reply-To: <alpine.LFD.1.00.0804140759190.2820@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.00.0804140808530.2820@woody.linux-foundation.org>
References: <200804112241.44626.bonganilinux@mweb.co.za> <20080411214257.GA4979@martell.zuzino.mipt.ru> <200804120905.50745.bonganilinux@mweb.co.za> <alpine.LFD.1.00.0804140759190.2820@woody.linux-foundation.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 14 Apr 2008, Linus Torvalds wrote:
> 
> Since you cannot see this on -rc9, can you go back to -rc8 and test this 
> patch [...]

Oh, maybe I should actually include the patch too ;)

			Linus
---
 kernel/printk.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index c46a20a..4476879 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -643,8 +643,20 @@ static int acquire_console_semaphore_for_printk(unsigned int cpu)
 {
 	int retval = 0;
 
-	if (can_use_console(cpu))
-		retval = !try_acquire_console_sem();
+	if (!try_acquire_console_sem()) {
+		retval = 1;
+
+		/*
+		 * If we can't use the console, we need to release
+		 * the console semaphore by hand to avoid flushing
+		 * the buffer
+		 */
+		if (!can_use_console(cpu)) {
+			console_locked = 0;
+			up(&console_sem);
+			retval = 0;
+		}
+	}
 	printk_cpu = UINT_MAX;
 	spin_unlock(&logbuf_lock);
 	return retval;
