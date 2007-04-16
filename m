Return-Path: <linux-kernel-owner+w=401wt.eu-S1030278AbXDPJuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030278AbXDPJuS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 05:50:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030295AbXDPJuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 05:50:17 -0400
Received: from qb-out-0506.google.com ([72.14.204.235]:19400 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030278AbXDPJuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 05:50:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pLhTi4NNdWOS4h0kKMxSN8KmWCUNRhEqVZ0VCLAaOJrJ+F119q2ArK9Me+2ohXPyieWdw+MLJ5Y6JK4gL3ZDXfUxLKtq0+jZUskbj3mq0k08ULEMKyaZrRK/xD/BAHkWZQvPqwPMhLrosRKAUbXJERT7gnwIkPs8xWZWskWEdXs=
Message-ID: <c03d1bd00704160250g158de0feqa0c7acd18673969f@mail.gmail.com>
Date: Mon, 16 Apr 2007 09:50:14 +0000
From: "Gautham Shenoy" <ego.lkml@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC][PATCH][EXPERIMENTAL] CPU hotplug with frozen tasks
Cc: LKML <linux-kernel@vger.kernel.org>, "Pavel Machek" <pavel@ucw.cz>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Gautham R Shenoy" <ego@in.ibm.com>,
       "Srivatsa Vaddagiri" <vatsa@in.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Oleg Nesterov" <oleg@tv-sign.ru>
In-Reply-To: <200704160027.58425.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200704061732.32712.rjw@sisk.pl> <200704160027.58425.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

On 4/15/07, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Hi,
>
> As I said before, we have a problem with using the CPU hotplug for suspending
> because of the notifiers that are called from within cpu_up()/cpu_down() and
> (sometimes) assume that the system is fully functional.
>

Right. In order to use freezer for CPU hotplug, we need to perform
that audit anyway.

> One obvious solution of this problem would be to make the notifiers behave
> differently if tasks are frozen, but for this purpose we'd need to tell them
> that this is the case.  In principle, we could do it in many different ways
> (eg. by using a global variable, with the help of suspend notifiers etc.), but
> IMO one of the cleanest methods woud be to use some special values for the
> notifications occuring while tasks are frozen (eg. CPU_DEAD_FROZEN instead of
> CPU_DEAD etc.).  In that case the notifiers could react in some special ways
> to the "FROZEN" notfifications and that would allow us to simplify some code
> paths (eg. in the microcode driver).
>

Agreed.

> The appended patch introduces such "FROZEN" notfifications, modifies the CPU
> hotplug core to use them and updates all of the users of CPU hotplug notifiers
> to recognize them.  For now, they are treated in the same way as the
> corresponding "normal" notifications, but I'm going to modify the microcode
> driver to really use them and I believe that some other subsystems can benefit
> from using them as well.
>

Ok. A minor doubt.

When you say FROZEN, do you mean frozen due to suspend ? If yes, then
it makes sense. Otherwise once cpu-hotplug starts using the freezer
(hopefully it will someday soon
:-)) won't this patch become redundant ? [Except of course fixing a few glitches
due to the assumption that the system is fully functional, when it's
actually frozen.]

I am of the opinion that we should have notifications which help the
cpu-hotplug aware
subsystems differentiate between a normal cpu-hotplug  and a
cpu-hotplug initiated by
suspend. Thereby they can handle it accordingly and not destroy any
percpu resources
and reuse them instead during resume.

Am I missing something?

> The patch is totally experimental and untested, although it's been successfully
> compiled on x86_64 and it's main purpose is to show what exactly I mean. :-)
>
> Comments welcome.
>

Other than that, I am ok with the patch.

> Greetings,
> Rafael
>

Thanks and Regards
gautham.
