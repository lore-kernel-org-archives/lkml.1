Return-Path: <linux-kernel-owner+w=401wt.eu-S1754748AbZCXWEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748AbZCXWEu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 18:04:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754569AbZCXWEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 18:04:32 -0400
Received: from mail-gx0-f208.google.com ([209.85.217.208]:60556 "EHLO
	mail-gx0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754699AbZCXWE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 18:04:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kLKvgGHIgsaDStx5JgxJB0EvkYsitC55bE6dVLiJ/VkndIJi//UwoMijVTovSE2zuB
         ne0H33Dhh16aE6YVY1ArKoLuA/OxdE9JdkKdaTapTfv1FR4p9yART6Ffl7dQhmOosiLI
         GpE77OSJpOxC9hnujiAu6/KcPZQtqSU9QKXjA=
MIME-Version: 1.0
In-Reply-To: <20090323181420.30125d59@hobbes.virtuouswap>
References: <200903210003.55161.rjw@sisk.pl> <200903222208.22434.rjw@sisk.pl>
	 <200903232230.10831.rjw@sisk.pl>
	 <20090323152330.536a5a1c@hobbes.virtuouswap>
	 <1237856239.25062.696.camel@pasglop>
	 <20090323181420.30125d59@hobbes.virtuouswap>
Date: Tue, 24 Mar 2009 18:04:25 -0400
Message-ID: <a728f9f90903241504m3fbd3417ke8705a415d7761df@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/2] Export platform_pci_set_power_state() and make 
	radeonfb use it
From: Alex Deucher <alexdeucher@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux PCI <linux-pci@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/23/09, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> On Tue, 24 Mar 2009 11:57:19 +1100
>  Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
>
>  > On Mon, 2009-03-23 at 15:23 -0700, Jesse Barnes wrote:
>  > > The thing I didn't like was that it made the radeon driver use an
>  > > internal interface; I'd really prefer a proper return value from
>  > > pci_set_power_state, which in turn means auditing all its current
>  > > callers. But that doesn't seem worth it unless we see other drivers
>  > > needing something similar...
>  > >
>  > > And if we did go with something like your first patch, I'd still
>  > > rather see the timeout done in the driver, rather than having the
>  > > attempts & delay included in the function...
>  >
>  > So what ? The driver would call pci_set_power_state() until it stops
>  > failing ?
>
>  Yeah, that's what I had in mind.
>
>  > I'm not too fan of that, because it will change the access pattern
>  > to the chip:
>  >
>  >  - write PM to 2
>  >  - short delay
>  >  - read PM, see 0, return error
>  >  - driver does big delay
>  >  - write PM to 2
>  >  - short delay
>  >  - read PM ....
>  >
>  > vs. the current sequence which is
>  >
>  >  - write PM to 2
>  >  - long delay
>  >  - read PM, be happy
>  >
>  > Which -seems- to be pretty much what happens in practice, though on
>  > that chip, I don't know for sure about others.
>  >
>  > I'm worried of the possible side effects of the first sequence that
>  > you propose since it would do 2 things potentially confusing to the
>  > HW:
>  >
>  >  - read PM after a short delay... it -should- be harmless but you know
>  > HW as well as I do ...
>  >
>  >  - write PM to 2 a second time after the long delay. Again, it
>  > -should- be harmless since the chip at this stage should already be
>  > in D2 state but god knows how the HW will react.
>  >
>  > I'm especially worried about the later in fact. Maybe we can minimize
>  > it by having pci_set_power_state() dbl check the content of the PM
>  > reg before writing to it...
>
>  Honestly I'm not too happy about any of the approaches, but yeah I see
>  your point.  The main thing is to prevent any config space access for
>  a specified time after the first D-state transition, which I think we
>  do correctly in the core.  Beyond that, we just have to make sure the
>  core state is updated correctly; Rafael's first patch does that
>  correctly I think.
>
>  Actually now that I think of it, maybe Alex can get us details on the
>  errata here.  If we just need a longer wait between a D-state transition
>  and the next config space access for this chip (or set of chips), we
>  could add that as a proper quirk to the core...
>
>  Alex, any thoughts about the bug & patch in
>  http://bugzilla.kernel.org/show_bug.cgi?id=12846 ?  Looks like old
>  radeon chips need a workaround when transitioning from D0 -> D2...

I don't see any errata for this, but it's hard to find stuff as chips get older.

Alex
