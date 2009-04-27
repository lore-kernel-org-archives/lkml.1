Return-Path: <linux-kernel-owner+w=401wt.eu-S1761593AbZD0UtO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761593AbZD0UtO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 16:49:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760651AbZD0Us4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 16:48:56 -0400
Received: from smtp-out.google.com ([216.239.33.17]:11409 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760734AbZD0Us4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 16:48:56 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=rQDoLygjhDXMVxAJbca70RSULKiYKJKVDBRnWkN2OJGLhKj4HfOMVrMqLSuVGYWZ6
	7sHK2UeCTUl56pphmYCuw==
Date: Mon, 27 Apr 2009 13:48:47 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Linux Memory Management List <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Replace the watermark-related union in struct zone with
 a watermark[] array
In-Reply-To: <20090427170054.GE912@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.0904271340320.11972@chino.kir.corp.google.com>
References: <1240408407-21848-1-git-send-email-mel@csn.ul.ie> <1240408407-21848-19-git-send-email-mel@csn.ul.ie> <alpine.DEB.2.00.0904221251350.14558@chino.kir.corp.google.com> <20090427170054.GE912@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Apr 2009, Mel Gorman wrote:

> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index c1fa208..1ff59fd 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -163,6 +163,13 @@ static inline int is_unevictable_lru(enum lru_list l)
>  #endif
>  }
>  
> +enum zone_watermarks {
> +	WMARK_MIN,
> +	WMARK_LOW,
> +	WMARK_HIGH,
> +	NR_WMARK
> +};
> +
>  struct per_cpu_pages {
>  	int count;		/* number of pages in the list */
>  	int high;		/* high watermark, emptying needed */
> @@ -275,12 +282,9 @@ struct zone_reclaim_stat {
>  
>  struct zone {
>  	/* Fields commonly accessed by the page allocator */
> -	union {
> -		struct {
> -			unsigned long	pages_min, pages_low, pages_high;
> -		};
> -		unsigned long pages_mark[3];
> -	};
> +
> +	/* zone watermarks, indexed with WMARK_LOW, WMARK_MIN and WMARK_HIGH */
> +	unsigned long watermark[NR_WMARK];
>  
>  	/*
>  	 * We don't know if the memory that we're going to allocate will be freeable

I thought the suggestion was for something like

	#define zone_wmark_min(z)	(z->pages_mark[WMARK_MIN])
	...
