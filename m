Return-Path: <linux-kernel-owner+w=401wt.eu-S1755434AbYFZHqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434AbYFZHqu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 03:46:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbYFZHqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 03:46:39 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34471 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbYFZHqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 03:46:39 -0400
Date: Thu, 26 Jun 2008 03:46:36 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, matthew@wil.cx, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] Extend completions to provide XFS object flush
	requirements
Message-ID: <20080626074636.GB7064@infradead.org>
References: <1214455277-6387-1-git-send-email-david@fromorbit.com> <1214455277-6387-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214455277-6387-2-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 02:41:12PM +1000, Dave Chinner wrote:
> XFS object flushing doesn't quite match existing completion semantics.  It
> mixed exclusive access with completion. That is, we need to mark an object as
> being flushed before flushing it to disk, and then block any other attempt to
> flush it until the completion occurs.
> 
> To do this we introduce:
> 
> void init_completion_flush(struct completion *x)
> 	which initialises x->done = 1
> 
> void completion_flush_start(struct completion *x)
> 	which blocks if done == 0, otherwise decrements done to zero and
> 	allows the caller to continue.
> 
> bool completion_flush_start_nowait(struct completion *x)
> 	returns a failure status if done == 0, otherwise decrements done
> 	to zero and returns a "flush started" status. This is provided
> 	to allow flushing to begin safely while holding object locks in
> 	inverted order.
> 
> This replaces the use of semaphores for providing this exclusion
> and completion mechanism.

Given that the only API call shared with normal completions is
complete() I'd rather make this a primitive of it's own, even if
internally implemented as completions.

Also please add kerneldoc comments for all new APIs eported to modules.

