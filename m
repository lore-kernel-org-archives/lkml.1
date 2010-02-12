Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481Ab0BLRMz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 12:12:55 -0500
Received: from smtp-out.google.com ([216.239.44.51]:2679 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757154Ab0BLRMw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 12:12:52 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=Nxyken7199sybMFt33HVIxlU6WH9D4P+1McAp+gm+rKsGo4MiRsVD03QN/9NCiUoy
	bkCeZGrRzvWM0ppEzeoKg==
MIME-Version: 1.0
In-Reply-To: <20100212165920.GB3062@redhat.com>
References: <bd4cb8901002120812n7da16b6k29dd9b950ac68f25@mail.gmail.com>
	 <20100212165920.GB3062@redhat.com>
Date: Fri, 12 Feb 2010 18:12:47 +0100
Message-ID: <bd4cb8901002120912x2f5b62b0r983c8595e250fdbd@mail.gmail.com>
Subject: Re: [PATCH 0/3 v2] new nmi_watchdog using perf events
From: Stephane Eranian <eranian@google.com>
To: Don Zickus <dzickus@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       mingo@elte.hu, Paul Mackerras <paulus@samba.org>,
       Robert Richter <robert.richter@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don,

On Fri, Feb 12, 2010 at 5:59 PM, Don Zickus <dzickus@redhat.com> wrote:
> On Fri, Feb 12, 2010 at 05:12:38PM +0100, Stephane Eranian wrote:
>> Don,
>>
>> How is this new NMI watchdog code going to work when you also have OProfile
>> enabled in your kernel?
>>
>> Today, perf_event disables the NMI watchdog while there is at least one event.
>> By releasing the PMU registers, it also allows for Oprofile to work.
>>
>> But now with this new NMI watchdog code, perf_event never releases the PMU.
>> Thus, I suspect Oprofile will not work anymore, unless the NMI watchdog is
>> explicitly disabled. Up until now OProfile could co-exist with the NMI watchdog.
>
> You are right.  Originally when I read the code I thought perf_event just
> grabbed all the PMUs in reserve_pmc_init().  But I see that only happens
> when someone actually creates a PERF_TYPE_HARDWARE event, which the new
> nmi watchdog does.  Those PMUs only get released when the event is
> destroyed which my new code only does when the cpu disappears.
>
> So yeah, I have effectively blocked oprofile from working.  I can change
> my code such that when you disable the nmi_watchdog, you can release the
> PMUs and let oprofile work.
>
> But then I am curious, considering that perf and oprofile do the same
> thing, how much longer do we let competing subsystems control the same
> hardware?  I thought the point of the perf_event subsystem was to have a
> proper framework on top of the PMUs such that anyone who wants to use it
> just registers themselves, which is what the new nmi_watchdog is doing.
>
> I can add code that allows oprofile and the new nmi watchdog to coexist,
> but things get a little ugly to maintain.  Just wondering what the
> gameplan is here?
>
I believe OProfile should eventually be removed from the kernel. I suspect
much of the functionalities it needs are already provided by perf_events.
But that does not mean the OProfile user level tool must disappear. There is
a very large user community. I think it could and should be ported to use
perf_events instead. Given that the Oprofile users only interact through
opcontrol, opreport, opannotate and such, they never "see" the actual kernel
API. Thus by re-targeting the scripts, this should be mostly transparent to
end-users.

But for now, I believe the most practical solution is to release the perf_event
event when you disable the NMI watchdog. That would at least provide a
way to run OProfile.
