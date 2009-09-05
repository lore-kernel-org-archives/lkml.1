Return-Path: <linux-kernel-owner+w=401wt.eu-S1752866AbZIERvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbZIERvL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 13:51:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752765AbZIERvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 13:51:10 -0400
Received: from fmailhost05.isp.att.net ([207.115.11.55]:41047 "EHLO
	fmailhost05.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729AbZIERvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 13:51:09 -0400
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Sat, 05 Sep 2009 13:51:09 EDT
X-Originating-IP: [76.250.133.175]
Message-ID: <4AA2A257.3000409@ameritech.net>
Date: Sat, 05 Sep 2009 13:39:35 -0400
From: "F. Heitkamp" <heitkamp@ameritech.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.15pre) Gecko/2009090411 Lightning/0.6a1 SeaMonkey/2.0a1pre
MIME-Version: 1.0
To: Ulrich Drepper <drepper@gmail.com>
CC: Andreas Schwab <schwab@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: popen2 popen call
References: <alpine.DEB.1.10.0908270803540.3447@pc1lin.fred.org> 	<m3prahctv6.fsf@hase.home> <082720091839.15057.4A96D2D10002C02000003AD122230647029B0A02D2080C0A9B079D0A030EBF9F030E059B070A08@att.net> <a36005b50908271215v27f06476p5808b9fb6b19fa81@mail.gmail.com>
In-Reply-To: <a36005b50908271215v27f06476p5808b9fb6b19fa81@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper wrote:
> On Thu, Aug 27, 2009 at 11:39,<heitkamp@ameritech.net>  wrote:
>    
>> OK.  I read in one of the messages, that glibc, passes the popen call to a ABI in the kernel. I have not
>> looked at the code in glibc yet.
>>      
>
> popen uses pipe2.  There is fallback code to use pipe if necessary.
> It's compiled out only of the libc assumes the kernel support is
> available.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>    
OK.  I think I found the problem but how do I fix it?
Did I miss a kernel config option?
I got the code from the man page:
http://linux.die.net/man/2/pipe
http://manpages.courier-mta.org/htmlman2/pipe.2.html

bash-4.0$ gcc -o linux-pipe linux-pipe.c
/tmp/ccHHOYkD.o: In function `main':
linux-pipe.c:(.text+0x3b): warning: warning: pipe2 is not implemented 
and will always fail
bash-4.0$ ./linux-pipe ls
pipe: Function not implemented
bash-4.0$


#include <sys/wait.h>
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
int
main(int argc, char *argv[])
{
     int pfd[2];
     pid_t cpid;
     char buf;
     assert(argc == 2);
     if (pipe2(pfd) == -1) { perror("pipe"); exit(EXIT_FAILURE); }
     cpid = fork();
     if (cpid == -1) { perror("fork"); exit(EXIT_FAILURE); }
     if (cpid == 0) {    /* Child reads from pipe */
         close(pfd[1]);          /* Close unused write end */
         while (read(pfd[0], &buf, 1) > 0)
             write(STDOUT_FILENO, &buf, 1);
         write(STDOUT_FILENO, "\n", 1);
         close(pfd[0]);
         _exit(EXIT_SUCCESS);
     } else {            /* Parent writes argv[1] to pipe */
         close(pfd[0]);          /* Close unused read end */
         write(pfd[1], argv[1], strlen(argv[1]));
         close(pfd[1]);          /* Reader will see EOF */
         wait(NULL);             /* Wait for child */
         exit(EXIT_SUCCESS);
     }
}

