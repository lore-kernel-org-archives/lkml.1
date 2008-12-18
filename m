Return-Path: <linux-kernel-owner+w=401wt.eu-S1753243AbYLRWBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243AbYLRWBR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 17:01:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbYLRWBB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 17:01:01 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:44124 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174AbYLRWBA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 17:01:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=NP2vaFf0de9qw9+PhFECWz2zyhL3+OqYdaK5igJ0IQ915zHFOFPkgosqc1leBAsa2J
         /S/muxwOW2ZigWIoDaMOY5Un8u4kCrWGb6F6OjYIM2lFVEUHBYMo0tOgc3XAV5ahGz7g
         Iu3UGgyB6ISGhzpuq/0oh+bLTCeVIWemRz1Fc=
Message-ID: <c62985530812181400l1b2d921che71bcb0242a8293d@mail.gmail.com>
Date: Thu, 18 Dec 2008 23:00:58 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH v2] tracing/function-graph-tracer: prevent from hrtimer interrupt infinite loop
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081218214458.GA30834@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <4949A2CC.6040209@gmail.com> <20081218103459.GD10513@elte.hu>
	 <alpine.LFD.2.00.0812181136410.3492@localhost.localdomain>
	 <20081218112216.GE14332@elte.hu>
	 <c62985530812181307k4fc35770x3698101b3981879a@mail.gmail.com>
	 <20081218211637.GF24271@elte.hu>
	 <c62985530812181336m6ab39c8ah410dff763bd02d24@mail.gmail.com>
	 <20081218214458.GA30834@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/18 Ingo Molnar <mingo@elte.hu>:
>
> * Frédéric Weisbecker <fweisbec@gmail.com> wrote:
>
>> > Which means that it's not some hrtimer problem, but simply the traced
>> > timer tick takes more than 1 millisecond to execute under this
>> > virtualization.
>> >
>> >        Ingo
>> >
>>
>> Oh ok I see. Sorry I'm a bit slow today... So the solution would be to
>> adapt dynamically the timeout between hrtimer irq. But I don't know that
>> much hrtimer to implement such a feature...
>
> just if you want this lockup to go away. I think you did the hardest bit
> already: to detect the situation reliably, without false positives. Now
> the 'action' needs to change: instead of 'turning off ftrace' (which is
> brutal - ftrace was just the last drop of water that pushed the system
> over the edge), we can instead do 'double the minimum clockevent delta
> threshold'.
>
> there's already such code in kernel/time/tick-oneshot.c:
>
>                /*
>                 * We tried 2 times to program the device with the given
>                 * min_delta_ns. If that's not working then we double it
>                 * and emit a warning.
>                 */
>                if (++i > 2) {
>                        /* Increase the min. delta and try again */
>                        if (!dev->min_delta_ns)
>                                dev->min_delta_ns = 5000;
>                        else
>                                dev->min_delta_ns += dev->min_delta_ns >> 1;
>
> what would be needed is to simply double ->min_delta_ns on every such
> situation you detect? Once you do that, it takes effect on the next tick
> automatically.
>
> Or something like that. In theory. :-)
>
>        Ingo
>

Ok. I understand. Thanks for these pointers, that seems more easy than
I thought.
I will send a patch in a few days....
