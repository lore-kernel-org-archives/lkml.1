Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881Ab0BSQPx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 11:15:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54659 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752090Ab0BSQPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 11:15:51 -0500
Message-ID: <4B7EB8FF.1090409@zytor.com>
Date: Fri, 19 Feb 2010 08:14:55 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH 34/35] x86: use num_processors for possible cpus
References: <1265793639-15071-1-git-send-email-yinghai@kernel.org> <1265793639-15071-35-git-send-email-yinghai@kernel.org> <4B7C98B9.1090903@zytor.com> <4B7CA825.9090309@kernel.org> <4B7D782F.20102@zytor.com> <alpine.DEB.2.00.1002181340380.7486@router.home> <4B7D9ABB.7020806@zytor.com> <alpine.DEB.2.00.1002190912550.25964@router.home>
In-Reply-To: <alpine.DEB.2.00.1002190912550.25964@router.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2010 07:14 AM, Christoph Lameter wrote:
> On Thu, 18 Feb 2010, H. Peter Anvin wrote:
> 
>>> As I have also repeatedly stated: Dynamic percpu data allocation when
>>> onlining / offlining processors will complicate locking (cannot rely on
>>> percpu be present anymore) and introduce numerous additional
>>> hotplug notifiers into subsystems.
>>
>> I did state explicitly "on first up".  Trying to free it would be
>> insane.  There are a couple of subsystems which are percpu memory
>> pigs... so far it's not clear any of them actually matters in a
>> production kernel.  60K * 16 phantom processors is still ~ 1 MB, which
>> probably isn't enough to worry about but isn't great.
> 
> The first up still means the addition of notifiers for subsystems that
> have to initialilze their per cpu data and dealing with potential races
> that would be caused by adding those.
> 

Yes... it's ugly no matter which way we go (wasted memory vs. code
complexity.)  Wasted memory can be alleviated by minimizing the use of
percpu memory; callbacks can be minimized by keeping a pattern buffer to
which new allocations are initialized, and encouraging users to set
things up so that that state is at least initially sufficient.

We're probably okay for now (the only really heavy users of percpu are
debugging at this point), and the other thing that might be worthwhile
is if we can actually determine what platforms a "disabled CPU" could
actually come to life.  Hopefully disabled CPUs that aren't really
available aren't *all* that common (it's not too common that people even
turn off SMT, and if they know to do that they might be willing to add a
kernel option if they care about the memory, too.)

However, if percpu memory usage increases, it might be messy.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

