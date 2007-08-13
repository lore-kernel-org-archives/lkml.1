Return-Path: <linux-kernel-owner+w=401wt.eu-S938164AbXHMBDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938164AbXHMBDv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 21:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762461AbXHMBDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 21:03:41 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:39302 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759919AbXHMBDk (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 21:03:40 -0400
Date: Mon, 13 Aug 2007 11:03:21 +1000
From: David Chinner <dgc@sgi.com>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Andrew Morton <akpm@osdl.org>, "Cc: Ken Chen" <kenchen@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/6] writeback: remove pages_skipped accounting in __block_write_full_page()
Message-ID: <20070813010321.GT12413810@sgi.com>
References: <20070812091120.189651872@mail.ustc.edu.cn> <20070812092052.848213359@mail.ustc.edu.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070812092052.848213359@mail.ustc.edu.cn>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 12, 2007 at 05:11:23PM +0800, Fengguang Wu wrote:
> Miklos Szeredi <miklos@szeredi.hu> and me identified a writeback bug:
> Basicly they are
> - during the dd: ~16M 
> - after 30s:      ~4M
> - after 5s:       ~4M
> - after 5s:     ~176M
> 
> The box has 2G memory.
> 
> Question 1:
> How come the 5s delays? I run 4 tests in total, 2 of which have such 5s delays.

pdflush runs every five seconds, so that is indicative of the inode being
written once for 1024 pages, and then delayed to the next pdflush run 5s later.
perhaps the inodes aren't moving between the lists exactly the way you
think they are...

> --- linux-2.6.23-rc2-mm2.orig/fs/buffer.c
> +++ linux-2.6.23-rc2-mm2/fs/buffer.c
> @@ -1713,7 +1713,6 @@ done:
>  		 * The page and buffer_heads can be released at any time from
>  		 * here on.
>  		 */
> -		wbc->pages_skipped++;	/* We didn't write this page */
>  	}
>  	return err;

Hmmmm - I suspect XFS is going to need a similar fix as well. I'm moving
house so I'm not going to get a chance to look at this for a week...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
