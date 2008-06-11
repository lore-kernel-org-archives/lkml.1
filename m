Return-Path: <linux-kernel-owner+w=401wt.eu-S1752668AbYFKURS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbYFKURS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 16:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751546AbYFKURH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 16:17:07 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:42284 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbYFKURF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 16:17:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=SsEYsPmdX3SSHWN1pPjJOotxefSv1bjkmjEOZp1aVH3LWKV+2q6TQlQNRIU3eSg9Q6
         udhziSSaNSrolZeusHxdLPx02AMGjrNeND/EQcMTGRAzZiIrvKBImMBwNdYhcY4ZA6bX
         yDBnRplVhSrH80MuBU73R8QD2LYdBizLe+jPQ=
Message-ID: <485032C8.4010001@gmail.com>
Date: Wed, 11 Jun 2008 22:17:12 +0200
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Swiftdove 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: balbir@linux.vnet.ibm.com, linux-mm@kvack.org, skumar@linux.vnet.ibm.com,
       yamamoto@valinux.co.jp, menage@google.com, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, xemul@openvz.org,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [-mm][PATCH 2/4] Setup the memrlimit controller (v5)
References: <20080521152921.15001.65968.sendpatchset@localhost.localdomain>	<20080521152948.15001.39361.sendpatchset@localhost.localdomain>	<4850070F.6060305@gmail.com> <20080611121510.d91841a3.akpm@linux-foundation.org>
In-Reply-To: <20080611121510.d91841a3.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 11 Jun 2008 19:10:40 +0200 (MEST)
> Andrea Righi <righi.andrea@gmail.com> wrote:
> 
>> Balbir Singh wrote:
>>> +static int memrlimit_cgroup_write_strategy(char *buf, unsigned long long *tmp)
>>> +{
>>> +	*tmp = memparse(buf, &buf);
>>> +	if (*buf != '\0')
>>> +		return -EINVAL;
>>> +
>>> +	*tmp = PAGE_ALIGN(*tmp);
>>> +	return 0;
>>> +}
>> We shouldn't use PAGE_ALIGN() here, otherwise we limit the address space
>> to 4GB on 32-bit architectures (that could be reasonable, because this
>> is a per-cgroup limit and not per-process).
>>
>> Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
>> ---
>>  mm/memrlimitcgroup.c |    4 +++-
>>  1 files changed, 3 insertions(+), 1 deletions(-)
>>
>> diff --git a/mm/memrlimitcgroup.c b/mm/memrlimitcgroup.c
>> index 9a03d7d..2d42ff3 100644
>> --- a/mm/memrlimitcgroup.c
>> +++ b/mm/memrlimitcgroup.c
>> @@ -29,6 +29,8 @@
>>  #include <linux/res_counter.h>
>>  #include <linux/memrlimitcgroup.h>
>>  
>> +#define PAGE_ALIGN64(addr) (((((addr)+PAGE_SIZE-1))>>PAGE_SHIFT)<<PAGE_SHIFT)
>> +
>>  struct cgroup_subsys memrlimit_cgroup_subsys;
>>  
>>  struct memrlimit_cgroup {
>> @@ -124,7 +126,7 @@ static int memrlimit_cgroup_write_strategy(char *buf, unsigned long long *tmp)
>>  	if (*buf != '\0')
>>  		return -EINVAL;
>>  
>> -	*tmp = PAGE_ALIGN(*tmp);
>> +	*tmp = PAGE_ALIGN64(*tmp);
>>  	return 0;
>>  }
>>  
> 
> I don't beleive the change is needed.
> 
> #define PAGE_ALIGN(addr)	(((addr)+PAGE_SIZE-1)&PAGE_MASK)
> 
> that implementation will behaved as desired when passed a 64-bit addr?

If I'm not doing something wrong, here is what happens on my i386 box:

$ uname -m
i686
$ cat 64-bit-page-align.c
#include <stdio.h>
#include <asm/page.h>

#define PAGE_ALIGN(addr)	(((addr)+PAGE_SIZE-1)&PAGE_MASK)
#define PAGE_ALIGN64(addr) (((((addr)+PAGE_SIZE-1))>>PAGE_SHIFT)<<PAGE_SHIFT)

#define SIZE ((1ULL << 32) - 1)

int main(int argc, char **argv)
{
	unsigned long long good, bad;

	good = (unsigned long long)PAGE_ALIGN64(SIZE);
	bad = (unsigned long long)PAGE_ALIGN(SIZE);

	fprintf(stdout, "good = %llu, bad = %llu\n", good, bad);

	return 0;
}
$ gcc -O2 -o 64-bit-page-align 64-bit-page-align.c
$ ./64-bit-page-align
good = 4294967296, bad = 0
                   ^^^^^^^
On a x86_64, instead, both PAGE_ALIGN()s work as expected:

$ uname -m
x86_64
$ gcc -O2 -o 64-bit-page-align 64-bit-page-align.c
$ ./64-bit-page-align
good = 4294967296, bad = 4294967296

At least we could add something like:

#ifdef CONFIG_32BIT
#define PAGE_ALIGN64(addr) (((((addr)+PAGE_SIZE-1))>>PAGE_SHIFT)<<PAGE_SHIFT)
#else
#define PAGE_ALIGN64(addr) PAGE_ALIGN(addr)
#endif

But IMHO the single PAGE_ALIGN64() implementation is more clear.

-Andrea
