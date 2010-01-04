Return-Path: <linux-kernel-owner+w=401wt.eu-S1753145Ab0ADSGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145Ab0ADSGx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 13:06:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219Ab0ADSGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 13:06:51 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:11252 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab0ADSGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 13:06:50 -0500
Message-ID: <4B422E0C.1070108@caviumnetworks.com>
Date: Mon, 04 Jan 2010 10:06:04 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Alexander Beregalov <a.beregalov@gmail.com>, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>, sam@ravnborg.org,
       dhowells@redhat.com
Subject: Re: [PATCH] BUG(): CONFIG_BUG=n version of BUG() should be unreachable()
References: <1261531032-15225-1-git-send-email-a.beregalov@gmail.com> <4B3171DF.4070903@caviumnetworks.com> <4B31743F.8070804@caviumnetworks.com> <200912302012.05827.arnd@arndb.de>
In-Reply-To: <200912302012.05827.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Jan 2010 18:06:05.0046 (UTC) FILETIME=[95102960:01CA8D68]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Wednesday 23 December 2009, David Daney wrote:
>> David Daney wrote:
>>
>> Well that may be too strong an objection, but I would really recommend 
>> deeper consideration.
>>
>> If you use: #define BUG() __builtin_unreachable()
>>
>> which is what your patch does for GCC >= 4.5, it is truly undefined what 
>> happens if it is ever reached.  One typical thing that might happen is 
>> that you start to try to execute data.  It is unclear to me if it is 
>> preferable in the kernel to do that, rather than loop endlessly.  You 
>> would likely achieve smaller code, but at what cost?
> 
> That is exactly what I was about to reply at first as well, but the
> definition is BUG() is really "this should never happen". Normally,
> i.e. CONFIG_BUG=y, we will print a stack dump and kill the running
> task here. The case that Alexander is patching is for !CONFIG_BUG,
> where we intentionally remove the handling for the unexpected bug
> in order to reduce code size. This option is really just for people
> that want to squeeze out every possibly byte from the kernel object
> code, while everyone else just enables CONFIG_BUG.
> 
> Currently, this is "do { } while (0)", which on old compilers is
> the best approximation of doing the right thing there, but may
> cause build warnings.
> 
> __builtin_unreachable() is even better on gcc-4.5, because gcc may
> save a few more instructions and not print warnings any more. Getting
> into an undefined state here is not an issue, because if we get to 
> a BUG() statement, the system state is already known to be broken
> and !CONFIG_BUG means we don't even try to to improve it any more.
> 
> The alternative "do { } while (1)" is not ideal, because an
> endless loop still requires more code (typically one instruction)
> than doing nothing at all.
> 

Well "do { } while (1)" is exactly the expansion of unreachable() for 
GCC < 4.5.  Since GCC-4.5 has not been released yet, most people will 
get these extra looping instructions if you change BUG in this way.


You might also consider the discussions here:

http://marc.info/?l=linux-kernel&m=125296549116694&w=2

When I suggested a similar patch.


> If there are only than a handful of places that actually cause a warning,
> using "do { } while (0)" (or __builtin_unreachable where available) and
> fixing up the code using it might be better.
> 
> 	Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

