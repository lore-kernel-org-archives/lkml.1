Return-Path: <linux-kernel-owner+w=401wt.eu-S932861AbXCAIEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932861AbXCAIEu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 03:04:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932865AbXCAIEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 03:04:49 -0500
Received: from smtp.osdl.org ([65.172.181.24]:33328 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932861AbXCAIEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 03:04:48 -0500
Date: Thu, 1 Mar 2007 00:03:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, Oleg Nesterov <oleg@tv-sign.ru>,
       vatsa@in.ibm.com, Gautham R Shenoy <ego@in.ibm.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>, David Chinner <dgc@sgi.com>,
       Nigel Cunningham <ncunningham@linuxmail.org>
Subject: Re: [PATCH] Make XFS workqueues nonfreezable
Message-Id: <20070301000351.ad3f641c.akpm@linux-foundation.org>
In-Reply-To: <200703010054.33536.rjw@sisk.pl>
References: <200702272251.28844.rjw@sisk.pl>
	<200702282339.31234.rjw@sisk.pl>
	<20070228224443.GC19542@elf.ucw.cz>
	<200703010054.33536.rjw@sisk.pl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Mar 2007 00:54:32 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> Since freezable workqueues are broken in 2.6.21-rc
> (cf. http://marc.theaimsgroup.com/?l=linux-kernel&m=116855740612755,
> http://marc.theaimsgroup.com/?l=linux-kernel&m=117261312523921&w=2)
> it's better to change the only user of them, which is XFS, to use "normal"
> nonfreezable workqueues.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  fs/xfs/linux-2.6/xfs_buf.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6.21-rc2/fs/xfs/linux-2.6/xfs_buf.c
> ===================================================================
> --- linux-2.6.21-rc2.orig/fs/xfs/linux-2.6/xfs_buf.c
> +++ linux-2.6.21-rc2/fs/xfs/linux-2.6/xfs_buf.c
> @@ -1829,11 +1829,11 @@ xfs_buf_init(void)
>  	if (!xfs_buf_zone)
>  		goto out_free_trace_buf;
>  
> -	xfslogd_workqueue = create_freezeable_workqueue("xfslogd");
> +	xfslogd_workqueue = create_workqueue("xfslogd");
>  	if (!xfslogd_workqueue)
>  		goto out_free_buf_zone;
>  
> -	xfsdatad_workqueue = create_freezeable_workqueue("xfsdatad");
> +	xfsdatad_workqueue = create_workqueue("xfsdatad");
>  	if (!xfsdatad_workqueue)
>  		goto out_destroy_xfslogd_workqueue;
>  

Won't this break suspend+XFS?

If so, and given that nobody seems to be reporting this deadlock, perhaps
we'd be better off leaving things as-is for the while?
