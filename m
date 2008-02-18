Return-Path: <linux-kernel-owner+w=401wt.eu-S1756419AbYBRBjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419AbYBRBjy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 20:39:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750862AbYBRBjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 20:39:44 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:51830 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904AbYBRBjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 20:39:43 -0500
Date: Sun, 17 Feb 2008 19:39:43 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, charles.kirsch@internet.lu,
       lkml <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org,
       Gerald Combs <gerald@wireshark.org>,
       Gilbert Ramirez <gram@alumni.rice.edu>, Guy Harris <guy@alum.mit.edu>
Subject: Re: Possible problem in linux file posix capabilities
Message-ID: <20080218013943.GA17142@sergelap.austin.ibm.com>
References: <20080217224851.GA9168@sergelap.austin.ibm.com> <47B8DD55.5070800@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B8DD55.5070800@kernel.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew G. Morgan (morgan@kernel.org):
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Serge E. Hallyn wrote:
> | Andrew, this pretty much was bound to happen...  we need to figure out
> | what our approach here should be.  My preference is still to allow
> | signals when p->uid==current->uid so long as !SECURE_NOROOT.  Then as
> | people start using secure_noroot process trees they at least must know
> | what they're asking for.
>
> I don't think there is anything special about root.
>
> I've been trying to advocate that we remove the *uid == 0 part of this
> check since we discussed it in November:
>
> As I said 11/29/07 [Re: [patch 31/55] file capabilities: don't prevent
> signaling	setuid root programs]:
> | I actually said (11/26/07):
> |> >> Serge,
> |> >>
> |> >> I still feel a bit uneasy about this. Looking ahead, with filesystem
> |> >> capabilities, one can simulate this same situation with a setuid
> |> >> 'non-root' program as follows:
> |> >>
> |> >> [... example of simulating the same situation with setuid-non-root
> ...]
> |> >>
> |> >> Is there a compelling reason to include the euid==0 check?
>
> So, independent of whether SECURE_NOROOT is in effect or not, I think
> this particular line should simply read:
>
> ~        if (p->uid == current->uid)
> ~                 return 0;

Hmm, well unless I misunderstand I think I'm fine with that.  And I must
have completely misunderstood you in November or my memory is just
playing tricks.

So the following patch against current -git is ok with you?

thanks,
-serge

>From bd076c7245d02be0cc01b7c09bd7170ec5946492 Mon Sep 17 00:00:00 2001
From: Serge E. Hallyn <serue@us.ibm.com>
Date: Sun, 17 Feb 2008 20:28:07 -0500
Subject: [PATCH 1/1] file capabilities: simplify signal check

Simplify the uid equivalence check in cap_task_kill().  Anyone
can kill a process owned by the same uid.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
---
 security/commoncap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/security/commoncap.c b/security/commoncap.c
index 5aba826..bb0c095 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -552,7 +552,7 @@ int cap_task_kill(struct task_struct *p, struct siginfo *info,
 	 * allowed.
 	 * We must preserve legacy signal behavior in this case.
 	 */
-	if (p->euid == 0 && p->uid == current->uid)
+	if (p->uid == current->uid)
 		return 0;
 
 	/* sigcont is permitted within same session */
-- 
1.5.1.1.GIT

