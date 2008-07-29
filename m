Return-Path: <linux-kernel-owner+w=401wt.eu-S1760637AbYG2Uw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760637AbYG2Uw6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 16:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756044AbYG2Uws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 16:52:48 -0400
Received: from smtp1.tu-cottbus.de ([141.43.99.247]:59098 "EHLO
	smtp1.TU-Cottbus.De" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755769AbYG2Uws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 16:52:48 -0400
X-Greylist: delayed 442 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Jul 2008 16:52:48 EDT
Date: Tue, 29 Jul 2008 22:45:12 +0200
From: Eugeniy Meshcheryakov <eugen@debian.org>
To: alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] try harder to load tty ldisc driver
Message-ID: <20080729204512.GA6242@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently function tty_ldisc_get() tries to load an ldisc driver module
only when tty_ldisc_try_get() returns -EAGAIN. This happens only if
module is being unloaded. If ldisc module is not loaded
tty_ldisc_try_get() returns -EINVAL and this case is not handled in
tty_ldisc_get(), so request_module() is not called.

Attached patch fixes this by calling request_module() if
tty_ldisc_try_get() returned any error code.

I discovered this when my UMTS modem stopped working with 2.6.27-rc1
because module ppp_async was not loaded.

Signed-off-by: Eugeniy Meshcheryakov <eugen@debian.org>
--
diff --git a/drivers/char/tty_ldisc.c b/drivers/char/tty_ldisc.c
index 241cbde..f307f13 100644
--- a/drivers/char/tty_ldisc.c
+++ b/drivers/char/tty_ldisc.c
@@ -169,7 +169,7 @@ static int tty_ldisc_get(int disc, struct tty_ldisc *ld)
 	if (disc < N_TTY || disc >= NR_LDISCS)
 		return -EINVAL;
 	err = tty_ldisc_try_get(disc, ld);
-	if (err == -EAGAIN) {
+	if (err < 0) {
 		request_module("tty-ldisc-%d", disc);
 		err = tty_ldisc_try_get(disc, ld);
 	}
