Return-Path: <linux-kernel-owner+w=401wt.eu-S932937AbYCGVX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932937AbYCGVX6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 16:23:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760486AbYCGVXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 16:23:48 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:45585 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758822AbYCGVXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 16:23:47 -0500
Date: Fri, 07 Mar 2008 14:23:36 -0700
From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 2/3] jbd2: replace potentially false assertion with if	block
In-reply-to: <48afbb3a44aa24dc1e31835c14e86c3c6c1c3b0a.1204844851.git.duaneg@dghda.com>
To: Duane Griffin <duaneg@dghda.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       Theodore Tso <tytso@mit.edu>, sct@redhat.com, akpm@linux-foundation.org
Message-id: <20080307212336.GE1881@webber.adilger.int>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <5e28cd633c71f6354a203a43000cbe5fef045589.1204844851.git.duaneg@dghda.com>
 <48afbb3a44aa24dc1e31835c14e86c3c6c1c3b0a.1204844851.git.duaneg@dghda.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 07, 2008  01:31 +0000, Duane Griffin wrote:
> If an error occurs during jbd2 cache initialisation it is possible for the
> journal_head_cache to be NULL when jbd2_journal_destroy_journal_head_cache is
> called. Replace the J_ASSERT with an if block to handle the situation
> correctly.
> 
> Note that even with this fix things will break badly if jbd2 is statically
> compiled in and cache initialisation fails.

It would probably be prudent to verify that these caches are initialized
at journal_load() time and either re-try to create the cache, and/or report
an error in that case and refuse to continue mounting.

Also, I note that journal_init_journal_head_cache() is comparing pointers
to "0", a style no-no...

> Signed-off-by: Duane Griffin <duaneg@dghda.com>

Acked-by: Andreas Dilger <adilger@sun.com>
> ---
>  fs/jbd2/journal.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 96ba846..0d8a595 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -1985,9 +1985,10 @@ static int journal_init_jbd2_journal_head_cache(void)
>  
>  static void jbd2_journal_destroy_jbd2_journal_head_cache(void)
>  {
> -	J_ASSERT(jbd2_journal_head_cache != NULL);
> -	kmem_cache_destroy(jbd2_journal_head_cache);
> -	jbd2_journal_head_cache = NULL;
> +	if (jbd2_journal_head_cache) {
> +		kmem_cache_destroy(jbd2_journal_head_cache);
> +		jbd2_journal_head_cache = NULL;
> +	}
>  }
>  
>  /*
> -- 
> 1.5.3.7
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

