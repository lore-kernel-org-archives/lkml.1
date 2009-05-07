Return-Path: <linux-kernel-owner+w=401wt.eu-S1760958AbZEGBAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760958AbZEGBAA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 21:00:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754057AbZEGA7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 20:59:52 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:56102 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753795AbZEGA7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 20:59:51 -0400
Date: Wed, 6 May 2009 17:36:03 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] [RFC][PATCH 1/5] PM/Freezer: Disable OOM killer
	whentasks are frozen
Message-ID: <20090507003603.GD17680@us.ibm.com>
References: <200905070040.08561.rjw@sisk.pl> <200905070041.04787.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905070041.04787.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 07, 2009 at 12:41:04AM +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> The OOM killer is not really going to work while tasks are frozen, so
> we can just give up calling it in that case.
> 
> This will allow us to safely use memory allocations for decreasing
> the number of saveable pages in the hibernation core code instead of
> using any artificial memory shriking mechanisms for this purpose.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>


> ---
>  include/linux/freezer.h |    2 ++
>  kernel/power/process.c  |   12 ++++++++++++
>  mm/page_alloc.c         |    5 +++++
>  3 files changed, 19 insertions(+)
> 
> Index: linux-2.6/kernel/power/process.c
> ===================================================================
> --- linux-2.6.orig/kernel/power/process.c
> +++ linux-2.6/kernel/power/process.c
> @@ -19,6 +19,8 @@
>   */
>  #define TIMEOUT	(20 * HZ)
> 
> +static bool tasks_frozen;
> +
>  static inline int freezeable(struct task_struct * p)
>  {
>  	if ((p == current) ||
> @@ -120,6 +122,10 @@ int freeze_processes(void)
>   Exit:
>  	BUG_ON(in_atomic());
>  	printk("\n");
> +
> +	if (!error)
> +		tasks_frozen = true;
> +

It's not really about whether some tasks are frozen -- that can 
happen using the cgroup freezer too. The flag really indicates if
all killable tasks are frozen. That can't happen using the cgroup
freezer since the root cgroup can't be frozen. So I think some name changes 
are in order but otherwise the patch looks fine.

Cheers,
	-Matt Helsley
