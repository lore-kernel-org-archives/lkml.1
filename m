Return-Path: <linux-kernel-owner+w=401wt.eu-S1757992AbZKRRO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757992AbZKRRO4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 12:14:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757941AbZKRRO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 12:14:56 -0500
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:38927 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757916AbZKRROz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 12:14:55 -0500
Date: Wed, 18 Nov 2009 11:15:38 -0600
From: scameron@beardog.cce.hp.com
To: Dan Merillat <dan.merillat@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andy Whitcroft <apw@canonical.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roel Kluin <roel.kluin@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       rostedt@goodmis.org, Mike Miller <mike.miller@hp.com>,
       Jens Axboe <jens.axboe@oracle.com>, iss_storagedev@hp.com
Subject: Re: [PATCH] ftrace: return error instead of 12 bytes read
Message-ID: <20091118171538.GK3273@beardog.cce.hp.com>
References: <4AFB2C0B.50605@gmail.com> <20091111134730.a0da9e38.akpm@linux-foundation.org> <25d66d860911120531u6a9cd40dmf3056fd99bd97f4e@mail.gmail.com> <20091112134554.GA30272@elte.hu> <c0c067900911180218h466bec13m5f8ec8713617b11a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c0c067900911180218h466bec13m5f8ec8713617b11a@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 05:18:53AM -0500, Dan Merillat wrote:
> On Thu, Nov 12, 2009 at 8:45 AM, Ingo Molnar <mingo@elte.hu> wrote:
> 
> > Even in filesystems, ~80% of the cases use proper negative values:
> >
> >  $ git grep 'return -E' fs/ | wc -l
> >  4540
> >  $ git grep 'return E' fs/ | wc -l
> >  895
> 
> Except....
> fs/9p/fid.c:                            return ERR_PTR(-EPERM);
> 
> try this:
> 
> $ git grep "return E[A-Z]*;" | grep -v EOF | grep -v ERROR | wc -l
> 138
> $ git grep "return -E[A-Z]*;"| wc -l
> 57285
> 
> 2 of those are in Documentation/ and 2 are comments from a quick
> glance.   134 uses of positive error returns, _74_ of which are in
> fs/xfs, 24 in bluetooth, and the rest scattered randomly around the
> kernel.
> 
> 134 positive error returns  vs 57881 negative?  The style is so
> strongly ingrained in the kernel (And I'd bet an audit of those
> remaning 134 would find at least one bug) that it'd be a good janitor
> task to go through and switch them.
> 
> 
> This is one example - a function that returns either ENXIO or 0, and
> the lone caller explicitly tests and flips the sign.
> 
> (Not signing off on this!!!!  but CCing the relevant people for this driver)
> 
> diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
> index 6399e50..79867d6 100644
> --- a/drivers/block/cciss.c
> +++ b/drivers/block/cciss.c
> @@ -428,7 +428,7 @@ cciss_proc_write(struct file *file, const char __user *buf,
> 
>                 rc = cciss_engage_scsi(h->ctlr);
>                 if (rc != 0)
> -                       err = -rc;
> +                       err = rc;
>                 else
>                         err = length;
>         } else
> diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
> index 3315268..4af3085 100644
> --- a/drivers/block/cciss_scsi.c
> +++ b/drivers/block/cciss_scsi.c
> @@ -1547,7 +1547,7 @@ cciss_engage_scsi(int ctlr)
>         if (sa->registered) {
>                 printk("cciss%d: SCSI subsystem already engaged.\n", ctlr);
>                 spin_unlock_irqrestore(CCISS_LOCK(ctlr), flags);
> -               return ENXIO;
> +               return -ENXIO;
>         }
>         sa->registered = 1;
>         spin_unlock_irqrestore(CCISS_LOCK(ctlr), flags);

I sent a patch to fix this already.

http://groups.google.com/group/linux.kernel/browse_thread/thread/40b43d35dff0f30a/0a073fc8014547e0?hl=en&lnk=gst&q=cciss+weird#0a073fc8014547e0

-- steve
