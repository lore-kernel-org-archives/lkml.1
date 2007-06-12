Return-Path: <linux-kernel-owner+w=401wt.eu-S1758143AbXFLNc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758143AbXFLNc0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 09:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757754AbXFLNcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 09:32:11 -0400
Received: from wr-out-0506.google.com ([64.233.184.224]:61808 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757607AbXFLNcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 09:32:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hE4e0lE0kvpl3m5PKLG4dgbdf8pwlwqZRGlOeTLSqohejVM6VoU/ZtMZB6H8w+XOpPuGeAc5FfXvINku3jyzAVXckatKr7JDnqWuv7y6JryPHmfhs+jb0KPnfhJSAoE7CQrHRcc/ywWMHgqgU0R68HCsNtSig7GQHgodJvp3eyE=
Message-ID: <a781481a0706120632p54ad83d0ka0a07a9fd9b276b4@mail.gmail.com>
Date: Tue, 12 Jun 2007 19:02:07 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Jan Beulich" <jbeulich@novell.com>
Subject: Re: [PATCH] x86: fix improper .init-type section references
Cc: "Venkatesh Pallipadi" <venkatesh.pallipadi@intel.com>,
       "Sam Ravnborg" <sam@ravnborg.org>, "Andi Kleen" <ak@suse.de>,
       linux-kernel@vger.kernel.org, patches@x86-64.org
In-Reply-To: <466EB12B.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <466E6BDF.76E4.0078.0@novell.com>
	 <a781481a0706120414g385ccfe8j82b5b18d96d064f2@mail.gmail.com>
	 <a781481a0706120509k89c331ela81f57ad0f0e29eb@mail.gmail.com>
	 <466EB12B.76E4.0078.0@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/12/07, Jan Beulich <jbeulich@novell.com> wrote:
> >> The cacheinfo_cpu_notifier itself is called out from _cpu_down() which
> >> is ... yep, *not* __cpuinit (and obviously *cannot* be so). _cpu_down()
> >> is called from cpu_down() which is (thankfully!) protected inside
> >> #ifdef CONFIG_HOTPLUG_CPU, so we've /just about/ escaped trouble
> >> so far, but another of it's callers is disable_nonboot_cpus() which does
> >> *not* depend on HOTPLUG_CPU, but is #ifdef'ed inside SUSPEND_SMP
> >> (gargh!) instead, and ... is _not_ __cpuinit either (obviously, again).
> >
> >Wait, SUSPEND_SMP again depends on HOTPLUG_CPU, so there
> >are no issues here in marking cache_remove_dev() __cpuexit
> >(which effectively simply becomes #ifdef HOTPLUG_CPU) as all
> >callsites that call out the notifier with CPU_DEAD/FROZEN are also
> >going to be disabled. [ Ok, looks like using __cpuexit as this kind of
> >pseudo-#ifdef HOTPLUG_CPU is a standard practice? ]
> >
> >But modpost will still complain (bogus warning) about calling __exit
> >from __init (when HOTPLUG_CPU=n) for cacheinfo_cpu_callback()
> >calling cache_remove_dev(), no?
>
> No, it doesn't, at least not for me.

That's weird. Some bug in modpost, I'd say.

(Googling around for: section mismatch cacheinfo_cpu_callback)

Yup, it seems a new version of modpost does catch it:
http://readlist.com/lists/vger.kernel.org/linux-kernel/69/349920.html

(Sam's patch there isn't quite right, though, it'll unnecessarily
link in cache_remove_dev() even when HOTPLUG_CPU=n.)

> And from a purely theoretical
> perspective I don't think such references should be considered bad -
> .exit.* should be discarded together with .init.* if unloading is
> impossible (built-in or configured off), not before module/kernel
> initialization.

Hmm, but that's not how things are, presently. __exit marked
functions are simply not linked into the kernel (when that module
is being built-in) at all -- this "discard" happens at _build time_
(to save on kernel image size).

> This is specifically because init code may want to utilize
> exit code in case of initialization failure.

You're right, such code (presently) has to remove the __exit
from the cleanup functions, if it wants the __init functions to
use them too.

Coming back to the code at hand, so we have two ways to fix this
(also applicable to the other such examples, as per your patch):

1. Mark cache_remove_dev() and cache_remove_shared_cpu_map()
as __cpuexit, and then whitelist (the __cpuinit marked)
cacheinfo_cpu_callback() so that modpost doesn't barf.

2. Place cache_remove_dev() and cache_remove_shared_cpu_map()
definitions inside #ifdef CONFIG_HOTPLUG_CPU and provide dummy
{} definitions (not marked either __init or __exit) when
HOTPLUG_CPU=n.

BTW at arch/i386/kernel/cpu/intel_cacheinfo.c:463:

static void __init cache_shared_cpu_map_setup(unsigned int cpu, int index) {}
static void __init cache_remove_shared_cpu_map(unsigned int cpu, int index) {}

is so crazy! What are we trying to "save" by marking these dummy "{}"
functions as __init??? These should in fact be inline, IMO.

There's the "third" option too, of course. Just say bye to the
entire .init.text/.exit.text-discarding concept. We lose a few (ok,
perhaps even several) 100 KB of memory, but save on developer
maintenance effort. But I'm not too sure if this suggestion would
be popular, though :-)
