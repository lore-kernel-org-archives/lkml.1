Return-Path: <linux-kernel-owner+w=401wt.eu-S1752984Ab0ATCrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984Ab0ATCrt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 21:47:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751958Ab0ATCrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 21:47:48 -0500
Received: from hera.kernel.org ([140.211.167.34]:54141 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944Ab0ATCrq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 21:47:46 -0500
Message-ID: <4B56703D.8000303@kernel.org>
Date: Wed, 20 Jan 2010 11:53:49 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Maxim Levitsky <maximlevitsky@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [block subsystem] Need help to prevent races on unexpected device
 removal
References: <1262546027.4555.17.camel@maxim-laptop>
In-Reply-To: <1262546027.4555.17.camel@maxim-laptop>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 20 Jan 2010 02:47:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing Jens) Hello,

Sorry about the late reply.  I tagged this while I was watching block
related mails a couple of weeks ago but forgot about this.

On 01/04/2010 04:13 AM, Maxim Levitsky wrote:
> During development of hotplug support for mtd translation layer I seems
> to be unable to figure a way to prevent following race:
> 
> First of all, a block device is registered. I attach a private structure
> to that device to save all internal information.

I suppose you're talking about struct gendisk and using
gendisk->private_data for the private data, right?

> Then out of the blue (when user pulls off the card) I receive a request
> to remove the device.
> 
> In the function that handles such removal, I do:
> 
> del_gendisk(...
> blk_start_queue
> 
> stop thread that processes the requests
> 
> blk_cleanup_queue(old->rq);
> 
> 
> The problem is that I don't know where/when to free the private
> structure.
> 
> I though about adding a field to the structure, with name 'invalid', so
> that release will not attempt to go futher, but free the structure, but
> what happens if release is never called?
> In other words this will work as long as there is a user of the block
> device.
> 
> I thought then that I can detect that condition and free the structure
> in the removal function itself, but then I get a race with ->open
> running in same time, and mutex will not prevent it, I will have to
> release it somwhen, and then ->open will access a freed structure....

On hotunplug, the driver should mark the device dead so that all
further operations coming from existing open fail and then put the
base reference.  On the final put which may happen either as part of
device destruction or release, the private data structure can be
destroyed while holding a mutex.  Open can be protected by grabbing
the mutex before dereferencing the private_data.

Thanks.

-- 
tejun
