Return-Path: <linux-kernel-owner+w=401wt.eu-S1752043AbXC2JfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043AbXC2JfR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 05:35:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753323AbXC2JfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 05:35:17 -0400
Received: from ananas2.netvision.net.il ([199.203.100.203]:45435 "EHLO
	ntx.netvision.net.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752043AbXC2JfP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 05:35:15 -0400
X-MIMEOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: cifs causes BUG: soft lockup detected on CPU
Date: Thu, 29 Mar 2007 11:35:13 +0200
Message-ID: <58D14E53A4F69C4EAF4D29171C447CC4011AC786@NTX-CL.forest.netvision.net.il>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-topic: cifs causes BUG: soft lockup detected on CPU
Thread-index: Acdx46gff6kaEXm1SCG7iGehaoueUwAAdTwA
From: "Valentin Zaharov" <karlos_@netvision.net.il>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, "Steven French" <sfrench@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I get this error when try to apply the patch:

patch -p1 < cifs.patch
patching file include/linux/fs.h
patch: **** malformed patch at line 26: /*

Am I missing something or patch is bad?  

Thanks in advance

-----Original Message-----
From: Andrew Morton [mailto:akpm@linux-foundation.org] 
Sent: Thursday, March 29, 2007 11:22 AM
To: Valentin Zaharov
Cc: linux-kernel@vger.kernel.org; Steven French
Subject: Re: cifs causes BUG: soft lockup detected on CPU

On Thu, 29 Mar 2007 11:13:04 +0200 "Valentin Zaharov"
<karlos_@netvision.net.il> wrote:

> I've tried different kernel versions.
> Right now iam using generic 2.6.9-42 on one machine and 2.6.20.1 on 
> another one.
> I also tried various distributions ( Suse, CentOS, RHEL4 ) - not sure 
> it is relevant.
> Tried installing latest cifs modules, tried changing CIFSMaxBufSize to

> 15000,  without luck.
> Freezes are totally random - sometimes they happen 2-4 times a day, 
> sometimes it can take 2 weeks.

Yeah, it's a relatively recently known-bug, I'm afraid.

Probably this will keep you out of trouble until it gets fixed for real:

--- a/include/linux/fs.h~a
+++ a/include/linux/fs.h
@@ -627,25 +627,7 @@ extern void inode_double_unlock(struct i
  */
 static inline loff_t i_size_read(const struct inode *inode)  { -#if
BITS_PER_LONG==32 && defined(CONFIG_SMP)
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

