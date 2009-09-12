Return-Path: <linux-kernel-owner+w=401wt.eu-S1754545AbZILSNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545AbZILSNv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 14:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752464AbZILSNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 14:13:50 -0400
Received: from relais.videotron.ca ([24.201.245.36]:24190 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbZILSNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 14:13:50 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Sat, 12 Sep 2009 14:13:52 -0400 (EDT)
From: Marc Dionne <marc.c.dionne@gmail.com>
To: David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] KEYS: unlock tasklist when exiting early from
 keyctl_session_to_parent
Message-id: <alpine.LFD.2.00.0909121347400.4263@tornado>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we exit early from keyctl_session_to_parent because of permissions
or because the session keyring is the same as the parent, we need to
unlock the tasklist.

The missing unlock causes the system to hang completely when
using keyctl(KEYCTL_SESSION_TO_PARENT) with a keyring shared with
the parent.

Signed-off-by: Marc Dionne <marc.c.dionne@gmail.com>
---
 security/keys/keyctl.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index 74c9685..60983f3 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -1319,6 +1319,7 @@ long keyctl_session_to_parent(void)
 already_same:
 	ret = 0;
 not_permitted:
+	write_unlock_irq(&tasklist_lock);
 	put_cred(cred);
 	return ret;
 
-- 
1.6.4.2

