Return-Path: <linux-kernel-owner+w=401wt.eu-S1755340AbZAEPMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340AbZAEPMF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 10:12:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750988AbZAEPLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 10:11:55 -0500
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:47424 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbZAEPLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 10:11:54 -0500
Date: Mon, 5 Jan 2009 09:10:57 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH] mm: __nr_to_section - make it safe against overflow
In-Reply-To: <20090105094034.GA7645@localhost>
Message-ID: <Pine.LNX.4.64.0901050906180.12774@quilx.com>
References: <20090105094034.GA7645@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Jan 2009, Cyrill Gorcunov wrote:

>  	/*
>  	 * This is, logically, a pointer to an array of struct
> @@ -980,9 +986,12 @@ extern struct mem_section mem_section[NR
>
>  static inline struct mem_section *__nr_to_section(unsigned long nr)
>  {
> -	if (!mem_section[SECTION_NR_TO_ROOT(nr)])
> +	unsigned long idx = SECTION_NR_TO_ROOT(nr);
> +	WARN_ON_ONCE(idx >= NR_SECTION_ROOTS);
> +
> +	if (idx >=NR_SECTION_ROOTS || !mem_section[idx])
>  		return NULL;
> -	return &mem_section[SECTION_NR_TO_ROOT(nr)][nr & SECTION_ROOT_MASK];
> +	return &mem_section[idx][nr & SECTION_ROOT_MASK];
>  }
>  extern int __section_nr(struct mem_section* ms);
>  extern unsigned long usemap_size(void);

Not that you are adding code to numerous hot code path. Plus this is a
frequently used inline. Code size is going to increase if you do this.

I would think that the code does not have the tests because of performance
and code size concerns. Can we just say that a sane nr must be passed to
__nr_section?

