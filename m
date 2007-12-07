Return-Path: <linux-kernel-owner+w=401wt.eu-S1756758AbXLGVfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758AbXLGVfn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 16:35:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754188AbXLGVff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 16:35:35 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:43564 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684AbXLGVfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 16:35:34 -0500
Message-ID: <4759BCA2.1020809@linux.vnet.ibm.com>
Date: Sat, 08 Dec 2007 03:05:30 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: linuxppc-dev@ozlabs.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fake NUMA emulation for PowerPC
References: <20071207211425.10223.91240.sendpatchset@balbir-laptop> <20071207212817.GA391@lixom.net>
In-Reply-To: <20071207212817.GA391@lixom.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olof Johansson wrote:
> Hi,
> 
> On Sat, Dec 08, 2007 at 02:44:25AM +0530, Balbir Singh wrote:
> 
>> Comments are as always welcome!
> 
> Care to explain what this is useful for? (Not saying it's a stupid idea,
> just wondering what the reason for doing it is).
> 

In my case, I use it to test parts of my memory controller patches on an
emulated NUMA machine. I plan to use it to test out page migration
across nodes.

>> diff -puN arch/powerpc/mm/numa.c~ppc-fake-numa-easy arch/powerpc/mm/numa.c
>> --- linux-2.6.24-rc4-mm1/arch/powerpc/mm/numa.c~ppc-fake-numa-easy	2007-12-07 21:25:55.000000000 +0530
>> +++ linux-2.6.24-rc4-mm1-balbir/arch/powerpc/mm/numa.c	2007-12-08 02:36:02.000000000 +0530
>> @@ -24,6 +24,8 @@
>>  
>>  static int numa_enabled = 1;
>>  
>> +char *cmdline __initdata;
>> +
> 
> Looks like this should be static.
> 

Yes, good catch!

>> @@ -702,6 +744,9 @@ static int __init early_numa(char *p)
>>  	if (strstr(p, "debug"))
>>  		numa_debug = 1;
>>  
>> +	if (strstr(p, "fake="))
>> +		cmdline = p + 5;	/* 5 is faster than strlen("fake=") */
> 
> This doesn't look right.
> 
> You check if it contains fake=, not if it starts with it. So if someone
> did: "numa=foo,fake=bar", or even "numa=debug,fake=", things wouldn't
> work right.
> 

Yes, you are right. I merely followed the strstr convention already
present, which as you righly point out is wrong. I suspect I need to do
something like

p = strstr(p, "fake=")
if (p)
	cmdline = p + 5;

This would still allow us to do things like

numa=foo,fake=bar but the memparse() utility would fail at fake=bar
								^^^

or even

numa=debug,fake=1G

I suspect that this should be good enough for a command line option.

> 
> -Olof


-- 
	Thanks,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
