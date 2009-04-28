Return-Path: <linux-kernel-owner+w=401wt.eu-S1758870AbZD1NIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758870AbZD1NIz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 09:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756697AbZD1NIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 09:08:44 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:64890 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240AbZD1NIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 09:08:44 -0400
Date: Tue, 28 Apr 2009 15:07:36 +0200
From: Alexander Schmidt <alexs@linux.vnet.ibm.com>
To: Stefan Roscher <ossrosch@linux.vnet.ibm.com>,
       Roland Dreier <rdreier@cisco.com>
Cc: fenkes@de.ibm.com, LKML <linux-kernel@vger.kernel.org>,
       OF-EWG <ewg@lists.openfabrics.org>,
       LinuxPPC-Dev <linuxppc-dev@ozlabs.org>, raisch@de.ibm.com,
       alexschm@de.ibm.com, stefan.roscher@de.ibm.com
Subject: Re: [ewg] Re: [PATCH 1/3] IB/ehca: Replace vmalloc with kmalloc
Message-ID: <20090428150736.1ea143f0@BL3D1974.boeblingen.de.ibm.com>
In-Reply-To: <200904221602.29028.ossrosch@linux.vnet.ibm.com>
References: <200904211716.45245.ossrosch@linux.vnet.ibm.com>
	<adaws9dvrkp.fsf@cisco.com>
	<200904221602.29028.ossrosch@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roland,

did you have a chance to take a look at the patchset and will you apply it, or
are there any outstanding issues we need to address?

Regards,
Alex

On Wed, 22 Apr 2009 16:02:28 +0200
Stefan Roscher <ossrosch@linux.vnet.ibm.com> wrote:

> In case of large queue pairs there is the possibillity of allocation failures 
> due to memory fragmentationo with kmalloc().To ensure the memory is allocated even
> if kmalloc() can not find chunks which are big enough, we try to allocate the memory
> with vmalloc().
> 
> Signed-off-by: Stefan Roscher <stefan.roscher@de.ibm.com>
> ---
> 
> On Tuesday 21 April 2009 07:34:30 pm Roland Dreier wrote:
> >  > +	queue->queue_pages = kmalloc(nr_of_pages * sizeof(void *), GFP_KERNEL);
> > 
> > How big might this buffer be?  Any chance of allocation failure due to
> > memory fragmentation?
> > 
> >  - R.
> Hey Roland, 
> yes you are right and here is the patch to circumvent the described problem.
> It will apply on top of the patchset.
> regards Stefan
> 
> 
> 
>  drivers/infiniband/hw/ehca/ipz_pt_fn.c |   17 +++++++++++++----
>  1 files changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/ehca/ipz_pt_fn.c b/drivers/infiniband/hw/ehca/ipz_pt_fn.c
> index a260559..1227c59 100644
> --- a/drivers/infiniband/hw/ehca/ipz_pt_fn.c
> +++ b/drivers/infiniband/hw/ehca/ipz_pt_fn.c
> @@ -222,8 +222,11 @@ int ipz_queue_ctor(struct ehca_pd *pd, struct ipz_queue *queue,
>  	/* allocate queue page pointers */
>  	queue->queue_pages = kmalloc(nr_of_pages * sizeof(void *), GFP_KERNEL);
>  	if (!queue->queue_pages) {
> -		ehca_gen_err("Couldn't allocate queue page list");
> -		return 0;
> +		queue->queue_pages = vmalloc(nr_of_pages * sizeof(void *));
> +		if (!queue->queue_pages) {
> +			ehca_gen_err("Couldn't allocate queue page list");
> +			return 0;
> +		}
>  	}
>  	memset(queue->queue_pages, 0, nr_of_pages * sizeof(void *));
> 
> @@ -240,7 +243,10 @@ int ipz_queue_ctor(struct ehca_pd *pd, struct ipz_queue *queue,
>  ipz_queue_ctor_exit0:
>  	ehca_gen_err("Couldn't alloc pages queue=%p "
>  		 "nr_of_pages=%x",  queue, nr_of_pages);
> -	kfree(queue->queue_pages);
> +	if (is_vmalloc_addr(queue->queue_pages))
> +		vfree(queue->queue_pages);
> +	else
> +		kfree(queue->queue_pages);
> 
>  	return 0;
>  }
> @@ -262,7 +268,10 @@ int ipz_queue_dtor(struct ehca_pd *pd, struct ipz_queue *queue)
>  			free_page((unsigned long)queue->queue_pages[i]);
>  	}
> 
> -	kfree(queue->queue_pages);
> +	if (is_vmalloc_addr(queue->queue_pages))
> +		vfree(queue->queue_pages);
> +	else
> +		kfree(queue->queue_pages);
> 
>  	return 1;
>  }
