Return-Path: <linux-kernel-owner+w=401wt.eu-S1756225AbZFDPpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225AbZFDPpS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 11:45:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753330AbZFDPpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 11:45:06 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37744 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151AbZFDPpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 11:45:05 -0400
Message-ID: <0921392c77890fc84fa69653ae4f31d9.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <20090604123625.GE7504@balbir.in.ibm.com>
References: <20090604141043.9a1064fd.kamezawa.hiroyu@jp.fujitsu.com>
    <20090604123625.GE7504@balbir.in.ibm.com>
Date: Fri, 5 Jun 2009 00:45:03 +0900 (JST)
Subject: Re: [PATCH] remove memory.limit v.s. memsw.limit comparison.
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-06-04
> 14:10:43]:
>
>> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>>
>> Removes memory.limit < memsw.limit at setting limit check completely.
>>
>> The limitation "memory.limit <= memsw.limit" was added just because
>> it seems sane ...if memory.limit > memsw.limit, only memsw.limit works.
>>
>> But To implement this limitation, we needed to use private mutex and
>> make
>> the code a bit complated.
>> As Nishimura pointed out, in real world, there are people who only want
>> to use memsw.limit.
>>
>> Then, this patch removes the check. user-land library or middleware can
>> check
>> this in userland easily if this really concerns.
>>
>> And this is a good change to charge-and-reclaim.
>>
>> Now, memory.limit is always checked before memsw.limit
>> and it may do swap-out. But, if memory.limit == memsw.limit, swap-out is
>> finally no help and hits memsw.limit again. So, let's allow the
>> condition
>> memory.limit > memsw.limit. Then we can skip unnecesary swap-out.
>>
>> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> ---
>
> There is one other option, we could set memory.limit_in_bytes ==
> memory.memsw.limit_in_bytes provided it is set to LONG_LONG_MAX. I am
> not convinced that we should allow memsw.limit_in_bytes to be less
> that limit_in_bytes, it will create confusion and the API is already
> exposed.
>
Ahhhh, I get your point.
 if memory.memsw.limit_in_bytes < memory.limit_in_bytes, no swap will
 be used bacause currnet try_to_free_pages() for memcg skips swap-out.
 Then, only global-LRU will use swap.
 This behavior is not easy to understand.

Sorry, I don't push this patch as this is. But adding documentation about
"What happens when you set memory.limit == memsw.limit" will be necessary.

...maybe give all jobs to user-land and keep the kernel as it is now
is a good choice.

BTW, I'd like to avoid useless swap-out in memory.limit == memsw.limit case.
If someone has good idea, please :(

Thanks,
-Kame


