Return-Path: <linux-kernel-owner+w=401wt.eu-S1763601AbYHDUXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763601AbYHDUXu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 16:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762571AbYHDUXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 16:23:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:45639 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755185AbYHDUXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 16:23:39 -0400
Date: Mon, 4 Aug 2008 13:15:05 -0700
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
       alan@lxorguk.ukuu.org.uk, Jiri Kosina <jkosina@suse.cz>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: [patch 10/33] Input: i8042 - retry failed CTR writes when resuming
Message-ID: <20080804201505.GK1139@suse.de>
References: <20080804200515.110033151@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="input-i8042-retry-failed-ctr-writes-when-resuming.patch"
In-Reply-To: <20080804201321.GA1139@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Jiri Kosina <jkosina@suse.cz>

commit 2f6a77d56523c14651236bc401a99b0e2aca2fdd upstream

There are systems that fail in i8042_resume() with

	i8042: Can't write CTR to resume

as i8042_command(&i8042_ctr, I8042_CMD_CTL_WCTR) fails even though the
controller claimed itself to be ready before.

One retry after failing write fixes the problems on the failing systems.

Reported-by: Helmut Schaa <hschaa@novell.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/input/serio/i8042.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -938,8 +938,12 @@ static int i8042_resume(struct platform_
 	i8042_ctr |= I8042_CTR_AUXDIS | I8042_CTR_KBDDIS;
 	i8042_ctr &= ~(I8042_CTR_AUXINT | I8042_CTR_KBDINT);
 	if (i8042_command(&i8042_ctr, I8042_CMD_CTL_WCTR)) {
-		printk(KERN_ERR "i8042: Can't write CTR to resume\n");
-		return -EIO;
+		printk(KERN_WARNING "i8042: Can't write CTR to resume, retrying...\n");
+		msleep(50);
+		if (i8042_command(&i8042_ctr, I8042_CMD_CTL_WCTR)) {
+			printk(KERN_ERR "i8042: CTR write retry failed\n");
+			return -EIO;
+		}
 	}
 
 	if (i8042_mux_present) {

-- 
