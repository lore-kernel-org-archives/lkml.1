Return-Path: <linux-kernel-owner+w=401wt.eu-S1755348AbYEKP3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348AbYEKP3t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 11:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbYEKP3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 11:29:41 -0400
Received: from anchor-post-37.mail.demon.net ([194.217.242.87]:64389 "EHLO
	anchor-post-37.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751400AbYEKP3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 11:29:40 -0400
Subject: [PATCH] [RFC] shrink struct pid by removing padding on 64 bit
	builds
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 11 May 2008 16:29:36 +0100
Message-Id: <1210519776.2958.34.camel@castor.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When struct pid is built on a 64 bit platform gcc has to insert padding
to maintain the correct alignment, by simply reordering its members the
memory usage shrinks from 88 bytes to 80.

I've successfully run with this patch on my desktop AMD64 machine.

There are no significant kernel size changes to a default config.X86_64
on the latest git v2.6.26-rc1

   text    data     bss     dec     hex filename
5404828  976760  734280 7115868  6c945c vmlinux
5404811  976760  734280 7115851  6c944b vmlinux.pid-patch

The question really is : Is it safe to make this change?

I haven't spotted anywhere that depends on the exact layout of the pid
structure, but there's a lot of code to review & I haven't gone though
it all in detail.
struct pid doesn't appear in the user headers, so isn't exposed to user
space. So I think it will be safe.

Any ideas ?

Thanks
Richard

diff --git a/include/linux/pid.h b/include/linux/pid.h
index c21c7e8..6f084b9 100644
--- a/include/linux/pid.h
+++ b/include/linux/pid.h
@@ -57,10 +57,10 @@ struct upid {
 struct pid
 {
 	atomic_t count;
+	unsigned int level;
 	/* lists of tasks that use this pid */
 	struct hlist_head tasks[PIDTYPE_MAX];
 	struct rcu_head rcu;
-	unsigned int level;
 	struct upid numbers[1];
 };
 


