Return-Path: <linux-kernel-owner+w=401wt.eu-S1755667AbYEWRLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667AbYEWRLQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 13:11:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751655AbYEWRLB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 13:11:01 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:54509 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbYEWRLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 13:11:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eI6kwE/I+n167qVgJHOS5UjM4hHMtzkDeBvxPEPWs/fQ7aQ7f3ADUvuKYlgu3ZA0zSe12bWC1Jcy/KH76Ha2Bcf/7A95kaSzeY+mEofbpMkSkqqGlZXVc6C4VgtVvYYwGC1Yw6ujVqwUeNa/BXpw+/MVUXUJ/b+gvg3F26GM3bA=
Message-ID: <19f34abd0805231010j54c20e5ge70dc5020e825bf6@mail.gmail.com>
Date: Fri, 23 May 2008 19:10:58 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Johannes Weiner" <hannes@saeurebad.de>
Subject: Re: [PATCH] kmemcheck: SMP support
Cc: "Ingo Molnar" <mingo@elte.hu>, "Pekka Enberg" <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org
In-Reply-To: <87od6xngt7.fsf@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080523141759.GA1833@damson.getinternet.no>
	 <87od6xngt7.fsf@saeurebad.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2008 at 6:09 PM, Johannes Weiner <hannes@saeurebad.de> wrote:
> Hi Vegard,
>
> Vegard Nossum <vegard.nossum@gmail.com> writes:
>
>> +static void
>> +resume(void)
>> +{
>> +#ifdef CONFIG_SMP
>> +     int cpus;
>> +
>> +     cpus = num_online_cpus() - 1;
>> +
>> +     atomic_set(&nmi_resume, 1);
>> +
>> +     while (atomic_read(&finished) != cpus)
>> +             cpu_relax();
>> +#endif
>> +}
>
> How about merging finished and started into one?  I.e. `paused'.
>
> The notifiers increases `paused' before the waiting-loop and decreases
> it again afterwards.
>
> pause_allbutself() sends the IPIs and waits until `paused' reached the
> number of CPUS.
>
> resume() justs waits until `paused' reaches zero.
>
> Would this work?  Will the NMI handler finish even when the CPU is
> removed while the handler runs?

Yup, that works perfectly. No CPU will be removed or added, since the
IPI is broadcast to all CPUs and the only CPU running anything besides
the NMI handler itself is waiting for the other CPUs... (At least I
think this is the case. It won't change the way the code currently
works I think...)

Thanks for the tip! :-)

Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
