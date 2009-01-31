Return-Path: <linux-kernel-owner+w=401wt.eu-S1754136AbZAaDNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136AbZAaDNp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 22:13:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755454AbZAaCry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 21:47:54 -0500
Received: from kroah.org ([198.145.64.141]:55677 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757390AbZAaCrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 21:47:47 -0500
Date: Fri, 30 Jan 2009 18:44:57 -0800
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
       alan@lxorguk.ukuu.org.uk, Jiri Slaby <jirislaby@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [patch 40/43] PCI hotplug: fix lock imbalance in pciehp
Message-ID: <20090131024457.GO12368@kroah.com>
References: <20090131022548.656772939@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="pci-hotplug-fix-lock-imbalance-in-pciehp.patch"
In-Reply-To: <20090131024158.GA12368@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jiri Slaby <jirislaby@gmail.com>

commit c2fdd36b550659f5ac2240d1f5a83ffa1a092289 upstream.

set_lock_status omits mutex_unlock in fail path. Add the omitted
unlock.

As a result a lockup caused by this can be triggered from userspace
by writing 1 to /sys/bus/pci/slots/.../lock often enough.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Reviewed-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/hotplug/pciehp_core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/pci/hotplug/pciehp_core.c
+++ b/drivers/pci/hotplug/pciehp_core.c
@@ -126,8 +126,10 @@ static int set_lock_status(struct hotplu
 	mutex_lock(&slot->ctrl->crit_sect);
 
 	/* has it been >1 sec since our last toggle? */
-	if ((get_seconds() - slot->last_emi_toggle) < 1)
+	if ((get_seconds() - slot->last_emi_toggle) < 1) {
+		mutex_unlock(&slot->ctrl->crit_sect);
 		return -EINVAL;
+	}
 
 	/* see what our current state is */
 	retval = get_lock_status(hotplug_slot, &value);

