Return-Path: <linux-kernel-owner+w=401wt.eu-S1755393AbXLHE1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbXLHE1R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 23:27:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752385AbXLHE1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 23:27:05 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:44549 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbXLHE1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 23:27:02 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, rjw@sisk.pl,
       trond.myklebust@fys.uio.no, gnome42@gmail.com,
       linux-kernel@vger.kernel.org, bfields@fieldses.org, den@openvz.org,
       Pavel Emelyanov <xemul@openvz.org>
Subject: [PATCH 2.6.24-rc4] proc: Remove/Fix proc generic d_revalidate
References: <fa4052ef0712062045o743a2666u3562a3569c1aa989@mail.gmail.com>
	<1197067918.10831.13.camel@heimdal.trondhjem.org>
	<20071207151444.af5d8e11.akpm@linux-foundation.org>
	<200712080043.29292.rjw@sisk.pl>
	<20071208000043.GC1951@martell.zuzino.mipt.ru>
	<20071207161508.afe8fdf1.akpm@linux-foundation.org>
Date: Fri, 07 Dec 2007 21:25:19 -0700
In-Reply-To: <20071207161508.afe8fdf1.akpm@linux-foundation.org> (Andrew
	Morton's message of "Fri, 7 Dec 2007 16:15:08 -0800")
Message-ID: <m1lk85q0cw.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ultimately to implement /proc perfectly we need an implementation
of d_revalidate because files and directories can be removed behind
the back of the VFS, and d_revalidate is the only way we can let
the VFS know that this has happened.

Unfortunately the linux VFS can not cope with anything in the path
to a mount point going away.  So a proper d_revalidate method that
calls d_drop also needs to call have_submounts which is moderately
expensive, so you really don't want a d_revalidate method that
unconditionally calls it, but instead only calls it when the
backing object has really gone away.

proc generic entries only disappear on module_unload (when
not counting the fledgling network namespace) so it is quite rare
that we actually encounter that case and has not actually caused
us real world trouble yet.

So until we get a proper test for keeping dentries in the dcache
fix the current d_revalidate method by completely removing it.  This
returns us to the current status quo.

So with CONFIG_NETNS=n things should look as they have always looked.

For CONFIG_NETNS=y things work most of the time but there are a few
rare corner cases that don't behave properly.  As the network namespace
is barely present in 2.6.24 this should not be a problem.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/proc/generic.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 8d49838..6a2fe51 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -374,16 +374,9 @@ static int proc_delete_dentry(struct dentry * dentry)
 	return 1;
 }
 
-static int proc_revalidate_dentry(struct dentry *dentry, struct nameidata *nd)
-{
-	d_drop(dentry);
-	return 0;
-}
-
 static struct dentry_operations proc_dentry_operations =
 {
 	.d_delete	= proc_delete_dentry,
-	.d_revalidate	= proc_revalidate_dentry,
 };
 
 /*
-- 
1.5.3.rc6.17.g1911

