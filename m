Return-Path: <linux-kernel-owner+w=401wt.eu-S1753860AbYCMDYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860AbYCMDYe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 23:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751901AbYCMDYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 23:24:14 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:11052 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbYCMDYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 23:24:12 -0400
Date: Wed, 12 Mar 2008 21:24:10 -0600
From: Alex Chiang <achiang@hp.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Greg KH <gregkh@suse.de>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Wilcox <matthew@wil.cx>, Gary Hade <garyhade@us.ibm.com>,
       warthog19@eaglescrag.net, rick.jones2@hp.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 4/4] ACPI PCI slot detection driver
Message-ID: <20080313032410.GA17561@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
	Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
	Greg KH <gregkh@suse.de>, Jesse Barnes <jbarnes@virtuousgeek.org>,
	Matthew Wilcox <matthew@wil.cx>, Gary Hade <garyhade@us.ibm.com>,
	warthog19@eaglescrag.net, rick.jones2@hp.com,
	linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
	linux-acpi@vger.kernel.org
References: <20080304054927.GA15566@suse.de> <200803041018.29035.jbarnes@virtuousgeek.org> <20080304193036.GB5534@suse.de> <20080304230937.GD3694@ldl.fc.hp.com> <47CDF339.3060304@jp.fujitsu.com> <20080305202052.GN3694@ldl.fc.hp.com> <47D684D0.6060200@jp.fujitsu.com> <20080311110403.7db9527c@appleyard> <20080311191406.GB29344@ldl.fc.hp.com> <47D7BF6C.3080306@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47D7BF6C.3080306@jp.fujitsu.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kenji-san,

* Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
> Hi Alex-san,
>
>> On my machine, it is legal to evaluate S1F0._SUN independent of
>> S1F0._STA because L001._INI has already been evaluated.
>> It would be helpful to know what Fujitsu's namespace looks like.
>> If Fujitsu slot objects contain _STA and _INI, then I agree with
>> Kenji-san -- I definitely need to check _STA before evaluating
>> _SUN.
>
> Thank you for explanation. Maybe I understood the summary of
> implementation of HP firmware. But how to use or where to put _INI
> method in the ACPI namespace never becomes reasonable reason why
> your driver may ignore _STA before evaluating _SUN.
>
>> But in any case, I think both HP and Fujitsu firmware are doing
>> legal things -- neither firmware is breaking the spec.
>
> My understanding of your explanation so far is:
>
> - evaluating _SUN without checking _STA doesn't cause problem,
>  from the view point of HP's implementation.
> - some IBM machine is doing same as HP
>
> I never think those are reasonable reasons why ignoring _STA
> before evaluating _SUN is legal. Am I missing something?

I think the piece that I did not explain clearly is that the spec
does not require checking _STA immediately before _SUN. The spec
says: 

	- you must check _STA before calling _INI
	- _INI must be called to initialize _SUN
	- _INI is called once, when the table is loaded

On HP's implementation, we do obey those rules. We call _INI on
the PCI bridge during boot, which then initializes the children
SxFy objects. From that point on, it is legal for us to call
_SUN.

The other issue is that the spec does not specify the *semantics*
of _STA. P/IBM firmware engineers think _STA should indicate card
presence, but Fujitsu firmware engineers think _STA should
indicate slot presence.

I don't think either firmware team is incorrect -- it is simply
the case that the specification was not precise enough, to the
point where separate teams following the same spec came up with
implementations with different behaviors and different semantics.

I believe that we both have compliant, legal firmware.

>> If one list is shorter than the other, then that should be the
>> list to put in the kernel, and the default behavior should be
>> "majority rule".
>
> I don't want to consider "majority rule" before I understand why
> ignoring _STA is legal.

On HP and IBM machines, it *is* legal because we *did* call _STA,
then _INI, then _SUN. That is one interpretation of the spec.

On Fujitsu machines, the semantics of _STA are different, and it
is not legal to ignore _STA. That is another interpretation of
the spec.

Because I think we both have compliant, legal firmware, I think
the kernel should pick the most maintainable solution for the
different implementations. In my opinion, writing code for
"majority rule" and shorter DMI lists is the most maintainable
solution.

Let us try to find a compromise, ok? Right now, for the machines
we know about, there are more implementations where _INI lives at
the bridge level and correctly initialize _SUN, so it's easier to
follow my original approach.

If we can get this into linux-next and get more exposure on more
platforms, and we find out that the other interpretation of the
spec is more popular, then I will very happily ACK your patch,
and we can have DMI calls to handle HP/IBM machines.

Does that sound fair?

[Let's try and work out an answer here before working on shpchp
naming issues; I already agree that I need to fix that issue
before going upstream, but I want to focus here first.]

Thanks,

/ac

