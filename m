Return-Path: <linux-kernel-owner+w=401wt.eu-S1754163AbYIEORS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163AbYIEORS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 10:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072AbYIEORF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 10:17:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37907 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753121AbYIEORE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 10:17:04 -0400
Date: Fri, 5 Sep 2008 10:16:15 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, Don Zickus <dzickus@redhat.com>,
       Prarit Bhargava <prarit@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       arozansk@redhat.com, Thomas.Mingarelli@hp.com, ak@linux.intel.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH RFC] NMI Re-introduce un[set]_nmi_callback
Message-ID: <20080905141615.GA13742@redhat.com>
References: <1220535463.8609.223.camel@twins> <48BFF0C0.7060208@redhat.com> <20080904145617.GB28095@elte.hu> <87y727vrgu.fsf@basil.nowhere.org> <20080904172052.GN3400@redhat.com> <20080904175231.GH18288@one.firstfloor.org> <20080904182637.GP3400@redhat.com> <20080904190816.GB4349@redhat.com> <20080904200032.GM18288@one.firstfloor.org> <20080905093303.GA28887@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080905093303.GA28887@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2008 at 11:33:03AM +0200, Ingo Molnar wrote:
> 
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
> > > Add "kdump" to the list. It will also be broken if we decide to let 
> > > one driver hijack the NMI handler.
> > 
> > kdump is a special case, similar to the NMI button panic mode. It 
> > should be always only active when the user configured it. When the 
> > user configured it should be always the fallback and override any 
> > other drivers.
> 
> if by 'any other drivers' you mean all other notifiers then that's wrong 
> - kdump must still come after many other NMI sources.
> 

Hi Ingo,

Kdump notifier is registered on the die list, only after when we have 
decided that system is no more runnable and it is time to die. So as long
as system is running, this notifier is not even present on the list and
does not compete for any of the NMI events.

But once the panic() has occurred, the only notifiers which probably
are interested in NMi events are kgdb and kdump? We probably don't want to
run any "instruction patching" callback or any profiling related callbacks
because system is already dead and we are just doing some last minute
information gathering/debugging exercise.

Keeping that in mind, I would think that it would make sense to register
kdump notifier at even higher priority (INT_MAX) and not lower the
priority. Because after panic() probably there is no body who is
interested in NMI event. Any contention for getting hold of panic() event
should be resolved at panic_notifier_list (kdump and kgdb contention comes
to mind). Possibly there are other users who want to get notified of
panic() event and do something. But I think platform drivers will not be
interested in NMI event after panic(). 

Thanks
Vivek
 
> Basically, the sane order is this:
> 
> highest priority:
>  
>   instruction patching callbacks. (kprobes, mmiotrace, kmemcheck) These 
>   are abstractions that are essential for the kernel to properly 
>   function/execute. We dont ever want them to be overriden.
> 
> high priority:
> 
>   CPU-generated profiling callbacks. (nmi-lapic watchdog, performance 
>   counter generated NMIs) These are 'good' NMI sources that can (well, 
>   'could') identify themselves, and they can also come in very 
>   frequently so we want to execute them early.
> 
> mid priority:
> 
>   optional/interactive debug facilities. (kdump, KGDB, trace dump, NMI 
>   button).
>   The user enables them optionally and wants them catch all non-expected 
>   or interactive NMI events.
> 
> normal priority:
> 
>   various platform drivers. Infrequent NMI sources. It's what we use to 
>   make unexpected events slightly more informative when the user does 
>   not configure any explicit debugging helper.
> 
> lowest priority:
> 
>   fallback legacy platform handlers - 61H reads, etc.
> 


> All in one, the patch submitted here is wrong as a generic facility. One 
> valid aspect of the patch is that the port 61H reads (and other 
> architecture code chipset ops) should execute as a regular notifier and 
> with low priority.
> 
> as it does not really solve anything in a structured way, it allows 
> platform drivers to install a super-high priority notifier, creating 
> needless duplication and confusion. The exact reasons for the changes 
> should be listed instead and proper (and separate) patches done for each 
> reason, along the suggestions in this thread - i believe all issues were 
> covered in one way or another.
> 
> 	Ingo
