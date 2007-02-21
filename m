Return-Path: <linux-kernel-owner+w=401wt.eu-S1423216AbXBUWki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423216AbXBUWki (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 17:40:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423220AbXBUWki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 17:40:38 -0500
Received: from smtp009.mail.ukl.yahoo.com ([217.12.11.63]:32437 "HELO
	smtp009.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1423216AbXBUWkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 17:40:36 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=rchFH+H9Vj9+UlVHWDsguHpDzkKorcY1MVSLh9z491f5u7FrF84a+pJ3B7WxSJpjUBGi68N4jkbYYQlsWe+q+8cbP9OapljjDJXuI3Fio/rHxqxasXU9EWXNqaZ5Nx/WJ14LA5fb4FkzfAIvUJITbC2R31EcJgqGKkIDcCE31u4=  ;
X-YMail-OSG: UCfBJ40VM1nGSWZv6Aqvo_xhvuFlTdklq2jd1HlXrAJ13BZHBGyR8yynWhB1lCbosytHICsPl1xPA9eqDfSzZtrxoZUEkIrJ74OHq3Du3wruU4Pqk8Y02qZ3vjs.kUOPFlJv8yjLkDAg
From: Blaisorblade <blaisorblade@yahoo.it>
To: user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [uml-devel] [PATCH 4/4] UML - lock host ldt retrieval
Date: Wed, 21 Feb 2007 23:40:28 +0100
User-Agent: KMail/1.9.5
Cc: Jeff Dike <jdike@addtoit.com>, akpm@osdl.org, linux-kernel@vger.kernel.org
References: <200702212025.l1LKPKRm006789@ccure.user-mode-linux.org>
In-Reply-To: <200702212025.l1LKPKRm006789@ccure.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702212340.28900.blaisorblade@yahoo.it>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 February 2007 21:25, Jeff Dike wrote:
> Add some locking to host_ldt_entries to prevent racing when reading
> LDT information from the host.

Please remove GFP_KERNEL allocation under spin_lock - simplest way is using a 
mutex unless this can be important for performance.

> @@ -386,15 +387,20 @@ static long do_modify_ldt_skas(int func,
>  	return ret;
>  }
>
> -short dummy_list[9] = {0, -1};
> -short * host_ldt_entries = NULL;
> +static DEFINE_SPINLOCK(host_ldt_lock);
> +static short dummy_list[9] = {0, -1};
> +static short * host_ldt_entries = NULL;
>
> -void ldt_get_host_info(void)
> +static void ldt_get_host_info(void)
>  {
>  	long ret;
>  	struct ldt_entry * ldt;
>  	int i, size, k, order;
>
> +	spin_lock(&host_ldt_lock);
> +	if(host_ldt_entries != NULL)
> +		goto out_unlock;
> +
>  	host_ldt_entries = dummy_list+1;
>
>  	for(i = LDT_PAGES_MAX-1, order=0; i; i>>=1, order++);
> @@ -402,8 +408,9 @@ void ldt_get_host_info(void)
>  	ldt = (struct ldt_entry *)
>  	      __get_free_pages(GFP_KERNEL|__GFP_ZERO, order);
>  	if(ldt == NULL) {
> -		printk("ldt_get_host_info: couldn't allocate buffer for host ldt\n");
> -		return;
> +		printk("ldt_get_host_info: couldn't allocate buffer for host "
> +		       "ldt\n");
> +		goto out_unlock;
>  	}
>
>  	ret = modify_ldt(0, ldt, (1<<order)*PAGE_SIZE);
> @@ -428,7 +435,8 @@ void ldt_get_host_info(void)
>  		size = (size + 1) * sizeof(dummy_list[0]);
>  		host_ldt_entries = kmalloc(size, GFP_KERNEL);
>  		if(host_ldt_entries == NULL) {
> -			printk("ldt_get_host_info: couldn't allocate host ldt list\n");
> +			printk("ldt_get_host_info: couldn't allocate host ldt "
> +			       "list\n");
>  			goto out_free;
>  		}
>  	}
> @@ -442,6 +450,8 @@ void ldt_get_host_info(void)
>
>  out_free:
>  	free_pages((unsigned long)ldt, order);
> +out_unlock:
> +	spin_unlock(&host_ldt_lock);
>  }
>
>  long init_new_ldt(struct mmu_context_skas * new_mm,
> @@ -480,8 +490,7 @@ long init_new_ldt(struct mmu_context_ska
>  			 * inherited from the host. All ldt-entries found
>  			 * will be reset in the following loop
>  			 */
> -			if(host_ldt_entries == NULL)
> -				ldt_get_host_info();
> +			ldt_get_host_info();
>  			for(num_p=host_ldt_entries; *num_p != -1; num_p++){
>  				desc.entry_number = *num_p;
>  				err = write_ldt_entry(&new_mm->id, 1, &desc,
> @@ -560,6 +569,6 @@ void free_ldt(struct mmu_context_skas *
>
>  int sys_modify_ldt(int func, void __user *ptr, unsigned long bytecount)
>  {
> -	return(CHOOSE_MODE_PROC(do_modify_ldt_tt, do_modify_ldt_skas, func,
> -	                        ptr, bytecount));
> +	return CHOOSE_MODE_PROC(do_modify_ldt_tt, do_modify_ldt_skas, func,
> +	                        ptr, bytecount);
>  }
>
>
> -------------------------------------------------------------------------
> Take Surveys. Earn Cash. Influence the Future of IT
> Join SourceForge.net's Techsay panel and you'll get the chance to share
> your opinions on IT & business topics through brief surveys-and earn cash
> http://www.techsay.com/default.php?page=join.php&p=sourceforge&CID=DEVDEV
> _______________________________________________
> User-mode-linux-devel mailing list
> User-mode-linux-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/user-mode-linux-devel

-- 
Inform me of my mistakes, so I can add them to my list!
Paolo Giarrusso, aka Blaisorblade
http://www.user-mode-linux.org/~blaisorblade
Chiacchiera con i tuoi amici in tempo reale! 
 http://it.yahoo.com/mail_it/foot/*http://it.messenger.yahoo.com 
