Return-Path: <linux-kernel-owner+w=401wt.eu-S1756168AbZHMUM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168AbZHMUM6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 16:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755922AbZHMUMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 16:12:51 -0400
Received: from kroah.org ([198.145.64.141]:41679 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755877AbZHMT7W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:59:22 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:51:27 2009
Message-Id: <20090813195126.920965349@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:49:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>
Subject: [patch 16/74] drm/i915: avoid non-atomic sysrq execution
References: <20090813194935.985368088@mini.kroah.org>
Content-Disposition: inline; filename=0003-drm-i915-avoid-non-atomic-sysrq-execution.patch
In-Reply-To: <20090813195705.GA22393@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jesse Barnes <jbarnes@virtuousgeek.org>

(cherry picked from commit b66d18ddb16603d1e1ec39cb2ff3abf3fd212180)

The sysrq functions are executed in hardirq context, so we shouldn't be
calling sleeping functions from them, like mutex_locks or memory
allocations.

Fix up the i915 sysrq handler to avoid this.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/gpu/drm/i915/intel_fb.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_fb.c
+++ b/drivers/gpu/drm/i915/intel_fb.c
@@ -857,9 +857,15 @@ void intelfb_restore(void)
 	drm_crtc_helper_set_config(&kernelfb_mode);
 }
 
+static void intelfb_restore_work_fn(struct work_struct *ignored)
+{
+	intelfb_restore();
+}
+static DECLARE_WORK(intelfb_restore_work, intelfb_restore_work_fn);
+
 static void intelfb_sysrq(int dummy1, struct tty_struct *dummy3)
 {
-        intelfb_restore();
+        schedule_work(&intelfb_restore_work);
 }
 
 static struct sysrq_key_op sysrq_intelfb_restore_op = {


