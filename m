Return-Path: <linux-kernel-owner+w=401wt.eu-S1755990AbXFZDxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990AbXFZDxv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 23:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753111AbXFZDxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 23:53:43 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50660 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752515AbXFZDxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 23:53:43 -0400
Date: Mon, 25 Jun 2007 20:52:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: NeilBrown <neilb@suse.de>
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH 007 of 8] knfsd: nfsd4: vary maximum delegation limit
 based on RAM size
Message-Id: <20070625205244.bbf0976a.akpm@linux-foundation.org>
In-Reply-To: <1070621043112.1144@suse.de>
References: <20070621142604.727.patches@notabene>
	<1070621043112.1144@suse.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jun 2007 14:31:12 +1000 NeilBrown <neilb@suse.de> wrote:

> 
> From: "J. Bruce Fields" <bfields@fieldses.org>
> 
> 
> Our original NFSv4 delegation policy was to give out a read delegation
> on any open when it was possible to.
> 
> Since the lifetime of a delegation isn't limited to that of an open, a
> client may quite reasonably hang on to a delegation as long as it has
> the inode cached.  This becomes an obvious problem the first time a
> client's inode cache approaches the size of the server's total memory.
> 
> Our first quick solution was to add a hard-coded limit.  This patch
> makes a mild incremental improvement by varying that limit according to
> the server's total memory size, allowing at most 4 delegations per
> megabyte of RAM.
> 
> My quick back-of-the-envelope calculation finds that in the worst case
> (where every delegation is for a different inode), a delegation could
> take about 1.5K, which would make the worst case usage about 6% of
> memory.  The new limit works out to be about the same as the old on a
> 1-gig server.
> 
> ...
>  
> +static void
> +set_max_delegations()
> +{
> +	struct sysinfo sys;
> +
> +	si_meminfo(&sys);
> +	sys.totalram *= sys.mem_unit;
> +	sys.totalram >>= (18 - PAGE_SHIFT);
> +	max_delegations = (unsigned int) sys.totalram;
> +}

Please put yourself in the position of the reader who happens across this
code and wonders why it is that way.

They could of course go hunt it out of the git repo but I do think it's
quite a bit more reader-friendly to explain the thinking in code comments.

