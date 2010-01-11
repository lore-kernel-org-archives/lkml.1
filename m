Return-Path: <linux-kernel-owner+w=401wt.eu-S1753193Ab0AKOq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193Ab0AKOq2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 09:46:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753100Ab0AKOq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 09:46:27 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:36709 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467Ab0AKOq0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 09:46:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qG8VW2CxTJF54Z5qT7sN5IgPZ6srTsnmGL9Urs5FPUR2jOJUXdBDi9yYBzWdDUhruD
         qwt5RRUOOVvVa5jiuXyJPo6r9H9YKN6q10lmWkEUIgaPoXNdOekfWx+w1KroZru0b1oW
         CGg1yJG1g3M1kXmxsWe0ILfiYRSWGpjME578I=
MIME-Version: 1.0
In-Reply-To: <20100111014730.GA22362@sli10-desk.sh.intel.com>
References: <1263052757-23436-1-git-send-email-czoccolo@gmail.com>
	 <20100111014730.GA22362@sli10-desk.sh.intel.com>
Date: Mon, 11 Jan 2010 15:46:23 +0100
Message-ID: <4e5e476b1001110646i20c2bcf4n51380853820c29d8@mail.gmail.com>
Subject: Re: [PATCH] cfq-iosched: rework seeky detection
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Yanmin Zhang <yanmin_zhang@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On Mon, Jan 11, 2010 at 2:47 AM, Shaohua Li <shaohua.li@intel.com> wrote:
> On Sat, Jan 09, 2010 at 11:59:17PM +0800, Corrado Zoccolo wrote:
>> Current seeky detection is based on average seek lenght.
>> This is suboptimal, since the average will not distinguish between:
>> * a process doing medium sized seeks
>> * a process doing some sequential requests interleaved with larger seeks
>> and even a medium seek can take lot of time, if the requested sector
>> happens to be behind the disk head in the rotation (50% probability).
>>
>> Therefore, we change the seeky queue detection to work as follows:
>> * each request can be classified as sequential if it is very close to
>>   the current head position, i.e. it is likely in the disk cache (disks
>>   usually read more data than requested, and put it in cache for
>>   subsequent reads). Otherwise, the request is classified as seeky.
>> * an history window of the last 32 requests is kept, storing the
>>   classification result.
>> * A queue is marked as seeky if more than 1/8 of the last 32 requests
>>   were seeky.
>>
>> This patch fixes a regression reported by Yanmin, on mmap 64k random
>> reads.
> Can we not count a big request (say the request data is >= 32k) as seeky
> regardless the seek distance? In this way we can also make a 64k random sync
> read not as seeky.
I think I understand what you are proposing, but I don't think request
size should
matter at all for rotational disk.
Usually, the disk firmware will load a big chunk of data in its cache even when
requested to read a single sector, and will provide following ones
from the cache
if you read them sequentially.

Now, in CFQ, what we really mean by saying that a queue is seeky is that
waiting a bit in order to serve an other request from this queue doesn't
give any benefit w.r.t. switching to an other queue.

So, if you read a single 64k block from disk and then seek, then you can service
any other request without losing bandwidth.
Instead, if you are reading 4k, then the next ones (and so on up to 64k, as it
happens with mmap when you fault in a single page at a time), then it
is convenient
to wait for the next request, since it has 3/4 of changes to be
sequential, so be
serviced by cache.

I'm currently testing a patch to consider request size in SSDs, instead.
In SSDs, the location of the request doesn't mean anything, but the
size is meaningful.
Therefore, submitting together many small requests from different
queues can improve
the overall performance.

Thanks,
Corrado

>
> Thanks,
> Shaohua
>
