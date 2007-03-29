Return-Path: <linux-kernel-owner+w=401wt.eu-S1753313AbXC2JVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313AbXC2JVl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 05:21:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753321AbXC2JVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 05:21:40 -0400
Received: from smtp.osdl.org ([65.172.181.24]:48322 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753313AbXC2JVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 05:21:40 -0400
Date: Thu, 29 Mar 2007 02:21:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Valentin Zaharov" <karlos_@netvision.net.il>
Cc: <linux-kernel@vger.kernel.org>, "Steven French" <sfrench@us.ibm.com>
Subject: Re: cifs causes BUG: soft lockup detected on CPU
Message-Id: <20070329022131.e5e48c53.akpm@linux-foundation.org>
In-Reply-To: <58D14E53A4F69C4EAF4D29171C447CC4011AC783@NTX-CL.forest.netvision.net.il>
References: <58D14E53A4F69C4EAF4D29171C447CC4011AC783@NTX-CL.forest.netvision.net.il>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Mar 2007 11:13:04 +0200 "Valentin Zaharov" <karlos_@netvision.net.il> wrote:

> I've tried different kernel versions.
> Right now iam using generic 2.6.9-42 on one machine and 2.6.20.1 on
> another one.
> I also tried various distributions ( Suse, CentOS, RHEL4 ) - not sure it
> is relevant.
> Tried installing latest cifs modules, tried changing CIFSMaxBufSize to
> 15000,  without luck.
> Freezes are totally random - sometimes they happen 2-4 times a day,
> sometimes it can take 2 weeks.

Yeah, it's a relatively recently known-bug, I'm afraid.

Probably this will keep you out of trouble until it gets fixed
for real:

--- a/include/linux/fs.h~a
+++ a/include/linux/fs.h
@@ -627,25 +627,7 @@ extern void inode_double_unlock(struct i
  */
 static inline loff_t i_size_read(const struct inode *inode)
 {
-#if BITS_PER_LONG==32 && defined(CONFIG_SMP)
-	loff_t i_size;
-	unsigned int seq;
-
-	do {
-		seq = read_seqcount_begin(&inode->i_size_seqcount);
-		i_size = inode->i_size;
-	} while (read_seqcount_retry(&inode->i_size_seqcount, seq));
-	return i_size;
-#elif BITS_PER_LONG==32 && defined(CONFIG_PREEMPT)
-	loff_t i_size;
-
-	preempt_disable();
-	i_size = inode->i_size;
-	preempt_enable();
-	return i_size;
-#else
 	return inode->i_size;
-#endif
 }
 
 /*
_

