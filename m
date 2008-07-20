Return-Path: <linux-kernel-owner+w=401wt.eu-S1757318AbYGTMQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318AbYGTMQb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 08:16:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755427AbYGTMQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 08:16:22 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55667 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801AbYGTMQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 08:16:21 -0400
Date: Sun, 20 Jul 2008 13:15:59 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: James Morris <jmorris@namei.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>
Subject: Re: BUG at security/selinux/avc.c:883 (was: Re: linux-next: Tree
	for July 17: early crash on x86-64)
Message-ID: <20080720121559.GV28946@ZenIV.linux.org.uk>
References: <20080718012842.690b8346.sfr@canb.auug.org.au> <a4423d670807180652y352e66lfe04d2b33d2ed176@mail.gmail.com> <20080719035231.GU28946@ZenIV.linux.org.uk> <200807192042.06988.rjw@sisk.pl> <Xine.LNX.4.64.0807200553380.22632@us.intercode.com.au> <1216546973.3217.6.camel@dhcppc2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216546973.3217.6.camel@dhcppc2>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 20, 2008 at 11:42:53AM +0200, Thomas Meyer wrote:
> Am Sonntag, den 20.07.2008, 05:54 +1000 schrieb James Morris:
> > On Sat, 19 Jul 2008, Rafael J. Wysocki wrote:
> > 
> > > > vfs-next/net-next conflict; apply the patch below on top of the
> > merge.
> > > 
> > > That helped, thanks.
> > > 
> > > But next it ran into the BUG_ON() in line 883 of
> > security/selinux/avc.c .
> > > Disabling selinux made the kernel boot, finally.
> > 
> > Ugh, that's not supposed to happen.  Where was this in the boot?  Do
> > you 
> > have a console log?

Argh...  Fallout from ->permission() patch series.  I've folded that into
rebase (along with Randy's compile fixes and missing bit in capability.c
in ->inode_permission() patch; AFAICS takes care of all mismerges as well).
In the meanwhile, see the patch below on top of next-20080718:

diff --git a/fs/namei.c b/fs/namei.c
index a15c155..c0a64e2 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -286,7 +286,8 @@ int permission(struct inode *inode, int mask, struct nameidata *nd)
 	if (retval)
 		return retval;
 
-	return security_inode_permission(inode, mask);
+	return security_inode_permission(inode,
+					mask & (MAY_READ|MAY_WRITE|MAY_EXEC));
 }
 
 /**
