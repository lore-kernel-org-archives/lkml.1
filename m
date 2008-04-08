Return-Path: <linux-kernel-owner+w=401wt.eu-S1758842AbYDHCg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758842AbYDHCg2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 22:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754979AbYDHCgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 22:36:18 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:58251 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491AbYDHCgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 22:36:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: virtualization@lists.linux-foundation.org
Subject: Re: [PATCH RFC 1/5] vringfd syscall
Date: Tue, 8 Apr 2008 04:35:53 +0200
User-Agent: KMail/1.9.9
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, Max Krasnyansky <maxk@qualcomm.com>
References: <200804052202.09157.rusty@rustcorp.com.au>
In-Reply-To: <200804052202.09157.rusty@rustcorp.com.au>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Disposition: inline
Message-Id: <200804080435.54012.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/H42nVTBkjlVoN/HyCcQFoFIsujBQ4yxQn02p
 8Ts6gcck634GnpLzdTysVd3JX4RBBCc1AUsaypwkpek9uprveT
 GvgdKRyEjCToiEN+ge15Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m382aeEB006680

On Saturday 05 April 2008, Rusty Russell wrote:> +asmlinkage long sys_vringfd(void __user *addr,> +                           unsigned num_descs,> +                           u16 __user *last_used)> +{> +       int fd, err;> +       struct file *filp;> +       struct vring_info *vr;> +> +       /* Must be a power of two, and representable by u16 */> +       if (!num_descs || (num_descs & (num_descs-1)) || num_descs > 65536) {> +               err = -EINVAL;> +               goto out;> +       }> +> +       fd = get_unused_fd();> +       if (fd < 0) {> +               err = fd;> +               goto out;> +       }> +> +       filp = alloc_file(vring_mnt, dget(vring_mnt->mnt_root), FMODE_WRITE,> +                         &vring_fops);> +       if (!filp) {> +               err = -ENFILE;> +               goto put_fd;> +       }
This looks like a candidate for anon_inode_getfd(), which would let youget rid of the code for registering your own file system.
	Arnd <><ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éÝ¶¥Šwÿº{.nÇ+‰·¥Š{±þG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŽŠÝ¢j"ú¶m§ÿÿ¾«þG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
