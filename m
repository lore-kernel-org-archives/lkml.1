Return-Path: <linux-kernel-owner+w=401wt.eu-S1753547AbXLTT35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbXLTT35 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 14:29:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751996AbXLTT3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 14:29:49 -0500
Received: from hera.kernel.org ([140.211.167.34]:58315 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157AbXLTT3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 14:29:48 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: Voluntary leave_mm before entering ACPI C3
Date: Thu, 20 Dec 2007 14:28:03 -0500
User-Agent: KMail/1.9.5
Cc: Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <20071219183443.GA547@linux-os.sc.intel.com> <20071219235357.53157cea@laptopd505.fenrus.org> <476A9576.3020203@zytor.com>
In-Reply-To: <476A9576.3020203@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712201428.03653.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 December 2007 11:16, H. Peter Anvin wrote:
> Arjan van de Ven wrote:
> > On Wed, 19 Dec 2007 11:48:14 -0800
> > "H. Peter Anvin" <hpa@zytor.com> wrote:
> > 
> >> I think C3 guarantees that the cache contents stay intact, and thus
> >> it might make sense in some technology to preserve the TLB as well
> >> (being a kind of cache.)
> > 
> > that sounds nice. It's fiction though ;-)
> > 
> > The thing to realize is that linux only sees "ACPI C3";
> > the BIOS maps that C3 to..
> > well any of the C states the processor in the system has.
> > What you're saying is afaik correct for the *hardware* C3, not for the "C3" that Linux sees..   
> 
> Well, it can only map ACPI C3 to a state which is no more "dead" than 
> what would normally be permitted by C3.  IIRC, C3 is allowed to require 
> that DMA be turned off (unlike C2), but is not allowed to lose the CPU 
> state.


Re: mapping HW to ACPI C-states.

Right, it is fair game for the BIOS to map a "shallower" hardware C-state
to a "deeper" ACPI C-state.

Re: CPU state

All C-states preserve the CPU SW programming state.
(eg. while it may be saved and restored in HW,
 it appears to SW to be always intact).

Re: C3 guarantees that the cache contents stay intact

This is both true and false, depending on how you use the word "intact".

If "intact" == "stays valid in cache", then no, this not guaranteed.
The HW reserves the right to flush some or all of the L1 and L2
caches whenever it wants to --
this includes both HW and ACPI C2 and C3 states.

If "intact" = "cache consistent", then yes, this guarantee is true.
The way the guarantee is implemented varies by generation.
Older systems would lock the bus in C3 to assure
the processor was woken up for DMA to snoop.
Newer hardware simply wakes the cache to snoop
without waking the cores, or if it flushes the caches
then it doesn't have to snoop at all -- which also
counts as "cache consistent":-)

cheers,
-Len

