Return-Path: <linux-kernel-owner+w=401wt.eu-S933441AbZINSfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933441AbZINSfB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 14:35:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755657AbZINSfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 14:35:00 -0400
Received: from e24smtp02.br.ibm.com ([32.104.18.86]:40253 "EHLO
	e24smtp02.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755708AbZINSe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 14:34:59 -0400
Subject: Re: [tpmdd-devel] [PATCH] TPM: Fixup pubek sysfs file
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: "Jonathan M. McCune" <jonmccune@cmu.edu>
Cc: Greg KH <greg@kroah.com>,
       Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
       linux-kernel@vger.kernel.org, jbeulich@novell.com, jmorris@namei.org,
       tpmdd-devel@lists.sourceforge.net, m.selhorst@sirrix.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Roland Dreier <rdreier@cisco.com>
In-Reply-To: <4AAE84EA.8010109@cmu.edu>
References: <20090904045231.GW4973@obsidianresearch.com>
	 <adaab1bnvz3.fsf@cisco.com>
	 <20090904140325.c592289a.akpm@linux-foundation.org>
	 <20090904212316.GZ406@obsidianresearch.com>
	 <17754_1252731784_n8C533ou010944_20090911162837.GC17677@kroah.com>
	 <4AAE84EA.8010109@cmu.edu>
Content-Type: text/plain
Date: Mon, 14 Sep 2009 15:34:39 -0300
Message-Id: <1252953279.9372.229.camel@blackbox>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, when reading the other queued patches I saw this discussion and
meant to write about this too.

On Mon, 2009-09-14 at 14:01 -0400, Jonathan M. McCune wrote:
> Hello everybody,
> 
> I have decided to chime in as a frequent (and I'm going to claim
> "experienced") user of the linux kernel TPM driver.
> 
> To the best of my knowledge there is very little code in the wild that
> depends on the current structure of these sysfs entries.  Probably the
> most used set of libraries and programs -- "TrouSerS" and "TPM Tools"
> (trousers.sourceforge.net) -- interact directly with the TPM via
> /dev/tpm*.  I'm fairly confident that "tboot" (tboot.sourceforge.net) 
> and "jTPM Tools" (trustedjava.sourceforge.net) don't use the sysfs 
> entries either.

At least for TrouSerS I can say it doesn't use sysfs at all. tpm-tools
runs on top of TrouSerS, so the same apply. And for jTPM, it can use the
jTSS wrapper, that wraps TrouSerS function calls, so no sysfs here too,
and IAIK jTSS, that's is intented to be cross-platform, so no sysfs here
too I assume. If I'm not wrong tboot doesn't run in user space. So, good
points for us.

> 
> Thus, fixing the one-item-per-file issues seems reasonable to me. For 
> example, changing /sys/devices/platform/tpm_tis/pcrs from a single
> multi-entry file to a directory containing files named 0-15 or 0-23 that
> each then contain only the relevant 20-byte value seems quite
> reasonable. (Today's TPMs contain either 16 or 24 PCRs but future ones
> could contain many more.)
> 

The number of PCRs of a particular TPM can be retrieved sending it the
TPM_GetCapability command, so it's feasible to build this directory
structure dynamically (chip independent).


> The changes I've mentioned are larger and don't seem appropriate for 
> 2.6.31, but perhaps a plan to have them implemented for an upcoming 
> version is reasonable?  Is anybody willing to help put together such a 
> patch?  Discuss whether it's reasonable / acceptable to do so?
> 

Count on me. ;-)

Do you all agree? I'll start writing something/patches and will post
here for further discussions.

Rajiv

