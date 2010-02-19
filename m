Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230Ab0BSI6h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 03:58:37 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:51487 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614Ab0BSI6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 03:58:36 -0500
Date: Fri, 19 Feb 2010 14:28:31 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Michael Stefaniuc <mstefani@redhat.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Maneesh Soni <maneesh@linux.vnet.ibm.com>,
       Alexandre Julliard <julliard@winehq.org>,
       "Rafael J . Wysocki" <rjw@sisk.pl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH 2/2] hw-breakpoint: Keep track of dr7 local enable bits
Message-ID: <20100219085831.GA10837@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <4B7881AC.5070209@redhat.com> <1266516001-7753-3-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266516001-7753-3-git-send-regression-fweisbec@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 18, 2010 at 07:00:01PM +0100, Frederic Weisbecker wrote:

> diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
> index 017d937..0c1033d 100644
> --- a/arch/x86/kernel/ptrace.c
> +++ b/arch/x86/kernel/ptrace.c
> @@ -702,7 +702,7 @@ static unsigned long ptrace_get_debugreg(struct task_struct *tsk, int n)
>  	} else if (n == 6) {
>  		val = thread->debugreg6;
>  	 } else if (n == 7) {
> -		val = ptrace_get_dr7(thread->ptrace_bps);
> +		val = thread->ptrace_dr7;

Some more comments that I missed out in the previous mail...

Shouldn't ptrace_get_dr7() function be entirely removed now, given that
its only caller no longer invokes it?

>  	}
>  	return val;
>  }
> @@ -778,8 +778,11 @@ int ptrace_set_debugreg(struct task_struct *tsk, int n, unsigned long val)
>  			return rc;
>  	}
>  	/* All that's left is DR7 */
> -	if (n == 7)
> +	if (n == 7) {
>  		rc = ptrace_write_dr7(tsk, val);

And ptrace_write_dr7() should be made to populate thread->ptrace_dr7 if
it is going to return a success.

> +		if (!rc)
> +			thread->ptrace_dr7 = val;
> +	}
> 
>  ret_path:
>  	return rc;
> -- 
> 1.6.2.3
> 

Thanks,
K.Prasad

