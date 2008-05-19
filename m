Return-Path: <linux-kernel-owner+w=401wt.eu-S1762362AbYESRzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762362AbYESRzP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 13:55:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757574AbYESRzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 13:55:00 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:57772 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457AbYESRzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 13:55:00 -0400
Subject: Re: ext4-mm-delalloc-ext4-lock-reverse-fix
From: Mingming Cao <cmm@us.ibm.com>
Reply-To: cmm@us.ibm.com
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, adobriyan@gmail.com,
       Dave Young <hidave.darkstar@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1211210687-4212-1-git-send-email-jirislaby@gmail.com>
References: <20080519002919.1f8f21f6.akpm@linux-foundation.org>
	 <1211210687-4212-1-git-send-email-jirislaby@gmail.com>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Mon, 19 May 2008 10:54:50 -0700
Message-Id: <1211219691.3663.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-05-19 at 17:24 +0200, Jiri Slaby wrote:
> Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Mon, 19 May 2008 15:15:09 +0800 "Dave Young" <hidave.darkstar@gmail.com> wrote:
> > 
> > > Hi,
> > > 
> > > With 2.6.26-rc2-mm1 I need to sync frequently. It's not normal as my
> > > understanding.
> > > 
> > > 1. scp a big file from a lan server. Firstly the speed is about 8M/s,
> > > but the speed will slow down to 100K/s at last. After I exec "sync",
> > > the speed will restore.
> > > 
> > > Is this a known issue?
> > > 
> > 
> > Yes, probably related to the "mkfs takes forever" problem.  I haven't
> > looked into it yet.  Nor has anyone else afaik.
> 
> Absolutely not sure what this breaks in ext4, but fixes the problem for me:
> ---
>  mm/page-writeback.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 040bc7c..789b6ad 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -881,7 +881,7 @@ int write_cache_pages(struct address_space *mapping,
>  	pagevec_init(&pvec, 0);
>  	if (wbc->range_cyclic) {
>  		index = mapping->writeback_index; /* Start from prev offset */
> -		end = wbc->range_end >> PAGE_CACHE_SHIFT;
> +		end = -1;
>  	} else {
>  		index = wbc->range_start >> PAGE_CACHE_SHIFT;
>  		end = wbc->range_end >> PAGE_CACHE_SHIFT;

Thanks, the patch does fixed the regression .

In the delalloc-ext4-lock-reverse.patch. It wants the
write_cache_pages() to do incremental writeout within the reserved
journal credits in case of delalyed allocation(turns on cyclic mode and
remembers starts from writeback_index). If the writeout caller sets the
range_end, it should not flushing to the end of the file in the case of
range_cyclic mode. The patch above fix the regression but makes possible
that we write too much. 


I'd say drop the delalloc-ext4-lock-reverse.patch for now, will re-think
of the delayed allocation support for page-journal-lock reserve method.

Mingming







