Return-Path: <linux-kernel-owner+w=401wt.eu-S1757265AbXIYPUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265AbXIYPUe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 11:20:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbXIYPU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 11:20:27 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:54774 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbXIYPU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 11:20:26 -0400
Date: Tue, 25 Sep 2007 17:20:25 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: David Newall <david@davidnewall.com>
cc: "Serge E. Hallyn" <serge@hallyn.com>, Bill Davidsen <davidsen@tmr.com>,
       Philipp Marek <philipp@marek.priv.at>, 7eggert@gmx.de,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, majkls <majkls@prepere.com>,
       bunk@fs.tum.de, linux-kernel@vger.kernel.org
Subject: Re: Chroot bug (was: sys_chroot+sys_fchdir Fix)
In-Reply-To: <46F924E3.50205@davidnewall.com>
Message-ID: <Pine.LNX.4.64.0709251715390.945@fbirervta.pbzchgretzou.qr>
References: <56705.193.171.152.61.1190289559.squirrel@webmail.marek.priv.at>
 <46F29A9A.4070806@davidnewall.com> <200709201817.17282@x5>
 <46F2B59F.8090709@davidnewall.com> <46F2DDD0.3030500@tmr.com>
 <46F380E4.4040606@davidnewall.com> <20070924213215.GA32716@vino.hallyn.com>
 <46F83474.5040503@davidnewall.com> <20070924230008.GA3160@vino.hallyn.com>
 <46F8BC8A.7080006@davidnewall.com> <20070925114947.GA9721@vino.hallyn.com>
 <46F91417.9050600@davidnewall.com> <46F924E3.50205@davidnewall.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 26 2007 00:40, David Newall wrote:
>
> Miloslav Semler pointed out that a root process can chdir("..") out of its
> chroot.  Although this is documented in the man page, it conflicts with the
> essential function, which is to change the root directory of the process.  In
> addition to any creative uses, for example Philipp Marek's loading dynamic
> libraries, it seems clear that the prime purpose of chroot is to aid security.
> Being able to cd your way out is handy for the bad guys, but the good guys
> don't need it; there are a thousand better, safer solutions.

So what? Just do this: chdir into the root after chroot.

It won't conform to SVR4/4.4BSD anymore, but hey, let Linux set some
sane standard ain't bad either. I doubt anyone really relies on the
fact that after chroot, your cwd might be outside the root.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 fs/open.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.23/fs/open.c
===================================================================
--- linux-2.6.23.orig/fs/open.c
+++ linux-2.6.23/fs/open.c
@@ -547,6 +547,7 @@ asmlinkage long sys_chroot(const char __
 
 	set_fs_root(current->fs, nd.mnt, nd.dentry);
 	set_fs_altroot();
+	set_fs_pwd(current->fs, nd.mnt, nd.dentry);
 	error = 0;
 dput_and_out:
 	path_release(&nd);
