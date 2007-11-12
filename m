Return-Path: <linux-kernel-owner+w=401wt.eu-S1757217AbXKLCFL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217AbXKLCFL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 21:05:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753246AbXKLCE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 21:04:57 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:44715 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056AbXKLCE4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 21:04:56 -0500
Message-ID: <4737B4AD.9070809@pobox.com>
Date: Sun, 11 Nov 2007 21:04:29 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Hugh Dickins <hugh@veritas.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-ia64@vger.kernel.org,
       rth@twiddle.net, Jaya Kumar <jayakumar.lkml@gmail.com>, krh@redhat.com,
       stefanr@s5r6.in-berlin.de, rolandd@cisco.com, mshefty@ichips.intel.com,
       hal.rosenstock@gmail.com, avi@qumranet.com, mchehab@infradead.org,
       dgilbert@interlog.com, Greg Kroah-Hartman <greg@kroah.com>,
       Takashi Iwai <tiwai@suse.de>, perex@perex.cz,
       Karsten Wiese <annabellesgarden@yahoo.de>
Subject: Re: [rfc][patch] remove nopage
References: <20071112015643.GA9291@wotan.suse.de>
In-Reply-To: <20071112015643.GA9291@wotan.suse.de>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> Index: linux-2.6/sound/oss/via82cxxx_audio.c
> ===================================================================
> --- linux-2.6.orig/sound/oss/via82cxxx_audio.c
> +++ linux-2.6/sound/oss/via82cxxx_audio.c
> @@ -2099,8 +2099,7 @@ static void via_dsp_cleanup (struct via_
>  }
>  
>  
> -static struct page * via_mm_nopage (struct vm_area_struct * vma,
> -				    unsigned long address, int *type)
> +static int via_mm_fault (struct vm_area_struct *vma, struct vm_fault *vmf)
>  {
>  	struct via_info *card = vma->vm_private_data;
>  	struct via_channel *chan = &card->ch_out;
> @@ -2108,22 +2107,14 @@ static struct page * via_mm_nopage (stru
>  	unsigned long pgoff;
>  	int rd, wr;
>  
> -	DPRINTK ("ENTER, start %lXh, ofs %lXh, pgoff %ld, addr %lXh\n",
> -		 vma->vm_start,
> -		 address - vma->vm_start,
> -		 (address - vma->vm_start) >> PAGE_SHIFT,
> -		 address);
> -
> -        if (address > vma->vm_end) {
> -		DPRINTK ("EXIT, returning NOPAGE_SIGBUS\n");
> -		return NOPAGE_SIGBUS; /* Disallow mremap */
> -	}
> +	DPRINTK ("ENTER, pgoff %ld\n", vmf->pgoff);
> +
>          if (!card) {
> -		DPRINTK ("EXIT, returning NOPAGE_SIGBUS\n");
> -		return NOPAGE_SIGBUS;	/* Nothing allocated */
> +		DPRINTK ("EXIT, returning VM_FAULT_SIGBUS\n");
> +		return VM_FAULT_SIGBUS;	/* Nothing allocated */
>  	}
>  
> -	pgoff = vma->vm_pgoff + ((address - vma->vm_start) >> PAGE_SHIFT);
> +	pgoff = vmf->pgoff;
>  	rd = card->ch_in.is_mapped;
>  	wr = card->ch_out.is_mapped;
>  
> @@ -2150,9 +2141,8 @@ static struct page * via_mm_nopage (stru
>  	DPRINTK ("EXIT, returning page %p for cpuaddr %lXh\n",
>  		 dmapage, (unsigned long) chan->pgtbl[pgoff].cpuaddr);
>  	get_page (dmapage);
> -	if (type)
> -		*type = VM_FAULT_MINOR;
> -	return dmapage;
> +	vmf->page = dmapage;
> +	return 0;
>  }


Although the overall concept looks nice (ACK, good work), the above 
change does not build.  The code continues to reference via_mm_nopage(), 
which has been renamed to via_mm_fault() in your patch.

	Jeff


