Return-Path: <linux-kernel-owner+w=401wt.eu-S1753789AbZLROJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789AbZLROJ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 09:09:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753572AbZLROJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 09:09:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34271 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753538AbZLROJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 09:09:56 -0500
Message-ID: <4B2B8D2A.1020804@redhat.com>
Date: Fri, 18 Dec 2009 09:09:46 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: lwoodman@redhat.com, LKML <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org, linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH v2] vmscan: limit concurrent reclaimers in shrink_zone
References: <20091217193818.9FA9.A69D9226@jp.fujitsu.com> <4B2A22C0.8080001@redhat.com> <20091218184046.6547.A69D9226@jp.fujitsu.com>
In-Reply-To: <20091218184046.6547.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2009 05:27 AM, KOSAKI Motohiro wrote:
>> KOSAKI Motohiro wrote:

>> Finally, having said all that, the system still struggles reclaiming
>> memory with
>> ~10000 processes trying at the same time, you fix one bottleneck and it
>> moves
>> somewhere else.  The latest run showed all but one running process
>> spinning in
>> page_lock_anon_vma() trying for the anon_vma_lock.  I noticed that there
>> are
>> ~5000 vma's linked to one anon_vma, this seems excessive!!!
>>
>> I changed the anon_vma->lock to a rwlock_t and page_lock_anon_vma() to use
>> read_lock() so multiple callers could execute the page_reference_anon code.
>> This seems to help quite a bit.
>
> Ug. no. rw-spinlock is evil. please don't use it. rw-spinlock has bad
> performance characteristics, plenty read_lock block write_lock for very
> long time.
>
> and I would like to confirm one thing. anon_vma design didn't change
> for long year. Is this really performance regression? Do we strike
> right regression point?

In 2.6.9 and 2.6.18 the system would hit different contention
points before getting to the anon_vma lock.  Now that we've
gotten the other contention points out of the way, this one
has finally been exposed.

-- 
All rights reversed.
