Return-Path: <linux-kernel-owner+w=401wt.eu-S637781AbXDSOqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S637781AbXDSOqg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 10:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S637782AbXDSOqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 10:46:36 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40583 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S637781AbXDSOqf (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 10:46:35 -0400
Date: Fri, 20 Apr 2007 00:46:18 +1000
From: David Chinner <dgc@sgi.com>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -mm] workqueue: debug possible endless loop in cancel_rearming_delayed_work
Message-ID: <20070419144618.GG32602149@melbourne.sgi.com>
References: <20070419065404.GB1782@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070419065404.GB1782@ff.dom.local>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2007 at 08:54:04AM +0200, Jarek Poplawski wrote:
> Hi,
> 
> IMHO cancel_rearming_delayed_work is dangerous place:

Agreed - I spent a couple of hours today learning why it
can only be used on work functions that always rearm...

> - it assumes a work function always rearms (with no exception),
> which probably isn't explained enough now (but anyway should
> be checked in such loops);
>
> - probably possible (theoretical) scenario: a few work
> functions rearm themselves with very short, equal times;
> before flush_workqueue ends, their timers are already
> fired, so cancel_delayed_work has nothing to do.

Easier than that - have a work function that rearms only if there's
more work to do in the future. You only arm the timer when you
have work to do, and it only rearms if there's more work to
do in the future (e.g. rotating expiry lists).

i.e. while there's more work to do, you need to call
cancel_rearming_delayed_work() to stop it reliably, but if you race
with the work function not restarting itself, you hang.....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
