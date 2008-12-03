Return-Path: <linux-kernel-owner+w=401wt.eu-S1756435AbYLCUNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756435AbYLCUNg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 15:13:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754665AbYLCTyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:54:36 -0500
Received: from kroah.org ([198.145.64.141]:60341 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754288AbYLCTye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:54:34 -0500
Date: Wed, 3 Dec 2008 11:52:56 -0800
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
       alan@lxorguk.ukuu.org.uk, Bernhard Walle <bwalle@suse.de>,
       Wim Van Sebroeck <wim@iguana.be>,
       Thomas Mingarelli <thomas.mingarelli@hp.com>,
       Vivek Goyal <vgoyal@redhat.com>
Subject: [patch 060/104] WATCHDOG: hpwdt: Fix kdump when using hpwdt
Message-ID: <20081203195256.GI8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="watchdog-hpwdt-fix-kdump-when-using-hpwdt.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Bernhard Walle <bwalle@suse.de>

commit 290172e79036fc25a22aaf3da4835ee634886183 upstream.

When the "hpwdt" module is loaded (even if the /dev/watchdog device is not
opened), then kdump does not work. The panic kernel either does not start at
all or crash in various places.

The problem is that hpwdt_pretimeout is registered with register_die_notifier()
with the highest possible priority. Because it returns NOTIFY_STOP, the
crash_nmi_callback which is also registered with register_die_notifier()
is never executed. This causes the shutdown of other CPUs to fail.

Reverting the order is no option: The crash_nmi_callback executes HLT
and so never returns normally. Because of that, it must be executed as
last notifier, which currently is done.

So, that patch returns NOTIFY_OK to keep the crash_nmi_callback executed.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Thomas Mingarelli <thomas.mingarelli@hp.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/watchdog/hpwdt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -485,7 +485,7 @@ static int hpwdt_pretimeout(struct notif
 			"Management Log for details.\n");
 	}
 
-	return NOTIFY_STOP;
+	return NOTIFY_OK;
 }
 
 /*

