Return-Path: <linux-kernel-owner+w=401wt.eu-S1753941AbYAIMOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbYAIMOi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 07:14:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752349AbYAIMO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 07:14:28 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:55327 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143AbYAIMO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 07:14:27 -0500
Date: Wed, 9 Jan 2008 13:14:25 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Nikanth Karthikesan <knikanth@suse.de>
cc: grant@torque.net, tim@cyberelk.net, Christoph Hellwig <hch@infradead.org>,
       Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] Change paride driver to use unlocked_ioctl instead of
 ioctl
In-Reply-To: <1199955347.6203.6.camel@nikanth-laptop.blr.novell.com>
Message-ID: <Pine.LNX.4.64.0801091313231.29244@fbirervta.pbzchgretzou.qr>
References: <4785B7BC.5040106@suse.de>  <20080109080620.GE32560@infradead.org>
  <4784D3E0.BANGALORE.BLR.100.174746A.1.EABB.1@1:7.BANGALORE.BLR.100.0.1.0.1@16>
 <1199955347.6203.6.camel@nikanth-laptop.blr.novell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 10 2008 14:25, Nikanth Karthikesan wrote:
>-static int pt_ioctl(struct inode *inode, struct file *file,
>-	 unsigned int cmd, unsigned long arg)
>+static long pt_ioctl(struct file *file, unsigned int cmd,
>+		unsigned long arg)
> {
> 	struct pt_unit *tape = file->private_data;
> 	struct mtop __user *p = (void __user *)arg;
> 	struct mtop mtop;
>+	long err = 0;
>+
>+	lock_kernel();
> 
> 	switch (cmd) {
> 	case MTIOCTOP:
>-		if (copy_from_user(&mtop, p, sizeof(struct mtop)))
>-			return -EFAULT;
>+		if (copy_from_user(&mtop, p, sizeof(struct mtop))) {
>+			err = -EFAULT;
>+			break;
>+		}

I wonder why a simple copy_from_user() requires the BKL.. if pt
does need locking, then probably some mutex inside pt.

