Return-Path: <linux-kernel-owner+w=401wt.eu-S1756616AbYH0S67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616AbYH0S67 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 14:58:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752426AbYH0S6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 14:58:49 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:47872 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbYH0S6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 14:58:48 -0400
Date: Wed, 27 Aug 2008 13:58:45 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: "Andrew G. Morgan" <morgan@kernel.org>, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Subject: Re: [patch] file capabilities: Add no_file_caps switch
Message-ID: <20080827185845.GA25669@us.ibm.com>
References: <200808262057.51606.agruen@suse.de> <200808271729.18220.agruen@suse.de> <20080827160439.GA12085@us.ibm.com> <200808271857.48651.agruen@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808271857.48651.agruen@suse.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andreas Gruenbacher (agruen@suse.de):
> On Wednesday, 27 August 2008 18:04:39 Serge E. Hallyn wrote:
> > Quoting Andreas Gruenbacher (agruen@suse.de):
> > > On Wednesday, 27 August 2008 15:52:06 Serge E. Hallyn wrote:
> > > > Quoting Andreas Gruenbacher (agruen@suse.de):
> > > > > Hello,
> > > > >
> > > > > here is a patch allowing to disable file capabilities via a kernel
> > > > > command line option (once compiled in with
> > > > > CONFIG_SECURITY_FILE_CAPABILITIES).
> > > > >
> > > > > We would like to ship our next round of products with file
> > > > > capabilities compiled in, yet we feel that too many system utilities
> > > > > are still file capabilitiy unaware, and so we would like to turn them
> > > > > off by default initially. File capabilities can be used to grant
> > > > > privileges to binaries which otherwise look "harmless", which is a
> > > > > security risk until utilities like rpm have learned how to install
> > > > > and verify capabilities, etc.
> > > > >
> > > > > Any objections?
> > > >
> > > > Hi Andreas,
> > > >
> > > > No objections in general - if it makes you more comfortable shipping
> > > > kernels with CONFIG_SECURITY_FILE_CAPABILITIES=y then it's worthwhile.
> > > > However, can you elaborate on your concerns?
> > >
> > > We don't have the time left for developing the few missing pieces and
> > > properly integrating file capabilities into our products (use in various
> > > packages, support in rpm, system management, manuals, release notes), and
> > > so I would like to have a way to turn them off by default for now.
> > >
> > > > In particular, if as you say above the concern is really just that a
> > > > file might have capabilities accidentally (or maliciously) enabled,
> > > > then we should be able to just check for file_caps_enabled() at
> > > > get_file_caps(), refusing to fill in the file capabilities.
> > >
> > > My main concern is accidental granting of capabilities because of admin
> > > unawareness / lack of tool support. This could be taken care of by not
> > > loading the capabilities from disk.
> > >
> > > > The other changes which you are canceling out confuscate the code but
> > > > actually make no difference.
> > >
> > > Well, the other difference is that with
> > > CONFIG_SECURITY_FILE_CAPABILITIES=y you currently lose the ability to
> > > pass on capabilities to other processes. Do you have good arguments why
> > > this feature is unnecessary?
> >
> > Yes, mainly that you don't actually have that ability anyway, because
> > when CONFIG_SECURITY_FILE_CAPABILITIES=n, then CAP_SETPCAP is not in the
> > system-wide capability bounding set, and without CAP_SETPCAP you cannot
> > pass capabilities to another process.
> >
> > You can do it if you have a custom initrd that adds CAP_SETPCAP to the
> > bounding set early enough, but it has to be done by pid=1.  As far as I
> > have seen there are 0 users of the feature.
> 
> Alright, this should suffice and we won't have to care about this case then.
> 
> What remains is a way to disable the loading of capabilities from the kernel 
> command line, but this is a rather trivial patch. Would you like to write 
> that? Shall i send a patch?

The below patch seems to be working for me.  Please take a look.

