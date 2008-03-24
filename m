Return-Path: <linux-kernel-owner+w=401wt.eu-S1762250AbYCXSff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762250AbYCXSff (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 14:35:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755107AbYCXSf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 14:35:28 -0400
Received: from gv-out-0910.google.com ([216.239.58.184]:34146 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756560AbYCXSf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 14:35:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CO6rXiNEh/aJGlr/uZ2dG/c5OjmXKPL8ge/yweSPbW0+sQwXsTVsKMsPPV/dKDbfQOysPvgt7C+WguoTH1x5HJc34YzvbJKMogmZOoD8UgaW8VcFZTd6MT2Otn+TX8MMFnkYjRylsYyikV3Q0JnBlt0v3Gq3td4cyUEyBptfOwY=
Message-ID: <4cefeab80803241135i70bd81e5od82b84685bc4dbb@mail.gmail.com>
Date: Tue, 25 Mar 2008 00:05:24 +0530
From: "Nitin Gupta" <nitingupta910@gmail.com>
To: "Will Newton" <will.newton@gmail.com>
Subject: Re: [PATCH 1/6] compcache: compressed RAM block device
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <87a5b0800803240923m1ec9e343ld08c2828fe42e4e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200803242032.40589.nitingupta910@gmail.com>
	 <87a5b0800803240923m1ec9e343ld08c2828fe42e4e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 24, 2008 at 9:53 PM, Will Newton <will.newton@gmail.com> wrote:
>
> On Mon, Mar 24, 2008 at 3:02 PM, Nitin Gupta <nitingupta910@gmail.com> wrote:


>  >  diff --git a/drivers/block/Makefile b/drivers/block/Makefile
>  >  index 5e58430..b6d3dd2 100644
>  >  --- a/drivers/block/Makefile
>  >  +++ b/drivers/block/Makefile
>  >  @@ -12,6 +12,7 @@ obj-$(CONFIG_PS3_DISK)                += ps3disk.o
>  >   obj-$(CONFIG_ATARI_FLOPPY)     += ataflop.o
>  >   obj-$(CONFIG_AMIGA_Z2RAM)      += z2ram.o
>  >   obj-$(CONFIG_BLK_DEV_RAM)      += brd.o
>  >  +obj-$(CONFIG_BLK_DEV_COMPCACHE)        += compcache.o
>
>  Minor - this isn't in alphabetical order.

Intent here is to keep related things together. So, I have placed it
with generic ramdisk. This also seems to be convention used in this
file.

>  >  diff --git a/drivers/block/compcache.c b/drivers/block/compcache.c
>  >  new file mode 100644
>  >  index 0000000..4ffcd63
>  >  --- /dev/null
>  >  +++ b/drivers/block/compcache.c
>  >  @@ -0,0 +1,440 @@
>  >  +/*
>  >  + * Compressed RAM based swap device
>  >  + *
>  >  + * (C) Nitin Gupta
>
>  Should add a copyright year.
>

ok.

>  >  +#include <asm/string.h>
>
>  Should this be <linux/string.h>?
>

Yes. I will change this.


>  >  +/* Check if request is within bounds and page aligned */
>  >  +static inline int valid_swap_request(struct bio *bio)
>  >  +{
>  >  +       if (unlikely((bio->bi_sector >= compcache.size) ||
>  >  +                       (bio->bi_sector & (SECTORS_PER_PAGE - 1)) ||
>  >  +                       (bio->bi_vcnt != 1) ||
>  >  +                       (bio->bi_size != PAGE_SIZE) ||
>  >  +                       (bio->bi_io_vec[0].bv_offset != 0)))
>  >  +               return 0;
>  >  +       return 1;
>  >  +}
>
>  Probably unnecessary to mark this explicitly inline.
>
>

Probably yes. I am not sure.


>  >  +       /*
>  >  +        * It is named like this to prevent distro installers
>  >  +        * from offering compcache as installation target. They
>  >  +        * seem to ignore all devices beginning with 'ram'
>  >  +        */
>  >  +       sprintf(compcache.disk->disk_name, "%s", "ramzswap0");
>
>  I'm not sure the name makes it 100% obvious what the device is for.
>  You could use strcpy here also.
>

"z" == compress
and hence the name ramzswap :)


>  >  +       if (compcache.table[0].addr)
>  >  +               free_page((unsigned long)compcache.table[0].addr);
>  >  +       if (compcache.compress_workmem)
>  >  +               kfree(compcache.compress_workmem);
>  >  +       if (compcache.compress_buffer)
>  >  +               kfree(compcache.compress_buffer);
>  >  +       if (compcache.table)
>  >  +               vfree(compcache.table);
>
>  kfree() and vfree() may safely be called on NULL pointers.
>

I will remove these unnecessary checks then.


Thanks,
Nitin
