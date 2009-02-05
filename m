Return-Path: <linux-kernel-owner+w=401wt.eu-S1755173AbZBERov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173AbZBERov (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 12:44:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758759AbZBERok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 12:44:40 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:51521 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbZBERoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 12:44:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Vehpyd1/iAvm4U9l7wPh1TbZZABIsKrgdoTqhTFwWLm9Ea6V+FMNd1PJe/zJ3c9Dxh
         ULyLrhxlcMIRLeflUJR6GCtYo1U5KX9G44mBBuW1Nu+VCYKDQNpyn8cpXGrzA1A47yal
         F+6Pz+1mKvl9AsKW9uZFcs4SwrK6EclXRjLF0=
MIME-Version: 1.0
In-Reply-To: <20090204134823.8eefa728.akpm@linux-foundation.org>
References: <20090116191108.135927000@polaris-admin.engr.sgi.com>
	 <200902041314.32277.rusty@rustcorp.com.au>
	 <20090203190111.2ec31cef.akpm@linux-foundation.org>
	 <200902042111.35543.rusty@rustcorp.com.au>
	 <20090204073636.30f15339.akpm@linux-foundation.org>
	 <20090204213519.GR22608@elte.hu>
	 <20090204134823.8eefa728.akpm@linux-foundation.org>
Date: Thu, 5 Feb 2009 18:44:36 +0100
Message-ID: <b647ffbd0902050944m40d69bc6m3b031b7a0ea80c7c@mail.gmail.com>
Subject: Re: [PATCH 2/3] work_on_cpu: Use our own workqueue.
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, rusty@rustcorp.com.au, travis@sgi.com,
       mingo@redhat.com, davej@redhat.com, cpufreq@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/2/4 Andrew Morton <akpm@linux-foundation.org>:
> On Wed, 4 Feb 2009 22:35:19 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
>
>>
>> * Andrew Morton <akpm@linux-foundation.org> wrote:
>>
>> > mm/pdflush.c:
>> >
>> >   wtf what the heck is all that stuff and who added it?  weird.
>> >
>> >   Leave it alone I guess.  Can admins manually move kernel threads to
>> >   other CPUs?
>>
>> they can - and there's even tools that do that (there's some -rt tools where
>> you can put kernel thread priorities into a config file).
>>
>
> Oh well, DontDoThatThen.
>
> I expect that the same argument applies to most of the set_cpus_allowed()
> callsites - they're run by root-only code.  Sure, root can (with
> careful timing) move root's own thread onto the wrong CPU in the middle
> of microcode loading.  In which case root gets to own both pieces.

Another issue is that those set_cpus_allowed() callsites may
effectivelly cancel the effect of sched_setaffinity() being run by an
administrator in parallel with a target process calling e.g.
cpufreq_get(0)

[ there are a couple of callsites in drivers/{video,pcmcia}, possibly
running in a process context for which sched_setaffinity() with mask
!= 'all_cpus_set' may be legitimate from admin's POV :-) ]

iow, not all use-cases are so obvious (like microcode) to fall into
the category of "didn't you know that this action could do some
unsynchronized cpu-mask-fiddling work behind your back". Not to say
that the existence of sych category is wrong, imho.

(regarding microcode)

> This code is just nuts.  What's the point in pinning itself to > a CPU for the act of loading the microcode into main
> memory?  It's only
> the loading of the microcode which should care about
> which CPU
> executes the code.  ie: apply_microcode().

Well, basically I tried to preserve the existing mechanisms/schemes as
much as possible when reworking this code and yes, I'm the person to
be blamed for this 'nuts' code.

> The code needs some laundering, switch to >schedule_work_on().

I had a patch doing exactly this but then there were other concerns
with the 'schedule_work_on()' approach
(e.g. http://linux.derkeiler.com/Mailing-Lists/Kernel/2008-08/msg02827.html)

then I had another idea (run it from start_secondary() or something
like this), but I never managed to look at this issue again
(and noone else seemed to care about really running "it as early as
possible" ;-)

In any case, it should be fixable one way or another.

> Ensure that the callback functions don't take >microcode_mutex.

yes, these actually look redundant in cpu-hotplug paths (other callers
call get/put_online_cpus() so this part should be ok).

Will fix. Thanks for your comments!


-- 
Best regards,
Dmitry Adamushko
