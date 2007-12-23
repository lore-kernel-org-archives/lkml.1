Return-Path: <linux-kernel-owner+w=401wt.eu-S1754762AbXLWIeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbXLWIeY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 03:34:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbXLWIeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 03:34:15 -0500
Received: from mailbox2.myri.com ([64.172.73.26]:1986 "EHLO myri.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750872AbXLWIeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 03:34:14 -0500
Message-ID: <476E1D55.6090003@myri.com>
Date: Sun, 23 Dec 2007 03:33:25 -0500
From: Loic Prylli <loic@myri.com>
User-Agent: Thunderbird/2.0.0.4 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch] Make MMCONFIG space (extended PCI config space) a driver
 opt-in issue
References: <20071222043139.0cd59804@laptopd505.fenrus.org> <476D1D16.5090703@garzik.org> <20071222064719.73fdd9a4@laptopd505.fenrus.org> <alpine.LFD.0.9999.0712221003000.21557@woody.linux-foundation.org> <476DB95F.3090801@garzik.org> <alpine.LFD.0.9999.0712221939570.21557@woody.linux-foundation.org> <476DDFEE.3010009@garzik.org> <alpine.LFD.0.9999.0712222034150.21557@woody.linux-foundation.org> <476DE98F.2010009@garzik.org> <476DF1A6.3060900@myri.com> <476DF5BE.5030004@garzik.org>
In-Reply-To: <476DF5BE.5030004@garzik.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/23/2007 12:44 AM, Jeff Garzik wrote:
>>
>> By possibly using different implementations for the two ranges you avoid
>> introducing a new API, you avoid taking risks with mmconf when you don't
>> need it. That doesn't preclude using mmconf for everything either if the
>> user requests it or based on enough knowledge of the system to be sure
>> nothing will break.
>
> Are you prepared to guarantee that freely mixing mmconfig and type1
> config accesses at runtime will always work, on all chipsets?  I'm
> talking about silicon here, not kernel software.




Your question is whether I expect a mix of type1 (for legacy conf space)
and mmconfig (for >= 256) to trigger some bug in silicon causing
flakiness (why not possible random corruption) that would not happen
when only using type1 or mmconfig.


Obviously, I cannot prove or guarantee the absence of subtle silicon
bugs. But I can say:
-  documentation is saying mixing them is OK,  pci-express docs insists
on paying attention to ordering when mixing (which is easy on x86),
acknowledging one is able to mix them.
- All current kernels have been using a mix of "type1" and "mmconf"
accesses to the same device even if that's only used during mmconfig
initialization.
- On amd platforms with typical combination on mmconf-aware and
non-mmconf aware chipsets, you always have a mix of "type1" and "mmconf"
accesses all the time with standard kernels (not on the same bus)
- Mixing such accesses on the same device at runtime has happened on
thousands of systems for Myricom device/software users.


Are you prepared to guarantee no processor will ever have a wierd
silicon problem that's triggered by any Linux change?

 Mixing mmconf/type-1 is an approach that any mmconf-able hardware is
supposed to support, it has been tried on at least most
server/workstation chipsets typically used in the last two years, so the
burden of proof is on actually finding some silicon that cannot do that
properly before rejecting that based on hardware fears  (otherwise you
go on a slippery slope).




>
> Furthermore, is it best for our users to find problems with mixed
> config accesses -- not at boot time, not at driver load time, but at
> some random time when some random driver does its first extended
> config space access?  IMO, no.  If you are going to fail, failing in a
> predictable, visible way is best.






A failure happening during driver initialization or some very specific
identifiable driver event (the first ext-conf-space access is not
something popping randomly in the life of a driver) is predictable and
visible.  I am not sure what kind of problem you are afraid of anyway
(ext-conf-space not available?), so it's hard to talk generally.


Needless to say, I never said to not to test mmconf on all pci-express
devices advertised in MCFG during initialization time (preferably after
all PCI-memory-space initialization is done since there is uncertainty
about whether mmconf might conflict with that in some corner cases).




>
> Failures are more predictable and more consistent with an all-or-none
> scenario.  The all-or-none solutions are the least complex on the
> software side, and far more widely tested than any mixed config access
> scheme.



Disabling altogether ext-conf-space access by default (that's the
default your propose, right? ) is definitely the safest approach. But
that's the least useful too.


Caricaturing, I am the one advocating the real all-or-none scenario:
always use type1 for legacy conf-space (never mmconf). You are saying
that for the legacy-conf-space access, some people should use mmconf and
other people should use type1 based on their kernel configuration or
command-line, and that use depends on something unrelated (whether they
feel they might need extended-conf-space access at some point, be it
even for lspci/setpci).



Loic



