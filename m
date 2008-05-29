Return-Path: <linux-kernel-owner+w=401wt.eu-S1754523AbYE2JnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523AbYE2JnV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 05:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752613AbYE2JnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 05:43:08 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:33670 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbYE2JnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 05:43:06 -0400
Message-ID: <483E7AC5.80508@bull.net>
Date: Thu, 29 May 2008 11:43:33 +0200
From: Nadia Derbey <Nadia.Derbey@bull.net>
Organization: BULL/DT/OSwR&D/Linux
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040115
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Only output msgmni value at boot time
References: <20080527082441.239624000@bull.net> <20080527082502.538707000@bull.net> <1FE6DD409037234FAB833C420AA843EC016AC45B@orsmsx424.amr.corp.intel.com>
In-Reply-To: <1FE6DD409037234FAB833C420AA843EC016AC45B@orsmsx424.amr.corp.intel.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luck, Tony wrote:
>>In http://lkml.org/lkml/2008/4/29/575 Tony Luck complained that this message
>>references an ipc namespace address that is useless.
>>
>>I first thought of using an audit_log instead of a printk, as suggested by
>>Serge Hallyn. But unfortunately, we do not have any other information than
>>the namespace address to provide here too.
>>So I chose to move the message and output it only at boot time, removing the
>>reference to the namespace.
> 
> 
> Diffing my before/after dmesg(8) output:
> < msgmni has been set to 7964 for ipc namespace a000000100a1ad58
> ---
> 
>>msgmni has been set to 7964
> 
> 
> Much prettier.  Thank you.
> 
> I'll leave it to SGI to ponder whether it is correct to compute
> msgmni based on a linear function of lowmem (their big systems can
> have terabytes of memory, all of which is counted as lowmem).

Sure that if the formula can be enhanced, that would be great.
But don't forget 2 things:
. msgmni cannot become higher than IPCMNI: i.e. starting from 16Gb of 
lowmem, and based on a value of 16K for msgmnb, msgmni won't increase. 
(if I'm not wrong in my computation).
. there is no memory pre-allocation done based upon msgmni value: by 
increasing its value we are just making the DoS (for too many msg 
queues) come later.
. there is still the possibility of lowering the value "by hand" (via 
procfs) if ever it is found to be too high.

Regards,
Nadia

> 
> 
>>This patch applies to 2.6.26-rc2-mm1.
> 
> 
> Acked-by: Tony Luck <tony.luck@intel.com>
> 
> Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
> 
> ---
>  ipc/msg.c |   13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
> 
> Index: linux-2.6.26-rc2-mm1/ipc/msg.c
> ===================================================================
> --- linux-2.6.26-rc2-mm1.orig/ipc/msg.c	2008-05-26 12:25:37.000000000 +0200
> +++ linux-2.6.26-rc2-mm1/ipc/msg.c	2008-05-27 10:59:34.000000000 +0200
> @@ -98,20 +98,15 @@ void recompute_msgmni(struct ipc_namespa
>  
>  	if (allowed < MSGMNI) {
>  		ns->msg_ctlmni = MSGMNI;
> -		goto out_callback;
> +		return;
>  	}
>  
>  	if (allowed > IPCMNI / nb_ns) {
>  		ns->msg_ctlmni = IPCMNI / nb_ns;
> -		goto out_callback;
> +		return;
>  	}
>  
>  	ns->msg_ctlmni = allowed;
> -
> -out_callback:
> -
> -	printk(KERN_INFO "msgmni has been set to %d for ipc namespace %p\n",
> -		ns->msg_ctlmni, ns);
>  }
>  
>  void msg_init_ns(struct ipc_namespace *ns)
> @@ -136,6 +131,10 @@ void msg_exit_ns(struct ipc_namespace *n
>  void __init msg_init(void)
>  {
>  	msg_init_ns(&init_ipc_ns);
> +
> +	printk(KERN_INFO "msgmni has been set to %d\n",
> +		init_ipc_ns.msg_ctlmni);
> +
>  	ipc_init_proc_interface("sysvipc/msg",
>  				"       key      msqid perms      cbytes       qnum lspid lrpid   uid   gid  cuid  cgid      stime      rtime      ctime\n",
>  				IPC_MSG_IDS, sysvipc_msg_proc_show);
> 




