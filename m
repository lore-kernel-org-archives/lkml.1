Return-Path: <linux-kernel-owner+w=401wt.eu-S1758264AbYJFX3F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758264AbYJFX3F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 19:29:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757084AbYJFXWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 19:22:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55270 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757066AbYJFXWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 19:22:43 -0400
Date: Mon, 6 Oct 2008 16:17:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 21/28] clockevents: remove WARN_ON which was used to gather
	information
Message-ID: <20081006231746.GV20567@suse.de>
References: <20081006225949.357365087@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="timer-fix-11.patch"
In-Reply-To: <20081006231639.GA20567@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Thomas Gleixner <tglx@linutronix.de>

commit 61c22c34c6f80a8e89cff5ff717627c54cc14fd4 upstream

The issue of the endless reprogramming loop due to a too small
min_delta_ns was fixed with the previous updates of the clock events
code, but we had no information about the spread of this problem. I
added a WARN_ON to get automated information via kerneloops.org and to
get some direct reports, which allowed me to analyse the affected
machines.

The WARN_ON has served its purpose and would be annoying for a release
kernel. Remove it and just keep the information about the increase of
the min_delta_ns value.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/time/tick-oneshot.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

--- a/kernel/time/tick-oneshot.c
+++ b/kernel/time/tick-oneshot.c
@@ -43,19 +43,17 @@ int tick_dev_program_event(struct clock_
 		 * and emit a warning.
 		 */
 		if (++i > 2) {
-			printk(KERN_WARNING "CE: __tick_program_event of %s is "
-			       "stuck %llx %llx\n", dev->name ? dev->name : "?",
-			       now.tv64, expires.tv64);
-			printk(KERN_WARNING
-			       "CE: increasing min_delta_ns %ld to %ld nsec\n",
-			       dev->min_delta_ns, dev->min_delta_ns << 1);
-			WARN_ON(1);
-
-			/* Double the min. delta and try again */
+			/* Increase the min. delta and try again */
 			if (!dev->min_delta_ns)
 				dev->min_delta_ns = 5000;
 			else
-				dev->min_delta_ns <<= 1;
+				dev->min_delta_ns += dev->min_delta_ns >> 1;
+
+			printk(KERN_WARNING
+			       "CE: %s increasing min_delta_ns to %lu nsec\n",
+			       dev->name ? dev->name : "?",
+			       dev->min_delta_ns << 1);
+
 			i = 0;
 		}
 

-- 
