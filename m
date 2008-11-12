Return-Path: <linux-kernel-owner+w=401wt.eu-S1752116AbYKLKKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116AbYKLKKe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 05:10:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751786AbYKLKK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 05:10:26 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:35559 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbYKLKKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 05:10:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=WATy0gDkFHUIkr/Q/GbJM9thj25fGwdRyUsah290s6StfDx78ujZWufL/RBHZamwzv
         22ws2z9jGBbwh5EHZ4r2ENz8bg1P95L9OTFPpeWu7L2eOSU8479KJYEaCkAkVec2V2ik
         7GrEfn2wlXjWoal4UabAcic1RKZEkM52NmRWo=
Message-ID: <7c86c4470811120210j2ea5ccdcv59a654aadc32ebd2@mail.gmail.com>
Date: Wed, 12 Nov 2008 11:10:22 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Markus Metzger" <markus.t.metzger@googlemail.com>
Subject: Re: debugctl msr
Cc: "Metzger, Markus T" <markus.t.metzger@intel.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <491A812D.9010208@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7c86c4470810300753v7d377092qbcd266178d8e7338@mail.gmail.com>
	 <029E5BE7F699594398CA44E3DDF5544402AB2C50@swsmsx413.ger.corp.intel.com>
	 <7c86c4470811040822i6745bee6mbe451284d76549be@mail.gmail.com>
	 <7c86c4470811050505j678c6929if00cceda2af8cb17@mail.gmail.com>
	 <7c86c4470811050711w3753232fk1030fb00259a7b8@mail.gmail.com>
	 <029E5BE7F699594398CA44E3DDF5544402AB350E@swsmsx413.ger.corp.intel.com>
	 <7c86c4470811060249g62666885nbaa559c1777217a0@mail.gmail.com>
	 <1226236327.6104.4.camel@raistlin>
	 <7c86c4470811111411k754887a8ic9b63163928157a6@mail.gmail.com>
	 <491A812D.9010208@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Markus,

On Wed, Nov 12, 2008 at 8:09 AM, Markus Metzger
<markus.t.metzger@googlemail.com> wrote:
> stephane eranian wrote:
>
>> For perfmon, PEBS can be used for both per-thread and per-cpu. With
>> perfmon, the allocation/initialization of the buffer is separated from its
>> activation. In other words, allocation/initialization may be done before
>> you
>> actually have to write the DS_AREA MSR. Allocation/initialization may not
>> necessary be done on the cpu you want to measure in per-cpu mode. The
>> logic of DS is different, ds_request_pebs() allocates and immediately
>> writes
>> DS_AREA. I cannot use that.
>
> DS_AREA contains a pointer to the actual configuration struct.
> The idea is that once I allocated the configuration struct, I can write
> the pointer to it into DS_AREA. It won't be used unless I turn on a feature
> that uses DS.
> So, the flow is:
> 1. allocate configuration struct
> 2. write DS_AREA

What if you are allocating the buffer for another task. For instance,
a tool is attaching
to a running process and wants to use PEBS. The tool allocates and
initializes the
PEBS buffer and then attaches it to the task to monitor (which is
stopped). When the
task is scheduled again, it picks up the PEBS buffer, and DS_AREA is written to.

> 3. configure BTS/PEBS
> 4. enable BTS/PEBS

enable PEBS consists in writing a PMU MSR. Perfmon takes care of that.

>
>
>> Concerning memory allocation of the buffer, the current kernel module
>> exporting PEBS lumps together the memory for the DS_AREA + PEBS
>> buffer. The entire region is then remapped to user space via mmap().
>> That implies that the memory region needs to be page-aligned and multiple
>> of page size. If I wanted to keep this, it is not clear to me how I could
>> use
>> your API to simply pass the addresses.
>
> Higher layers are not meant to know about DS configuration details. I admit
> that
> the interface is still very near to the actual h/w and that the developers
> of
> higher layers do of course know DS details. But they should not care, for
> example, that DS configuration requires memory allocation.
>
> The DS configuration is shared between PEBS and BTS users.
> Assuming there is already a BTS user for that thread or cpu. What should
> ds.c
> do with the memory you allocated for the DS configuration? It must have
> already
> allocated one to satisfy the BTS user.
>
> Besides, I would not expose this configuration to user-space. If the user
> were
> to modify the configuration, he could bring down the system. The PEBS/BTS
> buffers should be save, since they are write-only from h/w perspective.
>
The PEBS buffer (and thus DS_AREA) are remapped read-only.

There is another reason why the DS_AREA is exposed. This is the only way for
tools to see the current position in the PEBS buffer. They may want to poll on
that position index. The PEBS buffer is not necessarily full. What if
the session
terminates with a partial buffer. There must be a way for the tool to figure out
where the last sample is. By exposing DS read-only the index is always available
and always guaranteed current. Without this, the kernel would have to
extract the
index (pebs_get_index) and store it somewhere so the user can see it. This copy
could be tirggered by a PEBS buffer overflow or a stop of monitoring. Sampling
buffers formats currently do not have a stop callback but this can be
added easily.
