Return-Path: <linux-kernel-owner+w=401wt.eu-S1754858AbYHKAWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858AbYHKAWg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 20:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbYHKAW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 20:22:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50557 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752262AbYHKAW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 20:22:27 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080810113044.19143b0a@worthy.swandive.local>
References: <20080810113044.19143b0a@worthy.swandive.local> <1218322518.3268.0.camel@luna.unix.geek.nz> <1218287473.3155.13.camel@dhcppc0> <1218281190.3155.5.camel@dhcppc0> <1218214935.3146.5.camel@dhcppc0> <alpine.LRH.1.10.0808090747150.29079@tundra.namei.org> <14476.1218286327@redhat.com> <15386.1218290826@redhat.com> <10251.1218361539@redhat.com> 
To: Grant Wilson <grant.wilson@zen.co.uk>
Cc: dhowells@redhat.com, Jasper Bryant-Greene <jasper@amiton.co.nz>,
       Thomas Meyer <thomas@m3y3r.de>, James Morris <jmorris@namei.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux-Next <linux-next@vger.kernel.org>
Subject: Re: next-20080808: bash: fork: Resource temporarily unavailable
X-Mailer: MH-E 8.0.3+cvs; nmh 1.3; GNU Emacs 23.0.50
Date: Mon, 11 Aug 2008 01:21:10 +0100
Message-ID: <22475.1218414070@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Wilson <grant.wilson@zen.co.uk> wrote:

> [  223.039938] Rlimit EAGAIN (-1 >= 16375, uid 1000)
> [  223.044744] copy_process() = -11
> [  226.660319] Rlimit EAGAIN (-1 >= 16375, uid 1000)
> [  226.664166] copy_process() = -11

Can you try the attached patch please?

David
---
CRED: Inc the user processes count on cred share return from copy_creds()

From: David Howells <dhowells@redhat.com>

Increment the user processes count in the case where copy_creds() returns after
sharing the parent's credentials instead of allocating new ones.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 kernel/cred.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


diff --git a/kernel/cred.c b/kernel/cred.c
index f89c5e5..056ec90 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -299,6 +299,7 @@ int copy_creds(struct task_struct *p, unsigned long clone_flags)
 #endif
 		p->real_cred = get_cred(p->cred);
 		get_cred(p->cred);
+		atomic_inc(&p->cred->user->processes);
 		return 0;
 	}
 
