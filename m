Return-Path: <linux-kernel-owner+w=401wt.eu-S1751973AbZKAJd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973AbZKAJd2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 04:33:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbZKAJd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 04:33:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47709 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820AbZKAJdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 04:33:25 -0500
Message-ID: <4AED55C9.9010301@redhat.com>
Date: Sun, 01 Nov 2009 11:32:57 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Glauber Costa <glommer@redhat.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       kurt.hackel@oracle.com, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>, zach.brown@oracle.com,
       chris.mason@oracle.com, Ingo Molnar <mingo@redhat.com>
Subject: Re: [Xen-devel] Re: [PATCH 3/5] x86/pvclock: add vsyscall	implementation
References: <ffdfacb2-bc41-40b3-8a35-550fd441d77b@default>
In-Reply-To: <ffdfacb2-bc41-40b3-8a35-550fd441d77b@default>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2009 05:55 PM, Dan Magenheimer wrote:
>> From: Avi Kivity [mailto:avi@redhat.com]
>> Sent: Thursday, October 29, 2009 9:07 AM
>> To: Dan Magenheimer
>> Cc: Jeremy Fitzhardinge; Glauber Costa; Jeremy Fitzhardinge; Kurt
>> Hackel; the arch/x86 maintainers; Linux Kernel Mailing List;
>> Glauber de
>> Oliveira Costa; Xen-devel; Keir Fraser; Zach Brown; Chris Mason; Ingo
>> Molnar
>> Subject: Re: [Xen-devel] Re: [PATCH 3/5] x86/pvclock: add vsyscall
>> implementation
>>
>>
>> On 10/29/2009 04:46 PM, Dan Magenheimer wrote:
>>      
>>> No, the apps I'm familiar with (a DB and a JVM) need a timestamp
>>> not a monotonic counter.  The timestamps must be relatively
>>> accurate (e.g. we've been talking about gettimeofday generically,
>>> but these apps would use clock_gettime for nsec resolution),
>>> monotonically increasing, and work properly across a VM
>>> migration.  The timestamps are taken up to a 100K/sec or
>>> more so the apps need to ensure they are using the fastest
>>> mechanism available that meets those requirements.
>>>        
>> Out of interest, do you know (and can you relate) why those apps need
>> 100k/sec monotonically increasing timestamps?
>>      
> I don't have any public data available for this DB usage, but basically
> assume it is measuring transactions at a very high throughput, some
> of which are to a memory-resident portion of the DB.  Anecdotally,
> I'm told the difference between non-vsyscall gettimeofday
> and native rdtsc (on a machine with Invariant TSC support) can
> affect overall DB performance by as much as 10-20%.
>    

Sorry, that doesn't explain anything.

> I did find the following public link for the JVM:
>
> http://download.oracle.com/docs/cd/E13188_01/jrockit/tools/intro/jmc3.html
>
> Search for "flight recorder".  This feature is intended to
> be enabled all the time, but with non-vsyscall gettimeofday
> the performance impact is unacceptably high, so they are using
> rdtscp instead (on those machines where it is available).  With
> rdtscp, the performance impact is not measureable.
>
> Though the processor/server vendors have finally fixed the
> "unsynced TSC" problem on recent x86 platforms, thus allowing
> enterprise software to obtain timestamps at rdtsc performance,
> the problem comes back all over again with virtualization
> because of migration.  Jeremy's vsyscall+pvclock is a great
> solution if the app can ensure that it is present; if not,
> the apps will instead continue to use rdtsc as even emulated
> rdtsc is 2-3x faster than non-vsyscall gettimeofday.
>
> Does that help?
>    

For profiling work fast timestamping is of course great, but surely 
there is no monotonicity requirement?

I don't think we'll be able to provide monotonicity with vsyscall on 
tsc-broken hosts, so we'll be limited to correcting the tsc frequency 
after migration for good-tsc hosts.

-- 
error compiling committee.c: too many arguments to function

