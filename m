Return-Path: <linux-kernel-owner+w=401wt.eu-S1752590AbZLWBhM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbZLWBhM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 20:37:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535AbZLWBhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 20:37:10 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:18513 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbZLWBhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 20:37:08 -0500
Message-ID: <4B31743F.8070804@caviumnetworks.com>
Date: Tue, 22 Dec 2009 17:37:03 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Alexander Beregalov <a.beregalov@gmail.com>
CC: arnd@arndb.de, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>, sam@ravnborg.org,
       dhowells@redhat.com
Subject: Re: [PATCH] BUG(): CONFIG_BUG=n version of BUG() should be unreachable()
References: <1261531032-15225-1-git-send-email-a.beregalov@gmail.com> <4B3171DF.4070903@caviumnetworks.com>
In-Reply-To: <4B3171DF.4070903@caviumnetworks.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Dec 2009 01:37:03.0575 (UTC) FILETIME=[6DD54670:01CA8370]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Daney wrote:
> Alexander Beregalov wrote:
>> Previouss definition of BUG() as 'do {} while(0)' produced compilation
>> warnings when BUG() was used in default branch of switch() statement
>> (control reaches end of non-void function).
>>
>> Example:
>> unsigned long function()
>> {
>>     switch() {
>>     case 1:
>>         return 1;
>>     case 2:
>>         return 2;
>>     default:
>>         BUG();
>> }
>>
>> Using unreachable() fixes the problem.
>>
>> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
>>
> 
> NAK.
> 

Well that may be too strong an objection, but I would really recommend 
deeper consideration.

If you use: #define BUG() __builtin_unreachable()

which is what your patch does for GCC >= 4.5, it is truly undefined what 
happens if it is ever reached.  One typical thing that might happen is 
that you start to try to execute data.  It is unclear to me if it is 
preferable in the kernel to do that, rather than loop endlessly.  You 
would likely achieve smaller code, but at what cost?

David Daney

> 
>> diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
>> index 18c435d..1106439 100644
>> --- a/include/asm-generic/bug.h
>> +++ b/include/asm-generic/bug.h
>> @@ -89,7 +89,7 @@ extern void warn_slowpath_null(const char *file, 
>> const int line);
>>  
>>  #else /* !CONFIG_BUG */
>>  #ifndef HAVE_ARCH_BUG
>> -#define BUG() do {} while(0)
>> +#define BUG() unreachable()  #endif
>>  
>>  #ifndef HAVE_ARCH_BUG_ON
> 
> You can only use 'unreachable()' in situations where it is truly 
> unreachable.  In the case above you will reach it in the default case.
> 
> I would suggest one of the following instead:
> 
> #define BUG() BUILD_BUG_ON(1)
> 
> #define BUG() do {} while(1)
> 
> 
> David Daney
> 

