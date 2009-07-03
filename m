Return-Path: <linux-kernel-owner+w=401wt.eu-S1756177AbZGCG7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177AbZGCG7R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 02:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbZGCG7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 02:59:07 -0400
Received: from mail-bw0-f207.google.com ([209.85.218.207]:56416 "EHLO
	mail-bw0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbZGCG7G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 02:59:06 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Jul 2009 02:59:05 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:references:in-reply-to:mime-version
         :content-type:content-transfer-encoding:message-id;
        b=CG+VqICknTuhfV+PvhFow/PYKSiIpN75zCxUGny/gtnm1RBq09+aQ3ldy1WrOmzMVv
         7hs9W3f3mjYRg83iY/YeHOYfhhOLWA+TCu6MEG+FAuQwuy7QfQ/mgmd4in60rxzHSAGU
         fkPFG83oW261Q90P2nSUeyScTgzvYNljLrLlc=
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.27.26
Date: Fri, 3 Jul 2009 08:52:24 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc1; KDE/4.2.95; x86_64; ; )
References: <20090703000703.GA17190@kroah.com> <20090703000722.GB17190@kroah.com>
In-Reply-To: <20090703000722.GB17190@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200907030852.24912.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 of July 2009, Greg KH wrote:

Isn't this part broken?

The code in 2.6.27 already has such thing and new code is trying to return 
NULL even if function returns int

static int dm_blk_open(struct inode *inode, struct file *file)
{
        struct mapped_device *md;

        spin_lock(&_minor_lock);

        md = inode->i_bdev->bd_disk->private_data;
        if (!md)
                goto out;

        if (test_bit(DMF_FREEING, &md->flags) ||
            test_bit(DMF_DELETING, &md->flags)) {
                md = NULL;
                goto out;
        }

        dm_get(md);
        atomic_inc(&md->open_count);

out:
        spin_unlock(&_minor_lock);

        return md ? 0 : -ENXIO;
}


> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index ace998c..925efaf 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -265,6 +265,10 @@ static int dm_blk_open(struct inode *inode, struct
> file *file) goto out;
>         }
>  
> +       if (test_bit(DMF_FREEING, &md->flags) ||
> +           test_bit(DMF_DELETING, &md->flags))
> +               return NULL;
> +
>         dm_get(md);
>         atomic_inc(&md->open_count);
>  


-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
