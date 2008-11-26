Return-Path: <linux-kernel-owner+w=401wt.eu-S1753499AbYKZNRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499AbYKZNRu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 08:17:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752157AbYKZNRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 08:17:42 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:54559 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbYKZNRk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 08:17:40 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] generic compat_sys_ustat
Date: Wed, 26 Nov 2008 14:17:16 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, sandeen@sandeen.net, davem@davemloft.net,
       tony.luck@intel.com, ralf@linux-mips.org, kyle@mcmartin.ca,
       schwidefsky@de.ibm.com
References: <20081121084105.GA7155@lst.de> <20081126124046.GA22340@lst.de>
In-Reply-To: <20081126124046.GA22340@lst.de>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200811261417.18016.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18k0oNnfqrUoLEtpQR/Sx86HzlXmXY9+Fr+Pfd
 6Vlyn99AaW1dhlbFMYDdI6Whvln9F/kY3/vCWvrJycD38cH7Hp
 6Gsf5PPh685CwoocntSkQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 November 2008, Christoph Hellwig wrote:
> +asmlinkage long compat_sys_ustat(unsigned dev, struct compat_ustat __user *cu)
> +{
> +       struct ustat __user *u = compat_alloc_user_space(sizeof(*u));
> +       int ret;
> +
> +       ret = sys_ustat(dev, u);
> +       if (ret < 0)
> +               return ret;
> +
> +       if (!access_ok(VERIFY_WRITE, cu, sizeof(*cu)) ||
> +           __copy_in_user(&cu->f_tfree, &u->f_tfree, sizeof(compat_daddr_t)) ||
> +           __copy_in_user(&cu->f_tinode, &u->f_tinode, sizeof(compat_ino_t)) ||
> +           __copy_in_user(&cu->f_fname, u->f_fname, sizeof(cu->f_fname)) ||
> +           __copy_in_user(&cu->f_fpack, u->f_fpack, sizeof(cu->f_fpack)))
> +               return -EFAULT;
> +       return 0;
> +}

The __copy_in_user for f_tinode and f_tfree only work on little-endian
systems, or if the sizes are the same for 32 and 64 bit. f_fname and
f_fpack don't need to be copied at all, as they are always zero-filled in
the current implementation (which is unlikely to ever change).

Also, this function is not much simpler than the actual sys_ustat function,
so have you considered implementing it directly like this?

asmlinkage long compat_sys_ustat(unsigned dev, struct compat_ustat __user * ubuf)
{
        struct super_block *s;
        struct compat_ustat tmp;
        struct kstatfs sbuf;
        int err = -EINVAL;

        s = user_get_super(new_decode_dev(dev));
        if (s == NULL)
                goto out;
        err = vfs_statfs(s->s_root, &sbuf);
        drop_super(s);
        if (err)
                goto out;

        memset(&tmp,0,sizeof(struct compat_ustat));
        tmp.f_tfree = sbuf.f_bfree;
        tmp.f_tinode = sbuf.f_ffree;

        err = copy_to_user(ubuf,&tmp,sizeof(struct compat_ustat)) ? -EFAULT : 0;
out:
        return err;
}

This code is directly lifted from the sys_ustat implementation, with a few
compat_ added in the right places.

	Arnd <><
