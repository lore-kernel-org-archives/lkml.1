Return-Path: <linux-kernel-owner+w=401wt.eu-S1756706AbZFHXIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706AbZFHXIK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 19:08:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755530AbZFHXH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 19:07:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35429 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754692AbZFHXH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 19:07:57 -0400
Date: Mon, 8 Jun 2009 16:07:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: steiner@sgi.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Patch 04/12] GRU - collect per-context user statistics
Message-Id: <20090608160740.4d57ba5d.akpm@linux-foundation.org>
In-Reply-To: <20090608171953.673876000@sgi.com>
References: <20090608171648.988318000@sgi.com>
	<20090608171953.673876000@sgi.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 08 Jun 2009 12:16:52 -0500
steiner@sgi.com wrote:

>  /*
> + * Fetch GSEG statisticss
> + */
> +long gru_get_gseg_statistics(unsigned long arg)
> +{
> +	struct gru_thread_state *gts;
> +	struct gru_get_gseg_statistics_req req;
> +
> +	if (copy_from_user(&req, (void __user *)arg, sizeof(req)))
> +		return -EFAULT;
> +
> +	gts = gru_find_lock_gts(req.gseg);
> +	if (gts) {
> +		memcpy(&req.stats, &gts->ustats, sizeof(gts->ustats));
> +		gru_unlock_gts(gts);
> +	} else {
> +		memset(&req.stats, 0, sizeof(gts->ustats));
> +	}
> +
> +	if (copy_to_user((void __user *)arg, &req, sizeof(req)))
> +		return -EFAULT;
> +
> +	return 0;
> +}

So..  what's happening in the super-secret undocumented gts==NULL path?

It _looks_ like userspace passed into this ioctl a handle for something
which the kernel doesn't know about.  If so, shouldn't we return
-EINVAL or something?  

