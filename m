Return-Path: <linux-kernel-owner+w=401wt.eu-S1760770AbXH1Spf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760770AbXH1Spf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 14:45:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbXH1Sp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 14:45:27 -0400
Received: from smtp115.sbc.mail.re3.yahoo.com ([66.196.96.88]:41432 "HELO
	smtp115.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750952AbXH1Sp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 14:45:26 -0400
X-YMail-OSG: 2cfvfxAVM1nx8QRlIYLmuNf3Czqj7E600oUEGMn4i6GE1S6pD5QF2YjHVyZBI9Po4JpzZfl7j7oQDd.7eqeZBs_6TFxL3hFf0WM_RwwZuiNQVt.FAABn5Q--
Date: Tue, 28 Aug 2007 13:45:22 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Andrew Morton <akpm@osdl.org>, Andrew Morgan <morgan@kernel.org>
Cc: Marcel Holtmann <marcel@holtmann.org>,
       Michael Kerrisk <mtk-manpages@gmx.net>, linux-kernel@vger.kernel.org,
       Stephen Smalley <sds@epoch.ncsc.mil>
Subject: [PATCH -mm] capabilities: reset current->pdeath_signal when
	increasing capabilities
Message-ID: <20070828184522.GA24634@vino.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I think the following does the right thing with respect to the
pdeath_signal bug and file capabilities.  I somewhat question the need
to do this if we're just switching uid or gid (if running in strict
capability mode), but it seems prudent to just leave it right there.

Note that so far this is only need in -mm.  Linus' tree will do the
right thing with the original pdeath patch since the only way to
increase capabilities is to first become root or run a setuid root
binary.

thanks,
-serge

>From 7e21df941dfb55c4fc19d82a91d6eae74766a2ec Mon Sep 17 00:00:00 2001
From: Serge E. Hallyn <serue@us.ibm.com>
Date: Tue, 28 Aug 2007 14:32:35 -0400
Subject: [PATCH] capabilities: reset current->pdeath_signal when increasing capabilities

If running a program which has file capabilities which are not a subset
of the capabilities of the current task, reset pdeath_signal = 0 to
prevent the task parent from (deliberately) signaling a more privileged
app.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
---
 security/commoncap.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/security/commoncap.c b/security/commoncap.c
index d65ddd3..43f9027 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -315,6 +315,7 @@ void cap_bprm_apply_creds (struct linux_binprm *bprm, int unsafe)
 	if (bprm->e_uid != current->uid || bprm->e_gid != current->gid ||
 	    !cap_issubset (new_permitted, current->cap_permitted)) {
 		set_dumpable(current->mm, suid_dumpable);
+		current->pdeath_signal = 0;
 
 		if (unsafe & ~LSM_UNSAFE_PTRACE_CAP) {
 			if (!capable(CAP_SETUID)) {
-- 
1.5.1.1.GIT

