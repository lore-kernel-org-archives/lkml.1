Return-Path: <linux-kernel-owner+w=401wt.eu-S1753961AbXJALNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961AbXJALNu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 07:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752730AbXJALNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 07:13:37 -0400
Received: from mx1.suse.de ([195.135.220.2]:37383 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752512AbXJALNg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 07:13:36 -0400
From: Andi Kleen <andi@firstfloor.org>
To: thayne@c2.net
Subject: Re: [PATCH] Inconsistent mmap()/mremap() flags
Date: Mon, 1 Oct 2007 13:13:30 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, discuss@x86-64.org
References: <1190958393.5128.85.camel@phantasm.home.enterpriseandprosperity.com>
In-Reply-To: <1190958393.5128.85.camel@phantasm.home.enterpriseandprosperity.com>
Organization: -
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710011313.30171.andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> @@ -388,6 +392,9 @@
>  			if (vma->vm_flags & VM_MAYSHARE)
>  				map_flags |= MAP_SHARED;
>  
> +			if (flags & MAP_32BIT)
> +				map_flags |= MAP_32BIT;
> +
>  			new_addr = get_unmapped_area(vma->vm_file, 0, new_len,
>  						vma->vm_pgoff, map_flags);
>  			ret = new_addr;

That's not enough -- you would also need to fail the mremap when the result
is > 2GB (MAP_32BIT is actually a MAP_31BIT) 

But that would be ugly to implement without a new architecture wrapper
or better changing arch_get_unmapped_area()

It might be better to just not bother. MAP_32BIT is a kind of hack anyways
that at least for mmap can be easily emulated in user space anyways.
Given for mremap() it is not that easy because there is no "hint" argument
without MREMAP_FIXED; but unless someone really needs it i would prefer
to not propagate the hack. If it's really needed it's probably better
to implement a start search hint for mremap()

-Andi
