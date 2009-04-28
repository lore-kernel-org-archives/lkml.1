Return-Path: <linux-kernel-owner+w=401wt.eu-S1753243AbZD1Mnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243AbZD1Mnz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 08:43:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754898AbZD1Mno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 08:43:44 -0400
Received: from galaxy-old.riz.pl ([195.94.202.2]:57464 "HELO vhost.riz.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754382AbZD1Mnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 08:43:43 -0400
Date: Tue, 28 Apr 2009 14:43:37 +0200 (CEST)
From: Bart <mmx@riz.pl>
X-X-Sender: evil@galaxy.riz.pl
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
cc: rientjes@google.com, cl@linux.com, penberg@cs.helsinki.fi,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       rjw@sisk.pl, akpm@linux-foundation.org, jens.axboe@oracle.com
Subject: Re: [Bug #13112] Oops in drain_array
In-Reply-To: <20090428171139N.fujita.tomonori@lab.ntt.co.jp>
Message-ID: <Pine.LNX.4.64.0904281425040.2455@galaxy.riz.pl>
References: <alpine.DEB.1.10.0904271000200.16119@qirst.com>
 <Pine.LNX.4.64.0904271849590.2455@galaxy.riz.pl>
 <alpine.DEB.2.00.0904271327140.11650@chino.kir.corp.google.com>
 <20090428171139N.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 27 Apr 2009 13:36:46 -0700 (PDT)
> David Rientjes <rientjes@google.com> wrote:
>
>> On Mon, 27 Apr 2009, Bart wrote:
>>
>>> After turning the suggested debuging options I've got tons of these when
>>> trying to stress the tape device like before:
>>>
>>> Apr 27 16:57:30 fs kernel: [   96.446708] slab error in verify_redzone_free():
>>> cache `size-128': memory outside object was overwritten
>>> Apr 27 16:57:30 fs kernel: [   96.446713] Pid: 0, comm: swapper Not tainted
>>> 2.6.29.1-64 #2
>>> Apr 27 16:57:30 fs kernel: [   96.446715] Call Trace:
>>> Apr 27 16:57:30 fs kernel: [   96.446717]  <IRQ>  [<ffffffff8029adc5>]
>>> __slab_error+0x1f/0x25
>>> Apr 27 16:57:30 fs kernel: [   96.446728]  [<ffffffff8029b24b>]
>>> cache_free_debugcheck+0x108/0x1d6
>>> Apr 27 16:57:30 fs kernel: [   96.446731]  [<ffffffff8029b473>]
>>> kfree+0x81/0xc2
>>> Apr 27 16:57:30 fs kernel: [   96.446735]  [<ffffffff802bd311>]
>>> bio_free_map_data+0xc/0x1e
>>
>> This appears to be kfree(bmd->iovecs) in bio_free_map_data().  It looks
>> like the memcpy size in bio_set_map_data() overrides the kmalloc size; in
>> other words, for a redzone error, bio->bi_vcnt > nr_pages in
>> bio_copy_user_iov().
>
> Can you try this?
>
> diff --git a/fs/bio.c b/fs/bio.c
> index 7bbc98f..6a09356 100644
> --- a/fs/bio.c
> +++ b/fs/bio.c
> @@ -817,6 +817,9 @@ struct bio *bio_copy_user_iov(struct request_queue *q,
> 		len += iov[i].iov_len;
> 	}
>
> +	if (offset)
> +		nr_pages += 1;
> +
> 	bmd = bio_alloc_map_data(nr_pages, iov_count, gfp_mask);
> 	if (!bmd)
> 		return ERR_PTR(-ENOMEM);
>

There are no more errors in the dmesg after applying this patch to 
2.6.29.2.

Without this patch I can reproduce this kind of errors on 
2.6.29.1, 2.6.29.2.

I've not tested this patch with 2.6.29.1 and 2.6.30rc3-git3.
I will try to reproduce the error on 2.6.30rc3-git3 as soon as I compile 
it.

-- 
  Regards
  Bart mmx@riz.pl
