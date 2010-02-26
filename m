Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965899Ab0BZTnM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 14:43:12 -0500
Received: from mail-pz0-f172.google.com ([209.85.222.172]:56239 "EHLO
	mail-pz0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965843Ab0BZTnL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 14:43:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=PzApdVjqVEsbqsgtAEcWHNjErEpPSob5r+hgcpA6x6NhPSVL8ftxUCNnzkFt1go657
         7eI84WCH64/FVunOMgqDoJ9Ct3V5rrTijpvwrRQz4FqBtY/x/AuwZ2L612UJGkLwDE3t
         En73bAEpxcu0thfP62+RGRhQVLaHXlslubDHM=
MIME-Version: 1.0
In-Reply-To: <1267211701.3124.204.camel@iscandar.digidescorp.com>
References: <1267139849.3079.68.camel@iscandar.digidescorp.com>
	 <alpine.DEB.2.00.1002251544120.25189@chino.kir.corp.google.com>
	 <20100226102745.GC8417@bicker>
	 <1267211701.3124.204.camel@iscandar.digidescorp.com>
Date: Fri, 26 Feb 2010 12:43:10 -0700
X-Google-Sender-Auth: 431a3464b1bf37b5
Message-ID: <e9c3a7c21002261143w9a4cc29ha738e84496ef5c4c@mail.gmail.com>
Subject: Re: Buggy variable-length array code...or compiler?
From: Dan Williams <dan.j.williams@intel.com>
To: steve@digidescorp.com
Cc: Dan Carpenter <error27@gmail.com>, David Rientjes <rientjes@google.com>,
       linux-kernel@vger.kernel.org, microblaze-uclinux@itee.uq.edu.au,
       Dave Hansen <dave@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 26, 2010 at 12:15 PM, Steven J. Magnani
<steve@digidescorp.com> wrote:
> On Thu, 25 Feb 2010, Steven J. Magnani wrote:
>> >
>> > > When I run a memcpy dmatest with a Microblaze 2.6.33 noMMU kernel, the
>> > > system crashes after about 400 iterations. After much head scratching, I
>> > > believe I've narrowed the problem to this fragment of code in
>> > > drivers/dma/dmatest.c:
>> > >
>> > > static int dmatest_func(void *data)
>> > > {
>> > > ...
>> > >     int                     src_cnt;
>> > >     int                     dst_cnt;
>> > > ...
>> > >     if (thread->type == DMA_MEMCPY)
>> > >             src_cnt = dst_cnt = 1;
>> > > ...
>> > >     while (!kthread_should_stop()
>> > >            && !(iterations && total_tests >= iterations)) {
>> > > ...
>> > >             dma_addr_t dma_srcs[src_cnt];
>> > >             dma_addr_t dma_dsts[dst_cnt];
>> > > ...
>
> On Thu, Feb 25, 2010 at 03:46:48PM -0800, David Rientjes wrote:
>> > This could probably become the first kernel user of the flexible array
>> > library (see Documentation/flexible-arrays.txt).  Dan?
>> > --
>
> On Fri, 2010-02-26 at 13:27 +0300, Dan Carpenter wrote:
>> I think the max that src_cnt can be is 3 and the most dst_cnt can be is 2.
>> We could just put that there.
>
> src_cnt is dependent on module parameters.
>
> The bug goes away if dma_srcs and dma_dsts are declared outside the
> loop, but that requires knocking the loop in another tabstop. At that
> point dmatest_func() would be begging for refactoring.
>

...and even if you refactored it there is no guarantee that gcc would
not re-inline the functions and put you back in the same situation.
Especially given the finding that J.A.'s simple test, where the size
of the array should have been constant, still failed.

--
Dan
