Return-Path: <linux-kernel-owner+w=401wt.eu-S1755737AbZLRWoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737AbZLRWoh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 17:44:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752610AbZLRWof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 17:44:35 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:62341 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbZLRWoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 17:44:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tQQMiYuPPvciVSf7f37L7dLSSv1e/2OrIPvvvUiDV+TUFAFI3wsYUSJRFO6LxpQ0p+
         wfdk4ia4GiDsL+cvdm8UVzi2W9ibeGltdAafkDrHv6iSYxEE6P72InI9HbdLgEAULkJM
         v6i4am87TZDHjWVtMoxlcI8lf6rqx8ZgvXy5E=
Date: Sat, 19 Dec 2009 01:44:31 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH 2/2] x86/apic: check global clockevent in lapic timer
	setup
Message-ID: <20091218224431.GA8489@lenovo>
References: <43F901BD926A4E43B106BF17856F07559A257B5C@orsmsx508.amr.corp.intel.com> <20091217194148.GB5414@lenovo> <43F901BD926A4E43B106BF17856F07559A257E3D@orsmsx508.amr.corp.intel.com> <4B2AB1F0.1020105@linux.intel.com> <43F901BD926A4E43B106BF17856F07559A257FE1@orsmsx508.amr.corp.intel.com> <alpine.LFD.2.00.0912181704360.2755@localhost.localdomain> <43F901BD926A4E43B106BF17856F07559A25826A@orsmsx508.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43F901BD926A4E43B106BF17856F07559A25826A@orsmsx508.amr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 18, 2009 at 10:13:52AM -0800, Pan, Jacob jun wrote:
...
> >
> >No, we need to fix the whole lapic timer calibration logic first.
> >
> >There is no reason why we don't calibrate the lapic at the same time
> >as we calibrate the TSC.
> [[JPAN]] that seems to be much more efficient and we can have platform specific
> way of calibration too with the x86_init abstraction.

Good idea I think!

> >
> >Another question is why there is no way to read out the lapic clock
> >frequency from some config registers or wherever the chip designers
> >decided to hide that. There is no real reason why the lapic timer
> >calibration needs to be extremly precise.
> >
> [[JPAN]] x86 does have MSR_FSB_FREQ to read bus frequency then the DCR to figure
> out LAPIC timer freq. but i guess not all CPU models have that. so having
> the abstraction would be a plus for those do have reliable reporting of lapic
> freq.

IIRC old apics may use independent clock signal too, though I dont think that we
ever switch (espec novadays) to use it due to obsolescense of such chips :)

> 
> >> Honestly, i don't fully understand how the dummy lapic event device
> >> is related to the broadcast mechanism. can someone explain why we
> >> register the dummy lapic clockevent?
> >
> >The broadcast mechanism is there in the first place to work around the
> >APIC stops in deeper C-states idiocy.
> >
> >Then we need to support the disable lapic timer command line option
> >(even on SMP) so we make use of the existing broadcast mechanism and
> >register the dummy device to have a per cpu clock event device.
> >
> [[JPAN]] thanks for the explanation. so if we have per cpu timer that is
> always-on, and don't have a broadcast timer, then the dummy device would not
> be needed, correct?
> 
> 

Hmm... We may be using nmi detector, so I think we still need dummy clockevent
device to send broadcast "time" IPI, or per-cpu timer interrupt handler have
to call the local apic interrupt routine. At least that is how I imagine this
scheme :)

> >Thanks,
> >
> >	tglx
> 
	-- Cyrill
