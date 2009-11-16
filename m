Return-Path: <linux-kernel-owner+w=401wt.eu-S1752714AbZKPLvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714AbZKPLvl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 06:51:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752632AbZKPLvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 06:51:41 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:36725 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbZKPLvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 06:51:40 -0500
To: Pavel Machek <pavel@ucw.cz>
CC: ebiederm@xmission.com, miklos@szeredi.hu, alan@lxorguk.ukuu.org.uk,
       akpm@linux-foundation.org, viro@ZenIV.linux.org.uk, dhowells@redhat.com,
       hch@infradead.org, adilger@sun.com, mtk.manpages@gmail.com,
       torvalds@linux-foundation.org, drepper@gmail.com, jamie@shareable.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <20091108170157.GA1389@ucw.cz> (message from Pavel Machek on Sun,
	8 Nov 2009 18:01:57 +0100)
Subject: Re: [PATCH v2 resend] vfs: new O_NODE open flag
References: <E1N60RV-0002ed-FX@pomaz-ex.szeredi.hu> <20091105131545.72b4e319@lxorguk.ukuu.org.uk> <E1N63Io-000353-KX@pomaz-ex.szeredi.hu> <20091106141742.GA1428@ucw.cz> <m17hu3xtiy.fsf@fess.ebiederm.org> <E1N6g3B-0006UZ-1R@pomaz-ex.szeredi.hu> <m13a4qsiap.fsf@fess.ebiederm.org> <E1N6jWB-0006gu-2u@pomaz-ex.szeredi.hu> <m1y6mipnc4.fsf@fess.ebiederm.org> <20091108170157.GA1389@ucw.cz>
Message-Id: <E1NA06k-0007zE-91@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 16 Nov 2009 12:50:58 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Nov 2009, Pavel Machek wrote:
> Does it really close the race completely?
> 
> 					udev sets 660
> open does permission checks
> 					device disappears
> 					chmod 000
> 					new device appears
> 					udev chmods 600
> open returns new device

Yes, there's still a small hole there.

We could check nlink != 0 after grabbing the device (untested patch).
That is a hack, however, and would break apps which previously relied
on being able to re-open already deleted devices through /proc/*/fd.
But there might not be a better solution...  Thoughts?

Thanks,
Miklos


Index: linux-2.6/fs/char_dev.c
===================================================================
--- linux-2.6.orig/fs/char_dev.c	2009-09-24 20:10:58.000000000 +0200
+++ linux-2.6/fs/char_dev.c	2009-11-16 12:48:58.000000000 +0100
@@ -396,6 +396,16 @@ static int chrdev_open(struct inode *ino
 	if (ret)
 		return ret;
 
+	/*
+	 * The device might have been removed and then reused while
+	 * the open was in progress.  Make sure we don't let open
+	 * proceed in such a case, since the old device could have had
+	 * different permissions.
+	 */
+	ret = -ENOENT;
+	if (inode->i_nlink == 0)
+		goto out_cdev_put;
+
 	ret = -ENXIO;
 	filp->f_op = fops_get(p->ops);
 	if (!filp->f_op)
