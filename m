Return-Path: <linux-kernel-owner+w=401wt.eu-S1756820AbYHTNPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820AbYHTNPZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 09:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753243AbYHTNPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 09:15:14 -0400
Received: from hs-out-0708.google.com ([64.233.178.251]:51854 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793AbYHTNPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 09:15:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=gBrot/LBQmqT4IVnYtwDrk/d+VAli1O4E9SeXHH5T4E+1NObvG7FootVLGzz1osQy3
         AmiKlwHCRN1bw3KJjv1LYRItl47q9xOI+k73z7hYBB2BediVQUtRpWO5ksAaW1hsUu4i
         vNmt2LLdNqnrLQavt/0oS/PMxqLSN8nvzikIE=
Message-ID: <d4b6d3ea0808200615p1df9b41an6bf7d742c2e258dd@mail.gmail.com>
Date: Wed, 20 Aug 2008 09:15:10 -0400
From: "Michael Madore" <michael.madore@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: INFO: task blocked for more than 120 seconds
In-Reply-To: <d4b6d3ea0808191100m17ab13cbnb9a1a8a06f2e22e0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d4b6d3ea0808191100m17ab13cbnb9a1a8a06f2e22e0@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Committing a transaction would means writing rest of the meta-data in
>>> the transaction. And that would imply forcing most of the buffer_heads
>>> to disk in ordered mode. This can result a lot of seeks and make take
>>> more thatn 120 seconds.
>>
>>
>> Both Randy and Greg reported getting this for 2.6.27-rc but not
>> for 2.6.26.
>>
>> Why are people getting such messages for 2.6.27-rc but not for 2.6.26?
>
> Hi,
>
> I have reported getting these messages on 2.6.26:
>
> http://marc.info/?l=linux-kernel&m=121796211813099&w=2
>
> In addition to the system mentioned in that posting, I have just
> reproduced it by stress testing a system with 2 Opteron processors,
> 2GB of RAM and 2 SATA disks.
>
> Backing out this patch seems to help:
>
> commit cc19747977824ece6aa1c56a29e974fef5ec2b32
> Author: Jens Axboe <jens.axboe@oracle.com>
> Date:   Fri Apr 20 20:45:39 2007 +0200
>
>    cfq-iosched: tighten queue request overlap condition
>
>    For tagged devices, allow overlap of requests if the idle window
>    isn't enabled on the current active queue.
>
>    Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
>
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index a8237be..e859b49 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -989,7 +989,8 @@ static struct cfq_queue *cfq_select_queue(struct
> cfq_data *cfqd)
> * flight or is idling for a new request, allow either of these
> * conditions to happen (or time out) before selecting a new queue.
> */
> - if (cfqq->dispatched || timer_pending(&cfqd->idle_slice_timer)) {
> + if (timer_pending(&cfqd->idle_slice_timer) ||
> +     (cfqq->dispatched && cfq_cfqq_idle_window(cfqq))) {
> cfqq = NULL;
> goto keep_queue;
> }

Actually, I tested again with this commit reversed, and I'm still
seeing the problem.  Sorry for any confusion.

Mike
