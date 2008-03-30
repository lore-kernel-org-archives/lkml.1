Return-Path: <linux-kernel-owner+w=401wt.eu-S1753897AbYC3SnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbYC3SnR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 14:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752368AbYC3SnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 14:43:06 -0400
Received: from mail.gmx.net ([213.165.64.20]:35487 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752349AbYC3SnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 14:43:05 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX19oOCxyWORoKCpHHz/MH6i59ZiPlZ3FjH7eOwXggT
	4eir1cxTJtjud/
Date: Sun, 30 Mar 2008 20:42:59 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] evdev: Release eventual input device grabs when getting
	disconnected
Message-ID: <20080330184259.GB21375@atjola.homenet>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When getting disconnected we need to release eventual grabs on the
underlying input device as we also release the input device itself.
Otherwise, we would try to release the grab when the client that
requested it closes its handle, accessing the input device which
might already be freed.

Signed-off-by: Björn Steinbrink <B.Steinbrink@gmx.de>
---
I can't reproduce the bug on my UP box and currently can't afford
crashing my SMP box (all the oopses seem to come from SMP kernels, so I
guess it needs SMP to crash), so while this doesn't show any new
problems, I can't tell whether it actually fixes anything. Testers
welcome!

 drivers/input/evdev.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index 0727b0a..99562ce 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -853,6 +853,9 @@ static void evdev_cleanup(struct evdev *evdev)
 	evdev_hangup(evdev);
 	evdev_remove_chrdev(evdev);
 
+	if (evdev->grab)
+		evdev_ungrab(evdev, evdev->grab);
+
 	/* evdev is marked dead so no one else accesses evdev->open */
 	if (evdev->open) {
 		input_flush_device(handle, NULL);
-- 
1.5.5.rc2
