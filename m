Return-Path: <linux-kernel-owner+w=401wt.eu-S1753924AbYGYVfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbYGYVfu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 17:35:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751668AbYGYVfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 17:35:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34369 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751611AbYGYVfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 17:35:41 -0400
Date: Fri, 25 Jul 2008 14:29:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: alan@lxorguk.ukuu.org.uk, torvalds@linux-foundation.org, mingo@elte.hu,
       randy.dunlap@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] hugetlb: fix CONFIG_SYSCTL=n build
Message-Id: <20080725142921.2238dc5a.akpm@linux-foundation.org>
In-Reply-To: <20080725203351.GA18407@us.ibm.com>
References: <20080721.233512.128618365.anemo@mba.ocn.ne.jp>
	<20080721191519.GA15843@elte.hu>
	<20080721214258.787a67ca@lxorguk.ukuu.org.uk>
	<20080722072334.GA25241@elte.hu>
	<48865899.3030209@garzik.org>
	<20080723104520.GA20672@elte.hu>
	<20080724052603.GA8744@elte.hu>
	<20080725180935.5bd02bf5@lxorguk.ukuu.org.uk>
	<20080725203351.GA18407@us.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jul 2008 13:33:51 -0700
Nishanth Aravamudan <nacc@us.ibm.com> wrote:

> [resending with Linus' address fixed]
> 
> On 25.07.2008 [18:09:35 +0100], Alan Cox wrote:
> > On Thu, 24 Jul 2008 07:26:03 +0200
> > Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > 
> > > not sure it's known but despite all the fixes i still get:
> > > 
> > >  drivers/built-in.o: In function `ne_drv_resume':
> > >  ne.c:(.text+0x146ba4): undefined reference to `NS8390_init'
> > >  drivers/built-in.o: In function `ne_block_output':
> > >  ne.c:(.text+0x146e00): undefined reference to `NS8390_init'
> > 
> > This should do the trick. I can't test it currently as that configuration
> > now fails to build with mm errors in current git head..
> > 
> > mm/hugetlb.c: In function ???hugetlb_acct_memory???: mm/hugetlb.c:1507:
> > error: implicit declaration of function ???cpuset_mems_nr???

Remind me to give a wedgie to the next gcc developer I meet.

> 
> When moving the intialization functions around, I did not remove the
> dependency of some helpers on CONFIG_SYSCTL. This led to a large chunk
> of code being elided even though it is needed to build hugetlb.o.
> 
> Fixes a build failure reported by Alan Cox:
> 
> mm/hugetlb.c: In function ______hugetlb_acct_memory______: mm/hugetlb.c:1507:
> error: implicit declaration of function ______cpuset_mems_nr______

And the next one.

LANG=C stomps this silliness.

> Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 41341c4..3be79dc 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1026,7 +1026,6 @@ static void __init report_hugepages(void)
>  	}
>  }
>  
> -#ifdef CONFIG_SYSCTL
>  #ifdef CONFIG_HIGHMEM
>  static void try_to_free_low(struct hstate *h, unsigned long count)
>  {
> @@ -1386,6 +1385,7 @@ static unsigned int cpuset_mems_nr(unsigned int *array)
>  	return nr;
>  }
>  
> +#ifdef CONFIG_SYSCTL
>  int hugetlb_sysctl_handler(struct ctl_table *table, int write,
>  			   struct file *file, void __user *buffer,
>  			   size_t *length, loff_t *ppos)
> 

OK, we had a fix from Ingo but this one is better.
