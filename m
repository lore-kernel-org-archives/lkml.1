Return-Path: <linux-kernel-owner+w=401wt.eu-S1758192AbZDPStp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758192AbZDPStp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 14:49:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757231AbZDPStd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 14:49:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53709 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757106AbZDPStc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 14:49:32 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: djwong@us.ibm.com
Subject: Re: [PATCH v2] acpi: Fix regression where _PPC is not read at boot even when ignore_ppc=0
Date: Thu, 16 Apr 2009 20:49:26 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.19-3.2-default; KDE/4.1.3; x86_64; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       cpufreq@vger.kernel.org, linux-acpi@vger.kernel.org
References: <20090415225348.GW8311@plum> <200904161201.13409.trenn@suse.de> <20090416174217.GY8311@plum>
In-Reply-To: <20090416174217.GY8311@plum>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904162049.27588.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 April 2009 19:42:18 Darrick J. Wong wrote:
> On Thu, Apr 16, 2009 at 12:01:11PM +0200, Thomas Renninger wrote:
> > Hi,
> > 
> > be careful, this could break the T60 again.
> 
> So long as T60 owners boot with ignore_ppc=1, they should still be fine.
That would be a regression :)
But as said, I hope with Yakui's patch and your patch,
everything might work out fine for everyone.
Let me send a cleanup on top (your's is in already if I understood Ingo correctly)
in some days and people with affected machines should give it a try.
 
> > Can you and Ingo place acpidump of your machines somewhere, please.
> > 
> > On Thursday 16 April 2009 02:27:12 Darrick J. Wong wrote:
> > > Earlier, Ingo Molnar posted a patch to make it so that the kernel would avoid
> > > reading _PPC on his broken T60.  Unfortunately, it seems that with Thomas
> > > Renninger's patch last July to eliminate _PPC evaluations when the processor
> > > driver loads, the kernel never actually reads _PPC at all!
> > This is wrong. _PPC is only evaluated when a cpufreq driver got registered.
> 
> I put a printk just before the call to acpi_evaluate_integer in
> acpi_processor_get_platform_limit.  The printk did not appear unless (a)
> I triggered the Notify event to get the kernel to reevaluate _PPC or (b)
> I took a CPU offline and online.
> 
> An alternate way to describe the situation, I think, is that ignore_ppc
> doesn't go from -1 to 0 until acpi_processor_ppc_notifier gets called,
> and that only seems to happen during an ACPI Notify event.
> 
> > > This is problematic
> > > if you happen to boot your non-T60 computer in a state where the BIOS _wants_
> > > _PPC to be something other than zero.
> > Your machine should suffer from that since Ingo's T60 patch?
> 
> Yes, but the particular machine I have didn't exist until a couple of
> weeks ago, and before that our BIOSes were written so that _PPC always
> returned zero, which masked the problem.
> 
> The _PPC method in this (preproduction) machine's BIOS also sets a flag
> that enables the sending of _PPC Notify events.
Oh dear, I hope this is not for specific Windows OSes.

> I'm not sure if that's
> the proper way to do such things, though it seems logical that if an OS
> never reads _PPC then sending Notify events for it is pointless.
No it's not.
There is the _PDC call which the OS calls and tells the BIOS that it
has a cpufreq driver. I expect (hope) from this point on (when OS called this
function and told the BIOS that it can do cpufreq) the T60 does
return a sane (zero) _PPC value.
That was what my patch was doing in an ugly way. Making sure cpufreq drivers
were loaded first (and _PDC was called), before any _PPC notifications
are evaluated.
But Yakui's patch moved ACPI function calls in a way, that calling _PDC
is done before _PPC. So everybody (with your patch added) could be happy
in the end.
 
> > Reading the _PPC part of the ACPI spec again:
> > ---
> > In order to support dynamic changes of _PPC object, Notify events on
> > the processor object. Notify events of type 0x80 will cause OSPM to
> > reevaluate any _PPC objects residing under the particular processor object
> > notified.
> > ---
> > The *reevaluate* implies that the _PPC value has been evaluated/initialized
> > by the OS already and Ingo's patch would be wrong then.
> > I'd like to have a look at the T60's ACPI parts and find out what exactly
> > (or if at all) makes _PPC to return sane values, I expect it's _PDC.
> 
> I recall that on the T60 BIOS, the _PPC was programmed to read the value
> out of some register in the embedded controller, but I'll have to go
> find a T60 to see what the latest BIOSes do.  There's nothing in the T60
> BIOS update changelogs to indicate that they found and corrected a
> problem with _PPC... but that doesn't eliminate the possibility that
> they "forgot" to document one.
> 
> Though I do recall seeing some weird bug with that T60 where putting the
> machine to sleep would confuse it into "1ghz only" mode, though I never
> noticed this symptom after a fresh boot.
Yeah, really weird things can happen on really weird (and tons of different)
BIOS implementations.

    Thomas
> 
> > Hmm, I could also imagine that Ingo's T60 patch is not needed anymore since
> > Yakui's patch (0ac3c571315a53c14d2733564f14ebdb911fe903).
> > This one could make sure that _PDC is evaluated first making the internal
> > ACPI _PPC state initialize and makes sure _PPC gets only called afterwards.
> > 
> > If this patch does not break Ingo's T60, I think this should go in.
> > Due to Yakui's reordering/cleanup of ACPI function calls, I think also
> > the notifier chain I introduced is not needed anymore and I can clean this
> > up if I find some time.
> 
> > You are more or less reverting Ingo's patch (e4233dec749a3519069d9390561b5636a75c7579):
> 
> Yes, but preserving the ignore_ppc=1 override.

