Return-Path: <linux-kernel-owner+w=401wt.eu-S1755353AbZFVHfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353AbZFVHfw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 03:35:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753153AbZFVHfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 03:35:45 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:34124 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752384AbZFVHfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 03:35:44 -0400
Message-ID: <4A3F344F.1070206@snapgear.com>
Date: Mon, 22 Jun 2009 17:35:43 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>
CC: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
       David McCullough <davidm@snapgear.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] rmap: fixup page_referenced() for nommu systems
References: <1245371813-30954-1-git-send-email-vapier@gentoo.org>
In-Reply-To: <1245371813-30954-1-git-send-email-vapier@gentoo.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Mike Frysinger wrote:
> After the recent changes that went into mm/vmscan.c to overhaul stuff, we
> ended up with these warnings on no-mmu systems:
> mm/vmscan.c: In function ‘shrink_page_list’:
> mm/vmscan.c:580: warning: unused variable ‘vm_flags’
> mm/vmscan.c: In function ‘shrink_active_list’:
> mm/vmscan.c:1294: warning: ‘vm_flags’ may be used uninitialized in this function
> mm/vmscan.c:1242: note: ‘vm_flags’ was declared here
> 
> This is because the no-mmu function defines page_referenced() to work on
> the first argument only (the page).  It does not clear the vm_flags given
> to it because for no-mmu systems, they never actually get utilized.  Since
> that is no longer strictly true, we need to set vm_flags to 0 like everyone
> else so gcc can do proper dead code elimination without annoying us with
> unused warnings.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Acked-by: Greg Ungerer <gerg@uclinux.org>



>  include/linux/rmap.h |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
> index 216d024..bf116d0 100644
> --- a/include/linux/rmap.h
> +++ b/include/linux/rmap.h
> @@ -118,7 +118,14 @@ int try_to_munlock(struct page *);
>  #define anon_vma_prepare(vma)	(0)
>  #define anon_vma_link(vma)	do {} while (0)
>  
> -#define page_referenced(page, locked, cnt, flags) TestClearPageReferenced(page)
> +static inline int page_referenced(struct page *page, int is_locked,
> +				  struct mem_cgroup *cnt,
> +				  unsigned long *vm_flags)
> +{
> +	*vm_flags = 0;
> +	return TestClearPageReferenced(page);
> +}
> +
>  #define try_to_unmap(page, refs) SWAP_FAIL
>  
>  static inline int page_mkclean(struct page *page)

-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
