Return-Path: <linux-kernel-owner+w=401wt.eu-S932706AbZKFWdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932706AbZKFWdF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:33:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932537AbZKFWdB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:33:01 -0500
Received: from kroah.org ([198.145.64.141]:56974 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932491AbZKFWXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:23:12 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:47 2009
Message-Id: <20091106221547.023042710@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:14:58 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [60/99] xen/hvc: make sure console output is always emitted, with explicit polling
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=xen-hvc-make-sure-console-output-is-always-emitted-with-explicit-polling.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

commit 7825cf10e31c64ece3cac66fb01a742f1094da51 upstream.

We never want to rely on the hvc workqueue to emit output, because the
most interesting output is when the kernel is broken.  This will
improve oops/crash/console message for better debugging.

Instead, we force-poll until all output is emitted.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/hvc_xen.c |   25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

--- a/drivers/char/hvc_xen.c
+++ b/drivers/char/hvc_xen.c
@@ -55,7 +55,7 @@ static inline void notify_daemon(void)
 	notify_remote_via_evtchn(xen_start_info->console.domU.evtchn);
 }
 
-static int write_console(uint32_t vtermno, const char *data, int len)
+static int __write_console(const char *data, int len)
 {
 	struct xencons_interface *intf = xencons_interface();
 	XENCONS_RING_IDX cons, prod;
@@ -76,6 +76,29 @@ static int write_console(uint32_t vtermn
 	return sent;
 }
 
+static int write_console(uint32_t vtermno, const char *data, int len)
+{
+	int ret = len;
+
+	/*
+	 * Make sure the whole buffer is emitted, polling if
+	 * necessary.  We don't ever want to rely on the hvc daemon
+	 * because the most interesting console output is when the
+	 * kernel is crippled.
+	 */
+	while (len) {
+		int sent = __write_console(data, len);
+
+		data += sent;
+		len -= sent;
+
+		if (unlikely(len))
+			HYPERVISOR_sched_op(SCHEDOP_yield, NULL);
+	}
+
+	return ret;
+}
+
 static int read_console(uint32_t vtermno, char *buf, int len)
 {
 	struct xencons_interface *intf = xencons_interface();