> > If, however, you really do have such users, then we must go with a
> > version of your patch.  We may then want to consider altogether
> > replacing the CONFIG_SECURITY_FILE_CAPABILITIES boolean with a default
> > value for file_caps_enabled.  That may actually end up cleaner than
> > the current code by removing all of the #ifdefs.
> 
> Most ifdefs would go away by adding a file_caps_enabled variable / #define in 
> capability.h and using that. I would suggest to make this on-by-default as 
> the common case will eventually be on, and that way, we won't have to carry 
> the kernel command-line option code forever.
> 
> > (Also note that if you have such users, you'll want to ask David
> > Howells not to push the patch he has floated removing the ability to
> > pass caps to another task altogether when
> > CONFIG_SECURITY_FILE_CAPABILITIES=n :)
> 
> I was actually about to ask for making this behavior change pertinent instead 
> of having it depend on CONFIG_SECURITY_FILE_CAPABILITIES :)

Ok, cool.  In that case - David I was a little surprised to find that
patch not applied in Linus' tree.  You sent it quite some time ago,
didn't you?  Were you planning on trying again to push it soon?

In any case, how about the following patch?

If it is ok with everyone, then I'll rewrite the intro and send it
out separately.

thanks,
-serge

>From 0b69a9e882b07e33814aa15a2f5cdf90b92c7ec8 Mon Sep 17 00:00:00 2001
From: Serge Hallyn <serue@us.ibm.com>
Date: Wed, 27 Aug 2008 13:33:37 -0500
Subject: [PATCH 1/1] file capabilities: add no_file_caps switch (v2)

Hi,

here is a simplification of Andreas' patch from yesterday.  We
appear to be agreed that it suffices to prevent file capabilities
from being actually read from disk, so this version only does that.
This means that booting with the no_file_caps boot option will
not be the same as booting a kernel with file capabilities
compiled out - in particular a task with  CAP_SETPCAP will not
have any chance of passing capabilities to another task (which
isn't "really" possible anyway, and which may soon by killed
altogether by David Howells in any case), and it will instead
be able to put new capabilities in its pI.  However since fI
will always be empty and pI is masked with fI, it gains the
task nothing.

We also support the extra prctl options, setting securebits and
dropping capabilities from the per-process bounding set.

The other remaining difference is that killpriv, task_setscheduler,
setioprio, and setnice will continue to be hooked.  That will
be noticable in the case where a root task changed its uid
while keeping some caps, and another task owned by the new uid
tries to change settings for the more privileged task.

Signed-off-by: Serge Hallyn <serue@us.ibm.com>
---
 kernel/capability.c  |   13 +++++++++++++
 security/commoncap.c |   11 +++++++++++
 2 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/kernel/capability.c b/kernel/capability.c
index 33e51e7..5d034ec 100644
--- a/kernel/capability.c
+++ b/kernel/capability.c
@@ -33,6 +33,19 @@ EXPORT_SYMBOL(__cap_empty_set);
 EXPORT_SYMBOL(__cap_full_set);
 EXPORT_SYMBOL(__cap_init_eff_set);
 
+#ifdef CONFIG_SECURITY_FILE_CAPABILITIES
+int file_caps_enabled = 1;
+
+static int __init file_caps_disable(char *str)
+{
+	file_caps_enabled = 0;
+	return 1;
+}
+__setup("no_file_caps", file_caps_disable);
+#else
+static const int file_caps_enabled = 0;
+#endif
+
 /*
  * More recent versions of libcap are available from:
  *
diff --git a/security/commoncap.c b/security/commoncap.c
index e4c4b3f..8c66d34 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -27,6 +27,12 @@
 #include <linux/prctl.h>
 #include <linux/securebits.h>
 
+#ifdef CONFIG_SECURITY_FILE_CAPABILITIES
+extern int file_caps_enabled;
+#else
+static const int file_caps_enabled = 0;
+#endif
+
 int cap_netlink_send(struct sock *sk, struct sk_buff *skb)
 {
 	NETLINK_CB(skb).eff_cap = current->cap_effective;
@@ -279,6 +285,11 @@ static int get_file_caps(struct linux_binprm *bprm)
 	struct vfs_cap_data vcaps;
 	struct inode *inode;
 
+	if (!file_caps_enabled) {
+		bprm_clear_caps(bprm);
+		return 0;
+	}
+
 	if (bprm->file->f_vfsmnt->mnt_flags & MNT_NOSUID) {
 		bprm_clear_caps(bprm);
 		return 0;
-- 
1.5.4.3

