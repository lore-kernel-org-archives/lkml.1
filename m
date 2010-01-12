Return-Path: <linux-kernel-owner+w=401wt.eu-S1754735Ab0ALSOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab0ALSOP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 13:14:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754637Ab0ALSON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 13:14:13 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:60454 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206Ab0ALSNh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 13:13:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=qqWODMSWzQz9H7FMsQdJjkFd0E82a5/o/nP+8NNXrAO+hiGK9pRz3hGBJjpdsVRvfT
         YpX4utPiICud+zd7pboOcDZtdYOKlg9+bct/b6XVbtMwHOtS6LkRIeY4lRpEVbU/Ggwx
         ncuyT+16zkzmmwZqOdncDGHNxtlFa/iMqmN3I=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1001120719260.17145@localhost.localdomain>
References: <1263264483-3959-1-git-send-email-yinghai@kernel.org>
	 <1263264483-3959-4-git-send-email-yinghai@kernel.org>
	 <alpine.LFD.2.00.1001111906300.17145@localhost.localdomain>
	 <86802c441001120059s46a2e93aydc76067960aa07e6@mail.gmail.com>
	 <alpine.LFD.2.00.1001120719260.17145@localhost.localdomain>
Date: Tue, 12 Jan 2010 10:13:36 -0800
X-Google-Sender-Auth: 755878ce4eed6b24
Message-ID: <86802c441001121013o4b8775edl1bc36f120e072b75@mail.gmail.com>
Subject: Re: [RFC PATCH 2/4] x86: use dmi check to treat disabled cpus as 
	hotplug cpus.
From: Yinghai Lu <yinghai@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       "ananth@in.ibm.com" <ananth@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 12, 2010 at 7:19 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Tue, 12 Jan 2010, Yinghai Lu wrote:
>> >
>> > Slightly more intelligent:
>> >
>> >  - Look at the ACPI socket count, and hey, if it says it might have more
>> >   sockets - whether they are really hotplug or not, don't use flat mode,
>> >   because we simply don't know. But do _not_ do some kind of DMI table to
>> >   say one way or the other.
>>
>> that acpi could lie, for example, some system share one BIOS between 2
>> socket/4 socket/8 sockets
>> model. and BIOS could have bunch disabled entries in MADT. or MPTABLE.
>
> That's fine. So it would mean that sometimes we'd use non-flat mode even
> if we strictly didn't need to (because we _think_ that there could be four
> sockets even though there is only one, and three are disabled). But things
> would still work without any special cases.
>
>> > And if it's _really_ important:
>> >
>> >  - if flat mode is so important that you want to enable it whenever
>> >   possible, what about enabling/disabling it dynamically at CPU hotplug
>> >   time? That does sound _very_ painful, but it's still better than having
>> >   to maintain some list of all systems that can ever hot-plug.
>>
>> interesting, could be done.
>> init_apic_ldr is called even for physical flat on 64 bit.
>> could change apic on fly.
>
> Quite frankly, while I suggested it as an option, I really suspect it's
> too much complexity for very little real gain.
>
> Say that you have only four cores, but the kernel decided that it can't
> use logical flat APIC mode because it sees three disabled sockets and
> thinks "ok, we may end up with a total of 16 cores if those sockets are
> hotplugged". Is that such a disaster?
>
> Realistically, do we really care? Do you have performance numbers that say
> that logical flat mode is so important that we really _really_ want to use
> it, even at the cost of nasty run-time complexity with having to
> re-program the APIC setup entirely when going from 8->9 CPU's?

ok let stay with option 1.

and would like to use DMI to blacklist those systems that do need treat disabled
cpus MADT as hotplug cpus.

YH
