Return-Path: <linux-kernel-owner+w=401wt.eu-S1752906AbYJ1AUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbYJ1AUo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 20:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751731AbYJ1AUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 20:20:34 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:55162 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751246AbYJ1AUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 20:20:33 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Am4DAM8S9kh5LE2tgWdsb2JhbACTYAEBFiKuDIFr
X-IronPort-AV: E=Sophos;i="4.33,495,1220193000"; 
   d="scan'208";a="219414410"
Date: Tue, 28 Oct 2008 11:20:24 +1100
From: Dave Chinner <david@fromorbit.com>
To: ngupta@google.com
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH] Priorities in Anticipatory I/O scheduler
Message-ID: <20081028002024.GM4985@disturbed>
Mail-Followup-To: ngupta@google.com, linux-kernel@vger.kernel.org,
	jens.axboe@oracle.com, akpm@linux-foundation.org
References: <20081027190131.070061000@elf.corp.google.com> <20081027190139.838646000@elf.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081027190139.838646000@elf.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2008 at 12:01:32PM -0700, ngupta@google.com wrote:
> 
> Modifications to the Anticipatory I/O scheduler to add multiple priority
> levels. It makes use of anticipation and batching in current
> anticipatory scheduler to implement priorities.
> 
> - Minimizes the latency of highest priority level.
> - Low priority requests wait for high priority requests.
> - Higher priority request break any anticipating low priority request.
> - If single priority level is used the scheduler behaves as an
>   anticipatory scheduler. So no change for existing users.
> 
> With this change, it is possible for a latency sensitive job to coexist
> with background job.
> 
> Other possible use of this patch is in context of I/O subsystem controller.
> It can add another dimension to the parameters controlling a particular cgroup.
> While we can easily divide b/w among existing croups, setting a bound on
> latency is not a feasible solution. Hence in context of storage devices
> bandwidth and priority can be two parameters controlling I/O. Though
> it can be a standalone patch to separate latency sensitive jobs and need
> not be tied to I/O controller.
> 
> In this patch I have added a new class IOPRIO_CLASS_LATENCY to differentiate
> notion of absolute priority over existing uses of various time-slice based
> priority classes in cfq. Though internally within anticipatory scheduler all
> of them map to best-effort levels. Hence, one can also use various best-effort
> priority levels.

Please don't introduce yet another incompatible behaviour between
I/O schedulers. It's bad enough from an optimisation point of view
that BIO_RW_SYNC and BIO_RW_META mean different things to different
schedulers, let alone that only CFQ currently understands
priorities. If you are going to introduce priorities into AS, then
please, please, please make it use the same interface as CFQ.

Why? Both the extN and XFS devs have been considering bumping the
priority of journal writes using the existing CFQ-based I/O priority
mechanism - the last thing I want to see is a different scheduler
requiring a different priority configuration to acheive the same
optimisation. There is no way we can support this sort of
optimisation in the filesystem code if the interface changes when
the I/O scheduler changes. So please use the existing IOPRIO classes
to map the priorities for the AS scheduler.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
