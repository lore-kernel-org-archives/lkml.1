Return-Path: <linux-kernel-owner+w=401wt.eu-S1755270AbYJGN6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270AbYJGN6h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 09:58:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753397AbYJGN6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 09:58:25 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59774 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426AbYJGN6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 09:58:23 -0400
Message-ID: <48EB6A52.6080707@redhat.com>
Date: Tue, 07 Oct 2008 09:55:30 -0400
From: Peter Staubach <staubach@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20080915)
MIME-Version: 1.0
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
CC: Christoph Hellwig <hch@infradead.org>,
       Chris Mason <chris.mason@oracle.com>,
       Dave Chinner <david@fromorbit.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH] Improve buffered streaming write ordering
References: <1222886451.9158.34.camel@think.oraclecorp.com> <20081001215239.ee2ae63f.akpm@linux-foundation.org> <1222950054.6745.18.camel@think.oraclecorp.com> <20081002181856.GB29613@skywalker> <20081002234309.GH30001@disturbed> <1223063155.13375.64.camel@think.oraclecorp.com> <20081006101605.GA15881@skywalker> <1223302903.16546.58.camel@think.oraclecorp.com> <20081007084531.GB15881@skywalker> <20081007090554.GA23811@infradead.org> <20081007100257.GA30745@skywalker>
In-Reply-To: <20081007100257.GA30745@skywalker>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aneesh Kumar K.V wrote:
> On Tue, Oct 07, 2008 at 05:05:54AM -0400, Christoph Hellwig wrote:
>   
>> On Tue, Oct 07, 2008 at 02:15:31PM +0530, Aneesh Kumar K.V wrote:
>>     
>>> +static int ext4_write_cache_pages(struct address_space *mapping,
>>> +		      struct writeback_control *wbc, writepage_t writepage,
>>> +		      void *data)
>>> +{
>>>       
>> Looking at this functions the only difference is killing the
>> writeback_index and range_start updates.  If they are bad why would we
>> only remove them from ext4?
>>     
>
> I am also not updating wbc->nr_to_write.
>
> ext4 delayed allocation writeback is bit tricky. It does
>
> a) Look at the dirty pages and build an in memory extent of contiguous
> logical file blocks. If we use writecache_pages to do that it will
> update nr_to_write, writeback_index etc during this stage.
>
> b) Request the block allocator for 'x' blocks. We get the value x from
> step a.
>
> c) block allocator may return less than 'x' contiguous block. That would
> mean the variables updated by write_cache_pages need to corrected. The
> old code was doing that. Chris Mason suggested it would make it easy
> to use a write_cache_pages which doesn't update the variable for ext4.
>
> I don't think other filesystem have this requirement.

The NFS client can benefit from only writing pages in strictly
ascending offset order.  The benefit comes from helping the
server to do better allocations by not sending file data to the
server in random order.

There is also an NFS server in the market which requires data
to be sent in strict ascending offset order.  This sort of
support would make interoperating with that server much easier.

    Thanx...

       ps
