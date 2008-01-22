Return-Path: <linux-kernel-owner+w=401wt.eu-S1755388AbYAVVpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388AbYAVVpK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 16:45:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753445AbYAVVos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 16:44:48 -0500
Received: from 1wt.eu ([62.212.114.60]:1512 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753285AbYAVVoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 16:44:46 -0500
Date: Tue, 22 Jan 2008 22:15:30 +0100
From: Willy Tarreau <w@1wt.eu>
To: Jordan Crouse <jordan.crouse@amd.com>
Cc: Arnd Hannemann <hannemann@i4.informatik.rwth-aachen.de>,
       Andres Salomon <dilinger@queued.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24-rc8 hangs at mfgpt-timer
Message-ID: <20080122211530.GC16717@1wt.eu>
References: <20080117211917.GF8244@cosmic.amd.com> <478FCDB6.4010708@i4.informatik.rwth-aachen.de> <20080117223644.GK8244@cosmic.amd.com> <478FDC12.6020505@i4.informatik.rwth-aachen.de> <20080117225744.GL8244@cosmic.amd.com> <478FE733.2030806@i4.informatik.rwth-aachen.de> <20080121232709.GJ10837@cosmic.amd.com> <20080121233226.GA1052@1wt.eu> <20080122201524.GA16428@1wt.eu> <20080122210858.GD5241@cosmic.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080122210858.GD5241@cosmic.amd.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2008 at 02:08:58PM -0700, Jordan Crouse wrote:
> On 22/01/08 21:15 +0100, Willy Tarreau wrote:
> > So it seems like applying the workaround on top of TinyBIOS 0.98 undoes
> > this BIOS's workaround. I'm now wondering how we could detect whether
> > the workaround was applied or not :-/
> 
> Actually, the TinyBIOS "workaround" is the same thing.
> 
> Like I may have said before, there is a reason why this MSR is undocumented.
> It works, but the behavior is unvalidated, and obviously erratic.  When we
> first developed this code, we were using the Geode GX on the OLPC with VSA,
> so using the MSR was nessesary if we wanted to get our hands on any 
> timers at all.  Mitch Bradley (author of OpenFirmware) determined through
> testing that the MSR was erratic, especially when you ran it when all the
> timers were already clear.  I suspect thats the problem that we see here -
> writing the MSR in TinyBIOS unstablizied the registers, and writing the
> MSR again kicked it back.  Of course, the unfortunate corollary is that
> when the workaround isn't in v0.99, if you run the MSR in the kernel, then
> you will end up destabilizing everything.

Indeed, that looks exactly like what's happening.

> Furthermore, using the MSR is okay with TinyBIOS, but not okay with the
> other Geode BIOSen (Insyde, General Software, and for the moment LinuxBIOS)
> because VSA (the SMM handler) _does_ use some of the timers.  So needless
> to say, I'm concerned.

I certainly can understand.

> > Interestingly, during the boot, I got thousands of the following line :
> > geode_mfgpt: reading 0x6200 + 0x6 + (0x0 * 8) = 0x6206                          
> > It's a debug line I added in geode_mfgpt_read() which writes the timer and
> > reg being read. It slowed the boot down due to being written to a serial
> > console, but fortunately stopped when syslogd had changed the console log
> > level. Just checking...
> 
> We control the timer and the status bits for the timer in the setup 
> register, which is what you are showing above.  Thats fine.

OK.

> > # grep mfgpt /proc/interrupts;sleep 10;grep mfgpt /proc/interrupts
> >   7:      82320    XT-PIC-XT        mfgpt-timer
> >   7:      84882    XT-PIC-XT        mfgpt-timer
> > 
> > It delivers 256 IRQs/s. That makes me think about this comment in mfgpt_32.c :
> 
> Hmm - are you running with nohz?

No but I have CONFIG_HZ=250. That makes sense then :

#define MFGPT_HZ  (32000 / MFGPT_DIVISOR)
#define MFGPT_PERIODIC (MFGPT_HZ / HZ)

=> MFGPT_PERIODIC = (32000 / 16) / 250 = 8
Given that it's 32.768 kHz in fact, we get 32768/16/8 = 256 Hz

> >  * We are using the 32Khz input clock - its the only one that has the
> >  * ranges we find desirable.  The following table lists the suitable
> >  * divisors and the associated hz, minimum interval
> >  * and the maximum interval:
> >  *
> >  *  Divisor   Hz      Min Delta (S) Max Delta (S)
> >  *   1        32000     .0005          2.048
> >  *   2        16000      .001          4.096
> >  *   4         8000      .002          8.192
> > ...
> > 
> > When you say a 32kHz clock, you mean 32000 Hz. Are you really sure ? Most
> > 32 kHz clocks everywhere are really 32768 Hz (the watch quartz). BTW, I'm
> > seeing a 32.768 kHz xtal close to the CS5536, and the numbers above seem
> > to support this suggestion too.
> 
> Hmm - yeah, my math is off there - it is a 32768 Hz clock.  That
> shouldn't affect things too negatively - if it does we can adjust the
> divisor we use - currently we use 16.

Why not just ajust the constant in MFGPT_HZ since it's the only place (aside
the comments) where this is referenced ?

If you want I can send you a patch and adjust the comments at the same time.

> > So right now that I've found what caused old kernel to unexpectedly work,
> > I'm planning a BIOS upgrade. I'm still just wondering what we can do to
> > detect that the workaround should be needed. I suspect nothing, of course,
> > but just in case... Maybe we can detect the effects of the workaround ?
> 
> I'm not sure if we can - all we can tell is if the registers are zero or
> not.  Like I said, running the MSR is probably dangerous in 9 out of 10
> situations, the one good use being the one you determined.  I would
> support adding the mfgptfix bit though - just as long as it isn't 
> automagic.

OK I perfectly understand. While I see the current behaviour as a regression
compared to 2.6.22-mainline (since 2.6.24-rc8 does not boot off from this
board without nomfgpt), the first problem is in the BIOS and it requires an
upgrade. Maybe we should extend the scope of CONFIG_GEODE_MFGPT_TIMER to
allow it to completely disable the detection logic when it's off ? I certainly
can work a clean patch for "mfgptfix", but for users who will get caught with
this board not booting at all anymore, adding an option in their boot loaders
may be as problematic as upgrading the BIOS. I'm also thinking about the ones
preparing new software updates from a recent boards and deploying them miles
away without knowing they are running a 0.98 BIOS which will prevent their
new kernel from booting.

> Thank you very much for your help!

You're welcome, thanks to you too :-)
Willy

