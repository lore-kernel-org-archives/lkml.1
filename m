Return-Path: <linux-kernel-owner+w=401wt.eu-S1755850AbZCRPA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850AbZCRPA1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 11:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752324AbZCRPAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 11:00:15 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:48720 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263AbZCRPAO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 11:00:14 -0400
Message-ID: <49C10B6B.3040108@cosmosbay.com>
Date: Wed, 18 Mar 2009 15:55:39 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-aio <linux-aio@kvack.org>, zach.brown@oracle.com
Subject: Re: [patch] eventfd - remove fput() call from possible IRQ context
 (2nd rev)
References: <49B89B22.7080303@cosmosbay.com>	<20090311224712.fb8db075.akpm@linux-foundation.org>	<49B8A75E.6040409@cosmosbay.com>	<20090311233903.f036027a.akpm@linux-foundation.org>	<alpine.DEB.1.10.0903120625340.6040@makko.or.mcafeemobile.com>	<1236986902.7265.73.camel@heimdal.trondhjem.org>	<alpine.DEB.1.10.0903131732300.13254@makko.or.mcafeemobile.com>	<1237003328.7265.98.camel@heimdal.trondhjem.org>	<alpine.DEB.1.10.0903140729060.26556@makko.or.mcafeemobile.com>	<alpine.DEB.1.10.0903141826120.3888@makko.or.mcafeemobile.com>	<20090315174445.GD18305@kvack.org>	<alpine.DEB.1.10.0903151303490.16762@makko.or.mcafeemobile.com> <x49wsamhpvg.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49wsamhpvg.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Wed, 18 Mar 2009 15:55:40 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Moyer a écrit :
> Davide Libenzi <davidel@xmailserver.org> writes:
> 
>> The following patch remove a possible source of fput() call from inside 
>> IRQ context. Myself, like Eric, wasn't able to reproduce an fput() call 
>> from IRQ context, but conceptually the bug is there.
> 
> I've attached a test program which can reproduce the fput call in
> interrupt context.  It's a modified version of the eventfd test that
> Rusty wrote for the libaio test harness.  I verified that fput was in
> fact being called in interrupt context by using systemtap to print out
> the "thead_indent" of fput calls, and observing a "swapper(0)" in the
> output.  After applying your patch, I confirmed that __fput is no longer
> called from interrupt context.  Strangely enough, I never did get any
> output from the might_sleep in __fput.  I can't explain that.
> 
> I have some minor comments inlined below.
> 
>> This patch adds an optimization similar to the one we already do on 
>> ->ki_filp, on ->ki_eventfd. Playing with ->f_count directly is not pretty 
>> in general, but the alternative here would be to add a brand new delayed 
>> fput() infrastructure, that I'm not sure is worth it.
>>
>> On Sun, 15 Mar 2009, Benjamin LaHaise wrote:
>>
>>> This looks reasonably sane, the only concern I have with it is that I think 
>>> it logically makes more sense to use the same convention for fi_filp and 
>>> ki_eventfd, as the different in IS_ERR vs checking for NULL is a bit 
>>> confusing.  Aside from that, it looks like it should fix the problem 
>>> correctly.
>> Makes sense.
>>
>> Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
>>
>>
>> - Davide
>>
>>
>> ---
>>  fs/aio.c |   37 +++++++++++++++++++++++++++----------
>>  1 file changed, 27 insertions(+), 10 deletions(-)
>>
>> Index: linux-2.6.mod/fs/aio.c
>> ===================================================================
>> --- linux-2.6.mod.orig/fs/aio.c	2009-03-14 09:24:12.000000000 -0700
>> +++ linux-2.6.mod/fs/aio.c	2009-03-15 12:54:10.000000000 -0700
> ...
>> @@ -527,12 +528,14 @@ static void aio_fput_routine(struct work
>>   */
>>  static int __aio_put_req(struct kioctx *ctx, struct kiocb *req)
>>  {
>> +	int schedule_putreq = 0;
>> +
>>  	dprintk(KERN_DEBUG "aio_put(%p): f_count=%ld\n",
>>  		req, atomic_long_read(&req->ki_filp->f_count));
>>  
>>  	assert_spin_locked(&ctx->ctx_lock);
>>  
>> -	req->ki_users --;
>> +	req->ki_users--;
>>  	BUG_ON(req->ki_users < 0);
>>  	if (likely(req->ki_users))
>>  		return 0;
>> @@ -540,10 +543,23 @@ static int __aio_put_req(struct kioctx *
>>  	req->ki_cancel = NULL;
>>  	req->ki_retry = NULL;
>>  
>> -	/* Must be done under the lock to serialise against cancellation.
>> -	 * Call this aio_fput as it duplicates fput via the fput_work.
>> +	/*
>> +	 * Try to optimize the aio and eventfd file* puts, by avoiding to
>> +	 * schedule work in case it is not __fput() time. In normal cases,
>> +	 * we wouldn not be holding the last reference to the file*, so
>               ^^^^^^^^^^
> tyop
> 
>> +	 * this function will be executed w/out any aio kthread wakeup.
>>  	 */
>> -	if (unlikely(atomic_long_dec_and_test(&req->ki_filp->f_count))) {
>> +	if (unlikely(atomic_long_dec_and_test(&req->ki_filp->f_count)))
>> +		schedule_putreq++;
>> +	else
>> +		req->ki_filp = NULL;
>> +	if (unlikely(req->ki_eventfd != NULL)) {
>> +		if (unlikely(atomic_long_dec_and_test(&req->ki_eventfd->f_count)))
>> +			schedule_putreq++;
>> +		else
>> +			req->ki_eventfd = NULL;
>> +	}
> 
> I agree with Jamie that you should get rid of the unlikely.
> 
> Thanks for taking care of this, Davide.
> 
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
> 
> Cheers,
> Jeff
> 
> #define _GNU_SOURCE
> #include <stdio.h>
> #include <stdlib.h>
> #include <unistd.h>
> #include <fcntl.h>
> #include <string.h>
> #include <sys/types.h>
> #include <errno.h>
> #include <assert.h>
> #include <sys/eventfd.h>
> #include <libaio.h>
> 
> int
> main(int argc, char **argv)
> {
> #define SIZE	(256*1024*1024)
> 	char *buf;
> 	struct io_event io_event;
> 	struct iocb iocb;
> 	struct iocb *iocbs[] = { &iocb };
> 	int rwfd, efd;
> 	int res;
> 	io_context_t	io_ctx;
> 
> 	efd = eventfd(0, 0);
> 	if (efd < 0) {
> 		perror("eventfd");
> 		exit(1);
> 	}
> 
> 	rwfd = open("rwfile", O_RDWR|O_DIRECT);		assert(rwfd != -1);
> 	if (posix_memalign((void **)&buf, getpagesize(), SIZE) < 0) {
> 		perror("posix_memalign");
> 		exit(1);
> 	}
> 	memset(buf, 0x42, SIZE);
> 
> 	/* Write test. */
> 	res = io_queue_init(1024, &io_ctx);		assert(res == 0);
> 	io_prep_pwrite(&iocb, rwfd, buf, SIZE, 0);
> 	io_set_eventfd(&iocb, efd);
> 	res = io_submit(io_ctx, 1, iocbs);		assert(res == 1);

yes but io_submit() is blocking. so your close(efd) will come after the release in fs/aio.c

I suggest you start a thread just before io_submit() and give it this work :

void *thread_work(void *arg)
{
	usleep(10000);
	close(efd);
	return (void *)0;
}

> 
> 	/* Now close the eventfd so that AIO has the last reference */
> 	close(efd);
> 
> 	/* Keep this process around so that the aio subsystem does not hold
> 	 * the last reference on the rwfd, otherwise the really_put_req will
> 	 * be called from process context */
> 	res = io_getevents(io_ctx, 1, 1, &io_event, NULL);
> 	if (res != 1) {
> 		if (res < 0) {
> 			errno = -res;
> 			perror("io_getevents");
> 		} else
> 			printf("io_getevents did not return 1 event after "
> 			       "closing eventfd\n");
> 		exit(1);
> 	}
> 	assert(io_event.res == SIZE);
> 	printf("eventfd write test [SUCCESS]\n");
> 
> 	return 0;
> }
> /*
>  * Local variables:
>  *   c-basic-offset: 8
>  *   compile-command: "gcc -o eventfd-in-irq eventfd-in-irq.c -laio -g3"
>  * End:
>  */
> 
> 


