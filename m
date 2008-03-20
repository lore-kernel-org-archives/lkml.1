Return-Path: <linux-kernel-owner+w=401wt.eu-S1758886AbYCTDAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758886AbYCTDAg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 23:00:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754472AbYCTDAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 23:00:16 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:29680 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754333AbYCTDAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 23:00:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rwBbkF0iMBvG1vG1O2vkplyhiIwS1JHafd836b6XqO7QXejbrWU34taObeXVY9fmQW0/uFSxkGdiB909oWxkSZSzvFaidPGn+cNPyyZYmhs7t3kzvYNK7C52WjJeHbDGPYmp3uoMlLlnVNY7+M4cW5twNjkFnOD0TxJ1SKwaRSc=
Message-ID: <86802c440803192000x41a1383fxc2b58ed68e2375b7@mail.gmail.com>
Date: Wed, 19 Mar 2008 20:00:13 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 0/79] smpboot integration
Cc: "Glauber de Oliveira Costa" <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tglx@linutronix.de, "Andi Kleen" <andi@firstfloor.org>
In-Reply-To: <86802c440803191918y11af1269m39a7c7164f5f7d36@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12059475744092-git-send-email-gcosta@redhat.com>
	 <20080319173533.GA31576@elte.hu>
	 <86802c440803191918y11af1269m39a7c7164f5f7d36@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2008 at 7:18 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> On Wed, Mar 19, 2008 at 10:35 AM, Ingo Molnar <mingo@elte.hu> wrote:
>  >
>  >  * Glauber de Oliveira Costa <gcosta@redhat.com> wrote:
>  >
>  >  > Testing and bisectability:
>  >  >
>  >  > The end result was tested in all my hardware (which includes qemu ;-).
>  >  > It does not mean it will boot _your_ hardware, but I did my best ;-)
>  >  >
>  >  > The tree at least compiles in more than 20 randconfigs (for each of
>  >  > x86_64 and i386) For i386, each of the subarchitectures was compiled
>  >  > at least once. (By compile, I obviously mean, every patch,
>  >  > individually)
>  >
>  >  very nice work! I'll pick it up - and i'm not too worried about
>  >  breakages because at 80 patches granularity any problem should be
>  >  identifiable in a very finegrained way.
>  >
>
>  it broke 4 sockets quad core above with 64 bit
>
>  Booting processor 11/15 ip 6000
>  Initializing CPU#11
>  masked ExtINT on CPU#11
>  Calibrating delay using timer specific routine.. 4589.46 BogoMIPS (lpj=9178934)
>  CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
>  CPU: L2 Cache: 512K (64 bytes/line)
>  CPU 11/f -> Node 2
>  CPU: Physical Processor ID: 2
>  CPU: Processor Core ID: 3
>  CPU11: Quad-Core AMD Opteron(tm) Processor 8356 stepping 03
>  checking TSC synchronization [CPU#0 -> CPU#11]: passed.
>  Booting processor 12/16 ip 6000
>
>  looks like local apic id up 4 bit is masked out. so can not start 0x10
>  above any more.

in wakeup_secondary_via_INIT
before the patchsets
64 bit code:

        /*
         * Send IPI
         */
        apic_write(APIC_ICR, APIC_INT_LEVELTRIG | APIC_INT_ASSERT
                                | APIC_DM_INIT);


after patchset

        /* Boot on the stack */
        /* Kick the second */
        apic_write_around(APIC_ICR, APIC_DM_NMI | APIC_DEST_LOGICAL);

So that is wrong! esp for system has ext apic id that is has 8 bits
instead of 4 bits.

YH
