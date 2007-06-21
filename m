Return-Path: <linux-kernel-owner+w=401wt.eu-S1757511AbXFUQAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511AbXFUQAa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 12:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750796AbXFUQAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 12:00:22 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:48938 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358AbXFUQAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 12:00:20 -0400
Date: Thu, 21 Jun 2007 11:00:11 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Chris Wright <chrisw@sous-sol.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Andrew Morgan <morgan@kernel.org>,
       Andrew Morgan <agm@google.com>, casey@schaufler-ca.com,
       Andrew Morton <akpm@google.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: implement-file-posix-capabilities.patch
Message-ID: <20070621160011.GB9913@sergelap.austin.ibm.com>
References: <20070611123714.GA2063@sergelap.austin.ibm.com> <878322.98602.qm@web36606.mail.mud.yahoo.com> <afff21250706110926l244ddc28i44289cb08a6721e2@mail.gmail.com> <20070617135239.GA17689@sergelap> <4676007F.7060503@kernel.org> <20070618044017.GW3723@sequoia.sous-sol.org> <20070620171037.GA28670@sergelap.ibm.com> <20070620174613.GF3723@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070620174613.GF3723@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Chris Wright (chrisw@sous-sol.org):
> [folks, this is getting much too long-winded to stay a private thread]
> 
> * Serge E. Hallyn (serue@us.ibm.com) wrote:
> > Quoting Chris Wright (chrisw@sous-sol.org):
> > > * Andrew Morgan (morgan@kernel.org) wrote:
> > > > I share Casey's view that what's in the kernel now appears to have
> > > > evolved because of the absence of filesystem capabilities and not in
> > > > preparation for them. I'm not at all clear that they offer any real
> > > > improvement over the more macroscopic, but much simpler to understand,
> > > > superuser model.
> > > 
> > > Presently they offer next to nothing.  From the POV of kernel code,
> > > they've added an extremely coarse grained way to check privs for
> > > actions (CAP_SYS_ADMIN renders much of this useless for least priv).
> > > >From userspace POV, there's basically one well-known program that uses
> > > the existing crippled model to drop privs.  And from end-users' POV,
> > > there's no end of frustrated attempts to make something useful out
> > > of it.  From a security POV, there's missing functionality (which has
> > > been addressed in Andrew's older patches and Serge's current patchset).
> > 
> > I'm sorry I'm not sure what your conclusion is then.  Are you saying
> > that my patch does add functionality, or arguing that it shouldn't be
> > included?
> 
> It does add functionality, it is existing capabilities which are not
> particularly useful.

Ah, ok.

> > > > I think the implementation (the patch) adds support for storing
> > > > capabilities in the filesystem. But, I don't believe it is as a step
> > > > towards 'POSIX' capability support, but just adding another incrementa
> > > > twist to the Linux capability implementation - its hard to reason about
> > > > such a thing, in terms of security or otherwise. (Have you thought about
> > > > whether LD_LIBRARY_PATH is ignored by capability aware, but non-setuid-0
> > > > programs? To voice one example. There are many system consequences to
> > > > this model that will only become apparent when people start to seriously
> > > > implement and use it.)
> > > 
> > > The classic argument has been one of administration.  Tools know how to
> > > search for setuid programs,
> > 
> > Sure, but 'find' plus a 5-line program to check for security.capability
> > xattrs will find capability programs, right?
> 
> Yes.  I'm not 100% sold on the administration issue, but it is real, and
> unfortunately the extra 5-line program isn't a great solution.

It might not be :), but surely once people see what the actual
administration challenges turn out to be, they/we can write the tools to
satisfy those needs?  I don't believe they will be insurmountable.

You had in the past played with caps quite a bit, do you already have a
sense of what kinds of admin problems people will have?

> > Are there popular gui's in
> > widespread use which depend on programs granting extra privilege doing
> > so using setuid?
> > 
> > > and mainline MAC is not adding caps based on
> > > security domain during exec, etc.
> > 
> > I don't understand what you're saying - could you explain?  Which
> > 'mainline MAC', what sort of domains (TE?)?
> 
> mainline MAC meaning basically SELinux.  IOW, while LIDS and Apparmor
> had/have models for handling capabilities (don't recall if it was grant
> or restrict only), SELinux is just now talking about doing something
> like this, but nothing is upstream and in wide distribution.
> 
> > > My biggest concern is leaking caps to
> > > programs which are meant to be unprivileged.
> > 
> > Would it help if we place CONFIG_SECURITY_FILE_CAPABILITIES under
> > CONFIG_EXPERIMENTAl for a bit?
> 
> Would not hurt ;-)

Ok, here's a patch on top of 2.6.22-rc4-mm2 to do so,

thanks,
-serge

>From bf1566bb34ed47ffadfe9289ba2f1a85df5dc36f Mon Sep 17 00:00:00 2001
From: Serge E. Hallyn <serue@us.ibm.com>
Date: Thu, 21 Jun 2007 11:40:23 -0400
Subject: [PATCH 1/1] file capabilities: make file capabilities option EXPERIMENTAL

Make file capabilities depend upon CONFIG_EXPERIMENTAL, as few
people have used them to date.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
---
 security/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/Kconfig b/security/Kconfig
index 7c941d9..ac56c2c 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -81,8 +81,8 @@ config SECURITY_CAPABILITIES
 	  If you are unsure how to answer this question, answer Y.
 
 config SECURITY_FILE_CAPABILITIES
-	bool "File POSIX Capabilities"
-	depends on SECURITY=n || SECURITY_CAPABILITIES!=n
+	bool "File POSIX Capabilities (EXPERIMENTAL)"
+	depends on (SECURITY=n || SECURITY_CAPABILITIES!=n) && EXPERIMENTAL
 	default n
 	help
 	  This enables filesystem capabilities, allowing you to give
-- 
1.5.1.1.GIT

