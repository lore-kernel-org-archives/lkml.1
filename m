Return-Path: <linux-kernel-owner+w=401wt.eu-S933189AbZJNOFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933189AbZJNOFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 10:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756415AbZJNOFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 10:05:31 -0400
Received: from viefep15-int.chello.at ([62.179.121.35]:60754 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756318AbZJNOFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 10:05:30 -0400
X-SourceIP: 213.93.53.227
Subject: Re: bdi_threshold slow to reach steady state
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Wu Fengguang <fengguang.wu@intel.com>, lkml <linux-kernel@vger.kernel.org>,
       Martin Bligh <mbligh@google.com>
In-Reply-To: <1255528520.2360.94.camel@castor>
References: <1255518586.2360.78.camel@castor>
	 <1255520272.8392.429.camel@twins>  <1255528520.2360.94.camel@castor>
Content-Type: text/plain
Date: Wed, 14 Oct 2009 16:04:32 +0200
Message-Id: <1255529072.8392.436.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-14 at 14:55 +0100, Richard Kennedy wrote:
> 
> commit 11735a2336ba08cf21aebf79a706c86aca5e44b2
> Author: Richard Kennedy <richard@rsk.demon.co.uk>
> Date:   Wed Oct 14 14:46:21 2009 +0100
> 
>     mm: speed up per bdi dirty threshold calculations

I think the subject is confusing, we don't actually compute things
faster in the less cycles sense.

We reduce the dampening for the control system, yielding faster
convergence.

>     Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
> 
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index a3b1409..018024e 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -144,7 +144,7 @@ static int calc_period_shift(void)
>         else
>                 dirty_total = (vm_dirty_ratio *
> determine_dirtyable_memory()) /
>                                 100;
> -       return 2 + ilog2(dirty_total - 1);
> +       return ilog2(dirty_total - 1) - 2;
>  }

