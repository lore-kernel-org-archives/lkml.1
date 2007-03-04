Return-Path: <linux-kernel-owner+w=401wt.eu-S1751700AbXCDOKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700AbXCDOKA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 09:10:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbXCDOKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 09:10:00 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:58230 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbXCDOJ7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 09:09:59 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH] configfs: add missing mutex_unlock()
Date: Sun, 4 Mar 2007 15:10:19 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, Joel Becker <joel.becker@oracle.com>
References: <20070304133812.GC8519@APFDCB5C>
In-Reply-To: <20070304133812.GC8519@APFDCB5C>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703041510.20127.arnd@arndb.de>
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:bf0b512fe2ff06b96d9695102898be39
X-Provags-ID2: V01U2FsdGVkX18JezYPLE8Xu0QAnItwGdoI0x5BNVQ3vn2DJms
 TC5/HD5e74k6VCu5Ka8YLprxW6AvLLqc6A4RlPAKZhqStZtHM0
 w8lhuHfSPZieb1FuC863g==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 March 2007 14:38:12 Akinobu Mita wrote:
> @@ -1168,8 +1168,10 @@ int configfs_register_subsystem(struct c
>  
>         err = -ENOMEM;
>         dentry = d_alloc(configfs_sb->s_root, &name);
> -       if (!dentry)
> +       if (!dentry) {
> +               mutex_unlock(&configfs_sb->s_root->d_inode->i_mutex);
>                 goto out_release;
> +       }
>  
>         d_add(dentry, NULL);

This should be changed to jump to a new exit point, before the mutex_unlock
at the end of the function. Having multiple places in the function that
release the same lock easily leads to the kind of bug you are fixing here.

	Arnd <><
