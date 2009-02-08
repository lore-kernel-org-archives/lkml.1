Return-Path: <linux-kernel-owner+w=401wt.eu-S1756027AbZBHARY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027AbZBHARY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 19:17:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753970AbZBHARQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 19:17:16 -0500
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:63228 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753966AbZBHARP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 19:17:15 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAB6yjUlMQWt2/2dsb2JhbACBbspphBoG
Date: Sat, 7 Feb 2009 19:17:13 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Bert Wesarg <bert.wesarg@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [urcu PATCH] test_urcu.c: use gettid()
Message-ID: <20090208001713.GA5282@Krystal>
References: <1233946197-32046-1-git-send-email-bert.wesarg@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1233946197-32046-1-git-send-email-bert.wesarg@googlemail.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 19:17:05 up 38 days, 15 min,  3 users,  load average: 0.66, 0.77,
	0.58
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Bert Wesarg (bert.wesarg@googlemail.com) wrote:
> It's probably better to print the tid for each thread, not the pid.
> 
> Signed-off-by: Bert Wesarg <bert.wesarg@googlemail.com>
> 
Merged, thanks !

Mathieu

> ---
>  test_urcu.c |   28 ++++++++++++++++++++++++----
>  1 files changed, 24 insertions(+), 4 deletions(-)
> 
> diff --git a/test_urcu.c b/test_urcu.c
> index db0b68c..ea5a784 100644
> --- a/test_urcu.c
> +++ b/test_urcu.c
> @@ -17,6 +17,23 @@
>  #include <unistd.h>
>  #include <stdio.h>
>  #include <assert.h>
> +#include <sys/syscall.h>
> +
> +#if defined(_syscall0)
> +_syscall0(pid_t, gettid)
> +#elif defined(__NR_gettid)
> +static inline pid_t gettid(void)
> +{
> +	return syscall(__NR_gettid);
> +}
> +#else
> +#warning "use pid as tid"
> +static inline pid_t gettid(void)
> +{
> +	return getpid();
> +}
> +#endif
> +
>  #include "urcu.h"
>  
>  struct test_array {
> @@ -36,8 +53,8 @@ void *thr_reader(void *arg)
>  	int qparity, i, j;
>  	struct test_array *local_ptr;
>  
> -	printf("thread %s, thread id : %lu, pid %lu\n",
> -			"reader", pthread_self(), (unsigned long)getpid());
> +	printf("thread %s, thread id : %lx, tid %lu\n",
> +			"reader", pthread_self(), (unsigned long)gettid());
>  	sleep(2);
>  
>  	urcu_register_thread();
> @@ -66,8 +83,8 @@ void *thr_writer(void *arg)
>  	int i;
>  	struct test_array *new, *old;
>  
> -	printf("thread %s, thread id : %lu, pid %lu\n",
> -			"writer", pthread_self(), (unsigned long)getpid());
> +	printf("thread %s, thread id : %lx, tid %lu\n",
> +			"writer", pthread_self(), (unsigned long)gettid());
>  	sleep(2);
>  
>  	for (i = 0; i < 10000000; i++) {
> @@ -104,6 +121,9 @@ int main()
>  	void *tret;
>  	int i;
>  
> +	printf("thread %-6s, thread id : %lx, tid %lu\n",
> +			"main", pthread_self(), (unsigned long)gettid());
> +
>  	for (i = 0; i < NR_READ; i++) {
>  		err = pthread_create(&tid_reader[i], NULL, thr_reader, NULL);
>  		if (err != 0)
> -- 
> tg: (24316d1..) bw/use-gettid (depends on: master)
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
