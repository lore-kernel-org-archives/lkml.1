Return-Path: <linux-kernel-owner+w=401wt.eu-S933257AbXDAPG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933257AbXDAPG6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 11:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933281AbXDAPG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 11:06:58 -0400
Received: from il.qumranet.com ([82.166.9.18]:55181 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933257AbXDAPG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 11:06:57 -0400
Message-ID: <460FCA90.4000003@argo.co.il>
Date: Sun, 01 Apr 2007 18:06:56 +0300
From: Avi Kivity <avi@argo.co.il>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Suparna Bhattacharya <suparna@in.ibm.com>,
       Zach Brown <zach.brown@oracle.com>, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [patch 13/13] signal/timer/event fds v9 - KAIO eventfd support
 example ...
References: <send-serie.davidel@xmailserver.org.16816.1175371778.13>
In-Reply-To: <send-serie.davidel@xmailserver.org.16816.1175371778.13>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi wrote:
> This is an example about how to add eventfd support to the current KAIO code,
> in order to enable KAIO to post readiness events to a pollable fd
> (hence compatible with POSIX select/poll). The KAIO code simply signals
> the eventfd fd when events are ready, and this triggers a POLLIN in the fd.
> This patch uses a reserved for future use member of the struct iocb to pass
> an eventfd file descriptor, that KAIO will use to post events every time
> a request completes. At that point, an aio_getevents() will return the
> completed result to a struct io_event.
> I made a quick test program to verify the patch, and it runs fine here:
>
> Index: linux-2.6.21-rc5.fds/include/linux/aio_abi.h
> ===================================================================
> --- linux-2.6.21-rc5.fds.orig/include/linux/aio_abi.h	2007-03-31 12:45:30.000000000 -0700
> +++ linux-2.6.21-rc5.fds/include/linux/aio_abi.h	2007-03-31 12:46:31.000000000 -0700
> @@ -84,7 +84,11 @@
>  
>  	/* extra parameters */
>  	__u64	aio_reserved2;	/* TODO: use this for a (struct sigevent *) */
> -	__u64	aio_reserved3;
> +	__u32	aio_reserved3;
> +	/*
> +	 * If different from 0, this is an eventfd to deliver AIO results to
> +	 */
> +	__u32	aio_resfd;
>  }; /* 64 bytes */
>  

What is the motivation for adding aio_resfd to an individual iocb 
instead of the entire io context?  It seems redundant, as you can 
already create multiple io contexts to wait on.

[also, minor nit: sys_eventfd() can legitimately return 0, but you're 
banning its use in aio.  userspace could easily dup() and close(), but...]

-- 
error compiling committee.c: too many arguments to function

