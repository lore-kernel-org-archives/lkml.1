Return-Path: <linux-kernel-owner+w=401wt.eu-S1754862AbZD2IpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862AbZD2IpK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 04:45:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751396AbZD2Io5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 04:44:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:33070 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbZD2Io4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 04:44:56 -0400
Subject: Re: [PATCH] mm: prevent divide error for small values of
 vm_dirty_bytes
From: Peter Zijlstra <peterz@infradead.org>
To: Andrea Righi <righi.andrea@gmail.com>
Cc: David Rientjes <rientjes@google.com>, akpm@linux-foundation.org,
       Dave Chinner <david@fromorbit.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1240993759-30787-1-git-send-email-righi.andrea@gmail.com>
References: <1240993759-30787-1-git-send-email-righi.andrea@gmail.com>
Content-Type: text/plain
Date: Wed, 29 Apr 2009 10:44:36 +0200
Message-Id: <1240994676.8021.83.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-29 at 10:29 +0200, Andrea Righi wrote:
> Avoid to set less than two pages for vm_dirty_byte: this is necessary to avoid
> potential division by 0 (like the following) in get_dirty_limits().

isn't changing the .extra1 in the sysctl table a better fix?

> Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
> ---
>  mm/page-writeback.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 30351f0..9d6c427 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -213,6 +213,12 @@ int dirty_bytes_handler(struct ctl_table *table, int write,
>  	int ret;
>  
>  	ret = proc_doulongvec_minmax(table, write, filp, buffer, lenp, ppos);
> +	/*
> +	 * Do not allow to set less than two pages for vm_dirty_byte: this is
> +	 * necessary to avoid division by 0 in get_dirty_limits().
> +	 */
> +	vm_dirty_bytes = max_t(typeof(vm_dirty_bytes),
> +				vm_dirty_bytes, 2 * PAGE_SIZE);
>  	if (ret == 0 && write && vm_dirty_bytes != old_bytes) {
>  		update_completion_period();
>  		vm_dirty_ratio = 0;

