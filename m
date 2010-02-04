Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445Ab0BDRmA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:42:00 -0500
Received: from mga02.intel.com ([134.134.136.20]:37501 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159Ab0BDRl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:41:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,405,1262592000"; 
   d="scan'208";a="489694946"
Subject: Re: PATCH? process_32.c:__switch_to() calls __math_state_restore()
 before updating current_task
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20100204165105.GA5905@redhat.com>
References: <20100204165105.GA5905@redhat.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Thu, 04 Feb 2010 09:40:53 -0800
Message-Id: <1265305253.2768.7.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-02-04 at 08:51 -0800, Oleg Nesterov wrote:
> I didn't try to verify __switch_to()->__math_state_restore() is really
> wrong, this is more the question than the patch. But at least the code
> looks wrong, it calls __math_state_restore() which uses curent before
> current_task was updated.
> 
> Uncompiled/untested.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> 
> --- a/arch/x86/kernel/process_32.c
> +++ b/arch/x86/kernel/process_32.c
> @@ -377,9 +377,6 @@ __switch_to(struct task_struct *prev_p, 
>  	 */
>  	arch_end_context_switch(next_p);
>  
> -	if (preload_fpu)
> -		__math_state_restore();
> -
>  	/*
>  	 * Restore %gs if needed (which is common)
>  	 */
> @@ -388,6 +385,9 @@ __switch_to(struct task_struct *prev_p, 
>  
>  	percpu_write(current_task, next_p);
>  
> +	if (preload_fpu)
> +		__math_state_restore();
> +
>  	return prev_p;
>  }

Oleg, __math_state_restore() uses current_thread_info() which at that
point already has the right esp and as such uses the correct thread
struct etc.

After saying that, in the past I have also ran into this question and
got satisfied by looking deeper. Best is to make the 32bit and 64bit
code similar as much as possible and as such your patch is acceptable.

Can you please re-post with a proper changelog (and ofcourse testing
etc)? You can add my Ack to that.

thanks,
suresh

