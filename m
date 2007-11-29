Return-Path: <linux-kernel-owner+w=401wt.eu-S1762214AbXK2AR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762214AbXK2AR2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 19:17:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762018AbXK2ARH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 19:17:07 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:53230 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761957AbXK2ARG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 19:17:06 -0500
Date: Wed, 28 Nov 2007 18:17:01 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>, Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Andrew G. Morgan" <morgan@kernel.org>
Subject: Re: named + capset = EPERM [Was: 2.6.24-rc3-mm2]
Message-ID: <20071129001701.GA26817@sergelap.austin.ibm.com>
References: <474DF493.3010903@gmail.com> <830198.27330.qm@web36612.mail.mud.yahoo.com> <20071128234743.GA26217@sergelap.austin.ibm.com> <20071129000408.GA26502@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071129000408.GA26502@sergelap.austin.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Serge E. Hallyn (serue@us.ibm.com):
> Quoting Serge E. Hallyn (serue@us.ibm.com):
> > Quoting Casey Schaufler (casey@schaufler-ca.com):
> > > 
> > > --- Jiri Slaby <jirislaby@gmail.com> wrote:
> > > 
> > > > On 11/28/2007 12:41 PM, Andrew Morton wrote:
> > > > >
> > > >
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc3/2.6.24-rc3-mm2/
> > > > [...]
> > > > > +capabilities-introduce-per-process-capability-bounding-set.patch
> > > > 
> > > > A regression against -mm1. This patch breaks bind (9.5.0-18.a7.fc8):
> > > > capset(0x19980330, 0,
> > > >
> > > {CAP_DAC_READ_SEARCH|CAP_SETGID|CAP_SETUID|CAP_NET_BIND_SERVICE|CAP_SYS_CHROOT|CAP_SYS_RESOURCE,
> > > >
> > > CAP_DAC_READ_SEARCH|CAP_SETGID|CAP_SETUID|CAP_NET_BIND_SERVICE|CAP_SYS_CHROOT|CAP_SYS_RESOURCE,
> > > > 0}) = -1 EPERM (Operation not permitted)
> > > > 
> > > > $ grep SEC .config
> > > > CONFIG_SECCOMP=y
> > > > # CONFIG_NETWORK_SECMARK is not set
> > > > CONFIG_RPCSEC_GSS_KRB5=m
> > > > # CONFIG_RPCSEC_GSS_SPKM3 is not set
> > > > # CONFIG_SECURITY is not set
> > > > # CONFIG_SECURITY_FILE_CAPABILITIES is not set
> > > > 
> > > > probably this hunk?:
> > > > @@ -133,6 +119,12 @@ int cap_capset_check (struct task_struct
> > > >                 /* incapable of using this inheritable set */
> > > >                 return -EPERM;
> > > >         }
> > > > +       if (!!cap_issubset(*inheritable,
> > > > +                          cap_combine(target->cap_inheritable,
> > > > +                                      current->cap_bset))) {
> > > > +               /* no new pI capabilities outside bounding set */
> > > > +               return -EPERM;
> > > > +       }
> > 
> > That shouldn't be it, since you can't lower cap_bset since
> > CONFIG_SECURITY_FILE_CAPABILITIES=n.
> 
> Hmm, but sure enough that appears to be it.
> 
> Still trying to figure out why.

No.  Seriously.  You're kidding me.

Patch attached  :(

Thanks for spotting this, Jiri.  I don't know where I introduced this
since I thought all my tests had passed...

thanks,
-serge

>From 70d5da610fdbd66a36886c01e27b7fb11d2de044 Mon Sep 17 00:00:00 2001
From: sergeh@us.ibm.com <hallyn@kernel.(none)>
Date: Wed, 28 Nov 2007 16:16:23 -0800
Subject: [PATCH 1/1] capabilities: correct logic at capset_check

Fix typo at capset_check introduced with capability bounding set
patch.

Signed-off-by: sergeh@us.ibm.com <hallyn@kernel.(none)>
---
 security/commoncap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/security/commoncap.c b/security/commoncap.c
index c25ad09..503e958 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -119,7 +119,7 @@ int cap_capset_check (struct task_struct *target, kernel_cap_t *effective,
 		/* incapable of using this inheritable set */
 		return -EPERM;
 	}
-	if (!!cap_issubset(*inheritable,
+	if (!cap_issubset(*inheritable,
 			   cap_combine(target->cap_inheritable,
 				       current->cap_bset))) {
 		/* no new pI capabilities outside bounding set */
-- 
1.5.1

