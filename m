Return-Path: <linux-kernel-owner+w=401wt.eu-S1761534AbXKNSDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761534AbXKNSDQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 13:03:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756269AbXKNSCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 13:02:47 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:56530 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807AbXKNSCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 13:02:46 -0500
Date: Wed, 14 Nov 2007 12:02:35 -0600
From: "Serge E. Hallyn" <sergeh@us.ibm.com>
To: Chris Friedhoff <chris@friedhoff.org>
Cc: Serge E Hallyn <sergeh@us.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Posix file capabilities in 2.6.24rc2
Message-ID: <20071114180235.GA25344@sergelap.austin.ibm.com>
References: <20071113230720.22c6a036.chris@friedhoff.org> <20071113235318.GA6477@sergelap.austin.ibm.com> <20071114101251.a1f6214d.chris@friedhoff.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071114101251.a1f6214d.chris@friedhoff.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Chris Friedhoff (chris@friedhoff.org):
> Hello Serge,
> 
> I wanted only to express what I observed.
> 
> A "yes it should" confirms its ok.
> 
> And yes, I haven't looked into the patches and the name and commentary
> of file-capabilities-clear-fcaps-on-inode-change.patch explains this
> already.
> I'm preparing to update my page http://www.friedhoff.org/fscaps.html
> for 2.6.24, and I also want to explain what one has to take into account
> or be beware off. If I stumble about this, I think others will also
> (imho).
> 
> I have written a script to change suid binaries and servers,
> automating the examples I give on the webpage.

Cool, sounds very useful.

> In the sequence of commands I was setting fscaps and than chown the
> binary. Now with the aforementioned patch the fscaps are removed when
> I chown and the script wasn't working anymore. My point is not my
> script, it's being surprised and being a bit at a loss. Documenting
> this helps to clarify things and users to adopt this feature.
> 
> 
> The matter with "xinit:  Operation not permitted..." happens, when I
> (unprivileged user) close a from a console started X session. Similar to
> Andrew Morton'S http://lkml.org/lkml/2006/11/23/15 . The 2.6.24-rc2
> kernel has capabilties enabled but /usr/bin/xinit has no capabilities
> set. It remains the black screen with a cursor, the windowmanager is
> closed. Is this known? Is this a problem? Does anyone else observes
> this?

I'm setting up a vm to play with this.  Will look into it.

Oh, looking at a few branches, I see that the patch for bug# 9247
(on bugzilla.kernel.org) isn't in 2.6.24-rc2 yet.  Can you check
whether the following patch fixes it?

thanks,
-serge

>From 347faf5852644b91632813885784104f4cdb640a Mon Sep 17 00:00:00 2001
From: Serge E. Hallyn <serue@us.ibm.com>
Date: Wed, 14 Nov 2007 13:00:52 -0500
Subject: [PATCH 1/1] file capabilities: allow sigcont within session (v2.6.24-rc2)

Allow sigcont to be sent to a process with greater capabilities
if it is in the same session.  Otherwise, a shell from which
I've started a root shell and done 'suspend' can't be restarted
by the parent shell.

(this patch against v2.6.24-rc2)

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
---
 security/commoncap.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/security/commoncap.c b/security/commoncap.c
index bf67871..c9f6867 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -534,6 +534,8 @@ int cap_task_kill(struct task_struct *p, struct siginfo *info,
 		 * Used only by usb drivers?
 		 */
 		return 0;
+	if (sig == SIGCONT && (task_session_nr(current)==task_session_nr(p)))
+		return 0;
 	if (cap_issubset(p->cap_permitted, current->cap_permitted))
 		return 0;
 	if (capable(CAP_KILL))
-- 
1.5.1.1.GIT

