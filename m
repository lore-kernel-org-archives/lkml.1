Return-Path: <linux-kernel-owner+w=401wt.eu-S1755573AbZCXBAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573AbZCXBAs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 21:00:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753934AbZCXBAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 21:00:36 -0400
Received: from gate.crashing.org ([63.228.1.57]:43016 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753183AbZCXBAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 21:00:36 -0400
Subject: Re: [RFC][PATCH 0/2] Export platform_pci_set_power_state() and
 make radeonfb use it
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Linux PCI <linux-pci@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090323152330.536a5a1c@hobbes.virtuouswap>
References: <200903210003.55161.rjw@sisk.pl>
	 <200903222208.22434.rjw@sisk.pl> <200903232230.10831.rjw@sisk.pl>
	 <20090323152330.536a5a1c@hobbes.virtuouswap>
Content-Type: text/plain
Date: Tue, 24 Mar 2009 11:57:19 +1100
Message-Id: <1237856239.25062.696.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-23 at 15:23 -0700, Jesse Barnes wrote:
> The thing I didn't like was that it made the radeon driver use an
> internal interface; I'd really prefer a proper return value from
> pci_set_power_state, which in turn means auditing all its current
> callers. But that doesn't seem worth it unless we see other drivers
> needing something similar...
> 
> And if we did go with something like your first patch, I'd still rather
> see the timeout done in the driver, rather than having the attempts &
> delay included in the function...

So what ? The driver would call pci_set_power_state() until it stops
failing ?

I'm not too fan of that, because it will change the access pattern
to the chip:

 - write PM to 2
 - short delay
 - read PM, see 0, return error
 - driver does big delay
 - write PM to 2
 - short delay
 - read PM ....

vs. the current sequence which is

 - write PM to 2
 - long delay
 - read PM, be happy

Which -seems- to be pretty much what happens in practice, though on that chip,
I don't know for sure about others.

I'm worried of the possible side effects of the first sequence that you propose
since it would do 2 things potentially confusing to the HW:

 - read PM after a short delay... it -should- be harmless but you know
HW as well as I do ...

 - write PM to 2 a second time after the long delay. Again, it -should- be
harmless since the chip at this stage should already be in D2 state but god
knows how the HW will react.

I'm especially worried about the later in fact. Maybe we can minimize it by
having pci_set_power_state() dbl check the content of the PM reg before writing
to it...

Ben.


