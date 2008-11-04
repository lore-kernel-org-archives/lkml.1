Return-Path: <linux-kernel-owner+w=401wt.eu-S1754655AbYKDPNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655AbYKDPNT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 10:13:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753329AbYKDPND
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 10:13:03 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:45357 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077AbYKDPNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 10:13:00 -0500
Date: Tue, 4 Nov 2008 15:12:35 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Koyama, Yoshiya" <Yoshiya.Koyama@hp.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Kay Sievers <kay.sievers@vrfy.org>, linux-fsdevel@vger.kernel.org
Subject: Re: v2.6.28-rc1: readlink /proc/*/exe returns uninitialized data
	to userspace
Message-ID: <20081104151234.GH28946@ZenIV.linux.org.uk>
References: <19f34abd0810251014s7968557br38e43aa0b9cdcf09@mail.gmail.com> <200810252241.53601.rjw@sisk.pl> <m163nggvhq.fsf@frodo.ebiederm.org> <19f34abd0810261408w61b1e2dbvb9a0e16ce5a10022@mail.gmail.com> <19f34abd0811040139t8334502i7a5d8501c5fe95ac@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0811040139t8334502i7a5d8501c5fe95ac@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2008 at 10:39:19AM +0100, Vegard Nossum wrote:
> On Sun, Oct 26, 2008 at 10:08 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> # uname -a
> Linux localhost.localdomain 2.6.25.11-97.fc9.i686 #1 SMP Mon Jul 21
> 01:31:09 EDT 2008 i686 i686 i386 GNU/Linux
> # prelink -mRf /sbin/udevd
> # ./a.out /proc/564/exe
> warning: /proc/564/exe: got return value 38, expected 11
> 2f7362696e2f7564657664005f47387942426e5952446e566f306868202864656c6574656429
> /sbin/udevd _G8yBBnYRDnVo0hh (deleted)
> 
> Yoshiya Koyama reports that the problem exists on RHEL 2.6.9-42.ELsmp too.
> 
> I don't think it's exactly the same problem as originally reported,
> because I definitely wasn't using prelinking (the prelink binary
> wasn't even installed on the machine until today). But finding the
> root cause of this may solve both problems.

switch_names() buggered in case of short names on both sides.  That should
help:

>From 2acda856910b774717e0290bbf948c7dee0f2e1a Mon Sep 17 00:00:00 2001
From: Al Viro <viro@zeniv.linux.org.uk>
Date: Mon, 3 Nov 2008 15:03:50 -0500
Subject: [PATCH] fix switch_names() breakage in short-to-short case

We want ->name.len to match the resulting name on *both*
source and target

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/dcache.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index a1d86c7..15e4f83 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1620,8 +1620,11 @@ static void switch_names(struct dentry *dentry, struct dentry *target)
 			 */
 			memcpy(dentry->d_iname, target->d_name.name,
 					target->d_name.len + 1);
+			dentry->d_name.len = target->d_name.len;
+			return;
 		}
 	}
+	do_switch(dentry->d_name.len, target->d_name.len);
 }
 
 /*
@@ -1681,7 +1684,6 @@ already_unhashed:
 
 	/* Switch the names.. */
 	switch_names(dentry, target);
-	do_switch(dentry->d_name.len, target->d_name.len);
 	do_switch(dentry->d_name.hash, target->d_name.hash);
 
 	/* ... and switch the parents */
@@ -1791,7 +1793,6 @@ static void __d_materialise_dentry(struct dentry *dentry, struct dentry *anon)
 	struct dentry *dparent, *aparent;
 
 	switch_names(dentry, anon);
-	do_switch(dentry->d_name.len, anon->d_name.len);
 	do_switch(dentry->d_name.hash, anon->d_name.hash);
 
 	dparent = dentry->d_parent;
-- 
1.5.6.5

