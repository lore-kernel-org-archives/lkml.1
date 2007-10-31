Return-Path: <linux-kernel-owner+w=401wt.eu-S1754420AbXJaCfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420AbXJaCfx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 22:35:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752528AbXJaCfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 22:35:43 -0400
Received: from gate.crashing.org ([63.228.1.57]:53003 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751928AbXJaCfm (ORCPT <rfc822;Linux-Kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 22:35:42 -0400
Subject: Re: dev_ifname32() fails on 32->64bit calls in copy_in_user().
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Joel Becker <Joel.Becker@oracle.com>
Cc: Linux Netdev <netdev@vger.kernel.org>,
       Linux Kernel Mailing List <Linux-Kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20071031003850.GE7517@tasint.org>
References: <20071031003850.GE7517@tasint.org>
Content-Type: text/plain
Date: Wed, 31 Oct 2007 13:35:24 +1100
Message-Id: <1193798124.9928.91.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bug is in the new dev_ifname32:

	uifr = compat_alloc_user_space(sizeof(struct ifreq));
	if (copy_in_user(uifr, compat_ptr(arg), sizeof(struct ifreq32)));
		return -EFAULT;

There's a stray ";" after the if statement, that was obviously not
tested :-)

This fixes it here (tested):
----------------------------------------------------------------------------
[PATCH] Fix new dev_ifname32 returning -EFAULT

A stray semicolon slipped in the patch that updated dev_ifname32 to
not be inline, causing it to always return -EFAULT. This fixes it.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

Index: linux-work/fs/compat_ioctl.c
===================================================================
--- linux-work.orig/fs/compat_ioctl.c	2007-10-31 13:30:42.000000000 +1100
+++ linux-work/fs/compat_ioctl.c	2007-10-31 13:30:46.000000000 +1100
@@ -322,7 +322,7 @@ static int dev_ifname32(unsigned int fd,
 	int err;
 
 	uifr = compat_alloc_user_space(sizeof(struct ifreq));
-	if (copy_in_user(uifr, compat_ptr(arg), sizeof(struct ifreq32)));
+	if (copy_in_user(uifr, compat_ptr(arg), sizeof(struct ifreq32)))
 		return -EFAULT;
 
 	err = sys_ioctl(fd, SIOCGIFNAME, (unsigned long)uifr);


