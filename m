Return-Path: <linux-kernel-owner+w=401wt.eu-S1753585AbYKCSn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585AbYKCSn4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 13:43:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751393AbYKCSns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 13:43:48 -0500
Received: from mx2.redhat.com ([66.187.237.31]:44682 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925AbYKCSnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 13:43:47 -0500
Message-ID: <490F468B.4040602@redhat.com>
Date: Mon, 03 Nov 2008 13:44:27 -0500
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATH -mm -v2] Fix a race condtion of oops_in_progress
References: <1225268796.24095.48.camel@yhuang-dev.sh.intel.com>	 <49087871.3010303@redhat.com>	 <1225332179.24095.61.camel@yhuang-dev.sh.intel.com>	 <490B3574.1060501@redhat.com> <1225677161.24095.169.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1225677161.24095.169.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Ying wrote:
> On Sat, 2008-11-01 at 00:42 +0800, Chris Snook wrote:
>> Huang Ying wrote:
>>> Hi, Chris,
>>>
>>> On Wed, 2008-10-29 at 08:51 -0600, Chris Snook wrote:
>>>> Huang Ying wrote:
>>>>> Fix a race condition accessing oops_in_progress.  Which may be changed on
>>>>> multiple CPU simultaneously, but it is changed via non-atomic operation
>>>>> ++/--.  This patch changes the definition of oops_in_process from int to
>>>>> atomic_t, and accessing method to atomic operations.
>>>> You also need barriers.  I believe rmb() before atomic_read() and wmb() after 
>>>> atomic_set() should suffice.
>>> I don't think that is necessary. I haven't found there is particular
>>> consistent requirement about oops_in_progress.
>> atomic_read() and atomic_set() don't inherently cause changes to be visible on 
>> other CPUs any faster than ++ and -- operators.  Sometimes it happens to work 
>> out that way as a result of how the compiler and the CPU order operations, but 
>> there's no semantic guarantee, and it could even take arbitrarily long under 
>> some circumstances.  If you want to use atomic ops to close the race, you need 
>> to use barriers.
> 
> As far as I know, barriers don't cause changes to be visible on other
> CPUs faster too. It just guarantees corresponding operations after will
> not get executed until that before have finished. And, I don't think we
> need make changes to be visible on other CPUs faster.

You're correct that barrier() has no impact on other CPUs.  wmb() and rmb() do. 
  If we don't need to make changes visible any faster, what's the point in using 
atomic_set()?  It's not any less racy.  atomic_inc() and atomic_dec() would be 
less racy, but you're not using those.

-- Chris
