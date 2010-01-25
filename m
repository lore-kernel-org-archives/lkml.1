Return-Path: <linux-kernel-owner+w=401wt.eu-S1754478Ab0AYRhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478Ab0AYRhr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 12:37:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754469Ab0AYRho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 12:37:44 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:42405 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754466Ab0AYRhn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 12:37:43 -0500
Message-ID: <4B5DD6DF.4090102@us.ibm.com>
Date: Mon, 25 Jan 2010 09:37:35 -0800
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mark Seaborn <mrs@mythic-beasts.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>
Subject: Re: futex() on vdso makes process unkillable
References: <20100124.000458.506212773266927716.mrs@deli> <20100125120459.4944.A69D9226@jp.fujitsu.com> <20100125162733.BDB8.A69D9226@jp.fujitsu.com> <1264411574.4283.1632.camel@laptop>
In-Reply-To: <1264411574.4283.1632.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Mon, 2010-01-25 at 16:27 +0900, KOSAKI Motohiro wrote:
<snip>
>> Futex should work both file anon anon. however I personally think 
>> vdso is not file nor anon. it is special mappings. nobody defined
>> futex spec on special mappings. (yes, undefined).
>>
>> Personally, I think EINVAL or EFAULT are best result of vdso futexing, like as
>> futexing againt kernel address. but I guess another person have another thinking.
>>
>> I'd like to hear futex folks's opinion.
> 
> Well, my opinion is we should remove the vdso, its ugly as hell :-)
> 
> But I think it would make most sense to extend its definition in the
> direction of it being a file (for all intents and purposes its a special
> DSO -- which unfortunately isn't present in any filesystem).
> 
> [ For all intents and purposes processes can already communicate through
> futexes on the libc space, so being able to do so through the vsdo
> really doesn't add anything ]
> 
> So the problem is that the VDSO pages do not have a page->mapping
> because they lack the actual filesystem part of files, so even if (with
> the recent zero-page patch from Kosaki-san) you make private COWs of the
> VDSO, you'll get stuck in that loop.
> 
> So the prettiest solution is to simply place the vdso in an actual
> filesystem and slowly migrate towards letting userspace map it as a
> regular DSO -- /sys/lib{32,64}/libkernel.so like.
> 
> [ that has the bonus of getting rid of install_special_mapping() ]
> 
> The ugly solution is special casing the vdso in get_futex_key().

I like the creating-a-real-file solution. However, for now (and for 
stable), I think Kosaki's suggestion of EINVAL or EFAULT is a good 
stop-gap. EINVAL might play the best with existing glibc implementations.

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
