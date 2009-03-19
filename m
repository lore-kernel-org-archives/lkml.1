Return-Path: <linux-kernel-owner+w=401wt.eu-S1756423AbZCSQIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423AbZCSQIT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 12:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753012AbZCSQIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 12:08:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:50625 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbZCSQID convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 12:08:03 -0400
Date: Thu, 19 Mar 2009 09:09:05 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, akpm@linux-foundation.org
Subject: [PATCH] kobject: don't block for each kobject_uevent
Message-ID: <20090319090905.609d3750@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From d44701ae98a2c43a898dd7a7765d8894fd2e6caa Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Thu, 19 Mar 2009 09:02:17 -0700
Subject: [PATCH] kobject: don't block for each kobject_uevent

Right now, the kobject_uevent code blocks for each uevent that's being generated,
due to using (for hystoric reasons) UHM_WAIT_EXEC as flag to call_usermode_helper().
Specifically, the effect is that each uevent that is being sent causes the code to
wake up keventd, then block until keventd has processed the work. Needless to say,
this happens many times during the system boot.

This patches changes that to UHN_NO_WAIT (brilliant name for a constant btw) so
that we only schedule the work to fire the uevent message, but do not wait for
keventd to process the work.

This removes one of the bottlenecks during boot; each one of them is only a small
effect, but the sum of them does add up.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 lib/kobject_uevent.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
index 318328d..0b63523 100644
--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -248,7 +248,7 @@ int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
 			goto exit;
 
 		retval = call_usermodehelper(argv[0], argv,
-					     env->envp, UMH_WAIT_EXEC);
+					     env->envp, UMH_NO_WAIT);
 	}
 
 exit:
-- 
1.6.0.6



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
