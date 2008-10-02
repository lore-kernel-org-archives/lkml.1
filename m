Return-Path: <linux-kernel-owner+w=401wt.eu-S1754053AbYJBGMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053AbYJBGMr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 02:12:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752757AbYJBGMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 02:12:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58133 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752603AbYJBGMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 02:12:10 -0400
Date: Wed, 1 Oct 2008 23:11:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Fasheh <mfasheh@suse.com>
Cc: linux-kernel@vger.kernel.org, joel.becker@oracle.com,
       ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org,
       mfasheh@suse.com
Subject: Re: [PATCH 03/39] ocfs2: throttle back local alloc when low on disk
 space
Message-Id: <20081001231150.c1cd67b0.akpm@linux-foundation.org>
In-Reply-To: <1222293680-15451-4-git-send-email-mfasheh@suse.com>
References: <1222293680-15451-1-git-send-email-mfasheh@suse.com>
	<1222293680-15451-4-git-send-email-mfasheh@suse.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 24 Sep 2008 15:00:44 -0700 Mark Fasheh <mfasheh@suse.com> wrote:
> +void ocfs2_local_alloc_seen_free_bits(struct ocfs2_super *osb,
> +				      unsigned int num_clusters)
> +{
> +	spin_lock(&osb->osb_lock);
> +	if (osb->local_alloc_state == OCFS2_LA_DISABLED ||
> +	    osb->local_alloc_state == OCFS2_LA_THROTTLED)
> +		if (num_clusters >= osb->local_alloc_default_bits) {
> +			cancel_delayed_work(&osb->la_enable_wq);
> +			osb->local_alloc_state = OCFS2_LA_ENABLED;
> +		}
> +	spin_unlock(&osb->osb_lock);
> +}
> +
> +void ocfs2_la_enable_worker(struct work_struct *work)
> +{
> +	struct ocfs2_super *osb =
> +		container_of(work, struct ocfs2_super,
> +			     la_enable_wq.work);
> +	spin_lock(&osb->osb_lock);
> +	osb->local_alloc_state = OCFS2_LA_ENABLED;
> +	spin_unlock(&osb->osb_lock);
> +}

cacnel_delayed_work() is a pretty risky function.  The work handler
(ocfs2_la_enable_worker) can execute an arbitrarily long time after
cancel_delayed_work() has returned.  Can all the code here cope with such a
surprise alteration of ->local_alloc_state()?

And you canot use cancel_delayed_work_sync() here due to a deadlock on
->osb_lock().

