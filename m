Return-Path: <linux-kernel-owner+w=401wt.eu-S1753876AbZFVGUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbZFVGUu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 02:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752031AbZFVGUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 02:20:43 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:51901 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739AbZFVGUm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 02:20:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SDggqsMJDi1p9r5nQt+gZ1RahA/HdnGyS0Ys9WSWtBzxsepFnxMc7ArU9vS/rJuIYv
         MVlrsyhBKDl/qO+pq/1SABnt9ZrA3MrRX6UKaOyDp/XkBt9iA9h7kJK6HLescWhA9XFn
         g9TkBiQQwsdTNoFbivqNZm+Gz7ZwhdgRolfxg=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.0906201010590.12994-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.0906192141380.4003-100000@netrider.rowland.org>
	 <Pine.LNX.4.44L0.0906201010590.12994-100000@netrider.rowland.org>
Date: Mon, 22 Jun 2009 15:20:43 +0900
Message-ID: <aec7e5c30906212320v3e3e991fyd028d005675f1e25@mail.gmail.com>
Subject: Re: [linux-pm] [patch update 2 fix] PM: Introduce core framework for 
	run-time PM of I/O devices
From: Magnus Damm <magnus.damm@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 20, 2009 at 11:30 PM, Alan Stern<stern@rowland.harvard.edu> wrote:
> Some more thoughts...
>
> Magnus, you might have some insights here.  It occurred to me that some
> devices can switch power levels very quickly, and the drivers might
> therefore want the runtime suspend and resume methods to be called as
> soon as possible, even in interrupt context.

I'd like to call pm_request_suspend() from interrupt context. I don't
depend on it, but being able to perform runtime suspend directly from
the ISR would be convenient from a device driver POV. I'm not sure if
that should result in bus/device ->runtime_suspend() calls from
interrupt context though.

In my case the bus specific code for ->runtime_suspend() may just
decrease the usage count of the powerdomain but refrain from calling
the device ->runtime_suspend() callbacks until all devices in the
powerdomain have been suspended. The bus/device runtime suspend
callbacks do not need to be executed from interrupt context. Just
noting that the device is idle is enough at interrupt time. This could
be handled by generic code IMO.

Runtime resume needs to block until the hardware is woken up though.
Just marking the device as resumed and letting the driver access the
hardware before it is woken up does not seem like a good idea. =) For
my SuperH devices I do not need to resume from interrupt context, at
least at this point.

>From my perspective it's ok to specificy that the ->runtime_suspend()
and ->runtime_resume() callbacks are executed from process context
only and may sleep. Seems like a simple and good interface that can be
accepted by many bus types. My bus and driver code do not need to
sleep though, so a direct-from-interrupt-context design is fine as
well.

> In terms of the current framework, this probably means holding the
> runtime PM lock (i.e., not releasing it) across the calls to
> ->runtime_suspend and ->runtime_resume.  It also means that
> pm_request_suspend and pm_request_resume should carry out their jobs
> immediately instead of queuing a work item.  (Unless the current status
> is RPM_SUSPENDING or RPM_RESUMING, which should never happen.)

No problem holding a per struct device lock. I suspect that executing
the callbacks from interrupt context is the most efficient design, but
it may come with interrupt latency side effects.

> Should there be a flag in dev_pm_info to select this behavior?

I'd say that executing the callbacks from process context is enough
for now. This will probably be a good match together with interrupt
threads as well.

Maybe the ARM guys have more advanced requriements?

Cheers,

/ magnus
