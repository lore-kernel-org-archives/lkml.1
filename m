Return-Path: <linux-kernel-owner+w=401wt.eu-S965397AbXBLVD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965397AbXBLVD2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 16:03:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965405AbXBLVD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 16:03:28 -0500
Received: from web50102.mail.yahoo.com ([206.190.38.30]:21307 "HELO
	web50102.mail.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S965397AbXBLVD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 16:03:28 -0500
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Feb 2007 16:03:27 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=TkE7/EdUip6/opxKsVPM9cZza4ova3krDKjNTqoLawZnvKzDjxa84SSzE9moPvu+5NQZPQ7CesPN2kefNALYOjozG//SW5PwBkFbYZuXF0J677AMv78SXjE5AXKVmHRjkDv3imiy7+RgLFElym/JUeeQg98efADH2lfhrKjK9Dk=;
X-YMail-OSG: zEoOBgYVM1kb31gbu6CayvF5QigwF0yedBNj1iUPM2eCy3TDlJ_JTMuZR0jSM1nTpOgnId6pZG.0ISVOOB9j7r3y17rYfmMgNwEAa9N4FuoXNHUTTO7Z6rC1XdOkViUb6pbPk_hKAFY-
Date: Mon, 12 Feb 2007 12:56:47 -0800 (PST)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: -mm merge plans for 2.6.21
To: Andi Kleen <ak@suse.de>, Alan <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <p73ps8igo0v.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <484858.10028.qm@web50102.mail.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Andi Kleen <ak@suse.de> wrote:

> Alan <alan@lxorguk.ukuu.org.uk> writes:
> 
> > Please just push the EDAC K8 stuff. Andi will say "no" from now
> until the
> > end of time, but end users want it, distributions want it, and Andi
> is
> > not the EDAC maintainer so should consider himself overruled on
> what
> > isn't a technical issue but a personal political viewpoint.
> 
> Well it's a technical issue -- it conflicts with the machine check
> code that is already implemented by stealing away its events.
> You would first need a CONFIG_MCE=n on x86-64 at least, otherwise
> one of them will be unhappy.
> 
> The other issue is that the existing code does everything EDAC
> K8 does already perfectly fine, just in a small fraction of 
> the code.
> 
> -Andi

I assert that there is a greater than just a technical implementation
issue. I maintain that it is a design pattern issue.

The MCE hardware mechanism is a good mechanism for reporting Hardware
events. The problem comes in as to WHERE those events should be
handled.

EDAC was designed to be a 'stack' of drivers. The upper CORE module is
to provide an abstraction, whose presentation to user space is to be
uniform across processes and architectures. The individual lower
drivers, which register with the core, handle the machine and/or
architecture specifics of 'driving' the hardware and funnel events to
the core.

EDAC is operational now on MIPS and ARM architectures (phone device) as
well as on x86 and x86_64.

Additional features of a given arch/processor that can be utilized in
harvesting hardware events should be captured and then funneled to the
'low' level EDAC driver. That driver can then pass the event onto the
CORE module for further processings and presentation, as determined by
the controls into the CORE.  

MCE event processing should be funneled to the EDAC K8 driver and not
directly to userspace.

The design pattern I have been trying to utilize in EDAC, is the same
one used by the Network stack and the SCSI stack.  

If I have a new NIC, which has some great new hardware feature, should
the driver export that feature outside of the network stack, which does
not CURRENTLY support the processing of the feature. OR should the
network stack control paths be extended to provide a mechanism whereby
that new feature could be utilized?

Similiar design pattern exists on the SCSI stack, with device features
and hardware abilities.

I am currently developing enhancements to EDAC that provide for L1, L2,
etc cache ECC event harvesting, DMA ECC event harvest, interconnect
harvesting, and other chipset/processing ECC event harvesting. Some
events are polled others are software interupt delivered. This is on an
arch OTHER than x86 or x86_64. But these EDAC features can be used on
the x86/x86_64 as well.

As there IS an ECC event consumption race between MCE and EDAC, then at
least a 'config' mechanism can be utilized to switch between the two. 

Better yet, I would like to be able to capture the MCE events and
funnel them to EDAC, when loaded, as a downstream consumer of the MCE
event stream. Then EDAC would process the information and then proceed
to inform whether the event was handled or not by EDAC. Additionally,
it would inform whether a panic should occur or not.

When EDAC is not loaded, then MCE would act as it does now.

The downside with both EDAC and MCE being in place, is that there would
be ONE MCE processing pattern for the AMD x86_64 processors and the
EDAC pattern for all the other archs/processors. As far as I can tell,
other MCE processors don't generate the events as advertized. Maybe I
am wrong on that, but I can't find them. How much hardware specific
detail should be exported?

I assert the better solution is to have the ability to hook into the
MCE event stream by the EDAC K8 driver, then provide action rules (EDAC
controls) in processing those events, which EDAC would return to the
MCE stream.

As to the size of the MCE code doing everything EDAC K8 does, that is
mostly true. BUT then the x86_64 MCE mechanism becomes the exception
path. 

Even the company using EDAC on the phone device doesn't mind the 60
kilobytes.

doug t

