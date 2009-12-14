Return-Path: <linux-kernel-owner+w=401wt.eu-S1757451AbZLNOwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757451AbZLNOwh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 09:52:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757370AbZLNOwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 09:52:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756932AbZLNOwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 09:52:34 -0500
Message-ID: <4B265119.6090901@redhat.com>
Date: Mon, 14 Dec 2009 09:52:09 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: lwoodman@redhat.com, kosaki.motohiro@jp.fujitsu.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, aarcange@redhat.com
Subject: Re: [PATCH] vmscan: limit concurrent reclaimers in shrink_zone
References: <20091210185626.26f9828a@cuia.bos.redhat.com> <20091214131444.GA8990@infradead.org>
In-Reply-To: <20091214131444.GA8990@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2009 08:14 AM, Christoph Hellwig wrote:
> On Thu, Dec 10, 2009 at 06:56:26PM -0500, Rik van Riel wrote:

>> It should be possible to avoid both of those issues at once, by
>> simply limiting how many processes are active in the page reclaim
>> code simultaneously.
>>
>
> This sounds like a very good argument against using direct reclaim at
> all.

Not completely possible.  Processes that call try_to_free_pages
without __GFP_FS or __GFP_IO in their gfp_flags may be holding
some kind of lock that kswapd could end up waiting on.

That means those tasks cannot wait on kswapd, because a deadlock
could happen.

Having said that, maybe we can get away with making direct
reclaim a limited subset of what it does today.  Kswapd could
be the only process scanning and unmapping ptes, submitting
IOs and scanning the active list.  Direct reclaim could limit
itself to reclaiming clean inactive pages and sleeping in
congestion_wait().

-- 
All rights reversed.
