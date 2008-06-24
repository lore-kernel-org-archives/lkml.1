Return-Path: <linux-kernel-owner+w=401wt.eu-S1754581AbYFXFIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581AbYFXFIt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 01:08:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751165AbYFXFIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 01:08:41 -0400
Received: from wx-out-0506.google.com ([66.249.82.231]:59534 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbYFXFIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 01:08:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=OYxD46SO4TEpARZls0DMR9P8+bF7SgZPlz2Xwc0NOEk7csA+hAkvQsrQUs6pX0Y4Zq
         UVQATwImOiXUozZbxO8u6gefOPKabl+fn7svgo/4OeRcbTXAVOY4YanyOJMu2o+LPihg
         vHnPPVDdpvnmIkfLFS9GlvuFHXT0Hnl5xf6Wg=
Message-ID: <cfd18e0f0806232208o1a7545a6kb6859584ba1c0586@mail.gmail.com>
Date: Tue, 24 Jun 2008 07:08:36 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Bart Van Assche" <bart.vanassche@gmail.com>
Subject: Re: nanosleep() uses CLOCK_MONOTONIC, should be CLOCK_REALTIME?
Cc: "Michael Kerrisk" <mtk.manpages@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "john stultz" <johnstul@us.ibm.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Roman Zippel" <zippel@linux-m68k.org>
In-Reply-To: <e2e108260806230456w1b1faa0ftd2c8a4114dbdd89@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <485E00CD.9060503@gmail.com>
	 <e2e108260806230134g48f5ac63mb93256e08c57b4f7@mail.gmail.com>
	 <cfd18e0f0806230248g3a2ab795s63de2b96538ebdd0@mail.gmail.com>
	 <e2e108260806230456w1b1faa0ftd2c8a4114dbdd89@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2008 at 1:56 PM, Bart Van Assche
<bart.vanassche@gmail.com> wrote:
> On Mon, Jun 23, 2008 at 11:48 AM, Michael Kerrisk
> <mtk.manpages@googlemail.com> wrote:
>> On Mon, Jun 23, 2008 at 10:34 AM, Bart Van Assche
>> <bart.vanassche@gmail.com> wrote:
>>> On Sun, Jun 22, 2008 at 9:35 AM, Michael Kerrisk <mtk.manpages@gmail.com> wrote:
>>>> The POSIX.1 specification of nanosleep() says:
>>>>
>>>>       But, except for the case of being interrupted by a signal, the
>>>>       suspension time shall not be less than the time  specified  by
>>>>       rqtp, as measured by the system clock CLOCK_REALTIME.
>>>>
>>>>
>>>> However, reading kernel/hrtimer.c:sys_nanosleep(), it appears that
>>>> CLOCK_MONOTONIC is used.
>>>>
>>>>    return hrtimer_nanosleep(&tu, rmtp, HRTIMER_MODE_REL, CLOCK_MONOTONIC);
>>>>
>>>> Is there a reason to use CLOCK_MONOTONIC, instead of CLOCK_REALTIME?  Is it
>>>> intentional?  If yes, then I should document this in the man-pages.  If not,
>>>> then it should be fixed.
>>>
>>> CLOCK_MONOTONIC works fine even if ntpd steps the clock forward or
>>> backward, CLOCK_REALTIME not. So the man page should be fixed.
>>
>> Thanks for your reply, but I'm not quite convinced yet.  The things
>> is: the Solaris man page also says "CLOCK_REALTIME".  (Of course that
>> man page may just be parroting the standard.)  Could there not be some
>> reasonable semantics for a nanosleep() that was based on
>> CLOCK_REALTIME?
>
> Sorry, but I don't think that a nanosleep() based on CLOCK_REALTIME
> would have reasonable semantics. The first line of the description in
> nanosleep()'s manpage says:
> "nanosleep()  delays  the  execution  of  the program for at least the
> time specified in *req". So you really need CLOCK_MONOTONIC and not
> CLOCK_REALTIME.

I don't think it's sufficient to quote the man page here ;-).  That
sentence is really just an abridged version of the sentence that I
quoted from the spec at the start of this thread:

#       But, except for the case of being interrupted by a signal, the
#       suspension time shall not be less than the time  specified  by
#       rqtp, as measured by the system clock CLOCK_REALTIME.

I assume that the author of the man page simply neglected to mention
which clock the syscall measures by.

> The reason why CLOCK_REALTIME is mentioned is probably because other
> POSIX man pages define three types of clocks: real, virtual and
> profiiling. See e.g. the getitimer() man page
> (http://www.opengroup.org/onlinepubs/009695399/functions/setitimer.html).
> And an overview of all clock types defined by POSIX can be found here:
> http://www.opengroup.org/onlinepubs/000095399/functions/clock_getres.html.

I don't *think* this really provides a rationale for why POSIX talks
of CLOCK_REALTIME rather than CLOCK_MONOTONIC when specifying
nanosleep().


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
