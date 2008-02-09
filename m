Return-Path: <linux-kernel-owner+w=401wt.eu-S1754761AbYBIQIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbYBIQIb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 11:08:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752125AbYBIQIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 11:08:24 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:60244 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbYBIQIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 11:08:23 -0500
References: <2f11576a0802090755n123c9b7dh26e0af6a2fef28af@mail.gmail.com>
Message-Id: <CE520A17-98F2-4A08-82AB-C3D5061616A1@jonmasters.org>
From: Jon Masters <jonathan@jonmasters.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
In-Reply-To: <2f11576a0802090755n123c9b7dh26e0af6a2fef28af@mail.gmail.com>
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed;
	delsp=yes
X-Mailer: iPhone Mail (4A93)
Mime-Version: 1.0 (iPhone Mail 4A93)
Subject: Re: [sample] mem_notify v6: usage example
Content-Transfer-Encoding: 7bit
Date: Sat, 9 Feb 2008 11:07:09 -0500
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       Marcelo Tosatti <marcelo@kvack.org>,
       Daniel Spang <daniel.spang@gmail.com>, Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Al Boldi <a1426z@gawab.com>,
       Zan Lynx <zlynx@acm.org>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 32.136.95.248
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This really needs to be triggered via a generic kernel event in the  
final version - I picture glibc having a reservation API and having  
generic support for freeing such reservations.

Jon



On Feb 9, 2008, at 10:55, "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com 
 > wrote:

> this is usage example of /dev/mem_notify.
>
> Daniel Spang create original version.
> kosaki add fasync related code.
>
>
> Signed-off-by: Daniel Spang <daniel.spang@gmail.com>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>
> ---
> Documentation/mem_notify.c |  120 +++++++++++++++++++++++++++++++++++ 
> ++++++++++
> 1 file changed, 120 insertions(+)
>
> Index: b/Documentation/mem_notify.c
> ===================================================================
> --- /dev/null    1970-01-01 00:00:00.000000000 +0000
> +++ b/Documentation/mem_notify.c    2008-02-10 00:44:00.000000000  
> +0900
> @@ -0,0 +1,120 @@
> +/*
> + * Allocate 10 MB each second. Exit on notification.
> + */
> +
> +#define _GNU_SOURCE
> +
> +#include <sys/mman.h>
> +#include <fcntl.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <unistd.h>
> +#include <string.h>
> +#include <poll.h>
> +#include <pthread.h>
> +#include <errno.h>
> +#include <signal.h>
> +
> +int count = 0;
> +int size = 10;
> +
> +void *do_alloc()
> +{
> +        for(;;) {
> +                int *buffer;
> +                buffer = mmap(NULL,  size*1024*1024,
> +                              PROT_READ | PROT_WRITE,
> +                              MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> +                if (buffer == MAP_FAILED) {
> +                        perror("mmap");
> +                        exit(EXIT_FAILURE);
> +                }
> +                memset(buffer, 1 , size*1024*1024);
> +
> +                printf("-");
> +                fflush(stdout);
> +
> +                count++;
> +                sleep(1);
> +        }
> +}
> +
> +int wait_for_notification(struct pollfd *pfd)
> +{
> +        int ret;
> +        read(pfd->fd, 0, 0);
> +        ret = poll(pfd, 1, -1);              /* wake up when low  
> memory */
> +        if (ret == -1 && errno != EINTR) {
> +                perror("poll");
> +                exit(EXIT_FAILURE);
> +        }
> +        return ret;
> +}
> +
> +void do_free()
> +{
> +    int fd;
> +    struct pollfd pfd;
> +
> +        fd = open("/dev/mem_notify", O_RDONLY);
> +        if (fd == -1) {
> +                perror("open");
> +                exit(EXIT_FAILURE);
> +        }
> +
> +    pfd.fd = fd;
> +        pfd.events = POLLIN;
> +        for(;;)
> +                if (wait_for_notification(&pfd) > 0) {
> +                        printf("\nGot notification, allocated %d MB 
> \n",
> +                               size * count);
> +                        exit(EXIT_SUCCESS);
> +                }
> +}
> +
> +void do_free_signal()
> +{
> +    int fd;
> +    int flags;
> +
> +        fd = open("/dev/mem_notify", O_RDONLY);
> +        if (fd == -1) {
> +                perror("open");
> +                exit(EXIT_FAILURE);
> +        }
> +
> +    fcntl(fd, F_SETOWN, getpid());
> +    fcntl(fd, F_SETSIG, SIGUSR1);
> +
> +    flags = fcntl(fd, F_GETFL);
> +    fcntl(fd, F_SETFL, flags|FASYNC); /* when low memory, receive  
> SIGUSR1 */
> +
> +    for(;;)
> +        sleep(1);
> +}
> +
> +
> +void daniel_exit(int signo)
> +{
> +    printf("\nGot notification %d, allocated %d MB\n",
> +           signo, size * count);
> +    exit(EXIT_SUCCESS);
> +
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +        pthread_t allocator;
> +
> +    if(argc == 2 && (strcmp(argv[1], "-sig") == 0)) {
> +        printf("run signal mode\n");
> +        signal(SIGUSR1, daniel_exit);
> +        pthread_create(&allocator, NULL, do_alloc, NULL);
> +        do_free_signal();
> +    } else {
> +        printf("run poll mode\n");
> +        pthread_create(&allocator, NULL, do_alloc, NULL);
> +        do_free();
> +    }
> +    return 0;
> +}
>
