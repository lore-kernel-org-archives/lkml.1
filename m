Return-Path: <linux-kernel-owner+w=401wt.eu-S1754262AbYGNMQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262AbYGNMQ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 08:16:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752753AbYGNMQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 08:16:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33075 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752450AbYGNMQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 08:16:46 -0400
Date: Mon, 14 Jul 2008 08:16:13 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@devserv.devel.redhat.com
To: David Miller <davem@davemloft.net>
cc: andi@firstfloor.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: [SUGGESTION]: drop virtual merge accounting in I/O requests
In-Reply-To: <20080713.174855.234796356.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0807140805380.10106@devserv.devel.redhat.com>
References: <20080713.124610.193703496.davem@davemloft.net>
 <487A61DD.6090304@firstfloor.org> <Pine.LNX.4.64.0807131947090.7803@devserv.devel.redhat.com>
 <20080713.174855.234796356.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Jul 2008, David Miller wrote:

> From: Mikulas Patocka <mpatocka@redhat.com>
> Date: Sun, 13 Jul 2008 19:53:01 -0400 (EDT)
>
>> There is no need to turn BIO merge off --- the problem is caused by
>> accounting of BIO merging in block layer, not by BIO merging itself.
>>
>> Just do #define BIO_VMERGE_BOUNDARY 0, and that disables the accounting,
>> but leaves merging as it is.
>
> For the thousanth time, the BIO_VMERGE_BOUNDARY code is useful
> and worked perfectly fine before segment boundary handling was
> added to the block layer.
>
> It's a regression, and as such should be fixed or the guilty
> code reverted.
>
> Since when do we say "sorry that got broken, turn it off, thanks"
> ?

And which was the supposed "working" kernel version?

In current kernel there are three conditions that can cause merge failure 
(and possible crash as a result):
1. dma_addr != dma_next --- skipping over an allocated entry
2. outs->dma_length + s->length > max_seg_size --- max segment size, this 
is what I was hitting
3. is_span_boundary(out_entry, base_shift, seg_boundary_size, outs, s) --- 
a devices that have special dma_get_seg_boundary(dev)

So, show me a sparc64 kernel where none of these conditions existed and 
where merge-accounting was bug-free.

I suppose that before condition (2) was added, the conditions (1) and (3) 
still existed, making crashes still possible, although not as common as 
with condition (2). But if you want to show me otherwise --- a bug-free 
implementation of merge accounting --- just do it.

> For the thousanth time, the BIO_VMERGE_BOUNDARY code is useful

Where? BIO_VMERGE_BOUNDARY has nothing to do with actual merging (the 
merging happens with or without it BIO_VMERGE_BOUNDARY).

As you mentioned ESP driver, it declares .sg_tablesize = SG_ALL, so 
BIO_VMERGE_BOUNDARY has no effect on the operation of this driver. Any 
other driver where BIO_VMERGE_BOUNDARY does matter?

Mikulas
