Return-Path: <linux-kernel-owner+w=401wt.eu-S1756868AbYH1UiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868AbYH1UiT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 16:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755091AbYH1UiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 16:38:11 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:27803 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754358AbYH1UiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 16:38:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=Tf7hzd+xUVu06MqwoXCC3MoNYK4c2tmhZOuBtsnKHTxOjHOa6yeCJHb94SKS1XcoSf
         tGk33AUpQ2tagNKZvs0nMYxzAbh5b+/NaPdynqYx0NilnMWJ4T+0nTzsBw1O9mDQIYXO
         iR/MwLHE5izVkItcAKgRciqZI6B4rS7o7Iw8Y=
Message-ID: <7b5883fc0808281338l4cd77a8k99fa0b03a0eca03c@mail.gmail.com>
Date: Thu, 28 Aug 2008 23:38:07 +0300
From: "Roni Feldman" <roni.feldman+lkml@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Too many stupid questions about the block layer
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: e52b3bded615bd76
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello list,

This is pretty long -- I sure hope this is the right place to ask these :)

First of all, I have a board with a NAND flash device, to which I have
a 8k-wide PCI interface.
I've been wondering about these:

1. I would prefer if the block layer always passed me 8k long
segments, even though the hard sector size is 2k. I tried using
blk_queue_hardsect_size() and set it to 8k, but for some reason I get
a panic. Is it possible that hardsect cannot be larger than PAGE_SIZE
(makes some sense)? Or is it just a bug of mine?

2. (This is in case I can't have 8k-one-segment-bios/requests) I'm not
sure whether I should implement request_fn() or make_request_fn(),
since although the device is flash, there's sense in writing
consecutive sectors in one go - with each write of a block of sectors,
the devices erases a whole erase block, which is the size of many
sectors. More writes of consecutive sectors means we don't erase the
same erase block as much. Can I get the same "segment merging"
functionality from the block layer if I use make_request() instead of
request()?

3. I want to handle requests in a kernel thread, one by one. Ideally,
I would just pass the request to my kthread, and call blk_stop_queue
(since I can only handle one request at a time). In my kthread, I will
issue a DMA transfer for the request and in the end call
blk_end_request(), and the blk_start_queue(). But can the block layer
somehow add bio's to my request while the kthread runs? Is there a way
to lock the request (maybe blkdev_dequeue_request)? Am I even on the
right track?

Thanks for your time,
-- Roni Feldman
