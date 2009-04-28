Return-Path: <linux-kernel-owner+w=401wt.eu-S1756617AbZD1TyL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617AbZD1TyL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 15:54:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753413AbZD1Txz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 15:53:55 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:35241 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbZD1Txy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 15:53:54 -0400
Date: Tue, 28 Apr 2009 20:53:48 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Thomas Renninger <trenn@suse.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, cpufreq@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2] acpi: Fix regression where _PPC is not read at boot
	even when ignore_ppc=0
Message-ID: <20090428195348.GA8376@srcf.ucam.org>
References: <20090415225348.GW8311@plum> <20090416002712.GX8311@plum> <200904161201.13409.trenn@suse.de> <20090416174217.GY8311@plum> <20090416224507.GA31984@srcf.ucam.org> <20090428193303.GC6968@plum>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090428193303.GC6968@plum>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 12:33:04PM -0700, Darrick J. Wong wrote:
> On Thu, Apr 16, 2009 at 11:45:07PM +0100, Matthew Garrett wrote:
> 
> > That's not really an option. It works with Windows.
> 
> Who verified that?  Does anyone know what strategy Windows uses to avoid this
> T60 problem?  

The best guess was that Windows only evaluates _PPC when it receives a 
notification.

> > Please figure out how to make it work on everything rather than us just
> > repeatedly toggling between different sets of broken machines or being forced
> > to have a static table of machines.
> 
> I've thought about this for a while and still don't know how to proceed with
> this suggestion.  Right now we have:
> 
> 1. Linux, which right now does not read _PPC at boot time regardless of the
> ignore_ppc setting, leaving the kernel's copy set to 0 regardless of what the
> BIOS wants the kernel to do.  The kernel will pick up the correct value of _PPC
> if the BIOS sends a "re-evaluate _PPC" event.
> 
> Obviously, if ignore_ppc=1 then we should ignore _PPC, but I'm talking about
> _PPC not being read when ignore_ppc=0 or ignore_ppc isn't set at all.

Right. So far Linux is working as intended.

> 3. A smaller collection of machines that leave _PPC at 0 except for special
> circumstances that warrant freq/voltage restrictions (power overage,
> thermal/power throttling via p-state, etc.)
> 
> This is a problem for the following sequence:
> 
>   1. BIOS decides to set _PPC to any non-zero value.
>   2. The kernel boots with ignore_ppc=0, doesn't check _PPC, and runs with
>      all p-states enabled.
> 
>       <here is where we're running with the wrong _PPC and potentially
>        using more power/putting out more heat than the firmware wants>
> 
>   3. BIOS changes _PPC to something else and sends a Notify event.
>   4. Kernel now runs with the correct p-state restrictions.

Yes. How many machines have this behaviour, and how does Windows react 
to them?

> 4. Broken T60s where the EC (which is read in the _PPC method) freaks out and
> returns 2 all the time.  If you set ignore_ppc=1 then you get the full range of
> speeds even if the BIOS doesn't want to allow it.  Clearly the firmware needs
> some sort of fix, which means that we could Lenovo, which may or may not
> succeed because T60s were discontinued 18 months ago.

No, the T60 returns an incorrect _PPC value at boot time - once the 
firmware provides a notification (which is irritatingly frequent, given 
that the T60 seems to be a somewhat compromised as far as thermal design 
goes and Lenovo use P-state limiting as a thermal control method), it 
gives correct responses. This is what leads to the suspicion that 
Windows only evaluates _PPC in response to notifications.

> 1. No changes at all.  If ignore_ppc = 0 and _PPC != 0 when the kernel boots,
> the kernel ignores the BIOS.  That seems broken to me.

ignore_ppc will only be 0 at boot time if the user has explicitly set it 
to be, but you're right that Ingo's patch means that it won't be 
evaluated at boot time even if the user has passed ignore_ppc=0.

> I'd rather have the kernel work for the vast majority of machines that do not
> freak out, and special case the ones that do.  But I'm not clever enough to
> figure out a solution that fixes the runs-with-wrong-_PPC problem, avoids
> reading _PPC on machines that freak out, and doesn't involve blacklists or a
> toggle.  Any suggestions?

How many machines are we actually talking about here? There's a large 
number of T60s out there. It would be helpful to validate how Windows 
behaves, either by testing a machine that expects _PPC to be evaluated 
at boot time or by running something under kvm.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
