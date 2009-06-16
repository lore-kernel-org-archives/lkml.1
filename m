Return-Path: <linux-kernel-owner+w=401wt.eu-S1758270AbZFPM0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758270AbZFPM0X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 08:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753535AbZFPM0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 08:26:17 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:48550 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbZFPM0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 08:26:16 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4A378F66.5020702@s5r6.in-berlin.de>
Date: Tue, 16 Jun 2009 14:26:14 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.21) Gecko/20090523 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.30-rc1 regression? -- epoll: BUG: sleeping function called
 from invalid context
References: <tkrat.dc33b782c61692c7@s5r6.in-berlin.de> <alpine.DEB.1.10.0906152124480.21001@makko.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.1.10.0906152124480.21001@makko.or.mcafeemobile.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi wrote:
> Do you have a chance to give the patch below a spin, in your context?
> 
> 
> 
> - Davide

This works for me, i.e. the previously 100% reliably triggered BUGs went 
away, and testing did not reveal any issues anymore.

> ---
>  fs/eventpoll.c |   22 +++++++++++++---------
>  1 file changed, 13 insertions(+), 9 deletions(-)
> 
> Index: linux-2.6.mod/fs/eventpoll.c
> ===================================================================
> --- linux-2.6.mod.orig/fs/eventpoll.c	2009-06-15 19:27:05.000000000 -0700
> +++ linux-2.6.mod/fs/eventpoll.c	2009-06-15 21:14:36.000000000 -0700
> @@ -13,6 +13,7 @@
>  
>  #include <linux/init.h>
>  #include <linux/kernel.h>
> +#include <linux/hardirq.h>
>  #include <linux/sched.h>
>  #include <linux/fs.h>
>  #include <linux/file.h>
> @@ -98,7 +99,7 @@ struct epoll_filefd {
>  struct nested_call_node {
>  	struct list_head llink;
>  	void *cookie;
> -	int cpu;
> +	void *ctx;
>  };
>  
>  /*
> @@ -317,17 +318,17 @@ static void ep_nested_calls_init(struct 
>   * @nproc: Nested call core function pointer.
>   * @priv: Opaque data to be passed to the @nproc callback.
>   * @cookie: Cookie to be used to identify this nested call.
> + * @ctx: This instance context.
>   *
>   * Returns: Returns the code returned by the @nproc callback, or -1 if
>   *          the maximum recursion limit has been exceeded.
>   */
>  static int ep_call_nested(struct nested_calls *ncalls, int max_nests,
>  			  int (*nproc)(void *, void *, int), void *priv,
> -			  void *cookie)
> +			  void *cookie, void *ctx)
>  {
>  	int error, call_nests = 0;
>  	unsigned long flags;
> -	int this_cpu = get_cpu();
>  	struct list_head *lsthead = &ncalls->tasks_call_list;
>  	struct nested_call_node *tncur;
>  	struct nested_call_node tnode;
> @@ -340,7 +341,7 @@ static int ep_call_nested(struct nested_
>  	 * very much limited.
>  	 */
>  	list_for_each_entry(tncur, lsthead, llink) {
> -		if (tncur->cpu == this_cpu &&
> +		if (tncur->ctx == ctx &&
>  		    (tncur->cookie == cookie || ++call_nests > max_nests)) {
>  			/*
>  			 * Ops ... loop detected or maximum nest level reached.
> @@ -352,7 +353,7 @@ static int ep_call_nested(struct nested_
>  	}
>  
>  	/* Add the current task and cookie to the list */
> -	tnode.cpu = this_cpu;
> +	tnode.ctx = ctx;
>  	tnode.cookie = cookie;
>  	list_add(&tnode.llink, lsthead);
>  
> @@ -364,10 +365,9 @@ static int ep_call_nested(struct nested_
>  	/* Remove the current task from the list */
>  	spin_lock_irqsave(&ncalls->lock, flags);
>  	list_del(&tnode.llink);
> - out_unlock:
> +out_unlock:
>  	spin_unlock_irqrestore(&ncalls->lock, flags);
>  
> -	put_cpu();
>  	return error;
>  }
>  
> @@ -408,8 +408,12 @@ static int ep_poll_wakeup_proc(void *pri
>   */
>  static void ep_poll_safewake(wait_queue_head_t *wq)
>  {
> +	int this_cpu = get_cpu();
> +
>  	ep_call_nested(&poll_safewake_ncalls, EP_MAX_NESTS,
> -		       ep_poll_wakeup_proc, NULL, wq);
> +		       ep_poll_wakeup_proc, NULL, wq, (void *) (long) this_cpu);
> +
> +	put_cpu();
>  }
>  
>  /*
> @@ -663,7 +667,7 @@ static unsigned int ep_eventpoll_poll(st
>  	 * could re-enter here.
>  	 */
>  	pollflags = ep_call_nested(&poll_readywalk_ncalls, EP_MAX_NESTS,
> -				   ep_poll_readyevents_proc, ep, ep);
> +				   ep_poll_readyevents_proc, ep, ep, current);
>  
>  	return pollflags != -1 ? pollflags : 0;
>  }

Thanks for the quick response,
-- 
Stefan Richter
-=====-==--= -==- =----
http://arcgraph.de/sr/
