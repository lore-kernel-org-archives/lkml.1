Return-Path: <linux-kernel-owner+w=401wt.eu-S1754905Ab0AEVsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab0AEVsN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 16:48:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754462Ab0AEVsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 16:48:12 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:44095 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179Ab0AEVsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 16:48:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=KJWW4lTmgUxwdfcCUP+FTLGPZ8ZYMW+sRz84GQzIuHf9ZczUznoC3FFhIIYUm9+sG9
         Sc1f7J5eeRbY9nv/YIlKhRKudFrdb4qXxgZr6CqB1/9MQZgDXLRkaDTChBFIkpsFrikm
         n1mE1JZv+6Z579igfL9Bcgreiqm2vD1OYDANk=
MIME-Version: 1.0
In-Reply-To: <x49y6kc6yib.fsf@segfault.boston.devel.redhat.com>
References: <20091230213439.GQ4489@kernel.dk>
	 <4e5e476b1001040836p2c8d7486x807a1a89b61c2458@mail.gmail.com>
	 <x49wrzxak5n.fsf@segfault.boston.devel.redhat.com>
	 <4e5e476b1001041037x6aa63be6ncfa523a7df78bb0d@mail.gmail.com>
	 <20100104185100.GF7968@redhat.com>
	 <x49fx6ladzk.fsf@segfault.boston.devel.redhat.com>
	 <4e5e476b1001041237v71952c8ewaaef3778353f7521@mail.gmail.com>
	 <x49zl4s8uoj.fsf@segfault.boston.devel.redhat.com>
	 <20100105151353.GA4631@redhat.com>
	 <x49y6kc6yib.fsf@segfault.boston.devel.redhat.com>
Date: Tue, 5 Jan 2010 22:48:06 +0100
Message-ID: <4e5e476b1001051348y4637986epb9b56958c738061a@mail.gmail.com>
Subject: Re: [PATCH] cfq-iosched: non-rot devices do not need read queue 
	merging
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <jens.axboe@oracle.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Shaohua Li <shaohua.li@intel.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 5, 2010 at 10:19 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
>
>> Thanks Jeff, one thing comes to mind. Now with recent changes, we drive deeper
>> depths on SSD with NCQ and there are not many pending cfqq on service tree
>> until and unless number of parallel threads exceed NCQ depth (32). If
>> that's the case, then I think we might not be seeing lot of queue merging
>> happening in this test case until and unless dump utility is creating more
>> than 32 threads.
>>
>> If time permits, it might also be interesting to run the same test with queue
>> depth 1 and see if SSDs without NCQ will suffer or not.
>
> Corrado, I think what Vivek is getting at is that you should check for
> both blk_queue_nonrot and cfqd->hw_tag (like in cfq_arm_slice_timer).
> Do you agree?
Well, actually I didn't want to distinguish on hw_tag here. I had to
still allow merging of writes exactly because a write merge can save
hundreds of ms on a non-NCQ SSD.

Vivek is right that on non-NCQ SSDs a successful merge would increase
the performance, but I still think that the likelyhood of a merge is
so low that maintaining the RB-tree is superfluous. Usually, those
devices are coupled with low-end CPUs, so saving the code execution
could be a win there too. I'll run some tests on my netbook.

BTW, I'm looking at read-test2 right now. I see it doesn't use direct
I/O, so it relies also on page cache. I think page cache can detect
the hidden sequential pattern, and thus send big readahead requests to
the device, making merging impossible (on my SSD, readahead size and
max hw request size match).

Thanks,
Corrado

>
> Cheers,
> Jeff
>
