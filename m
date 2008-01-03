Return-Path: <linux-kernel-owner+w=401wt.eu-S1756266AbYACQYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266AbYACQYd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 11:24:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbYACQYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 11:24:25 -0500
Received: from mga06.intel.com ([134.134.136.21]:4280 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751599AbYACQYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 11:24:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,240,1196668800"; 
   d="scan'208";a="248441380"
Message-ID: <477D0BC6.2060204@linux.intel.com>
Date: Thu, 03 Jan 2008 17:22:30 +0100
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/3] move WARN_ON() out of line
References: <477C32DA.5060905@linux.intel.com> <20080103092502.GA16096@elte.hu>
In-Reply-To: <20080103092502.GA16096@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Arjan van de Ven <arjan@linux.intel.com> wrote:
> 
>> +#define WARN_ON(condition) do_warn_on((unsigned long)(condition), __FILE__, \
>> +					 __LINE__, __FUNCTION__)
> 
> hm. This passes in 4 arguments to do_warn_on().
> 
> i think we could get away with no arguments (!), by using section 
> tricks. Firstly, we can get rid of __FUNCTION__ and replace it with a 
> ksyms lookup - that is fine enough.

I can see that; I'll play with that

> Secondly, we could put __FILE__ and 
> __LINE__ into a text section and key it up to the return address from 
> do_warn_on().

the asm generated for this is 2 movl instructions for immediate to register.
Doing fancy tricks ... it may well end up bigger and gain nothing.
> 
> the condition code should not be passed in at all i think - it creates 
> extra function calls to do_warn_on() all the time.

function calls are *CHEAP*.

passing the condition is actually near free (remember we have regparm!), it's likely to be
in a register already anyway.

Doing the test inline makes stuff bigger, and also spreads the branch prediction pain around
rather than having one nicely predictable place...


