Return-Path: <linux-kernel-owner+w=401wt.eu-S1760570AbYBGBlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760570AbYBGBlb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 20:41:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752464AbYBGBlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 20:41:23 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:10596 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbYBGBlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 20:41:22 -0500
Date: Wed, 6 Feb 2008 18:41:17 -0700
From: dann frazier <dannf@hp.com>
To: Willy TARREAU <w@1wt.eu>
Cc: Florian Zumbiehl <florz@florz.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] 2.4: [PPPOE]: memory leak when socket is release()d before
	PPPIOCGCHAN has been called on it
Message-ID: <20080207014117.GA14829@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a 2.4 backport of a linux-2.6 change by Florian Zumbiehl.
(commit 202a03acf9994076055df40ae093a5c5474ad0bd)

CVE-2007-2525 was assigned for this issue. It has been compile tested-only.

Commit log from 2.6 follows.

  below you find a patch that fixes a memory leak when a PPPoE socket is
  release()d after it has been connect()ed, but before the PPPIOCGCHAN ioctl
  ever has been called on it.

  This is somewhat of a security problem, too, since PPPoE sockets can be
  created by any user, so any user can easily allocate all the machine's
  RAM to non-swappable address space and thus DoS the system.

  Is there any specific reason for PPPoE sockets being available to any
  unprivileged process, BTW? After all, you need a packet socket for the
  discovery stage anyway, so it's unlikely that any unprivileged process
  will ever need to create a PPPoE socket, no? Allocating all session IDs
  for a known AC is a kind of DoS, too, after all - with Juniper ERXes,
  this is really easy, actually, since they don't ever assign session ids
  above 8000 ...

Signed-off-by: dann frazier <dannf@hp.com>
---
 drivers/net/pppox.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/pppox.c b/drivers/net/pppox.c
index 7830e4d..4883c0f 100644
--- a/drivers/net/pppox.c
+++ b/drivers/net/pppox.c
@@ -67,7 +67,7 @@ void pppox_unbind_sock(struct sock *sk)
 {
 	/* Clear connection to ppp device, if attached. */
 
-	if (sk->state & (PPPOX_BOUND|PPPOX_ZOMBIE)) {
+	if (sk->state & (PPPOX_BOUND | PPPOX_CONNECTED | PPPOX_ZOMBIE)) {
 		ppp_unregister_channel(&sk->protinfo.pppox->chan);
 		sk->state = PPPOX_DEAD;
 	}
-- 
1.5.3.7

