Return-Path: <linux-kernel-owner+w=401wt.eu-S1758245AbZF2Inb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758245AbZF2Inb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 04:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757693AbZF2InQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 04:43:16 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:40230 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757099AbZF2InO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 04:43:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ByCKfnyGaOF5qZvCqKlbLrmnUrFaIE121hDlGBgO+wdmb0WAYHYS8rZNRktXBitUF7
         BldNpeksEE9AWlEw/7466LAeBEs9SHjBJwHs1i1EvBInnUle7kmE8VB+uRivktEyEfr0
         HjbpiOipUeMQWDV7LIWqjf3nt4bDgsJKicgA4=
MIME-Version: 1.0
In-Reply-To: <20090629083035.GA4017@elte.hu>
References: <3877989d0906282347i311eb14bp80a7c80878219c31@mail.gmail.com>
	 <20090629072047.GB20225@elte.hu>
	 <3877989d0906290104q11a767b6qcc1acc4c2d1feba6@mail.gmail.com>
	 <20090629081615.GB571@elte.hu>
	 <3877989d0906290121l15705d2cn72e4c49dd96ed950@mail.gmail.com>
	 <20090629083035.GA4017@elte.hu>
Date: Mon, 29 Jun 2009 16:43:16 +0800
Message-ID: <3877989d0906290143y3b5306f4s4a990ecbfbfc49b6@mail.gmail.com>
Subject: Re: [RFC patch] Use IPI_shortcut for lapic timer broadcast
From: Luming Yu <luming.yu@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, suresh.b.siddha@intel.com,
       venkatesh.pallipadi@intel.com, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 4:30 PM, Ingo Molnar<mingo@elte.hu> wrote:
>
> * Luming Yu <luming.yu@gmail.com> wrote:
>
>> On Mon, Jun 29, 2009 at 4:16 PM, Ingo Molnar<mingo@elte.hu> wrote:
>> >
>> > * Luming Yu <luming.yu@gmail.com> wrote:
>> >
>> >> On Mon, Jun 29, 2009 at 3:20 PM, Ingo Molnar<mingo@elte.hu> wrote:
>> >> >
>> >> > * Luming Yu <luming.yu@gmail.com> wrote:
>> >> >
>> >> >> Hello,
>> >> >>
>> >> >> We need to use IPI shortcut to send lapic timer broadcast
>> >> >> to avoid the latency of sending IPI one bye one on systems with many
>> >> >> logical processors when NO_HZ is disabled.
>> >> >> Without this patch,I have seen upstream kernel with RHEL 5 kernel
>> >> >> config boot hang .
>> >> >
>> >> > hm, that might be a valid optimization - but why does the lack of
>> >> > this optimization result in a hang?
>> >>
>> >> It is hang caused by kernel code for work around lapic-timer-stop
>> >> issue. With HZ=1000, and a lot of cpus (eg. 64 logical cpus), cpu
>> >> 0 will be busy working on send TIMER IPI instead of making
>> >> progress in boot (right after deep-C-state has been used).
>> >
>> > that's a bit weird. With HZ=1000 we have 1000 usecs between each
>> > timer tick. Assuming a CPU sends to a lot of CPUs (64 logical CPUs)
>> > that means that each IPI takes more than ~15 microseconds to
>> > process. On what hardware/platform can this happen realistically?
>>
>> https://bugzilla.redhat.com/show_bug.cgi?id=499271
>>
>> Someone has measured that it needs 50-100us latency to send one
>> IPI
>
> Ugh. What platform is it that takes this much time to pass an IPI?
>
> IPIs are the lifeline of process messaging under Linux. TLB flushes
> in threaded apps rely on it (heavily), the scheduler relies on it
> for wakeups (heavily) and a lot of other code relies on IPIs as
> well.
>
> Even a Pentium-5 100 MHz dual box was able to do cross-CPU IPIs
> within 10-20 microseconds more than a decade ago - so 50-100 usecs
> latency on a modern platform is totally out of this planet and will
> hurt Linux performance big time. And the worst thing about it is
> that none of the usual performance metrics will really show _why_
> performance is tanking ...
>


Please note this is deep-C-state related.
C state does add extra latency.. but I don't know how much...
