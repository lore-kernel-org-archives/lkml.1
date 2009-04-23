Return-Path: <linux-kernel-owner+w=401wt.eu-S1760582AbZDWH7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760582AbZDWH7r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:59:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757700AbZDWHg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:36:28 -0400
Received: from sous-sol.org ([216.99.217.87]:47491 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757677AbZDWHg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:36:26 -0400
Message-Id: <20090423073055.839821637@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:21:53 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Marcelo Tosatti <mtosatti@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [patch 093/100] virtio: fix suspend when using virtio_balloon
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=virtio-fix-suspend-when-using-virtio_balloon.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Marcelo Tosatti <mtosatti@redhat.com>

upstream commit: 84a139a985300901dfad99bd93c7345d180af860

Break out of wait_event_interruptible() if freezing has been requested,
in the vballoon thread. Without this change vballoon refuses to stop and
the system can't suspend.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: stable@kernel.org
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/virtio/virtio_balloon.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -190,7 +190,8 @@ static int balloon(void *_vballoon)
 		try_to_freeze();
 		wait_event_interruptible(vb->config_change,
 					 (diff = towards_target(vb)) != 0
-					 || kthread_should_stop());
+					 || kthread_should_stop()
+					 || freezing(current));
 		if (diff > 0)
 			fill_balloon(vb, diff);
 		else if (diff < 0)