> Thanks,
> -Jon
> 
> 
> Greg KH wrote:
> > On Fri, Sep 04, 2009 at 03:23:16PM -0600, Jason Gunthorpe wrote:
> >> On Fri, Sep 04, 2009 at 02:03:25PM -0700, Andrew Morton wrote:
> >>> On Thu, 03 Sep 2009 22:02:24 -0700
> >>> Roland Dreier <rdreier@cisco.com> wrote:
> >>>
> >>>>  > Algorithm: 00 00 00 01
> >>>>  > Encscheme: 00 03
> >>>>  > Sigscheme: 00 01
> >>>>  > Parameters: 00 00 08 00 00 00 00 02 00 00 00 00
> >>>>  > Modulus length: 256
> >>>>
> >>>> No argument that this fix is an improvement, but what happened to the
> >>>> "one value per file" rule for sysfs??
> >>> We goofed.  This one snuck through.
> >>>
> >>> It's one of the reasons why I recommend that people cite examples of
> >>> the sysfs/procfs output in changelogs.  These things are part of the
> >>> kernel ABI and once they go in we cannot change them so we have to get
> >>> them right first time.
> >> Several of the sysfs files in the TPM driver are goofed:
> >>
> >> /sys/devices/platform/tpm_tis.0 # cat caps
> >> Manufacturer: 0x57454300
> >> TCG version: 1.2
> >> Firmware version: 2.16
> >>
> >> /sys/devices/platform/tpm_tis.0 # cat pcrs 
> >> PCR-00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
> >> PCR-01: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
> >> PCR-02: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
> >> PCR-03: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
> >> PCR-04: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
> >> PCR-05: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
> >> PCR-06: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
> >> PCR-07: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
> >> PCR-08: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
> >> PCR-09: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
> >> PCR-10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
> >> PCR-11: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
> >> PCR-12: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
> >> PCR-13: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
> >> PCR-14: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
> >> PCR-15: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
> >> PCR-16: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
> >> PCR-17: FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF 
> >> PCR-18: FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF 
> >> PCR-19: FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF 
> >> PCR-20: FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF 
> >> PCR-21: FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF 
> >> PCR-22: FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF 
> >> PCR-23: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
> >>
> >> /sys/devices/platform/tpm_tis.0 # cat pubek
> >> Algorithm: 00 00 00 01
> >> Encscheme: 00 03
> >> Sigscheme: 00 01
> >> Parameters: 00 00 08 00 00 00 00 02 00 00 00 00
> >> Modulus length: 256
> >> Modulus: 
> >> AF 6B 30 9B 0D B3 B4 7D 74 35 68 45 8D CA A5 EF 
> >> A8 8A DD 0F D7 84 8E 8D 1F 40 22 92 09 CF 12 C8 
> >> 9F 6E 55 57 6A 2C A8 0B 5E 45 C7 5E 3D 56 DA 64 
> >> E6 E1 F7 8C DD 41 92 28 2E 06 41 02 3E 11 7D B2 
> >> C5 46 38 E5 8C 60 D2 96 EE 0C D6 3D F8 99 E3 02 
> >> 3A 32 7A 02 C8 31 29 98 28 B9 1B EF 30 A1 A0 45 
> >> A0 C0 05 0E C5 96 95 FD 91 47 0A 35 E0 69 B0 8B 
> >> 49 BD B9 F6 5D 25 21 25 79 1B 20 0D C3 C7 1F 87 
> >> 5E 5F 41 4B DE 32 DF 55 F3 BD 7F CA D8 7D 3A B4 
> >> D5 0A EF CF 8E 72 20 52 15 FA FB C6 C0 2E C2 AB 
> >> C6 07 D0 9D 96 6B 2E 30 F7 54 C4 A5 CD 9B 13 54 
> >> A0 D1 71 66 91 97 06 12 B5 2D B2 33 62 FB 56 62 
> >> 64 A8 AA E9 F2 F4 03 C3 F4 49 2A 09 0D 7D 75 99 
> >> 6C F0 47 1E 7D D5 A5 CA CE EF 45 B2 DA 88 93 B4 
> >> EE EB FB B0 A6 A4 19 C4 B8 0D 04 46 AE BD C5 2E 
> >> 30 84 49 57 25 34 78 E6 ED C4 50 AF 3B F6 86 43 
> >>
> >> At least this has been like this since before the git history, so it
> >> isn't recent..
> >>
> >> Can these be scheduled for removal or some such process? I haven't
> >> seen anything actually using the files, the only one that is really
> >> useful is caps...
> >>
> >> They probably should have been in debugfs, had it existed at the time.
> > 
> > Feel free to move them to debugfs, it looks like that is what they are
> > for.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > ------------------------------------------------------------------------------
> > Let Crystal Reports handle the reporting - Free Crystal Reports 2008 30-Day 
> > trial. Simplify your report design, integration and deployment - and focus on 
> > what you do best, core application coding. Discover what's new with 
> > Crystal Reports now.  http://p.sf.net/sfu/bobj-july
> > _______________________________________________
> > tpmdd-devel mailing list
> > tpmdd-devel@lists.sourceforge.net
> > https://lists.sourceforge.net/lists/listinfo/tpmdd-devel
> > 
> 

