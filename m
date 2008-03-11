Return-Path: <linux-kernel-owner+w=401wt.eu-S1755320AbYCKTOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320AbYCKTOU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 15:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753407AbYCKTOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 15:14:10 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:36953 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579AbYCKTOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 15:14:08 -0400
Date: Tue, 11 Mar 2008 13:14:06 -0600
From: Alex Chiang <achiang@hp.com>
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>, Greg KH <gregkh@suse.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Wilcox <matthew@wil.cx>, Gary Hade <garyhade@us.ibm.com>,
       warthog19@eaglescrag.net, rick.jones2@hp.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 4/4] ACPI PCI slot detection driver
Message-ID: <20080311191406.GB29344@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
	Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
	Greg KH <gregkh@suse.de>, Jesse Barnes <jbarnes@virtuousgeek.org>,
	Matthew Wilcox <matthew@wil.cx>, Gary Hade <garyhade@us.ibm.com>,
	warthog19@eaglescrag.net, rick.jones2@hp.com,
	linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
	linux-acpi@vger.kernel.org
References: <20080229002341.GA21420@ldl.fc.hp.com> <20080301144307.GD24386@parisc-linux.org> <20080304054927.GA15566@suse.de> <200803041018.29035.jbarnes@virtuousgeek.org> <20080304193036.GB5534@suse.de> <20080304230937.GD3694@ldl.fc.hp.com> <47CDF339.3060304@jp.fujitsu.com> <20080305202052.GN3694@ldl.fc.hp.com> <47D684D0.6060200@jp.fujitsu.com> <20080311110403.7db9527c@appleyard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080311110403.7db9527c@appleyard>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kenji, Kristen,

* Kristen Carlson Accardi <kristen.c.accardi@intel.com>:
> On Tue, 11 Mar 2008 22:10:40 +0900
> Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com> wrote:
> 
> > Hi Alex-san,
> > 
> > Alex Chiang wrote:
> > >>> It wasn't the IBM machine that was breaking; it was Fujitsu. They
> > >>> were returning an error code (the numerical value 1023) when I
> > >>> called the _SUN method on a slot object that existed in the ACPI
> > >>> namespace but was not present (as reported by the _STA method).
> > >>> By the time I got that error report, I'd already dropped the
> > >>> duplicate name detection code, and was letting the kobject
> > >>> infrastructure warn about duplicate names because for my test
> > >>> cases, refcounting was a better solution.
> > >>> [Kenji-san from Fujitsu seemed to be ok with the progress I'd
> > >>> made at the time, he can speak up if he's changed his mind ;)]
> > >> Unfortunatelly, I have not tried the new version of slot detection
> > >> driver because of the lack of test environment. Maybe we need more
> > >> several days to wait for test environment. 
> > >> BTW, does the new one fixes the issue I reported before? I could
> > >> not find it in the changelog. IIRC, this issue was difficult to
> > >> solve because the root cause of this issue is from the difference
> > >> of interpretation of ACPI spec between HP and Fujitsu (I still
> > >> don't think it's a good idea to evaluate _SUN for the device
> > >> object whose _STA is 0).
> > > 
> > > It looks like we disagree on how to interpret the spec (IBM
> > > machines interpret the spec the same way HP machines do).
> > > 
> 
> OK, let me see if I can understand what the issue is here.  Please
> correct me if I'm wrong.  The debate is about whether or not it is
> legitimate to call _SUN if _STA indicates that the device is not
> present and functional.  

Yes, I agree that is what we are discussing here.

> I've checked ACPI 3.0b, and from what I've read, you may not
> evaluate _SUN until _INI is called.  And _INI should not be
> called unless _STA indicates that a device is present and
> functional.

This is also true, but I would like to point out that the *scope*
of these control methods is confusing the issue slightly.

On my machine, I have a namespace that looks like this:

|   |   |-- L001 [6]
|   |   |   |-- _UID (0x100) [1]
|   |   |   |-- LMUT [9]
|   |   |   |-- _STA (0xf) [8]
|   |   |   |-- _BBN (0x1) [8]
|   |   |   |-- _HID (HWP0002) [8]
|   |   |   |-- _CID (PNP0A03) [8]
|   |   |   |-- _PRT [8]
|   |   |   |-- _CRS [8]
|   |   |   |-- RDFM [8]
|   |   |   |-- WRFM [8]
|   |   |   |-- _DSM [8]
|   |   |   |-- _OSC [8]
|   |   |   |-- _INI [8]
|   |   |   |-- S1F0 [6]
|   |   |   |   |-- SLOT (0x0) [1]
|   |   |   |   |-- FUNC (0x0) [1]
|   |   |   |   |-- _UID (0x100) [8]
|   |   |   |   |-- _ADR (0x10000) [8]
|   |   |   |   |-- _STA (0x0) [8]
|   |   |   |   |-- _SUN (0x9) [8]
|   |   |   |   |-- _EJ0 [8]
|   |   |   |   |-- _PS0 [8]
|   |   |   |   |-- _PS3 [8]
|   |   |   |   |-- ATNS [8]
|   |   |   |   |-- ASTA [8]
|   |   |   |   |-- PWRS [8]
|   |   |   |   `-- PSTA [8]
|   |   |   |-- S1F1 [6]

My L001 object is the PCI bridge. Note that it has _STA and _INI.
My S1F0 object is the PCI slot. Note that it has a _STA and a
_SUN, but it does *not* have an _INI.

So on my machine, if L001._STA indicates "present", then we
should evaluate L001._INI and examine the children for _INI
methods. (according to acpi 3.0b spec).

If the children have _INI, then we need to check child._STA
before evaluating the child._INI.

On my machine, it is legal to evaluate S1F0._SUN independent of
S1F0._STA because L001._INI has already been evaluated.

It would be helpful to know what Fujitsu's namespace looks like.
If Fujitsu slot objects contain _STA and _INI, then I agree with
Kenji-san -- I definitely need to check _STA before evaluating
_SUN.

But in any case, I think both HP and Fujitsu firmware are doing
legal things -- neither firmware is breaking the spec.

I should not have called Fujitsu's machine a quirk, so I
apologize for that. I can change the comments to remove that
language.

I do think that what we should do is see which list is easier to
maintain, based on "what interpretation is being implemented on
most platforms".

If one list is shorter than the other, then that should be the
list to put in the kernel, and the default behavior should be
"majority rule".

Thanks.

/ac

