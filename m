Return-Path: <linux-kernel-owner+w=401wt.eu-S1757183AbXE3R4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757183AbXE3R4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 13:56:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753387AbXE3R4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 13:56:32 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:43403 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752891AbXE3R4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 13:56:31 -0400
Date: Wed, 30 May 2007 10:56:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] Make page-writeback timers 1 sec jiffy aligned
Message-Id: <20070530105629.d9320955.akpm@linux-foundation.org>
In-Reply-To: <20070529175951.GB5411@linux-os.sc.intel.com>
References: <20070529175951.GB5411@linux-os.sc.intel.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 May 2007 10:59:51 -0700
Venki Pallipadi <venkatesh.pallipadi@intel.com> wrote:

> 
> 
> timer round_jiffies in page-writeback.
> 
> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> 
> Index: linux-2.6.22-rc-mm/mm/page-writeback.c
> ===================================================================
> --- linux-2.6.22-rc-mm.orig/mm/page-writeback.c	2007-05-25 10:49:11.000000000 -0700
> +++ linux-2.6.22-rc-mm/mm/page-writeback.c	2007-05-25 10:49:29.000000000 -0700
> @@ -469,7 +469,7 @@
>  	if (time_before(next_jif, jiffies + HZ))
>  		next_jif = jiffies + HZ;
>  	if (dirty_writeback_interval)
> -		mod_timer(&wb_timer, next_jif);
> +		mod_timer(&wb_timer, round_jiffies(next_jif));
>  }
>  
>  /*
> @@ -481,7 +481,7 @@
>  	proc_dointvec_userhz_jiffies(table, write, file, buffer, length, ppos);
>  	if (dirty_writeback_interval) {
>  		mod_timer(&wb_timer,
> -			jiffies + dirty_writeback_interval);
> +			round_jiffies(jiffies + dirty_writeback_interval));
>  		} else {
>  		del_timer(&wb_timer);
>  	}

mutter.

These tunables are in units of centiseconds, so the user can indeed set the
writeback interval to, say, 0.2 seconds.  People have played with that sort
of thing.

I doubt if this patch will hurt anyone much, but it is an incompatible
user-visible change.

Probably a suitable heuristic for fixing this would be to only do the
rounding if dirty_writeback_interval is a multiple of HZ.  In the vast
majority of cases, that will be true.

