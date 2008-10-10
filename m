Return-Path: <linux-kernel-owner+w=401wt.eu-S1756415AbYJJJcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756415AbYJJJcj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 05:32:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751554AbYJJJcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 05:32:31 -0400
Received: from ik-out-1112.google.com ([66.249.90.178]:6172 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbYJJJca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 05:32:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=f3klZCP1yBE6dhYnG64kyCh+2hMvIYIcpynUsRgAG8BFroYQcvkZBa39jk9epF0zgT
         dOJc3kOdyeAUJVZky3wbzPlAvPgnaYSK7FCvNNXj7fMWfzLifXUKNlyv+Dsk4A5Pr97G
         cRWnYMhVDh1ZEf45owb+Du9n37qOMk3nWZWlM=
Message-ID: <48EF2138.9050307@gmail.com>
Date: Fri, 10 Oct 2008 11:32:40 +0200
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: balbir@linux.vnet.ibm.com, Michael Rubin <mrubin@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, menage@google.com,
       dave@linux.vnet.ibm.com, chlunde@ping.uio.no, dpshah@google.com,
       eric.rannaud@gmail.com, fernando@oss.ntt.co.jp, agk@sourceware.org,
       m.innocenti@cineca.it, s-uchida@ap.jp.nec.com, ryov@valinux.co.jp,
       matt@bluehost.com, dradford@bluehost.com,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm] page-writeback: fine-grained dirty_ratio and dirty_background_ratio
References: <1221232192-13553-1-git-send-email-righi.andrea@gmail.com>	<20080912131816.e0cfac7a.akpm@linux-foundation.org>	<532480950809221641y3471267esff82a14be8056586@mail.gmail.com>	<48EB4236.1060100@linux.vnet.ibm.com>	<48EB851D.2030300@gmail.com>	<20081008101642.fcfb9186.kamezawa.hiroyu@jp.fujitsu.com>	<48ECB215.4040409@linux.vnet.ibm.com>	<48EE236A.90007@gmail.com> <20081010094139.e7f8653d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081010094139.e7f8653d.kamezawa.hiroyu@jp.fujitsu.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> <snip>
> 
>> -int dirty_background_ratio = 5;
>> +int dirty_background_ratio = 5 * PERCENT_PCM;
>>  
>>  /*
>>   * free highmem will not be subtracted from the total free memory
>> @@ -77,7 +77,7 @@ int vm_highmem_is_dirtyable;
>>  /*
>>   * The generator of dirty data starts writeback at this percentage
>>   */
>> -int vm_dirty_ratio = 10;
>> +int vm_dirty_ratio = 10 * PERCENT_PCM;
>>  
>>  /*
>>   * The interval between `kupdate'-style writebacks, in jiffies
>> @@ -135,7 +135,8 @@ static int calc_period_shift(void)
>>  {
>>  	unsigned long dirty_total;
>>  
>> -	dirty_total = (vm_dirty_ratio * determine_dirtyable_memory()) / 100;
>> +	dirty_total = (vm_dirty_ratio * determine_dirtyable_memory())
>> +			/ ONE_HUNDRED_PCM;
>>  	return 2 + ilog2(dirty_total - 1);
>>  }
>>  
> I wonder...isn't this overflow in 32bit system ?

Correct! the worst case is (in pages):

4GB = 100,000 * determine_dirtyable_memory()

that means 42950 pages (~168MB) of dirtyable memory is enough to overflow :(.
Using an u64 for dirty_total should resolve.

Delta patch is below.

Unfortunately I have all 64-bit machines right now. Maybe tomorrow I'll
be able to get a 32-bit box, if someone doesn't test this before.

Thanks!
-Andrea

---
Subject: fix overflow in 32-bit systems using fine-grained dirty_ratio

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/page-writeback.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 6bc8c9b..29913e5 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -133,7 +133,7 @@ static struct prop_descriptor vm_dirties;
  */
 static int calc_period_shift(void)
 {
-	unsigned long dirty_total;
+	u64 dirty_total;
 
 	dirty_total = (vm_dirty_ratio * determine_dirtyable_memory())
 			/ ONE_HUNDRED_PCM;
