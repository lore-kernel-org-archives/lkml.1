Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445Ab0BOL5W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 06:57:22 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:43790 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755294Ab0BOL5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 06:57:21 -0500
Date: Mon, 15 Feb 2010 17:27:13 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Michael Stefaniuc <mstefani@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       Maneesh Soni <maneesh@linux.vnet.ibm.com>,
       Alexandre Julliard <julliard@winehq.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Roland McGrath <roland@redhat.com>
Subject: Re: Regression in ptrace (Wine) starting with 2.6.33-rc1
Message-ID: <20100215115713.GA8907@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <4B743149.4000707@redhat.com> <20100211182224.GC4915@nowhere> <4B745F5C.5050001@redhat.com> <20100213173323.GB3778@in.ibm.com> <4B7719AC.6040901@redhat.com> <20100214171535.GA5065@nowhere> <4B785952.8020706@redhat.com> <20100214204130.GD5479@nowhere> <4B7881AC.5070209@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B7881AC.5070209@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 15, 2010 at 12:05:16AM +0100, Michael Stefaniuc wrote:
> On 02/14/2010 09:41 PM, Frederic Weisbecker wrote:
>> On Sun, Feb 14, 2010 at 09:13:06PM +0100, Michael Stefaniuc wrote:
>>> Although Wine will map address 0x0 for DOS programs that isn't the
>>> reason for those tests. Wine has to support games that come with
>>> pointless copy protection schemes that employ that technique.
>> Ah, which kind of protection?
> No clue as I'm not into games. But the wiki has a page for that  
> http://wiki.winehq.org/CopyProtection
>
>
>>> Cool, thanks!
>>> Any chance to get that fix into 2.6.33?
>> Yeah.
>>
>> Could you please test the following patch on top of
>> 2.6.33-rc9 ?
> It is an improvement as I don't get an -EINVAL now but the data in DR7
> is not what was written there and the test fails with:
> exception.c:612: Test failed: failed to set debugregister 7 to 0x155,  
> got 2aa
>

Okay, so this 0x155 written onto ptrace got converted into 0x2AA -
basically all requests to 'locally' enable breakpoints in DR0-DR3 (bits
0, 2, 4 and 6 of DR7) was converted into a request to 'globally' enable
(bits 1, 3, 5 and 7) breakpoints.

'Local' breakpoints - here would mean those breakpoints pertaining to a
process that are "automatically cleared on every task switch", which I
presume, happen in cases where TSS registers are used for context
switches (and as I learn is not the case with Linux).

The hw-breakpoint infrastructure in Linux currently implements
per-process breakpoints using 'global' flag but performs the clean-up
after a task-switch using other methods (such as scheduler hooks through
perf-events). All breakpoint requests (kernel or per-process)
is treated as 'global'.

We could change this to become 'local' for every local request (but still
cleanup the breakpoints using scheduler hooks like the way we presently
do), but I think this is an implementation detail and that a ptrace user
need not worry about it. Or do you believe that there's any?

I'm afraid I don't understand your motivation for these read/write tests
on debug control register? Such tests, as in this case, cause unnecessary
panic due to changes in an implementation detail internal to the kernel
without any perceptible difference in functionality.

Thanks,
K.Prasad

