Return-Path: <linux-kernel-owner+w=401wt.eu-S1754189AbYG3QyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189AbYG3QyW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 12:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751580AbYG3QyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 12:54:14 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:2364 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbYG3QyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 12:54:13 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5349"; a="5009694"
Message-ID: <48909CC5.5090305@qualcomm.com>
Date: Wed, 30 Jul 2008 09:54:29 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
CC: Peter Oruba <peter.oruba@amd.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/4] x86: AMD microcode patch loading v2 fixes
References: <20080729154103.007575982@amd.com>	 <b647ffbd0807290918kaa0a05es3cebf7a6f15fb790@mail.gmail.com>	 <488F581B.7060009@qualcomm.com> <48903431.9060707@amd.com> <b647ffbd0807300257x43dd6018o59533bec11b7a504@mail.gmail.com>
In-Reply-To: <b647ffbd0807300257x43dd6018o59533bec11b7a504@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Dmitry Adamushko wrote:
> 2008/7/30 Peter Oruba <peter.oruba@amd.com>:
>>> [ ... ]
>> Since ucode updates may fix severe issues, it is supposed to happen as early
>> as possible. If you re-plug your CPU into your socket, your BIOS also
>> applies a ucode patch, but that won't necessarily be the latest and critical
>> one.
Sure. The question is would not workqueue be soon enough ?
I'd say it is given the non-deterministic CPU hotplug callback sequence.

> Hum, let's say we don't do it from cpu-hotplug handlers [1] but from
> start_secondary() before calling cpu_idle()? [*]
> 
> This way, we do it before any other task may have a chance to run on a
> cpu which is not a case with cpu-hotplug handlers
> (and we don't mess-up with cpu-hotplug events :-)
> 
> [ the drawback is that 'microcode' subsystem is not local to
> microcode.c anymore ]
> 
> [1] if we need a sync. operation in cpu-hotplug handlers and IPI is
> not ok (say, we need to run in a sleepablel context) then perhaps it's
> workqueues + wait_on_cpu_work(). But then it's not a bit later than
> could have been with [*].
Why would not IPI be ok ? From looking at the code all we have to do is to
factor request_firmware() out of the update path. So we'd do
collect_cpu_info() in the IPI, then do request_firwmare() inplace and then do
apply_microcode() in the IPI. ie The only thing that sleeps is request_firmware().

Max
