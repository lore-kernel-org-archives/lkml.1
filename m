Return-Path: <linux-kernel-owner+w=401wt.eu-S1753006AbZGTR2E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006AbZGTR2E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 13:28:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752624AbZGTR2D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 13:28:03 -0400
Received: from bc.sympatico.ca ([209.226.175.184]:45321 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752612AbZGTR2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 13:28:01 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoIFAANGZEpMQWU3/2dsb2JhbACBUYEwzhmEDAU
Date: Mon, 20 Jul 2009 13:27:48 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linuxtronix.de>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Anton Blanchard <anton@samba.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "K . Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH 1/5] hw-breakpoints: Make kernel breakpoints API
	truly generic
Message-ID: <20090720172748.GA27660@Krystal>
References: <1248109687-7808-1-git-send-email-fweisbec@gmail.com> <1248109687-7808-2-git-send-email-fweisbec@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1248109687-7808-2-git-send-email-fweisbec@gmail.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:18:24 up 142 days, 13:44,  3 users,  load average: 0.16, 0.31,
	0.36
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Frederic Weisbecker (fweisbec@gmail.com) wrote:
[...]
> diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
> index c1f64e6..015fec6 100644
> --- a/kernel/hw_breakpoint.c
> +++ b/kernel/hw_breakpoint.c
> @@ -297,15 +297,21 @@ EXPORT_SYMBOL_GPL(unregister_user_hw_breakpoint);
>  /**
>   * register_kernel_hw_breakpoint - register a hardware breakpoint for kernel space
>   * @bp: the breakpoint structure to register
> - *
> - * @bp.info->name or @bp.info->address, @bp.info->len, @bp.info->type and
> + * @addr: the address where we want to set the breakpoint
> + * @len: length of the value in memory to break in
> + * @type: the type of the breakpoint (read/write/execute)
>   * @bp->triggered must be set properly before invocation

Hi Frederic,

I think one of the great addition in this patchset is to allow using
breakpoints from arch-agnostic code.

It becomes important to document the error values which can be returned
by register_kernel_hw_breakpoint, so this will serve as guidelines for
architecture-specific arch_fill_hw_breakpoint() implementation. This
will become increasingly important, as this abstraction layer will
basically be responsible for either:

- Finding the best support the architecture can provide for a given hw
  breakpoint.
- Failing with an explicit error value telling the in-kernel user why it
  failed (e.g. if it must use a fallback, or return the error to the
  user).

Maybe we should think of a more flexible breakpoint type mapping too,
e.g.:

 monitor _strictly_ execute operation on address 0x...
   -> would fail if the architecture does not support execution access
      monitoring
 monitor (at least) execute operations on address 0x...
   -> would be allowed to use a more general monitor (e.g. RWX) if the
      architecture does not support "execute only" monitor.

(same for read and write)

Mathieu

>   *
>   */
> -int register_kernel_hw_breakpoint(struct hw_breakpoint *bp)
> +int register_kernel_hw_breakpoint(struct hw_breakpoint *bp, unsigned long addr,
> +				  int len, enum breakpoint_type type)
>  {
>  	int rc;
>  
> +	rc = arch_fill_hw_breakpoint(bp, addr, len, type);
> +	if (rc)
> +		return rc;
> +
>  	rc = arch_validate_hwbkpt_settings(bp, NULL);
>  	if (rc)
>  		return rc;
-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
