Return-Path: <linux-kernel-owner+w=401wt.eu-S1760975AbYBOXzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760975AbYBOXzq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 18:55:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757368AbYBOXzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 18:55:39 -0500
Received: from smtp-out.google.com ([216.239.33.17]:10084 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757078AbYBOXzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 18:55:38 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=PRnbjCb147ZXhv9LdNOxRBs2KpYGqkXfRwpj2pXwIEtktF4CTftOzeB3UupOZLXU7
	8kyLRpxMbxtul048xc8sA==
Date: Fri, 15 Feb 2008 15:55:11 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: akpm@linux-foundation.org, clameter@sgi.com, Lee.Schermerhorn@hp.com,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/4] mempolicy: add MPOL_F_STATIC_NODES flag
In-Reply-To: <20080215174554.92f14bac.pj@sgi.com>
Message-ID: <alpine.DEB.1.00.0802151548060.30015@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com> <alpine.DEB.1.00.0802101507210.11145@chino.kir.corp.google.com> <alpine.DEB.1.00.0802101507400.11145@chino.kir.corp.google.com> <20080214040918.d735e920.pj@sgi.com>
 <alpine.DEB.1.00.0802141336590.6067@chino.kir.corp.google.com> <20080215032748.8b07e5eb.pj@sgi.com> <alpine.DEB.1.00.0802151216330.19332@chino.kir.corp.google.com> <20080215174554.92f14bac.pj@sgi.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Feb 2008, Paul Jackson wrote:

> --- 2.6.24-mm1.orig/include/linux/mempolicy.h	2008-02-15 00:11:10.000000000 -0800
> +++ 2.6.24-mm1/include/linux/mempolicy.h	2008-02-15 15:16:16.031031424 -0800
> @@ -8,6 +8,14 @@
>   * Copyright 2003,2004 Andi Kleen SuSE Labs
>   */
>  
> +/*
> + * The 'policy' field of 'struct mempolicy' has both a mode and
> + * some flags packed into it.  The flags (MPOL_F_* below) occupy
> + * the high bit positions (MPOL_MODE_FLAGS), and the mempolicy
> + * modes (the "Policies" below) are encoded in the remaining low
> + * bit positions.
> + */
> +
>  /* Policies */
>  enum {
>  	MPOL_DEFAULT,
> @@ -18,16 +26,12 @@ enum {
>  };
>  
>  /*
> - * The lower MPOL_FLAG_SHIFT bits of the policy mode represent the MPOL_*
> - * constants defined in the above enum.  The upper bits represent optional
> - * set_mempolicy() or mbind() MPOL_F_* mode flags.
> + * Optional flags that modify nodemask numbering.
>   */
> -#define MPOL_FLAG_SHIFT		(8)
> -#define MPOL_MODE_MASK		((1 << MPOL_FLAG_SHIFT) - 1)
> -
> -/* Flags for set_mempolicy */
> -#define MPOL_F_STATIC_NODES	(1 << MPOL_FLAG_SHIFT)
> -#define MPOL_MODE_FLAGS		(MPOL_F_STATIC_NODES)	/* legal set_mempolicy() MPOL_F_* flags */
> +#define MPOL_F_RELATIVE_NODES (1<<14)		/* remapped relative to cpuset */
> +#define MPOL_F_STATIC_NODES (1<<15)		/* unremapped physical masks */
> +#define MPOL_MODE_FLAGS (MPOL_F_RELATIVE_NODES|MPOL_F_STATIC_NODES)
> +						/* combined MPOL_F_* mask flags */
>  
>  /* Flags for get_mempolicy */
>  #define MPOL_F_NODE	(1<<0)	/* return next IL mode instead of node mask */
> @@ -128,14 +132,14 @@ static inline int mpol_equal(struct memp
>  
>  #define mpol_set_vma_default(vma) ((vma)->vm_policy = NULL)
>  
> -static inline unsigned char mpol_mode(unsigned short mode)
> +static inline unsigned short mpol_mode(unsigned short mode)
>  {
> -	return mode & MPOL_MODE_MASK;
> +	return mode & ~MPOL_MODE_FLAGS;
>  }
>  
>  static inline unsigned short mpol_flags(unsigned short mode)
>  {
> -	return mode & ~MPOL_MODE_MASK;
> +	return mode & MPOL_MODE_FLAGS;
>  }
>  
>  /*
> @@ -201,7 +205,7 @@ static inline int mpol_equal(struct memp
>  
>  #define mpol_set_vma_default(vma) do {} while(0)
>  
> -static inline unsigned char mpol_mode(unsigned short mode)
> +static inline unsigned short mpol_mode(unsigned short mode)
>  {
>  	return 0;
>  }
> --- 2.6.24-mm1.orig/mm/mempolicy.c	2008-02-15 00:18:35.000000000 -0800
> +++ 2.6.24-mm1/mm/mempolicy.c	2008-02-15 08:16:52.034431591 -0800
> @@ -884,8 +884,6 @@ asmlinkage long sys_mbind(unsigned long 
>  
>  	if (mpol_mode(mode) >= MPOL_MAX)
>  		return -EINVAL;
> -	if (mpol_flags(mode) & ~MPOL_MODE_FLAGS)
> -		return -EINVAL;
>  	err = get_nodes(&nodes, nmask, maxnode);
>  	if (err)
>  		return err;
> @@ -898,13 +896,9 @@ asmlinkage long sys_set_mempolicy(int mo
>  {
>  	int err;
>  	nodemask_t nodes;
> -	unsigned short flags;
>  
>  	if (mpol_mode(mode) >= MPOL_MAX)
>  		return -EINVAL;
> -	if (mpol_flags(mode) & ~MPOL_MODE_FLAGS)
> -		return -EINVAL;
> -	flags = mpol_flags(mode) & MPOL_MODE_FLAGS;
>  	err = get_nodes(&nodes, nmask, maxnode);
>  	if (err)
>  		return err;
> 

There's been significant changes in this area since my last posting, but I 
agree that doing a slight variation of this is better.

On that topic, I am ready to post the updated patchset but I'd like to do 
it with your bitmap_onto() patch so that I can fully implement and test 
MPOL_F_RELATIVE_NODES.  Do you know when the patch that adds 
bitmap_onto(), which is a name I think I noticed you liking, will be 
available?

		David
