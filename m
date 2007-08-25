Return-Path: <linux-kernel-owner+w=401wt.eu-S1761546AbXHYB6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761546AbXHYB6Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 21:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751247AbXHYB6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 21:58:14 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:49074 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbXHYB6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 21:58:13 -0400
Date: Fri, 24 Aug 2007 18:56:21 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Dr. David Alan Gilbert" <linux@treblig.org>
Cc: neilb@suse.de, bfields@fieldses.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add source address to sunrpc svc errors
Message-Id: <20070824185621.3f16f7c9.randy.dunlap@oracle.com>
In-Reply-To: <20070825012630.GB5431@gallifrey>
References: <20070825012630.GB5431@gallifrey>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Aug 2007 02:26:30 +0100 Dr. David Alan Gilbert wrote:

> Hi,
>   This patch adds the address of the client that caused an
> error in sunrpc/svc.c so that you get errors that look like:
> 
> svc: 192.168.66.28, port=709 :unknown version (3 for prog 100003, nfsd)
> 
> I've seen machines which get bunches of unknown version or similar
> errors from time to time, and while the recent patch to add
> the service helps to find which service has the wrong version it doesn't
> help find the potentially bad client.
> 
>   The patch is against a checkout of Linus's git tree made
> on 2007-08-24.
> 
>   One observation is that the svc_print_addr function
> prints to a buffer which in this case makes life a little more complex;
> it just feels as if there must be lots of places that print a
> connection address - is there a better function to use anywhere?
> 
> I think actually there are a few places with semi duplicated code; e.g.
> one_sock_name switches on the address family but only currently
> has IPV4; I wonder how many other places are similar.
> 
> Dave
> 
> 	Signed-off-by: Dave Gilbert <linux@treblig.org>
> 
> -- 
>  -----Open up your eyes, open up your mind, open up your code -------   
> / Dr. David Alan Gilbert    | Running GNU/Linux on Alpha,68K| Happy  \ 
> \ gro.gilbert @ treblig.org | MIPS,x86,ARM,SPARC,PPC & HPPA | In Hex /
>  \ _________________________|_____ http://www.treblig.org   |_______/
> 
> 
> --- linux-2.6/net/sunrpc/svc.c.predag	2007-08-25 00:50:06.000000000 +0100
> +++ linux-2.6/net/sunrpc/svc.c	2007-08-25 01:34:56.000000000 +0100
> @@ -777,6 +777,28 @@ svc_register(struct svc_serv *serv, int 
>  }
>  
>  /*
> + * Printk the given error with the address of the client that caused it.
> + */
> +static int
> +svc_printkerr(struct svc_rqst *rqstp, const char* fmt,...)

add:
	__attribute__ ((format (printf, 2, 3)))
so that the compiler can check the args list.

> +{
> +	va_list args;
> +	int 	r;
> +	char 	buf[RPC_MAX_ADDRBUFLEN];
> +
> +	if (!net_ratelimit())
> +		return 0;
> +
> +	printk("svc: %s :", svc_print_addr(rqstp, buf, sizeof(buf)));

some KERN_* level, please.

> +
> +	va_start(args, fmt);
> +	r = vprintk(fmt, args);
> +	va_end(args);
> +
> +	return r;
> +}
> +
> +/*
>   * Process the RPC request.
>   */
>  int
> @@ -963,14 +985,13 @@ svc_process(struct svc_rqst *rqstp)
>  	return 0;
>  
>  err_short_len:
> -	if (net_ratelimit())
> -		printk("svc: short len %Zd, dropping request\n", argv->iov_len);
> +	svc_printkerr(rqstp, "short len %Zd, dropping request\n",
> +			argv->iov_len);
>  
>  	goto dropit;			/* drop request */
>  
>  err_bad_dir:
> -	if (net_ratelimit())
> -		printk("svc: bad direction %d, dropping request\n", dir);
> +	svc_printkerr(rqstp, "bad direction %d, dropping request\n", dir);
>  
>  	serv->sv_stats->rpcbadfmt++;
>  	goto dropit;			/* drop request */
> @@ -1000,8 +1021,7 @@ err_bad_prog:
>  	goto sendit;
>  
>  err_bad_vers:
> -	if (net_ratelimit())
> -		printk("svc: unknown version (%d for prog %d, %s)\n",
> +	svc_printkerr(rqstp, "unknown version (%d for prog %d, %s)\n",
>  		       vers, prog, progp->pg_name);
>  
>  	serv->sv_stats->rpcbadfmt++;
> @@ -1011,16 +1031,14 @@ err_bad_vers:
>  	goto sendit;
>  
>  err_bad_proc:
> -	if (net_ratelimit())
> -		printk("svc: unknown procedure (%d)\n", proc);
> +	svc_printkerr(rqstp, "unknown procedure (%d)\n", proc);
>  
>  	serv->sv_stats->rpcbadfmt++;
>  	svc_putnl(resv, RPC_PROC_UNAVAIL);
>  	goto sendit;
>  
>  err_garbage:
> -	if (net_ratelimit())
> -		printk("svc: failed to decode args\n");
> +	svc_printkerr(rqstp, "svc: failed to decode args\n");
>  
>  	rpc_stat = rpc_garbage_args;
>  err_bad:
> -

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
