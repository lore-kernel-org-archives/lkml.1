Return-Path: <linux-kernel-owner+w=401wt.eu-S1756580AbXJBVsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580AbXJBVsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 17:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753494AbXJBVsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 17:48:06 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:50199 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752656AbXJBVsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 17:48:05 -0400
Date: Wed, 3 Oct 2007 07:47:45 +1000
From: David Chinner <dgc@sgi.com>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       David Chinner <dgc@sgi.com>, Ken Chen <kenchen@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Rubin <mrubin@google.com>
Subject: Re: [PATCH 5/5] writeback: introduce writeback_control.more_io to indicate more io
Message-ID: <20071002214736.GJ995458@sgi.com>
References: <20071002084143.110486039@mail.ustc.edu.cn> <20071002090254.987182999@mail.ustc.edu.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071002090254.987182999@mail.ustc.edu.cn>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2007 at 04:41:48PM +0800, Fengguang Wu wrote:
>  		wbc.pages_skipped = 0;
> @@ -560,8 +561,9 @@ static void background_writeout(unsigned
>  		min_pages -= MAX_WRITEBACK_PAGES - wbc.nr_to_write;
>  		if (wbc.nr_to_write > 0 || wbc.pages_skipped > 0) {
>  			/* Wrote less than expected */
> -			congestion_wait(WRITE, HZ/10);
> -			if (!wbc.encountered_congestion)
> +			if (wbc.encountered_congestion || wbc.more_io)
> +				congestion_wait(WRITE, HZ/10);
> +			else
>  				break;
>  		}

Why do you call congestion_wait() if there is more I/O to issue?  If
we have a fast filesystem, this might cause the device queues to
fill, then drain on congestion_wait(), then fill again, etc. i.e. we
will have trouble keeping the queues full, right?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
