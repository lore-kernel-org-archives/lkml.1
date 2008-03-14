Return-Path: <linux-kernel-owner+w=401wt.eu-S1753963AbYCNLIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963AbYCNLIX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 07:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752039AbYCNLIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 07:08:15 -0400
Received: from wr-out-0506.google.com ([64.233.184.238]:11481 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153AbYCNLIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 07:08:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kXYITe6c1lRTsZIqZAOJhcGVkORpvUf73L/jyscHDGV0Bk2xcJbVa30u2+gXcql8O6Tmq+jLfF+Qygt7kkYF1GOS5x29JNR/cVgqBsDCVV20oWp/japL8uk6nsnFeV0ER6k1YKL1qkvlczptJXQcZ9dFUrGwlegPEXye9T6uB6Q=
Message-ID: <a8e1da0803140408je1f180cra6f6027b39fa07dd@mail.gmail.com>
Date: Fri, 14 Mar 2008 19:08:14 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH][BUG 10227] readahead ret value fix
Cc: wfg@mail.ustc.edu.cn, akpm@linux-foundation.org, jack@suse.cz,
       chris@linuxinfotag.de
In-Reply-To: <20080314104906.GA2898@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080314104906.GA2898@darkstar.te-china.tietoenator.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2008 at 6:49 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
> If the page_offset > end_index, the return value should be updated to 0,
>  avoiding the redundant read_pages
>
>  Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
>
>  ---
>  mm/readahead.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
>  diff -upr linux/mm/readahead.c linux.new/mm/readahead.c
>  --- linux/mm/readahead.c        2008-03-14 18:38:12.000000000 +0800
>  +++ linux.new/mm/readahead.c    2008-03-14 18:38:58.000000000 +0800
>  @@ -144,8 +144,10 @@ __do_page_cache_readahead(struct address
>         for (page_idx = 0; page_idx < nr_to_read; page_idx++) {
>                 pgoff_t page_offset = offset + page_idx;
>
>  -               if (page_offset > end_index)
>  +               if (page_offset > end_index) {
>  +                       ret = 0;
>                         break;
>  +               }
>
>                 rcu_read_lock();
>                 page = radix_tree_lookup(&mapping->page_tree, page_offset);
>

It's not right at all,  sorry for the wrong quick patch.

Anyway, please see the following debug info of me
Mar 14 18:33:51 darkstar kernel: [   19.073085] 3c59x: Donald Becker and others.
Mar 14 18:34:39 darkstar kernel: [  117.837850] #0 page_offset : 0,
end_index : 2 ret: 0
Mar 14 18:34:39 darkstar kernel: [  117.837854] #1 page_offset : 0,
end_index : 2
Mar 14 18:34:39 darkstar kernel: [  117.837861] #0 page_offset : 1,
end_index : 2 ret: 1
Mar 14 18:34:39 darkstar kernel: [  117.837873] #1 page_offset : 1,
end_index : 2
Mar 14 18:34:39 darkstar kernel: [  117.837888] #0 page_offset : 2,
end_index : 2 ret: 2
Mar 14 18:34:39 darkstar kernel: [  117.837911] #1 page_offset : 2,
end_index : 2
Mar 14 18:34:39 darkstar kernel: [  117.837922] #0 page_offset : 3,
end_index : 2 ret: 3
Mar 14 18:34:40 darkstar kernel: [  118.051620] #0 page_offset : 3,
end_index : 2 ret: 0
Mar 14 18:34:40 darkstar kernel: [  118.051626] zisofs : req invalid
