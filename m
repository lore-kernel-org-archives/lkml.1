Return-Path: <linux-kernel-owner+w=401wt.eu-S1761411AbZD2Vjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761411AbZD2Vjp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 17:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758355AbZD2Vje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 17:39:34 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:54287 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757918AbZD2Vjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 17:39:32 -0400
Date: Wed, 29 Apr 2009 14:39:31 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Thomas Renninger <trenn@suse.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, cpufreq@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2] acpi: Fix regression where _PPC is not read at boot
	even when ignore_ppc=0
Message-ID: <20090429213930.GE6968@plum>
Reply-To: djwong@us.ibm.com
References: <20090415225348.GW8311@plum> <20090416002712.GX8311@plum> <200904161201.13409.trenn@suse.de> <20090416174217.GY8311@plum> <20090416224507.GA31984@srcf.ucam.org> <20090428193303.GC6968@plum> <20090428195348.GA8376@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090428195348.GA8376@srcf.ucam.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 08:53:48PM +0100, Matthew Garrett wrote:
> On Tue, Apr 28, 2009 at 12:33:04PM -0700, Darrick J. Wong wrote:
> > On Thu, Apr 16, 2009 at 11:45:07PM +0100, Matthew Garrett wrote:
> > 
> > > That's not really an option. It works with Windows.
> > 
> > Who verified that?  Does anyone know what strategy Windows uses to avoid this
> > T60 problem?  
> 
> The best guess was that Windows only evaluates _PPC when it receives a 
> notification.

Here's the answer from the Windows side of the house:

Windows (both WS03 and WS08) will evaluate the _PPC method during boot 
once the intelppm.sys processor driver loads.  The processor driver will 
"evaluate" the _PPC method:

IntelPPM.sys: 0: Entering AcpiEval_PPC
IntelPPM.sys: 0: Entering AcpiEvaluateMethod
=0x0
AMLI: EvalObject(\_PR.C000._PPC)=Integer(:Value=0x0[0])

The Windows intelppm.sys driver can return non-zero for the _PPC method 
(in this example, _PPC returns non-zero based on what's stored in \_PTSE 
and \_TSTE named objects that were updated during POST.  The capture is 
during Windows boot when evaluating the ACPI P-State objects for each 
ProcessorId object):

....
IntelPPM.sys: Processor Performance States (0x85DF7DF0)
IntelPPM.sys:   Size:              0x210
IntelPPM.sys:   Revision:          0x1
IntelPPM.sys:   Type:              0xfe
IntelPPM.sys:   Count:             0xf
IntelPPM.sys:   MaxFrequency:      2394 mhz
IntelPPM.sys:   PState Handler:    0x88fb7006
IntelPPM.sys:   PState Context:    0x85d74298
IntelPPM.sys:   PState Cap:        0x3          <= PTSE (test: hardcoded 
PTSE to return something other than P[0])
IntelPPM.sys:   TState Handler:    0x88fb7048
IntelPPM.sys:   TState Context:    0x85d742c0
IntelPPM.sys:   TState Cap:        0x4          <= TSTE (test: hardcoded 
TSTE to return something other than T[0])
IntelPPM.sys:   Feedback Handler:  0x88fb7084
IntelPPM.sys:   Target Processors: 0xff
IntelPPM.sys:
IntelPPM.sys:   State   Speed           Power           Latency Control 
Status
IntelPPM.sys:   -----   -----           -----           ------- ------- 
------
IntelPPM.sys:   0:      2394 mhz        106000 mW       10 us   0x12 0x12 
// P[0]
IntelPPM.sys:   1:      2261 mhz        90000 mW        10 us   0x11 0x11
IntelPPM.sys:   2:      2128 mhz        74000 mW        10 us   0x10 0x10
IntelPPM.sys:   3:      1995 mhz        58000 mW        10 us   0xf 0xf // 
PTSE
IntelPPM.sys:   4:      1862 mhz        42000 mW        10 us   0xe 0xe 
IntelPPM.sys:   5:      1729 mhz        26000 mW        10 us   0xd 0xd
IntelPPM.sys:   6:      1596 mhz        10000 mW        10 us   0xc 0xc
IntelPPM.sys:   7:      1596 mhz        10000 mW        0 us    0x2 0x2
IntelPPM.sys:   8:      1404 mhz         8750 mW        0 us    0x1e 0x1e 
// T[0]
IntelPPM.sys:   9:      1197 mhz         7500 mW        0 us    0x1c 0x1c
IntelPPM.sys:   10:     1005 mhz         6250 mW        0 us    0x1a 0x1a
IntelPPM.sys:   11:      798 mhz         5000 mW        0 us    0x18 0x18
IntelPPM.sys:   12:      606 mhz         3750 mW        0 us    0x16 0x16 
// TSTE
IntelPPM.sys:   13:      399 mhz         2500 mW        0 us    0x14 0x14
IntelPPM.sys:   14:      207 mhz         1250 mW        0 us    0x12 0x12
IntelPPM.sys:
....


0: kd> !amli dns /s \TSTE

ACPI Name Space: \TSTE (ffffffff854e484c)
Integer(TSTE:Value=0x0000000000000004[4])

0: kd> !amli dns /s \PSTE

ACPI Name Space: \PSTE (ffffffff854e4898)
Integer(PSTE:Value=0x0000000000000003[3])

Note the two above dbg traces are from different systems.

(end reply)

I don't know about XP's copy of intelppm.sys, but this would seem to confirm
that WS03 and WS08 check _PPC at boot time.

--D
