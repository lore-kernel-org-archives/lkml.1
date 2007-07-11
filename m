Return-Path: <linux-kernel-owner+w=401wt.eu-S1765003AbXGKSSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765003AbXGKSSW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 14:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758424AbXGKSSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 14:18:13 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:43857 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758473AbXGKSSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 14:18:12 -0400
Date: Wed, 11 Jul 2007 11:17:58 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       olaf.kirch@oracle.com, johnpol@2ka.mipt.ru
Subject: Re: [PATCH][RFC] network splice receive v3
Message-ID: <20070711181758.GX1011@tasint.org>
Mail-Followup-To: Jens Axboe <jens.axboe@oracle.com>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	olaf.kirch@oracle.com, johnpol@2ka.mipt.ru
References: <20070711091927.GQ4587@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070711091927.GQ4587@kernel.dk>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever come to perfection.
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2007 at 11:19:27AM +0200, Jens Axboe wrote:
> Subject: [PATCH] splice: don't assume regular pages in splice_to_pipe()
> 
> Allow caller to pass in a release function, there might be
> other resources that need releasing as well. Needed for
> network receive.
> 
> diff --git a/fs/splice.c b/fs/splice.c
> index 3160951..4b4b501 100644
> --- a/fs/splice.c
> +++ b/fs/splice.c
> @@ -254,11 +254,16 @@ ssize_t splice_to_pipe(struct pipe_inode_info *pipe,
>  	}
>  
>  	while (page_nr < spd_pages)
> -		page_cache_release(spd->pages[page_nr++]);
> +		spd->spd_release(spd, page_nr++);

	Rather than requiring the caller set this, shouldn't we just
allow it?  Especially given there is only one non-page user?

  	while (page_nr < spd_pages)
 -		page_cache_release(spd->pages[page_nr++]);
 +		if (spd->spd_release)
 +			spd->spd_release(spd, page_nr++);
 +		else
 +			page_cache_release(spd->pages[page_nr++]);

Joel

-- 

"Any man who is under 30, and is not a liberal, has not heart;
 and any man who is over 30, and is not a conservative, has no brains."
         - Sir Winston Churchill 

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
