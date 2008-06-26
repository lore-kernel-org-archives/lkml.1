Return-Path: <linux-kernel-owner+w=401wt.eu-S1760778AbYFZUdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760778AbYFZUdl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 16:33:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755783AbYFZUdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 16:33:32 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:21639 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954AbYFZUdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 16:33:31 -0400
Subject: Re: [PATCH 1/6] Extend completions to provide XFS object flush
	requirements
From: Daniel Walker <dwalker@mvista.com>
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, matthew@wil.cx, linux-kernel@vger.kernel.org
In-Reply-To: <1214455277-6387-2-git-send-email-david@fromorbit.com>
References: <1214455277-6387-1-git-send-email-david@fromorbit.com>
	 <1214455277-6387-2-git-send-email-david@fromorbit.com>
Content-Type: text/plain
Date: Thu, 26 Jun 2008 13:33:25 -0700
Message-Id: <1214512405.21035.110.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-06-26 at 14:41 +1000, Dave Chinner wrote:
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

I think there is some basis to make the changes that you have here.
Specifically this email and thread,

http://lkml.org/lkml/2008/4/15/232

However, I don't like how your implementing this as specifically a
"flush" mechanism for XFS, and the count is limited to just 1 .. There
are several other places that do this kind of counting with semaphores,
and have counts above 1..

> +
> +static inline void completion_flush_start(struct completion *x)
> +{
> +	wait_for_completion(x);
> +}

Above seems completely pointless.. I would just call
wait_for_completion(), and make the rest of the interface generic.

Daniel

