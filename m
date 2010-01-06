Return-Path: <linux-kernel-owner+w=401wt.eu-S1756308Ab0AFVk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308Ab0AFVk1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 16:40:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756266Ab0AFVk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 16:40:26 -0500
Received: from toro.web-alm.net ([62.245.132.31]:51438 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755747Ab0AFVkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 16:40:25 -0500
Message-ID: <4B4502FD.1000404@osadl.org>
Date: Wed, 06 Jan 2010 22:39:09 +0100
From: Carsten Emde <Carsten.Emde@osadl.org>
Organization: Open Source Automation Development Lab (OSADL) eG
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: John Kacur <jkacur@redhat.com>
CC: Clark Williams <williams@redhat.com>, RT <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [rt-tests] change to cyclictest behavior
References: <20100106130400.7f30ae55@torg> <520f0cf11001061139j2af13403qfcbf567647bdfaa8@mail.gmail.com>
In-Reply-To: <520f0cf11001061139j2af13403qfcbf567647bdfaa8@mail.gmail.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2010 08:39 PM, John Kacur wrote:
> On Wed, Jan 6, 2010 at 8:04 PM, Clark Williams <williams@redhat.com> wrote:
>> I have a problem with the way cyclictest sets up measurement threads,
>> but before I went and changed things I thought I would ask if people
>> cherished this particular behavior.
>>
>> Currently, when cyclictest is run with multiple threads (i.e. -t
>> option) it distributes both the sample interval and the realtime
>> priority by adding the 'distance' parameter to the interval and
>> decrementing the priority by one. This means if you have a distance of
>> 500us (default), a specified RT priority of 95 and start four threads,
>> they will be started with the following parameters:
>>
>> $ cyclictest -t4 -p95
>>
>> Will give you:
>>
>> thread          priority        sample interval
>> 0               95              500
>> 1               94              1000
>> 2               93              1500
>> 3               92              2000
>>
>> What I'd like to do is modify this logic so that when '-a' (affinity) is
>> specified, the priority and sample interval will not be altered. I
>> don't think there's any point in distributing the priority's and
>> sample intervals when the measurement threads are pinned to their own
>> CPU.
>>
>> So:
>>
>> $ cyclictest -t4 -p95 -a
>>
>> Would have each thread at SCHED_FIFO 95 and a sample interval of 500us.
>>
>> Note that this behavior also occurs when the histogram (-h) option is
>> specified).
> Seems reasonable to me. Maybe it would also be nice to have a flag to
> get the old behaviour back even with -a?
I know that there are quite a few people out there who get furious, if
someone breaks backward compatibility - especially in things that are
used for automatic testing. Cyclictest is such a thing.

In addition, I would propose to consider not only affinity but also the
number of threads. If, for example, someone specifies -a -t5 on a
four-way machine, then it may not make sense to use the same priority
and the same interval on all threads. If any, the new feature would only
make sense in cases where both the -a and the -t option do not have an
argument so the number of threads matches the number of CPUs and every
thread runs on its own CPU. Another pitfall is hyperthreading in which
case it may be desired to have as many threads at the same priority as
real CPUs rather than as available hyperthreads.

Here is my proposal:
Do not change the meaning of existing options. Introduce a new option
that is mutual exclusive with the -a, the -t and the -d option. This new
option does the same as -a and -t and -d0 and sets the same priority to
all threads. How about that?

	Carsten.
