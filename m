Return-Path: <linux-kernel-owner+w=401wt.eu-S935989AbZLQEWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935989AbZLQEWN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:22:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935969AbZLQEFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:05:08 -0500
Received: from kroah.org ([198.145.64.141]:55765 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935718AbZLQEEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:04:55 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:55 2009
Message-Id: <20091217035655.194444555@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:56:31 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ian Campbell <ian.campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [094/151] xen: dont leak IRQs over suspend/resume.
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ian Campbell <ian.campbell@citrix.com>

commit fed5ea87e02aaf902ff38c65b4514233db03dc09 upstream.

On resume irq_info[*].evtchn is reset to 0 since event channel mappings
are not preserved over suspend/resume. The other contents of irq_info
is preserved to allow rebind_evtchn_irq() to function.

However when a device resumes it will try to unbind from the
previous IRQ (e.g.  blkfront goes blkfront_resume() -> blkif_free() ->
unbind_from_irqhandler() -> unbind_from_irq()). This will fail due to the
check for VALID_EVTCHN in unbind_from_irq() and the IRQ is leaked. The
device will then continue to resume and allocate a new IRQ, eventually
leading to find_unbound_irq() panic()ing.

Fix this by changing unbind_from_irq() to handle teardown of interrupts
which have type!=IRQT_UNBOUND but are not currently bound to a specific
event channel.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/xen/events.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -474,6 +474,9 @@ static void unbind_from_irq(unsigned int
 		bind_evtchn_to_cpu(evtchn, 0);
 
 		evtchn_to_irq[evtchn] = -1;
+	}
+
+	if (irq_info[irq].type != IRQT_UNBOUND) {
 		irq_info[irq] = mk_unbound_info();
 
 		dynamic_irq_cleanup(irq);


