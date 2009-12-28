Return-Path: <linux-kernel-owner+w=401wt.eu-S1752019AbZL1KY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019AbZL1KY5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 05:24:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751261AbZL1KY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 05:24:56 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:63641 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbZL1KYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 05:24:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=cH7ni4WbWCNDa4t5BDpJdt0diG54+i/2GZjG4L9oIiBIKaLmKz/USoqPFC6PSX7ttp
         YGyxRcn6Kp5MhfpsZABRgxH7pHHwjGUDznlqR4HmouFou+sZM1RipA/SPRUVPwGAq0zd
         KvCI/SYtffnvMgY41Lmfz1nDFhv+l7PFgYxiw=
Message-ID: <4B38876F.6010204@gmail.com>
Date: Mon, 28 Dec 2009 19:24:47 +0900
From: Minchan Kim <minchan.kim@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: [PATCH 2/3 -mmotm-2009-12-10-17-19] Count zero page as file_rss
References: <ceeec51bdc2be64416e05ca16da52a126b598e17.1258773030.git.minchan.kim@gmail.com> <ae2928fe7bb3d94a7ca18d3b3274fdfeb009803a.1258773030.git.minchan.kim@gmail.com>
In-Reply-To: <ae2928fe7bb3d94a7ca18d3b3274fdfeb009803a.1258773030.git.minchan.kim@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I missed Hugh. 

Minchan Kim wrote:
> Long time ago, we counted zero page as file_rss.
> But after reinstanted zero page, we don't do it.
> It means rss of process would be smaller than old.
> 
> It could chage OOM victim selection.
> 
> Kame reported following as
> "Before starting zero-page works, I checked "questions" in lkml and
> found some reports that some applications start to go OOM after zero-page
> removal.
> 
> For me, I know one of my customer's application depends on behavior of
> zero page (on RHEL5). So, I tried to add again it before RHEL6 because
> I think removal of zero-page corrupts compatibility."
> 
> So how about adding zero page as file_rss again for compatibility?
> 
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> ---
>  mm/memory.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 3743fb5..a4ba271 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1995,6 +1995,7 @@ static int do_wp_page(struct mm_struct *mm, struct vm_area_struct *vma,
>  	int reuse = 0, ret = 0;
>  	int page_mkwrite = 0;
>  	struct page *dirty_page = NULL;
> +	int zero_pfn = 0;
>  
>  	old_page = vm_normal_page(vma, address, orig_pte);
>  	if (!old_page) {
> @@ -2117,7 +2118,8 @@ gotten:
>  	if (unlikely(anon_vma_prepare(vma)))
>  		goto oom;
>  
> -	if (is_zero_pfn(pte_pfn(orig_pte))) {
> +	zero_pfn = is_zero_pfn(pte_pfn(orig_pte));
> +	if (zero_pfn) {
>  		new_page = alloc_zeroed_user_highpage_movable(vma, address);
>  		if (!new_page)
>  			goto oom;
> @@ -2147,7 +2149,7 @@ gotten:
>  	 */
>  	page_table = pte_offset_map_lock(mm, pmd, address, &ptl);
>  	if (likely(pte_same(*page_table, orig_pte))) {
> -		if (old_page) {
> +		if (old_page || zero_pfn) {
>  			if (!PageAnon(old_page)) {
>  				dec_mm_counter(mm, file_rss);
>  				inc_mm_counter(mm, anon_rss);
> @@ -2650,6 +2652,7 @@ static int do_anonymous_page(struct mm_struct *mm, struct vm_area_struct *vma,
>  		spin_lock(ptl);
>  		if (!pte_none(*page_table))
>  			goto unlock;
> +		inc_mm_counter(mm, file_rss);
>  		goto setpte;
>  	}
>  
