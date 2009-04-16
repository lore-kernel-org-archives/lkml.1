Return-Path: <linux-kernel-owner+w=401wt.eu-S1753464AbZDPEqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464AbZDPEqp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 00:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbZDPEqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 00:46:35 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:60527 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbZDPEqe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 00:46:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UAjZBAFS5+StbPhjErmYVqMe55WU8lrM4x3vtL9eBseARFEB6/C2j9KhTuN/3S7d13
         /+oJD5+VWmuw2LHRamIhGwQNupXTWZO9YdhBfXDOoX0mXm5MuA3bxBbvA12gK2LKlSzN
         Ud2ydbYc0FVLwZ5xCBrz1UahhuI3xZYCcEZm4=
MIME-Version: 1.0
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE1909015F8DFA@mi8nycmail19.Mi8.com>
References: <BD79186B4FD85F4B8E60E381CAEE1909015F8DFA@mi8nycmail19.Mi8.com>
Date: Thu, 16 Apr 2009 06:46:32 +0200
Message-ID: <19f34abd0904152146l3db9961bt3b52f224abc8d960@mail.gmail.com>
Subject: Re: [PATCH] block/genhd.c: fix sparse warning
From: Vegard Nossum <vegard.nossum@gmail.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/16 H Hartley Sweeten <hartleys@visionengravers.com>:
> Fix sparse warning in block/genhd.c.
>
>        warning: symbol '__mptr' shadows an earlier one
>
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

Hi,

Just a heads up: There seems to be some sort of consensus that this
type of patch title is not a very good one. (What about "remove
variable shadowing"?)

It would also be nice to have an explanation of where the __mptr
symbol comes into play, because it doesn't even appear in the patch,
and reviewers would likely have an easier job if they knew where to
look it up.

Was this warning harmless, or was the code in fact broken?

Can we rewrite container_of() to not use an extra variable (__mptr),
or perhaps using an inline function for part of the computation?

Do we also have this problem in expressions like max(max(x, y), z)?

Thanks :-)


Vegard

>
> ---
>
> diff --git a/block/genhd.c b/block/genhd.c
> index a9ec910..ca3eedb 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -576,8 +576,10 @@ struct gendisk *get_gendisk(dev_t devt, int
> *partno)
>                struct kobject *kobj;
>
>                kobj = kobj_lookup(bdev_map, devt, partno);
> -               if (kobj)
> -                       disk = dev_to_disk(kobj_to_dev(kobj));
> +               if (kobj) {
> +                       struct device *dev = kobj_to_dev(kobj);
> +                       disk = dev_to_disk(dev);
> +               }
>        } else {
>                struct hd_struct *part;
>
> @@ -1010,7 +1012,7 @@ static int diskstats_show(struct seq_file *seqf,
> void *v)
>                                "wsect wuse running use aveq"
>                                "\n\n");
>        */
> -
> +
>        disk_part_iter_init(&piter, gp, DISK_PITER_INCL_PART0);
>        while ((hd = disk_part_iter_next(&piter))) {
>                cpu = part_stat_lock();
> @@ -1034,7 +1036,7 @@ static int diskstats_show(struct seq_file *seqf,
> void *v)
>                        );
>        }
>        disk_part_iter_exit(&piter);
> -
> +
>        return 0;
>  }
