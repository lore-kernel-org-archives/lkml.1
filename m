Return-Path: <linux-kernel-owner+w=401wt.eu-S1758095AbZCCEwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758095AbZCCEwy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 23:52:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753577AbZCCEwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 23:52:45 -0500
Received: from wf-out-1314.google.com ([209.85.200.172]:15842 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbZCCEwo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 23:52:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jWMTyRtJvqRakM8GHWTrJ/skSNhysad0THAwnrvS7Cr/PBgWiHLj2tnpGToiiMXIOJ
         TgBqvpO+I93vhlapCQlPWTAaCZDKS5EA2yxGjnIpyAYWOXDbngCDQzpwBgAmTX3oUCnm
         HJOFLTX5gO62rL6OaalVYeDpU3G8LGrLWcOs4=
MIME-Version: 1.0
In-Reply-To: <49ACB02D.8070300@cse.unsw.edu.au>
References: <d364733c0903012106g2625d433o4cdbbbcc5a9ff19a@mail.gmail.com>
	 <49ACB02D.8070300@cse.unsw.edu.au>
Date: Tue, 3 Mar 2009 12:52:42 +0800
Message-ID: <d364733c0903022052g671a07ayf4ded2014d085fdf@mail.gmail.com>
Subject: Re: The difference of request dir between AS and Deadline I/O 
	scheduler?
From: =?GB2312?B?0Lu42Q==?= <xiegang112@gmail.com>
To: Aaron Carroll <aaronc@cse.unsw.edu.au>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 3, 2009 at 12:21 PM, Aaron Carroll <aaronc@cse.unsw.edu.au> wrote:
> � wrote:
>> Hi,
>>
>> I'm little confused about the defination of request dir in AS and
>> Deadline I/O scheduler.
>> In AS, the request dir is defined by wheher it's sync:
>>
>> data_dir = rq_is_sync(rq);
>>
>> But in Deadline, the requests are grouped by read and write.
>>
>> Why is there the difference since AS is an extension of Deadline?
>> what's the consideration?
>
> I also thought it was silly to have different behaviours, so I tried
> the following patch that makes deadline use sync/async instead of
> read/write.  All the benchmarks I tried showed that performance
> dropped or remained constant at best, so I didn't propose it.
> Maybe you will have more luck...
Hello,
Which benchmark tool do you use? I'd like to have a try. I think the
I/O behavior is an important factor which can affect the performance.

Thanks,
>
> --
>
> From: Aaron Carroll <aaronc@cse.unsw.edu.au>
> Date: Sat, 4 Oct 2008 11:58:23 +1000
> Subject: [PATCH] deadline-iosched: support SYNC bio/request flag
>
> Support sync/async requests in deadline rather than read/write, as is
> done in AS and CFQ.
>
> Signed-off-by: Aaron Carroll <aaronc@cse.unsw.edu.au>
> ---
>  block/deadline-iosched.c |   63 ++++++++++++++++++++++++---------------------
>  1 files changed, 34 insertions(+), 29 deletions(-)
>
> diff --git a/block/deadline-iosched.c b/block/deadline-iosched.c
> index 342448c..b2cfd47 100644
> --- a/block/deadline-iosched.c
> +++ b/block/deadline-iosched.c
> @@ -23,6 +23,11 @@ static const int writes_starved = 2;    /* max times reads can starve a write */
>  static const int fifo_batch = 16;       /* # of sequential requests treated as one
>                                     by the above parameters. For throughput. */
>
> +enum {
> +       REQ_ASYNC,
> +       REQ_SYNC,
> +};
> +
>  struct deadline_data {
>        /*
>         * run time data
> @@ -53,7 +58,7 @@ struct deadline_data {
>
>  static void deadline_move_request(struct deadline_data *, struct request *);
>
> -#define RQ_RB_ROOT(dd, rq)     (&(dd)->sort_list[rq_data_dir((rq))])
> +#define RQ_RB_ROOT(dd, rq)     (&(dd)->sort_list[rq_is_sync((rq))])
>
>  /*
>  * get the request after `rq' in sector-sorted order
> @@ -86,7 +91,7 @@ retry:
>  static inline void
>  deadline_del_rq_rb(struct deadline_data *dd, struct request *rq)
>  {
> -       const int data_dir = rq_data_dir(rq);
> +       const int data_dir = rq_is_sync(rq);
>
>        if (dd->next_rq[data_dir] == rq)
>                dd->next_rq[data_dir] = deadline_latter_request(rq);
> @@ -101,7 +106,7 @@ static void
>  deadline_add_request(struct request_queue *q, struct request *rq)
>  {
>        struct deadline_data *dd = q->elevator->elevator_data;
> -       const int data_dir = rq_data_dir(rq);
> +       const int data_dir = rq_is_sync(rq);
>
>        deadline_add_rq_rb(dd, rq);
>
> @@ -206,10 +211,10 @@ deadline_move_to_dispatch(struct deadline_data *dd, struct request *rq)
>  static void
>  deadline_move_request(struct deadline_data *dd, struct request *rq)
>  {
> -       const int data_dir = rq_data_dir(rq);
> +       const int data_dir = rq_is_sync(rq);
>
> -       dd->next_rq[READ] = NULL;
> -       dd->next_rq[WRITE] = NULL;
> +       dd->next_rq[REQ_SYNC] = NULL;
> +       dd->next_rq[REQ_ASYNC] = NULL;
>        dd->next_rq[data_dir] = deadline_latter_request(rq);
>
>        dd->last_sector = rq->sector + rq->nr_sectors;
> @@ -245,18 +250,18 @@ static inline int deadline_check_fifo(struct deadline_data *dd, int ddir)
>  static int deadline_dispatch_requests(struct request_queue *q, int force)
>  {
>        struct deadline_data *dd = q->elevator->elevator_data;
> -       const int reads = !list_empty(&dd->fifo_list[READ]);
> -       const int writes = !list_empty(&dd->fifo_list[WRITE]);
> +       const int reads = !list_empty(&dd->fifo_list[REQ_SYNC]);
> +       const int writes = !list_empty(&dd->fifo_list[REQ_ASYNC]);
>        struct request *rq;
>        int data_dir;
>
>        /*
>         * batches are currently reads XOR writes
>         */
> -       if (dd->next_rq[WRITE])
> -               rq = dd->next_rq[WRITE];
> +       if (dd->next_rq[REQ_ASYNC])
> +               rq = dd->next_rq[REQ_ASYNC];
>        else
> -               rq = dd->next_rq[READ];
> +               rq = dd->next_rq[REQ_SYNC];
>
>        if (rq) {
>                /* we have a "next request" */
> @@ -276,12 +281,12 @@ static int deadline_dispatch_requests(struct request_queue *q, int force)
>         */
>
>        if (reads) {
> -               BUG_ON(RB_EMPTY_ROOT(&dd->sort_list[READ]));
> +               BUG_ON(RB_EMPTY_ROOT(&dd->sort_list[REQ_SYNC]));
>
>                if (writes && (dd->starved++ >= dd->writes_starved))
>                        goto dispatch_writes;
>
> -               data_dir = READ;
> +               data_dir = REQ_SYNC;
>
>                goto dispatch_find_request;
>        }
> @@ -292,11 +297,11 @@ static int deadline_dispatch_requests(struct request_queue *q, int force)
>
>        if (writes) {
>  dispatch_writes:
> -               BUG_ON(RB_EMPTY_ROOT(&dd->sort_list[WRITE]));
> +               BUG_ON(RB_EMPTY_ROOT(&dd->sort_list[REQ_ASYNC]));
>
>                dd->starved = 0;
>
> -               data_dir = WRITE;
> +               data_dir = REQ_ASYNC;
>
>                goto dispatch_find_request;
>        }
> @@ -338,16 +343,16 @@ static int deadline_queue_empty(struct request_queue *q)
>  {
>        struct deadline_data *dd = q->elevator->elevator_data;
>
> -       return list_empty(&dd->fifo_list[WRITE])
> -               && list_empty(&dd->fifo_list[READ]);
> +       return list_empty(&dd->fifo_list[REQ_ASYNC])
> +               && list_empty(&dd->fifo_list[REQ_SYNC]);
>  }
>
>  static void deadline_exit_queue(elevator_t *e)
>  {
>        struct deadline_data *dd = e->elevator_data;
>
> -       BUG_ON(!list_empty(&dd->fifo_list[READ]));
> -       BUG_ON(!list_empty(&dd->fifo_list[WRITE]));
> +       BUG_ON(!list_empty(&dd->fifo_list[REQ_SYNC]));
> +       BUG_ON(!list_empty(&dd->fifo_list[REQ_ASYNC]));
>
>        kfree(dd);
>  }
> @@ -363,12 +368,12 @@ static void *deadline_init_queue(struct request_queue *q)
>        if (!dd)
>                return NULL;
>
> -       INIT_LIST_HEAD(&dd->fifo_list[READ]);
> -       INIT_LIST_HEAD(&dd->fifo_list[WRITE]);
> -       dd->sort_list[READ] = RB_ROOT;
> -       dd->sort_list[WRITE] = RB_ROOT;
> -       dd->fifo_expire[READ] = read_expire;
> -       dd->fifo_expire[WRITE] = write_expire;
> +       INIT_LIST_HEAD(&dd->fifo_list[REQ_SYNC]);
> +       INIT_LIST_HEAD(&dd->fifo_list[REQ_ASYNC]);
> +       dd->sort_list[REQ_SYNC] = RB_ROOT;
> +       dd->sort_list[REQ_ASYNC] = RB_ROOT;
> +       dd->fifo_expire[REQ_SYNC] = read_expire;
> +       dd->fifo_expire[REQ_ASYNC] = write_expire;
>        dd->writes_starved = writes_starved;
>        dd->front_merges = 1;
>        dd->fifo_batch = fifo_batch;
> @@ -403,8 +408,8 @@ static ssize_t __FUNC(elevator_t *e, char *page)                    \
>                __data = jiffies_to_msecs(__data);                      \
>        return deadline_var_show(__data, (page));                       \
>  }
> -SHOW_FUNCTION(deadline_read_expire_show, dd->fifo_expire[READ], 1);
> -SHOW_FUNCTION(deadline_write_expire_show, dd->fifo_expire[WRITE], 1);
> +SHOW_FUNCTION(deadline_read_expire_show, dd->fifo_expire[REQ_SYNC], 1);
> +SHOW_FUNCTION(deadline_write_expire_show, dd->fifo_expire[REQ_ASYNC], 1);
>  SHOW_FUNCTION(deadline_writes_starved_show, dd->writes_starved, 0);
>  SHOW_FUNCTION(deadline_front_merges_show, dd->front_merges, 0);
>  SHOW_FUNCTION(deadline_fifo_batch_show, dd->fifo_batch, 0);
> @@ -426,8 +431,8 @@ static ssize_t __FUNC(elevator_t *e, const char *page, size_t count)        \
>                *(__PTR) = __data;                                      \
>        return ret;                                                     \
>  }
> -STORE_FUNCTION(deadline_read_expire_store, &dd->fifo_expire[READ], 0, INT_MAX, 1);
> -STORE_FUNCTION(deadline_write_expire_store, &dd->fifo_expire[WRITE], 0, INT_MAX, 1);
> +STORE_FUNCTION(deadline_read_expire_store, &dd->fifo_expire[REQ_SYNC], 0, INT_MAX, 1);
> +STORE_FUNCTION(deadline_write_expire_store, &dd->fifo_expire[REQ_ASYNC], 0, INT_MAX, 1);
>  STORE_FUNCTION(deadline_writes_starved_store, &dd->writes_starved, INT_MIN, INT_MAX, 0);
>  STORE_FUNCTION(deadline_front_merges_store, &dd->front_merges, 0, 1, 0);
>  STORE_FUNCTION(deadline_fifo_batch_store, &dd->fifo_batch, 0, INT_MAX, 0);
>



-- 
Xie Gang
