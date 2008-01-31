Return-Path: <linux-kernel-owner+w=401wt.eu-S932648AbYAaLQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932648AbYAaLQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 06:16:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763253AbYAaLPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 06:15:52 -0500
Received: from hs-out-0708.google.com ([64.233.178.240]:38854 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762774AbYAaLPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 06:15:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NQTLOSRsXZpa3mXD2Dwwnq87ocVPgxTkQxsuSYofbQdXIRGL9D3toj/VbALuwJUmcmVx0Eaf6YG74W3if0iPxxCYV7oo7Q0dAt+7TH/G+yLbjy7vqMTCTeIDSb/908w/O8LTfpWs/x6o18pP+yaJhe+ndBR730yu6yHtFXnLZls=
Message-ID: <7c86c4470801310315w4d73c948tc0e0995c33a61260@mail.gmail.com>
Date: Thu, 31 Jan 2008 12:15:47 +0100
From: "stephane eranian" <eranian@googlemail.com>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Subject: Re: ptrace API extensions for BTS
Cc: "Roland McGrath" <roland@redhat.com>, "Ingo Molnar" <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, markus.t.metzger@gmail.com
In-Reply-To: <029E5BE7F699594398CA44E3DDF55444014A581D@swsmsx413.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <029E5BE7F699594398CA44E3DDF55444010F8D7C@swsmsx413.ger.corp.intel.com>
	 <20080130072557.EC73C26F9A7@magilla.localdomain>
	 <029E5BE7F699594398CA44E3DDF55444014A55DD@swsmsx413.ger.corp.intel.com>
	 <7c86c4470801300301n426f3ab4n94419db3a5553936@mail.gmail.com>
	 <029E5BE7F699594398CA44E3DDF55444014A581D@swsmsx413.ger.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Markus,

I looked at your code. My understanding is that it abstracts the BTS
so that higher
level code does not have to know the intricacies of the implementation
especially
given that the changed the DS_AREA structure a lot between P4 and Core 2.

The code does not cover PEBS though. In the case of perfmon, the ra PEBS data
is exposed to user-level. This way we ensure zero-copy all the way to
the application.
Of course, that means applications needs to know whether they are using P4 PEBS
or Core PEBS, but that's fine.

I noticed that your code does not support 64-bit Netburst DS_AREA configuration.
I have used that myself and it works. Also Penryn support is missing
(Fam 6 model 23).

The code does not actually touch the HW resource. This needs to be
added somehow.
It must be part of a register allocator outside of ds.c. We could
extend the simple
allocator currently used for the PMU registers in perfctr-watchdog.c.
In fact, that one
would have to be generalized.

Perfmon does read/write the DS_AREA pointer and content. PEBS is supported in
per-thread and system-wide mode. This means that we save/restore DS_AREA pointer
on ctxsw. Perfmon does not touch the BTS specific fields, just the PEBS relevant
fields. PEBS does generate interrupts and they are routed via the PMU interrupt.

Internally perfmon2 needs to access the internals of the ds_area to
fiddle with the
pebs_index/pebs_intr_thres. Some of that code is in the perfmon core and not in
the model specific (P4 vs. Core) kernel module. On Core2, I think I could get
rid of this dependency but not on P4. I could use your code to abstract the DS
area and give me access to the pebs fields in a more generic way. that assumes
you would add PEBS support to ds.c.

What do you think?

Thanks.


On Jan 30, 2008 1:52 PM, Metzger, Markus T <markus.t.metzger@intel.com> wrote:
> >From: stephane eranian [mailto:eranian@googlemail.com]
> >Sent: Mittwoch, 30. Januar 2008 12:01
>
> >You can get information about the perfmon2 project at:
> >http://perfmon2.sf.net
>
> I downloaded your patch for 2.6.23 and cloned your git repository.
>
> From a first glance, it looks like there is indeed a lot of overlap.
>
>
> >I would like to take a look at your patches. Where can I get them?
>
> You can find the changes in the mm branch of the x86 git. Do they keep
> the patches there, somewhere, as well?
>
> You should get the best overview if you look at arch/x86/kernel/ds.c,
> include/asm-x86/ds.h, include/asm-x86/ptrace-abi.h, and
> arch/x86/kernel/ptrace.c or simply grep for BTS.
>
> I have all the patches that I submitted but they rather protocol
> development than describe the final thing.
>
>
> >My understanding at this point is that we would need to coordinate
> >access to the
> >DS_AREA. It would likely have to be mutually exclusive access.
>
> From a brief look at your patch, I would say that we should rather
> combine the configuration and collection part. They are very similar.
>
> We might still want to provide different interfaces on top of it.
> In particular, I think the ptrace interface is most appropriate for
> debuggers.
>
>
> >I am planning on
> >adding support for LBRs in the next few months. But BTS the way it is
> >currently defined
> >is useless for performance monitoring. I think this a great debug
> >feature, though.
>
> Debugging was my target;-)
>
>
> >Now, there is some preliminary perf. MSR allocator in the kernel.
> >However, it does not know
> >of all available MSRs out there. It focuses on the counters mostly.
> >Perfmon, oprofile and
> >the NMI watchdog use it. I think it could be generalized to other MSR
> >(non-contiguous).
> >
> >I would be happy to work with you in refining this MSR allocator.
>
>
> Are you planning to get the perfmon patch into the kernel? Or do you
> want it to remain a separate patch?
>
> In the first case, we should try to merge the features. In the second
> case, refining the MSR allocator would probably be best.
>
>
> thanks and regards,
