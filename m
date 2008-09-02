Return-Path: <linux-kernel-owner+w=401wt.eu-S1754705AbYIBWPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbYIBWPU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 18:15:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753381AbYIBWPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 18:15:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36336 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753189AbYIBWPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 18:15:06 -0400
Date: Tue, 2 Sep 2008 15:14:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "La Monte H.P. Yarroll" <piggy@laurelnetworks.com>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH] Provide control over core name even for multithreaded
 processes
Message-Id: <20080902151426.98935cd1.akpm@linux-foundation.org>
In-Reply-To: <20080829152215.2cdb1438@kartuli>
References: <20080829152215.2cdb1438@kartuli>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Aug 2008 15:22:15 -0400
"La Monte H.P. Yarroll" <piggy@laurelnetworks.com> wrote:

> Our system explicitly sets core_pattern to force a relatively small
> limit on the number of different core dump names.
> 
> Unfortunately, the kernel unconditionally appends .<tid> for
> multithreaded processes.
> 
> The attached patch introduces "%T" to the core_pattern language, which
> expands to ".<tid>" for multithreaded processes. It then changes the
> default core_pattern to "core%T" replicating the current default
> behavior.
> 
> Signed-off-by: La Monte H.P. Yarroll <piggy@laurelnetworks.com> 74-256740
> 
> diff -Naur linux-2.6.26.3/Documentation/sysctl/kernel.txt linux-2.6.26.3-new/Documentation/sysctl/kernel.txt
> --- linux-2.6.26.3/Documentation/sysctl/kernel.txt	2008-08-20 14:11:37.000000000 -0400
> +++ linux-2.6.26.3-new/Documentation/sysctl/kernel.txt	2008-08-28 13:27:50.239325000 -0400
> @@ -88,7 +88,7 @@
>  core_pattern:
>  
>  core_pattern is used to specify a core dumpfile pattern name.
> -. max length 128 characters; default value is "core"
> +. max length 128 characters; default value is "core%T"
>  . core_pattern is used as a pattern template for the output filename;
>    certain string patterns (beginning with '%') are substituted with
>    their actual values.
> @@ -104,6 +104,7 @@
>  	%g	gid
>  	%s	signal number
>  	%t	UNIX time of dump
> +	%T      .tgid or nothing if process is not threaded
>  	%h	hostname
>  	%e	executable filename
>  	%<OTHER> both are dropped
> diff -Naur linux-2.6.26.3/fs/exec.c linux-2.6.26.3-new/fs/exec.c
> --- linux-2.6.26.3/fs/exec.c	2008-08-20 14:11:37.000000000 -0400
> +++ linux-2.6.26.3-new/fs/exec.c	2008-08-28 13:46:57.919768000 -0400
> @@ -66,7 +66,7 @@
>  #endif
>  
>  int core_uses_pid;
> -char core_pattern[CORENAME_MAX_SIZE] = "core";
> +char core_pattern[CORENAME_MAX_SIZE] = "core%T";
>  int suid_dumpable = 0;
>  
>  /* The maximal length of core_pattern is also specified in sysctl.c */
> @@ -1415,7 +1415,7 @@
>  			case 'p':
>  				pid_in_pattern = 1;
>  				rc = snprintf(out_ptr, out_end - out_ptr,
> -					      "%d", task_tgid_vnr(current));
> +					      "%d", task_pid_vnr(current));
>  				if (rc > out_end - out_ptr)
>  					goto out;
>  				out_ptr += rc;
> @@ -1455,6 +1455,17 @@
>  				out_ptr += rc;
>  				break;
>  			}
> +			/* Conditional tgid */
> +			case 'T': {
> +			  if (atomic_read(&current->mm->mm_users) != 1) {
> +			    rc = snprintf(out_ptr, out_end - out_ptr,
> +					  ".%d", task_tgid_vnr(current));
> +			    if (rc > out_end - out_ptr)
> +			      goto out;
> +			    out_ptr += rc;
> +			  }
> +			  break;
> +			}
>  			/* hostname */
>  			case 'h':
>  				down_read(&uts_sem);
> @@ -1492,10 +1503,9 @@
>  	 * If core_pattern does not include a %p (as is the default)
>  	 * and core_uses_pid is set, then .%pid will be appended to
>  	 * the filename. Do not do this for piped commands. */
> -	if (!ispipe && !pid_in_pattern
> -            && (core_uses_pid || atomic_read(&current->mm->mm_users) != 1)) {
> +	if (!ispipe && !pid_in_pattern && core_uses_pid) {
>  		rc = snprintf(out_ptr, out_end - out_ptr,
> -			      ".%d", task_tgid_vnr(current));
> +			      ".%d", current->pid);
>  		if (rc > out_end - out_ptr)
>  			goto out;
>  		out_ptr += rc;

Please review Oleg's
http://userweb.kernel.org/~akpm/mmotm/broken-out/coredump-format_corename-dont-append-%25pid-if-multi-threaded.patch,
which I have queued for 2.6.28.

