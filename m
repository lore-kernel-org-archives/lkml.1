Return-Path: <linux-kernel-owner+w=401wt.eu-S933604AbXG0Hbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933604AbXG0Hbh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 03:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760100AbXG0Hba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 03:31:30 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:63238 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636AbXG0Hb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 03:31:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=atZmtre6n3NSfmBi/mL840m5FAQn0KVq4d7bZdshBv8tb6TM8Kyq5QcEWVy+hmn4KzLSMIjrtPoa8vGAVKeeJXM/7i0cTlqH5a4k9hGoh7DyJ8nUcFLQlVE04loyIoJcOEgxPWMUNKTZDaZBGD3cFVVYvzopRJJBwY7rz/pui0U=
Message-ID: <a8e1da0707270031u3a4e5616t7cb38356dd86a560@mail.gmail.com>
Date: Fri, 27 Jul 2007 07:31:27 +0000
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Joe Jin" <joe.jin@oracle.com>
Subject: Re: [PATCH] add check do_direct_IO() return val
Cc: "Andrew Morton" <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       gurudas.pai@oracle.com, wen.gang.wang@oracle.com,
       "Badari Pulavarty" <pbadari@us.ibm.com>,
       "Zach Brown" <zach.brown@oracle.com>
In-Reply-To: <20070727071547.GA25084@joejin-pc.cn.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070726090400.GA18640@joejin-pc.cn.oracle.com>
	 <20070726221307.3d7b3446.akpm@linux-foundation.org>
	 <20070727071547.GA25084@joejin-pc.cn.oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>On 7/27/07, Joe Jin <joe.jin@oracle.com> wrote:
> > I think we still want to run dio_cleanup() if do_direct_IO() failed?
> > Otherwise we can leak pages.
> >
> > And there's nothing special about EFAULT or ENOMEM here: if do_direct_IO()
> > returns any error then that's it: we bale out, yes?
> >
>
> Yes, I think we'll out from here if get EFAULT/ENOMEM error, also maybe -EIO
> return, return diretly should ok.
>
> > In fact I'm suspecting that this is what the code in there used to do.
> > Something like:
> >
> >       for (...) {
> >               ...
> >               ret = do_direct_IO(...);
> >               ...
> >               if (ret) {
> >                       dio_dleanup(dio);
> >                       break
> >               }
> >       }
> >       return ret;
> >
>
> Yes, we need call dio_cleanup() to release page cache, I lost it.
>
> However, we need do more while return -ENOTBLK, right?
> so I think the patch maybe like following:
>
>
> --- linux-2.6.22/fs/direct-io.c.orig    2007-07-27 14:39:15.000000000 +0800
> +++ linux-2.6.22/fs/direct-io.c 2007-07-27 15:08:58.000000000 +0800
> @@ -1032,18 +1032,19 @@ direct_io_worker(int rw, struct kiocb *i
>                                         blkbits);
>
>                 if (ret) {
> +                       if (ret == -ENOTBLK && (rw & WRITE)) {
> +                               /*
> +                                * The remaining part of the request will be
> +                                * be handled by buffered I/O when we return
> +                                */
> +                               ret = 0;
> +                               break;
> +                       }
>                         dio_cleanup(dio);
> -                       break;
> +                       goto out;
>                 }
>         } /* end iovec loop */
>
> -       if (ret == -ENOTBLK && (rw & WRITE)) {
> -               /*
> -                * The remaining part of the request will be
> -                * be handled by buffered I/O when we return
> -                */
> -               ret = 0;
> -       }
>         /*
>          * There may be some unwritten disk at the end of a part-written
>          * fs-block-sized block.  Go zero that now.
>
>
>
>
> > _
> >
> > However I'd like to ask you guys to carefully review and test that please.
> >
> Gurudas, would you please give more test of this patch?
>
Hi,
If you are sure the problem is caused by EFAULT or ENOMEM , why not:
               if (ret) {
                       dio_cleanup(dio);
                       if (ret == -EFAULT || ret == -ENOMEM)
                               goto out;
                       break;
               }

regards
dave
