Return-Path: <linux-kernel-owner+w=401wt.eu-S1753289AbYIVOra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbYIVOra (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 10:47:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752555AbYIVOrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 10:47:22 -0400
Received: from main.gmane.org ([80.91.229.2]:48707 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752506AbYIVOrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 10:47:22 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Halesh S <halesh.sadashiv@ap.sony.com>
Subject: Re: Regarding select() on PPC
Date: Mon, 22 Sep 2008 14:47:03 +0000 (UTC)
Message-ID: <loom.20080922T143915-56@post.gmane.org>
References: <loom.20080919T140301-79@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 59.96.48.15 (Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Halesh S <halesh.sadashiv <at> ap.sony.com> writes:

> 
> Hi all,
> 
> Please find the below testcase.
> 
> #include <stdio.h>
> #include <sys/time.h>
> #include <sys/types.h>
> #include <unistd.h>
> #include <fcntl.h>
> #include <string.h>
> #include <time.h>
> #include <errno.h>
> #include <stdlib.h>
> 
> int main()
> {
> 
>  int fd;
>  fd_set rfds;
>  struct timeval tv;
>  int ret_val;
> 
>  if ((fd = open("test_file", O_RDWR|O_CREAT, 0664)) < 0)
>   {
>     printf("Open failed\n");
>   }
> 
>   FD_ZERO(&rfds);
>   FD_SET(fd, &rfds);
> 
>   /* Wait up to five seconds. */
>   tv.tv_sec = 1;
>   tv.tv_usec = 0;
> 
>   if ( (ret_val = select(-1, &rfds, NULL, NULL, &tv)) < 0)
>   {
>     if (errno == EINVAL)
>       printf("OK\n");
>     else
>       printf("Not OK, Got errno %d\n", errno);
>   }
>   exit(0);
> }
> 
> For negetive value of n (first argument to select) select fails with
> EINVAL error,
> 
> But for the same when I tested for PowerPC it was giving EFAULT, 
> Its on 2.6.16 kernel.
> 
> Please let me know, If this is fixed or it's a issue in PPC.
> For other archs its working fine.
> 
> Thanks,
> Halesh
> 
> 


On further investigation found, the above problem occurs only in PPC32.

Because select()->ppc_select()->sys_select() only for PPC32.

In the file powerpc/kernel/syscalls.c, 

#ifdef CONFIG_PPC32
/*
* Due to some executables calling the wrong select we sometimes
* get wrong args.  This determines how the args are being passed
* (a single ptr to them all args passed) then calls
* sys_select() with the appropriate args. -- Cort
*/
int
ppc_select(int n, fd_set __user *inp, fd_set __user *outp, fd_set __user *exp, 
struct timeval __user *tvp)
{
        if ( (unsigned long)n >= 4096 )
        {
                unsigned long __user *buffer = (unsigned long __user *)n;
                if (!access_ok(VERIFY_READ, buffer, 5*sizeof(unsigned long))
                   || __get_user(n, buffer)
                   || __get_user(inp, ((fd_set __user * __user *)(buffer+1)))
                   || __get_user(outp, ((fd_set  __user * __user *)(buffer+2)))
                   || __get_user(exp, ((fd_set  __user * __user *)(buffer+3)))
                   || __get_user(tvp, ((struct timeval  __user * __user *)
(buffer+4))))
                   return -EFAULT;
        }
        return sys_select(n, inp, outp, exp, tvp);
}
#endif


What is the purpose of Argument check only for PPC32, is ther any specific 
reason? Please let me know if so. Comments were not enough to understad the 
actual reason reas for me.

On all archs I have checked like PPC64, ARM, i686 with invalid 'n' val returns 
EINVAL, execpet on PPC32, this needs to be fixed ??

either man page / return value in kernel source.

 - return -EFAULT
 + return -EINVAL

Please let me know regarding this issue.


Thanks,
Halesh













