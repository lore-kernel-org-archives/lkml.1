Return-Path: <linux-kernel-owner+w=401wt.eu-S1753801Ab0ALI7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801Ab0ALI7g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 03:59:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753573Ab0ALI7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 03:59:35 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:48293 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539Ab0ALI7e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 03:59:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=GOXTKLYKzAfEmo2EAz6qoH5qPNJwiFnNF0/rN5TkcykRyIDHVzjwN61udXCkb6S/Qz
         IoRS9TDIoia5DhxhwoxXV/pzyz2+4FSydh34j+EsdW62h6cRSadhgW6S0ngps7bKdqZG
         u6+BVO6QGCzofiUnJUF9idocHfp8HCYanStaQ=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1001111906300.17145@localhost.localdomain>
References: <1263264483-3959-1-git-send-email-yinghai@kernel.org>
	 <1263264483-3959-4-git-send-email-yinghai@kernel.org>
	 <alpine.LFD.2.00.1001111906300.17145@localhost.localdomain>
Date: Tue, 12 Jan 2010 00:59:31 -0800
X-Google-Sender-Auth: 5449840ab0bbd754
Message-ID: <86802c441001120059s46a2e93aydc76067960aa07e6@mail.gmail.com>
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

On Mon, Jan 11, 2010 at 7:13 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Mon, 11 Jan 2010, Yinghai Lu wrote:
>>
>> some systems that have disable cpus entries because same
>>   BIOS will support 2 sockets and 4 sockets and more at
>>   same time, BIOS just leave some disable entries, but
>>   those system do not support cpu hotplug. we don't need
>>   treat disabled_cpus as hotplug cpus.
>>
>> so we can make nr_cpu_ids smaller and save more space
>>   (pcpu data allocations), and could make some systems run
>>   with logical flat instead of physical flat apic mode
>
> .. but this one I detest.
>
> We can't play games that depend on us always filling in some DMI table
> correctly. Things need to "just work".
>
> So while 1/4 looks fine, 2/4 looks fundamentally unacceptable.
>
> Is the flat APIC mode really so important?
>
> I would suggest a few alternatives:
>
> Truly static:
>
>  - only use that flat apic mode when you _know_ that you absolutely will
>   never have more than 8 cpu's. Ie when CONFIG_NR_CPUS <= 8 (or, with
>   1/3, when nr_cpu_ids <= 8) and/or when <= 8 CPU's were detected, and
>   CPU hotplug is disabled entirely.
that is this patch try to do. but can not find out the system that does support
real hw support hotadd cpus.
>
> Slightly more intelligent:
>
>  - Look at the ACPI socket count, and hey, if it says it might have more
>   sockets - whether they are really hotplug or not, don't use flat mode,
>   because we simply don't know. But do _not_ do some kind of DMI table to
>   say one way or the other.

that acpi could lie, for example, some system share one BIOS between 2
socket/4 socket/8 sockets
model. and BIOS could have bunch disabled entries in MADT. or MPTABLE.

>
> And if it's _really_ important:
>
>  - if flat mode is so important that you want to enable it whenever
>   possible, what about enabling/disabling it dynamically at CPU hotplug
>   time? That does sound _very_ painful, but it's still better than having
>   to maintain some list of all systems that can ever hot-plug.

interesting, could be done.
init_apic_ldr is called even for physical flat on 64 bit.
could change apic on fly.

YH
