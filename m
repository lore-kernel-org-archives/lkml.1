Return-Path: <linux-kernel-owner+w=401wt.eu-S1764968AbXFEPOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764968AbXFEPOW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 11:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755776AbXFEPON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 11:14:13 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:37167 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760229AbXFEPON (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 11:14:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WVTKeI7o/SfmXpn7KPE7oTgQhGAdUNLqu4VVJ6nHjjZRLEgdisOpITD+YV1QkTl0haLICvYqspbVwkBSCT9ydFovnUzkhxSQRlEJXvVwI2d4xL3f1JDuRN19uD544FEQQR++4Hb7dgI9coK4kB/pibCSktvnLNCxSpKqP/JBYco=
Message-ID: <b647ffbd0706050814u1e145b82qdb344d475d9ffe93@mail.gmail.com>
Date: Tue, 5 Jun 2007 17:14:12 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Matt Mackall" <mpm@selenic.com>
Subject: Re: Interesting interaction between lguest and CFS
Cc: "Ingo Molnar" <mingo@elte.hu>, "Rusty Russell" <rusty@rustcorp.com.au>,
       akpm@linux-foundation.org, Linux-kernel@vger.kernel.org
In-Reply-To: <20070605140342.GR11115@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070604173710.GR11166@waste.org> <20070604175436.GC30274@elte.hu>
	 <20070604184106.GG11115@waste.org> <20070605071904.GB25163@elte.hu>
	 <20070605140342.GR11115@waste.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/07, Matt Mackall <mpm@selenic.com> wrote:
> > [...]
> > Click into the lguest window and trigger the delay.
>
> I did:
>
> while true; do sleep 1; cat /proc/sched_debug > sched_debug.txt; done
>
> and got this, hopefully inside the window:
>
> Sched Debug Version: v0.02
> now at 257428593818894 nsecs
>
> cpu: 0
>   .nr_running            : 3
>   .raw_weighted_load     : 2063
>   .nr_switches           : 242830075
>   .nr_load_updates       : 30172063
>   .nr_uninterruptible    : 0
>   .jiffies               : 64282148
>   .next_balance          : 0
>   .curr->pid             : 27182
>   .clock                 : 125650217819008823
>   .prev_clock_raw        : 257428516403535

The delta (clock - prev_clock_raw) looks insane.

The current time (which doesn't depend on rq_clock() --> sched_clock() is
" now at 257428593818894 nsecs " (right at the beginning of the output).

'prev_clock_raw' is updated any time rq_clock() is called - basically
upon any scheduling operation (e.g. enqueue/dequeue)

now - prev_clock_raw == 257428593818894 - 257428516403535 == ~ 80 ms.

while 'clock' reports something crazy.. that would explain why there
wes a huge "block_max" reported earlier.. I guess, sched_clock() is
tsc-based in your case?

Any way to get it switched to jiffies-based one and repeat the test?


-- 
Best regards,
Dmitry Adamushko
