Return-Path: <linux-kernel-owner+w=401wt.eu-S1754578AbYJGOn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578AbYJGOn2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 10:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbYJGOnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 10:43:18 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:57003 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbYJGOnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 10:43:16 -0400
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Chris Mason <chris.mason@oracle.com>,
       Dave Chinner <david@fromorbit.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       ext4 <linux-ext4@vger.kernel.org>
Message-Id: <D59BBC1C-956F-4D17-821A-669356CBECF2@oracle.com>
From: Chuck Lever <chuck.lever@oracle.com>
To: Peter Staubach <staubach@redhat.com>
In-Reply-To: <48EB6A52.6080707@redhat.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: [PATCH] Improve buffered streaming write ordering
Date: Tue, 7 Oct 2008 10:38:00 -0400
References: <1222886451.9158.34.camel@think.oraclecorp.com> <20081001215239.ee2ae63f.akpm@linux-foundation.org> <1222950054.6745.18.camel@think.oraclecorp.com> <20081002181856.GB29613@skywalker> <20081002234309.GH30001@disturbed> <1223063155.13375.64.camel@think.oraclecorp.com> <20081006101605.GA15881@skywalker> <1223302903.16546.58.camel@think.oraclecorp.com> <20081007084531.GB15881@skywalker> <20081007090554.GA23811@infradead.org> <20081007100257.GA30745@skywalker> <48EB6A52.6080707@redhat.com>
X-Mailer: Apple Mail (2.929.2)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 7, 2008, at Oct 7, 2008, 9:55 AM, Peter Staubach wrote:

> Aneesh Kumar K.V wrote:
>> On Tue, Oct 07, 2008 at 05:05:54AM -0400, Christoph Hellwig wrote:
>>
>>> On Tue, Oct 07, 2008 at 02:15:31PM +0530, Aneesh Kumar K.V wrote:
>>>
>>>> +static int ext4_write_cache_pages(struct address_space *mapping,
>>>> +		      struct writeback_control *wbc, writepage_t writepage,
>>>> +		      void *data)
>>>> +{
>>>>
>>> Looking at this functions the only difference is killing the
>>> writeback_index and range_start updates.  If they are bad why  
>>> would we
>>> only remove them from ext4?
>>>
>>
>> I am also not updating wbc->nr_to_write.
>>
>> ext4 delayed allocation writeback is bit tricky. It does
>>
>> a) Look at the dirty pages and build an in memory extent of  
>> contiguous
>> logical file blocks. If we use writecache_pages to do that it will
>> update nr_to_write, writeback_index etc during this stage.
>>
>> b) Request the block allocator for 'x' blocks. We get the value x  
>> from
>> step a.
>>
>> c) block allocator may return less than 'x' contiguous block. That  
>> would
>> mean the variables updated by write_cache_pages need to corrected.  
>> The
>> old code was doing that. Chris Mason suggested it would make it easy
>> to use a write_cache_pages which doesn't update the variable for  
>> ext4.
>>
>> I don't think other filesystem have this requirement.
>
> The NFS client can benefit from only writing pages in strictly
> ascending offset order.  The benefit comes from helping the
> server to do better allocations by not sending file data to the
> server in random order.

For the record, it would also help prevent the creation of temporary  
holes in O_APPEND files.

If an NFS client writes the front and back ends of a request before it  
writes the middle, other clients will see a temporary hole in that  
file.  Applications (especially simple ones like "tail") are often not  
prepared for the appearance of such holes.

Over a client crash, data integrity would improve if the client was  
less likely to create temporary holes in files.

> There is also an NFS server in the market which requires data
> to be sent in strict ascending offset order.  This sort of
> support would make interoperating with that server much easier.

-- 
Chuck Lever
chuck[dot]lever[at]oracle[dot]com
