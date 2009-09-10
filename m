Return-Path: <linux-kernel-owner+w=401wt.eu-S1753864AbZIJUMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864AbZIJUMb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 16:12:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753196AbZIJUMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 16:12:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44178 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777AbZIJUMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 16:12:30 -0400
Date: Thu, 10 Sep 2009 16:11:48 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Munehiro Ikeda <m-ikeda@ds.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       containers@lists.linux-foundation.org, dm-devel@redhat.com,
       nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, agk@redhat.com, akpm@linux-foundation.org,
       peterz@infradead.org, jmarchan@redhat.com,
       torvalds@linux-foundation.org, mingo@elte.hu, riel@redhat.com
Subject: Re: [PATCH 07/23] io-controller: Common hierarchical fair queuing
	code in elevaotor layer
Message-ID: <20090910201148.GA3617@redhat.com>
References: <1251495072-7780-1-git-send-email-vgoyal@redhat.com> <1251495072-7780-8-git-send-email-vgoyal@redhat.com> <4A9F3319.8040509@ds.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A9F3319.8040509@ds.jp.nec.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 02, 2009 at 11:08:09PM -0400, Munehiro Ikeda wrote:
> Hi,
> 
> Vivek Goyal wrote, on 08/28/2009 05:30 PM:
> > +static struct io_group *io_find_alloc_group(struct request_queue *q,
> > +			struct cgroup *cgroup, struct elv_fq_data *efqd,
> > +			int create)
> > +{
> > +	struct io_cgroup *iocg = cgroup_to_io_cgroup(cgroup);
> > +	struct io_group *iog = NULL;
> > +	/* Note: Use efqd as key */
> > +	void *key = efqd;
> > +
> > +	/*
> > +	 * Take a refenrece to css object. Don't want to map a bio to
> > +	 * a group if it has been marked for deletion
> > +	 */
> > +
> > +	if (!css_tryget(&iocg->css))
> > +		return iog;
> 
> cgroup_to_io_cgroup() returns NULL if only blkio subsystem
> is mounted but io subsystem is not.  It can cause NULL pointer
> access.
> 

Good catch Muuhh.  Thanks. Applied for next release.

Thanks
Vivek

> Signed-off-by: Munehiro "Muuhh" Ikeda <m-ikeda@ds.jp.nec.com>
> ---
>  block/elevator-fq.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/block/elevator-fq.c b/block/elevator-fq.c
> index b723c12..6714e73 100644
> --- a/block/elevator-fq.c
> +++ b/block/elevator-fq.c
> @@ -1827,7 +1827,7 @@ static struct io_group *io_find_alloc_group(struct request_queue *q,
>          * a group if it has been marked for deletion
>          */
>  
> -       if (!css_tryget(&iocg->css))
> +       if (!iocg || !css_tryget(&iocg->css))
>                 return iog;
>  
>         iog = io_cgroup_lookup_group(iocg, key);
> -- 
> 1.6.2.5
> 
> 
> -- 
> IKEDA, Munehiro
>   NEC Corporation of America
>     m-ikeda@ds.jp.nec.com
