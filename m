Return-Path: <linux-kernel-owner+w=401wt.eu-S1758065AbZCYAul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758065AbZCYAul (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:50:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756140AbZCYAaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:30:46 -0400
Received: from kroah.org ([198.145.64.141]:54210 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756791AbZCYAaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:30:30 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 56/61] kobject: don't block for each kobject_uevent
Date: Tue, 24 Mar 2009 17:27:00 -0700
Message-Id: <1237940825-22904-56-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <20090325001659.GA22461@kroah.com>
References: <20090325001659.GA22461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@linux.intel.com>

Right now, the kobject_uevent code blocks for each uevent that's being
generated, due to using (for hystoric reasons) UHM_WAIT_EXEC as flag to
call_usermode_helper().  Specifically, the effect is that each uevent
that is being sent causes the code to wake up keventd, then block until
keventd has processed the work. Needless to say, this happens many times
during the system boot.

This patches changes that to UHN_NO_WAIT (brilliant name for a constant
btw) so that we only schedule the work to fire the uevent message, but
do not wait for keventd to process the work.

This removes one of the bottlenecks during boot; each one of them is
only a small effect, but the sum of them does add up.

[Note, distros that need this are broken, they should be setting
CONFIG_UEVENT_HELPER_PATH to "", that way this code path will never be
excuted at all -- gregkh]

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 lib/kobject_uevent.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
index b2181cc..e68e743 100644
--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -255,7 +255,7 @@ int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
 			goto exit;
 
 		retval = call_usermodehelper(argv[0], argv,
-					     env->envp, UMH_WAIT_EXEC);
+					     env->envp, UMH_NO_WAIT);
 	}
 
 exit:
-- 
1.6.2

