Return-Path: <linux-kernel-owner+w=401wt.eu-S1754775AbYFYGRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775AbYFYGRQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 02:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753018AbYFYGQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 02:16:59 -0400
Received: from wx-out-0506.google.com ([66.249.82.237]:36261 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056AbYFYGQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 02:16:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=eWkUU6THW7+WG9ci0U4pfysZhUQx3pzB8JqVV9WwUa2zwOpHhgsYY+SE9W5fqIso2U
         DNpMJgxNBFiVP3Y+TZeq5rS8RsFBN9HuY7gd6DHvEjumGrZzqIwcc2918Lu91xdlQKho
         Sw0rqejUu7TpGln9A0BSyZwpMQObJSrG488nw=
Message-ID: <cfd18e0f0806242316g11fe654gf23bb0c60f29ac3f@mail.gmail.com>
Date: Wed, 25 Jun 2008 08:16:56 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: nanosleep() uses CLOCK_MONOTONIC, should be CLOCK_REALTIME?
Cc: "Roman Zippel" <zippel@linux-m68k.org>,
       "Bart Van Assche" <bart.vanassche@gmail.com>,
       "Michael Kerrisk" <mtk.manpages@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>,
       "john stultz" <johnstul@us.ibm.com>, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <alpine.LFD.1.10.0806250809030.3297@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <485E00CD.9060503@gmail.com>
	 <e2e108260806230134g48f5ac63mb93256e08c57b4f7@mail.gmail.com>
	 <cfd18e0f0806230248g3a2ab795s63de2b96538ebdd0@mail.gmail.com>
	 <Pine.LNX.4.64.0806231438130.6791@localhost.localdomain>
	 <cfd18e0f0806232239w78546747p8fb899f614c89496@mail.gmail.com>
	 <alpine.LFD.1.10.0806250809030.3297@apollo.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2008 at 8:13 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Tue, 24 Jun 2008, Michael Kerrisk wrote:
>> > If you check the man page for clock_settime, it specifically
>> > mentions that pending relative timer (including nanosleep) aren't affected
>> > by the changed time, thus if CLOCK_MONOTONIC and CLOCK_REALTIME advance
>> > equally, it doesn't matter which you use for relative timer.
>>
>> Well, I was going to say that that's just a man page, and man page
>> authors are fallible ;-).  But then I went and had a look at the POSIX
>> spec for clock_settime().  It includes the following paragraph:
>>
>>        Setting the value of the CLOCK_REALTIME  clock  via  clock_set-
>>        time() shall have no effect on threads that are blocked waiting
>>        for a relative time service based upon  this  clock,  including
>>        the  nanosleep()  function;  nor  on the expiration of relative
>>        timers  based  upon  this  clock.   Consequently,  these   time
>>        services  shall  expire  when  the  requested relative interval
>>        elapses, independently of the new or old value of the clock.
>>
>> So that rather flatly contradicts the alternative semantics that I
>> suggested were possible in my reply to Bart a few minutes ago.
>>
>> So in my reading of things now, it looks as though the Linux
>> implementation is probably fine, since the fact that relative
>> timers/sleeps are explicitly unaffected by jumps in CLOCK_REALTIME
>> means that the semantics are effectively the same as if the relative
>> interval was measured against CLOCK_MONOTONIC (unless the two clocks
>> counted time at different rates; not sure if that  would be possible
>> in theory, but certainly seems very unlikely in practice).
>
> We use CLOCK_MONOTONIC for the relative timeouts simply to avoid
> trickery vs. clock_settime(CLOCK_REALTIME). That's an kernel internal
> implementation detail which does not have any visible effect to the
> user space interface.
>
> CLOCK_MONOTONIC and CLOCK_REALTIME are using the same timebase
> internally and therefor we can safely use CLOCK_MONOTONIC for the
> relative timeouts.

Thanks Thomas -- that's what I was beginning to understand, butit's
nice to have confirmation.

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
