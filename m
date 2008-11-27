Return-Path: <linux-kernel-owner+w=401wt.eu-S1752637AbYK0G1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbYK0G1j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 01:27:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751380AbYK0G1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 01:27:31 -0500
Received: from gw-ca.panasas.com ([66.104.249.162]:17236 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751290AbYK0G1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 01:27:30 -0500
Message-ID: <492E3DE7.9040107@panasas.com>
Date: Thu, 27 Nov 2008 08:27:51 +0200
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Thunderbird 3.0a1 (X11/2008050714)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: WARN_ON out of range error in ERR_PTR?
References: <492D6FB8.80401@panasas.com> <20081126161503.6211f140.akpm@linux-foundation.org>
In-Reply-To: <20081126161503.6211f140.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Nov 2008 06:26:02.0977 (UTC) FILETIME=[0567CD10:01C95059]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov. 27, 2008, 2:15 +0200, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed, 26 Nov 2008 17:48:08 +0200
> Benny Halevy <bhalevy@panasas.com> wrote:
> 
>> Andrew,
>>
>> After hitting a bug where an nfs error -10021 wasn't handled
>> correctly since IS_ERR returned false on its ERR_PTR value
> 
> That sounds like an error in NFS.  Did it get fixed?

Right, it is an error I made when developing new code for nfs41
and I caught and fixed it in my branch before releasing the code.
I just thought that this WARN_ON could be beneficial for everybody...

Benny

> 
>> I realized that adding a BUG_ON to make sure the mapped error
>> is in the valid range would have caught this.
>>
>> Since ERR_PTR is not called on the critical path
>> (unlike IS_ERR) but rather on the error handling path I believe
>> we can tolerate the extra cost.
>>
>> The reason this is just a WARN_ON and not BUG_ON is to make
>> fixing it easier, although I do consider calling ERR_PTR on an
>> out of range error a pretty dangerous bug as the error might go
>> unnoticed.
>>
>> How about committing the following patch to -mm?
>>
>> Signed-off-by: Benny Halevy <bhalevy@panasas.com>
>> ---
>>  include/linux/err.h |    3 ++-
>>  1 files changed, 2 insertions(+), 1 deletions(-)
>>
>> diff --git a/include/linux/err.h b/include/linux/err.h
>> index ec87f31..81df84f 100644
>> --- a/include/linux/err.h
>> +++ b/include/linux/err.h
>> @@ -2,7 +2,7 @@
>>  #define _LINUX_ERR_H
>>  
>>  #include <linux/compiler.h>
>> -
>> +#include <asm/bug.h>
>>  #include <asm/errno.h>
>>  
>>  /*
>> @@ -21,6 +21,7 @@
>>  
>>  static inline void *ERR_PTR(long error)
>>  {
>> +	WARN_ON(error && !IS_ERR_VALUE(error));
>>  	return (void *) error;
>>  }
> 
> We have over 2000 ERR_PTR callsites, and WARN_ON() is a big fat porky
> thing, so this change would add quite a lot of kernel text&data.
> 
> If this problem does occur again, I expect that the kernel will
> reliably dereference a small negative address and we'll get an oops,
> which will give us the same information as that WARN_ON would have
> done, no?
> 
> 
> 
