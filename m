Return-Path: <linux-kernel-owner+w=401wt.eu-S1757725AbYFBHBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757725AbYFBHBQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 03:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752807AbYFBHA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 03:00:58 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:12995 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299AbYFBHA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 03:00:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=wbcmkfQGr4qQJ276/jPCQma4o75GU8+sgYT2tDsjE0qRGHgYRxNNMYpEjZfyXwsbuyNxvyDdZS3wRtCT+U0G4eVSMYtGrydQaZDY927er9emK82/nbudIj9pE9hBfcqdmrgzwWM2i3juRGKuHKu713ttPwQs/okK3mVbnYPLA0k=
Message-ID: <19f34abd0806020000h407e3fb1kadff228a3cf4c6f@mail.gmail.com>
Date: Mon, 2 Jun 2008 09:00:56 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: find: WARNING: Hard link count is wrong for /proc/1
Cc: "Pavel Emelyanov" <xemul@openvz.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <19f34abd0806012331m7c57468bu820e9b6b0184836d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0806012331m7c57468bu820e9b6b0184836d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 2, 2008 at 8:31 AM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> Hi,
>
> 2.6.26-rc4 seems to exhibit the following (new since at least 2.6.24)
> warning when running find /proc/1:
>
> find: WARNING: Hard link count is wrong for /proc/1: this may be a bug
> in your filesystem driver.  Automatically turning on find's -noleaf
> option.  Earlier results may have failed to include directories that
> should have been searched.

My prime suspect is

commit e9720acd728a46cb40daa52c99a979f7c4ff195c
Author: Pavel Emelyanov <xemul@openvz.org>
Date:   Fri Mar 7 11:08:40 2008 -0800

    [NET]: Make /proc/net a symlink on /proc/self/net (v3)


as this patch introduces a new directory entry without bumping the nlink count.

Will this do? (Untested)

Vegard


>From a43ef05a8c1f8d45ca88e00fdd31c00ddfdba1b8 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Mon, 2 Jun 2008 08:57:45 +0200
Subject: [PATCH] proc: fix /proc/<pid> link count

commit e9720acd728a46cb40daa52c99a979f7c4ff195c
Author: Pavel Emelyanov <xemul@openvz.org>
Date:   Fri Mar 7 11:08:40 2008 -0800

    [NET]: Make /proc/net a symlink on /proc/self/net (v3)

introduced /proc/net without bumping the link count on /proc/self.

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 fs/proc/base.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index c447e07..10ee4a2 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2589,6 +2589,9 @@ static struct dentry
*proc_pid_instantiate(struct inode *dir,
 #ifdef CONFIG_SECURITY
 	inode->i_nlink += 1;
 #endif
+#ifdef CONFIG_NET
+	inode->i_nlink += 1;
+#endif

 	dentry->d_op = &pid_dentry_operations;

-- 
1.5.4.1
