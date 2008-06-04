Return-Path: <linux-kernel-owner+w=401wt.eu-S1758560AbYFDHot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758560AbYFDHot (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 03:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751549AbYFDHok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 03:44:40 -0400
Received: from mailout02.t-online.de ([194.25.134.17]:44960 "EHLO
	mailout02.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbYFDHoi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 03:44:38 -0400
From: =?iso-8859-1?q?J=FCrgen_Mell?= <j.mell@t-online.de>
Reply-To: j.mell@t-online.de
To: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: CONFIG_PREEMPT causes corruption of application's FPU stack
Date: Wed, 4 Jun 2008 09:44:15 +0200
User-Agent: KMail/1.9.6 (enterprise 20071221.751182)
Cc: Andi Kleen <andi@firstfloor.org>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com, mingo@elte.hu,
       hpa@zytor.com, tglx@linutronix.de,
       Simon Holm =?iso-8859-1?q?Th=F8gersen?= <odie@cs.aau.dk>
References: <200806011101.06491.j.mell@t-online.de> <20080602213756.GB25114@linux-os.sc.intel.com> <20080602225727.GC25114@linux-os.sc.intel.com>
In-Reply-To: <20080602225727.GC25114@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200806040944.15815.j.mell@t-online.de>
X-ID: V8q+W+ZcwhgZ+nenLxb-u3ofpj5JcxU+seAV9bBBt7omPVPElR3cqV0bqjNwFqTwCS
X-TOI-MSGID: 96c684ab-a30d-4f42-b451-b1ae66592073
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 3rd June 2008, Suresh Siddha wrote:
> On Mon, Jun 02, 2008 at 02:37:56PM -0700, Suresh Siddha wrote:
> > On Sun, Jun 01, 2008 at 06:47:29PM +0200, Jürgen Mell wrote:
> > > On Sonntag, 1. Juni 2008, Andi Kleen wrote:
> > > > j.mell@t-online.de writes:
> > > > > or it is restored more than
> > > > > once. Please keep in mind, that I am always running two Einstein
> > > > > processes simultaneously on my two cores!
> > > > > I am willing to do further testing of this problem if someone
> > > > > can give me a hint how to continue.
> > > >
> > > > My bet would have been actually on
> > > > aa283f49276e7d840a40fb01eee6de97eaa7e012 because it does some
> > > > nasty things (enable interrupts in the middle of __switch_to).
> > > >
> > > > I looked through the old patchkit and couldn't find any specific
> > > > PREEMPT problems. All code it changes should run with preempt_off
> > > >
> > > > You could verify with sticking WARN_ON_ONCE(preemptible()) into
> > > > all the places acc207616a91a413a50fdd8847a747c4a7324167
> > > > changes (__unlazy_fpu, math_state_restore) and see if that
> > > > triggers anywhere.
> > >
> > > No, that did not trigger. I put the WARN_ON_ONCE into process.c,
> > > traps.c and also into the __unlazy_fpu macro in i387.h but I got no
> > > messages anywhere (dmesg, /var/log/messages, /var/log/warn) when the
> > > trap #8 occurred.
> > > Meanwhile I am also running the tests on another machine to make
> > > sure it is not a hardware-related problem.
> > >
> > > Any new ideas are welcome!
> > >
> > > Meanwhile I will go back to 2.6.20 and revert
> > > aa283f49276e7d840a40fb01eee6de97eaa7e012. Maybe I got on a wrong
> > > track...
> >
> > 2.6.20 doesn't have the commit
> > 'aa283f49276e7d840a40fb01eee6de97eaa7e012'
> >
> > As you are seeing this corruption problem starting from 2.6.20,
> > atleast recent(in 2.6.26 series) fpu changes don't play a role in
> > this.
> >
> > I will try to reproduce your issue.
>
> Jürgen, I think I found the reason for your issue aswell.
>
> As you observed, it is probably coming from the commit
> acc207616a91a413a50fdd8847a747c4a7324167, i386: add sleazy FPU
> optimization
>
> It's a side affect though. This is the failing scenario:
>
> process 'A' in save_i387_ia32() just after clear_used_math()
>
> Got an interrupt and pre-empted out.
>
> At the next context switch to process 'A' again, kernel tries to restore
> the math state proactively and sees a fpu_counter > 0 and
> !tsk_used_math()
>
> This results in init_fpu() during the __switch_to()'s
> math_state_restore()
>
> And resulting in fpu corruption which will be saved/restored
> (save_i387_fxsave and restore_i387_fxsave) during the remaining
> part of the signal handling after the context switch.
>
> So in short, yes the problem shows up for preempt enabled kernels and
> the same patch I sent out 30 mins back (appended again) should fix your
> issue aswell. Can you please test this and check if my theory is indeed
> correct. If it fixes your issue aswell, then I will re-post the patch
> with a new changelog and updated comments in the patch.
>

I have applied your patch to both an openSUSE 2.6.22.17 kernel and a 
2.6.26-rc4 kernel.org kernel and run the test with Einstein@home on two 
different machines. One machine is running 24 hours now, the other 18 
hours. 

During this time there were no faults on both machines.

As it never before took more than 12 hours until the first appearance of 
the problem, I think your patch fixed it. Very good work!

I will continue running the test, but I believe we can call this fixed.

Thank you again!
                             Jürgen
