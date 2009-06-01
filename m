Return-Path: <linux-kernel-owner+w=401wt.eu-S1756337AbZFATeN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337AbZFATeN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 15:34:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753637AbZFATd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 15:33:58 -0400
Received: from 41-052.adsl.zetnet.co.uk ([194.247.41.52]:58716 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685AbZFATd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 15:33:57 -0400
To: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
       netdev@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [E1000-devel] 2.6.30rc7: ksoftirqd CPU saturation (x86-64 only, not x86-32) (e1000e-related?)
References: <87prdozxns.fsf@hades.wkstn.nix>
	<alpine.WNT.1.10.0906010941170.656@jbrandeb-MOBL1.amr.corp.intel.com>
From: Nix <nix@esperi.org.uk>
Emacs: ... it's not just a way of life, it's a text editor!
Date: Mon, 01 Jun 2009 20:33:43 +0100
In-Reply-To: <alpine.WNT.1.10.0906010941170.656@jbrandeb-MOBL1.amr.corp.intel.com> (Jesse Brandeburg's message of "Mon, 1 Jun 2009 09:48:18 -0700 (Pacific Daylight Time)")
Message-ID: <87d49nzr3c.fsf@hades.wkstn.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b28 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-sonic.net-Metrics: hades 1156; Body=5 Fuz1=5 Fuz2=5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 Jun 2009, Jesse Brandeburg spake thusly:
>>  57:      0     0       0   7654      0      0      0     0   PCI-MSI-edge      gordianet-rx-0
>>  58:      0     0       0      0   8065      0      0     0   PCI-MSI-edge      gordianet-tx-0
>>  59:      0     0       0      0      3      0      0     0   PCI-MSI-edge      gordianet
>>  60:      0     0       0      0      0   3576      0     0   PCI-MSI-edge      fastnet-rx-0
>>  61:      0     0       0      0      0   2555      0     0   PCI-MSI-edge      fastnet-tx-0
>>  62:      0     0       0      0      0      0      2     0   PCI-MSI-edge      fastnet
>
> where is the e1000e interrupt here?  I was expecting to see eth0/eth1

Sorry, I renamed the interfaces and forgot because I've been running
with them renamed for so very long that I've forgotten that they ever
had other names!

They're the interrupts left in above. Not exactly line saturation, is
it?

>> I'd not expect that level of e1000e interrupt activity to flood the
>> ksoftirqds like this, and in 32-bit mode it doesn't.
>> 
>> So, anyone know what's going on, or how I could find out?
>
> when you went into 64 bit mode your kernel enabled the IOMMU/DMAR, which 
> means that map/unmap cycles are taking many more cycles per packet, 

I thought that might be so, but now I'm running in 64-bit mode with a
load of pretty much zero and the out-of-tree driver: and we see
ksoftirqd saturation with the in-tree driver on a completely idle box
(well, it's sending the odd packet out of the network interfaces because
it's headless and that's the only way I can see anything at all).

(actually I thought IOMMUs were supposed to *decrease* the load of
things like that. Is it because pte changes have to be propagated to the
IOMMU or something? It would be nice if the configure help text gave the
poor user some clue whether to turn it off or on. Presumably it's
sometimes useful or it wouldn't be there...)

> accounting for the increased CPU utilization.  you can disable at boot 
> with intel_iommu=off to see if it goes back to previous behavior.

Not so, it goes wrong in 32-bit mode as well: my original report was
incorrect, triggered by a faulty build (where 'faulty' equals
'accidentally used the in-tree e1000e rather than the out-of-tree one').

Will try hunting backwards (unisecting?) to see if the in-tree driver
*ever* worked with this card.
