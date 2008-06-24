Return-Path: <linux-kernel-owner+w=401wt.eu-S1755116AbYFXFjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116AbYFXFjv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 01:39:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751549AbYFXFjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 01:39:43 -0400
Received: from wx-out-0506.google.com ([66.249.82.236]:2504 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbYFXFjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 01:39:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=iPkvAfyIf/YpzlD1YjSSp9aUKd/ScETsHaz86eLHtwAPcZ9Ds5w96VRWe593KCfcUa
         O2a+5vHVKVhFXGLJd3+GZ9iXNQOfXFVYTkQc2eJGNYz0TArMzjDB88PD0Q9hZxFb0/jS
         +tROJWH7qe4VSd5i75HCJOHt3IJUx+6rq4Hqk=
Message-ID: <cfd18e0f0806232239w78546747p8fb899f614c89496@mail.gmail.com>
Date: Tue, 24 Jun 2008 07:39:41 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Roman Zippel" <zippel@linux-m68k.org>
Subject: Re: nanosleep() uses CLOCK_MONOTONIC, should be CLOCK_REALTIME?
Cc: "Bart Van Assche" <bart.vanassche@gmail.com>,
       "Michael Kerrisk" <mtk.manpages@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "john stultz" <johnstul@us.ibm.com>, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <Pine.LNX.4.64.0806231438130.6791@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <485E00CD.9060503@gmail.com>
	 <e2e108260806230134g48f5ac63mb93256e08c57b4f7@mail.gmail.com>
	 <cfd18e0f0806230248g3a2ab795s63de2b96538ebdd0@mail.gmail.com>
	 <Pine.LNX.4.64.0806231438130.6791@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roman,

On Mon, Jun 23, 2008 at 2:43 PM, Roman Zippel <zippel@linux-m68k.org> wrote:
> Hi,
>
> On Mon, 23 Jun 2008, Michael Kerrisk wrote:
>
>> >> Is there a reason to use CLOCK_MONOTONIC, instead of CLOCK_REALTIME?  Is it
>> >> intentional?  If yes, then I should document this in the man-pages.  If not,
>> >> then it should be fixed.
>> >
>> > CLOCK_MONOTONIC works fine even if ntpd steps the clock forward or
>> > backward, CLOCK_REALTIME not. So the man page should be fixed.
>>
>> Thanks for your reply, but I'm not quite convinced yet.  The things
>> is: the Solaris man page also says "CLOCK_REALTIME".  (Of course that
>> man page may just be parroting the standard.)  Could there not be some
>> reasonable semantics for a nanosleep() that was based on
>> CLOCK_REALTIME?
>
> CLOCK_MONOTONIC is optional, that's probably the reason it's not mentioned
> there.

This seems a little unlikely.  POSIX specifies clock_nanosleep() (see
my other reply) specifically to allow for clocks other than
CLOCK_REALTIME.

> If you check the man page for clock_settime, it specifically
> mentions that pending relative timer (including nanosleep) aren't affected
> by the changed time, thus if CLOCK_MONOTONIC and CLOCK_REALTIME advance
> equally, it doesn't matter which you use for relative timer.

Well, I was going to say that that's just a man page, and man page
authors are fallible ;-).  But then I went and had a look at the POSIX
spec for clock_settime().  It includes the following paragraph:

       Setting the value of the CLOCK_REALTIME  clock  via  clock_set-
       time() shall have no effect on threads that are blocked waiting
       for a relative time service based upon  this  clock,  including
       the  nanosleep()  function;  nor  on the expiration of relative
       timers  based  upon  this  clock.   Consequently,  these   time
       services  shall  expire  when  the  requested relative interval
       elapses, independently of the new or old value of the clock.

So that rather flatly contradicts the alternative semantics that I
suggested were possible in my reply to Bart a few minutes ago.

So in my reading of things now, it looks as though the Linux
implementation is probably fine, since the fact that relative
timers/sleeps are explicitly unaffected by jumps in CLOCK_REALTIME
means that the semantics are effectively the same as if the relative
interval was measured against CLOCK_MONOTONIC (unless the two clocks
counted time at different rates; not sure if that  would be possible
in theory, but certainly seems very unlikely in practice).

I'll add some text (not quite sure what yet) in the nanosleep() man
page on this point.

Thanks Roman, Bart.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
