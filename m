Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751459Ab0CBIu4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 03:50:56 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:53959 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001Ab0CBIuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 03:50:55 -0500
Date: Tue, 2 Mar 2010 14:20:46 +0530
From: Rishikesh K Rajak <risrajak@linux.vnet.ibm.com>
To: naresh kamboju <naresh.kernel@gmail.com>
Cc: ltp-list <ltp-list@lists.sourceforge.net>, linux-kernel@vger.kernel.org
Subject: Re: [LTP] [PATCH] Synchronization required before release the lock:
 sem_post/8-1.c
Message-ID: <20100302085046.GA27023@linux.vnet.ibm.com>
Mail-Followup-To: naresh kamboju <naresh.kernel@gmail.com>,
	ltp-list <ltp-list@lists.sourceforge.net>,
	linux-kernel@vger.kernel.org
References: <f5a7b3811002250545x3d5288cfqd114d3bcd79581f2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5a7b3811002250545x3d5288cfqd114d3bcd79581f2@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 25, 2010 at 07:15:42PM +0530, naresh kamboju wrote:
> Hi,
> 
> I have found abnormal behavior of sem_post/8-1.c test case under posix.
> This test case passes in some times and failed in many times :-(
> 
> After my investigation found synchronization is missing between the
> child processes.
> Made a patch to fix this issue.
> 
> Patch includes
> 1.	Reverting back changes made by mreed on Sep 25 2006. Making sure
> child has been waiting for the lock (below Refs).
> 2.	using sleep in while loop is not a good idea, so sleep is removed
> from while loop
> 3.	For the synchronization I have added sleep before releasing the lock.
> 
> 
> After applying this patch I have tested this test case 1000 times continuously.
> All the times test case reported as Test Pass :-)
> 
> 
> Signed-off-by: Naresh Kamboju < naresh.kernel@gmail.com >

Looks good to me though i needed few clarification below.

Acked-By: Rishikesh K Rajak <risrajak@linux.vnet.ibm.com>

> ---
>  testcases/open_posix_testsuite/conformance/interfaces/sem_post/8-1.c
> |   15    8 +     7 -     0 !
>  1 file changed, 8 insertions(+), 7 deletions(-)
> 
> Index: b/testcases/open_posix_testsuite/conformance/interfaces/sem_post/8-1.c
> ===================================================================
> --- a/testcases/open_posix_testsuite/conformance/interfaces/sem_post/8-1.c
> +++ b/testcases/open_posix_testsuite/conformance/interfaces/sem_post/8-1.c
> @@ -161,7 +161,6 @@ int main()
>         }
>         fprintf(stderr, "P: child_1:%d forked\n", c_1);
> 
> -       sleep(1);
>         c_2 = fork();
>         if (c_2 == 0)
>         {
> @@ -176,13 +175,13 @@ int main()
>         }
>         fprintf(stderr, "P: child_2: %d forked\n", c_2);
> 
> +        /* Step 3 Implementation */
>         /* Make sure the two children has been waiting */
> -       /*do {
> -               sleep(1);
I feel before getting semaphore value, we need to sync first so here
sleep is require,though your point is valid that there is no use of
using sleep inside while loop.

> +       do {
>                 sem_getvalue(sem_1, &val);
>                 //printf("val = %d\n", val);
>         } while (val != 1);
> -       */
> +
>         c_3 = fork();
>         if (c_3 == 0)
>         {
> @@ -191,13 +190,15 @@ int main()
>         }
>         fprintf(stderr, "P: child_3: %d forked\n", c_3);
> 
> +        /* Step 3 Implementation */
>         /* Make sure child 3 has been waiting for the lock */
> -       /*do {
> -               sleep(1);
> +       do {
>                 sem_getvalue(sem_1, &val);
>                 //printf("val = %d\n", val);
>         } while (val != 0);
> -       */
> +
> +       /* Synchronization required before release the lock */
> +       sleep(1);
>         /* Ok, let's release the lock */
>         fprintf(stderr, "P: release lock\n");
>         sem_post(sem);
> 
> 
> Test script to test 1000 times:
> /*****************************************************/
> #!/bin/sh
> 
> for ((  i = 0 ;  i < 1000;  i++  ))
> 
> do
> 
> ./8-1.test >> /tmp/sem-post-8-1.log
> done
> /*****************************************************/
> 
> Refs:
> http://ltp.cvs.sourceforge.net/viewvc/ltp/ltp/testcases/open_posix_testsuite/conformance/interfaces/sem_post/8-1.c?view=log
> 
> Please review this patch and let me know if you have any issues.
> 
> Best regards
> Naresh Kamboju


> ------------------------------------------------------------------------------
> Download Intel&#174; Parallel Studio Eval
> Try the new software tools for yourself. Speed compiling, find bugs
> proactively, and fine-tune applications for parallel performance.
> See why Intel Parallel Studio got high marks during beta.
> http://p.sf.net/sfu/intel-sw-dev

> _______________________________________________
> Ltp-list mailing list
> Ltp-list@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/ltp-list


-- 
Thanks & Regards
Rishi
LTP Maintainer
IBM, LTC, Bangalore
Please join IRC #ltp @ irc.freenode.net
