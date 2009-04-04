Return-Path: <linux-kernel-owner+w=401wt.eu-S937653AbZDDAft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937653AbZDDAft (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 20:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936943AbZDDA2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 20:28:49 -0400
Received: from mail-gx0-f160.google.com ([209.85.217.160]:54807 "EHLO
	mail-gx0-f160.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937020AbZDDA2r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 20:28:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=PtlUwzb5YoJOhdqvux+nFq8WwuRqWFjT8nnL6+tUt//Wp1WYuex1R7JRIGYC8vBYJO
         EqmEK0GvepXEF8DDq3tEYyhOY9hsDsgJOd3GkydrFgufa0ZxRkWA+FKFSTDEyE4+Vfq0
         YSH2mEAXDPYBTGiUtY5kTXZRZXWzTVRXbQbIA=
MIME-Version: 1.0
In-Reply-To: <20090403200647.GA22497@sgi.com>
References: <20090403200647.GA22497@sgi.com>
Date: Fri, 3 Apr 2009 17:28:44 -0700
X-Google-Sender-Auth: 08c8858fe56c44ae
Message-ID: <1f1b08da0904031728m1369bfbat20e07a37b4a62604@mail.gmail.com>
Subject: Re: [PATCH] Move calc_load call out from xtime_lock protection
From: john stultz <johnstul@us.ibm.com>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 3, 2009 at 1:06 PM, Dimitri Sivanich <sivanich@sgi.com> wrote:
> The xtime_lock is being held for long periods on larger systems due
> to an extensive amount of time being spent in calc_load(),
> specifically here:
>  do_timer->update_times->calc_load->count_active_tasks->nr_active()
>
> On a 64 cpu system I've seen this take approximately 55 usec.
> Presumably it would be worse on larger systems.  This causes other
> cpus to be held off in places such as
> scheduler_tick->sched_clock_tick waiting for the xtime_lock to be
> released.
>
> Why does the xtime_lock need to be held when calc_load() is called?
> Since the calculation is statistical in nature, it doesn't -seem- to
> warrant protection via a write lock.

Hrm.. So its an interesting patch, and anything we can do to reduce
xtime_lock write hold times is good, since lots of applications
constantly pound on gettimeofday() and friends.

So as far as what's being protected, from my quick audit, its
basically just the avenrun[] array (also possibly the static count
value in calc_load, but as long as only one cpu calls calc_load, you
shouldn't have a race there).

Readers of the avenrun array that might get bad data:
   fs/proc/loadavg.c: loadavg_proc_show()
   kernel/timer.c: do_sysinfo()

Other users (and there are a few) don't take the xtime_lock to read it
anyway, so no added risk there.

I'm not very savvy on users of the loadavg values, so I'm not as
confident that this won't break anything. In fact, without changes to
the CALC_LOAD() macros so it uses an intermediate value, I expect some
very incorrect values could be seen.

However, assuming that's fixed, and folks don't object to reading
valid but inconsistent load avg values (ie: the 5 minute load not
including high load seen in the 1minute load)  in the two functions
above, then this might work.

thanks
-john
