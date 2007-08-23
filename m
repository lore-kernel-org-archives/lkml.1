Return-Path: <linux-kernel-owner+w=401wt.eu-S1758224AbXHWI3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224AbXHWI3m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 04:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751560AbXHWI3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 04:29:34 -0400
Received: from brick.kernel.dk ([87.55.233.238]:23271 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078AbXHWI3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 04:29:33 -0400
Date: Thu, 23 Aug 2007 10:29:30 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Corrections in Documentation/block/ioprio.txt
Message-ID: <20070823082929.GI23758@kernel.dk>
References: <20070823081817.GA27439@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070823081817.GA27439@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23 2007, Dhaval Giani wrote:
> Hi Jens,
> 
> The newer glibc does not allow system calls to be made via _syscallN()
> wrapper. They have to be made through syscall(). The ionice code used
> the older interface. Correcting it to use syscall.
> 
> Signed-of-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
> 
> 
> Index: linux-2.6.23-rc3-mm1/Documentation/block/ioprio.txt
> ===================================================================
> --- linux-2.6.23-rc3-mm1.orig/Documentation/block/ioprio.txt	2007-07-09 05:02:17.000000000 +0530
> +++ linux-2.6.23-rc3-mm1/Documentation/block/ioprio.txt	2007-08-23 13:23:28.000000000 +0530
> @@ -86,8 +86,9 @@ extern int sys_ioprio_get(int, int);
>  #error "Unsupported arch"
>  #endif
>  
> -_syscall3(int, ioprio_set, int, which, int, who, int, ioprio);
> -_syscall2(int, ioprio_get, int, which, int, who);
> +#define ioprio_set(which, who, ioprio)  syscall(__NR_ioprio_set, which,\
> +							who, ioprio)
> +#define ioprio_get(which, who)	syscall(__NR_ioprio_get, which, who)

Agree, it fails as-of recent distros. But I prefer a function instead,
can you resend with something ala:

static inline int ioprio_set(int which, int who, int ioprio)
{
        return syscall(__NR_ioprio_set, which, who, ioprio);
}

and ditto for ioprio_get()?

-- 
Jens Axboe

