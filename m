Return-Path: <linux-kernel-owner+w=401wt.eu-S1755513AbZCXBOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513AbZCXBOh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 21:14:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753380AbZCXBO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 21:14:27 -0400
Received: from outbound-mail-14.bluehost.com ([69.89.18.114]:33597 "HELO
	outbound-mail-14.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752218AbZCXBO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 21:14:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Eo4RrVa/r24o146zdmBfxWo09w4p5eXW9Ozn6Qj/oy0GY4XZfgOpcUuMMfpL7lKnmCJ80c80km0GjxGS7FvLdbo/vLd+7w6D3hKx2lv6YElapDLigAeAp4KmYhH8SWOl;
Date: Mon, 23 Mar 2009 18:14:20 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Linux PCI <linux-pci@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alex Deucher <alexdeucher@gmail.com>
Subject: Re: [RFC][PATCH 0/2] Export platform_pci_set_power_state() and make
 radeonfb use it
Message-ID: <20090323181420.30125d59@hobbes.virtuouswap>
In-Reply-To: <1237856239.25062.696.camel@pasglop>
References: <200903210003.55161.rjw@sisk.pl>
	<200903222208.22434.rjw@sisk.pl>
	<200903232230.10831.rjw@sisk.pl>
	<20090323152330.536a5a1c@hobbes.virtuouswap>
	<1237856239.25062.696.camel@pasglop>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Mar 2009 11:57:19 +1100
Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Mon, 2009-03-23 at 15:23 -0700, Jesse Barnes wrote:
> > The thing I didn't like was that it made the radeon driver use an
> > internal interface; I'd really prefer a proper return value from
> > pci_set_power_state, which in turn means auditing all its current
> > callers. But that doesn't seem worth it unless we see other drivers
> > needing something similar...
> > 
> > And if we did go with something like your first patch, I'd still
> > rather see the timeout done in the driver, rather than having the
> > attempts & delay included in the function...
> 
> So what ? The driver would call pci_set_power_state() until it stops
> failing ?

Yeah, that's what I had in mind.

> I'm not too fan of that, because it will change the access pattern
> to the chip:
> 
>  - write PM to 2
>  - short delay
>  - read PM, see 0, return error
>  - driver does big delay
>  - write PM to 2
>  - short delay
>  - read PM ....
> 
> vs. the current sequence which is
> 
>  - write PM to 2
>  - long delay
>  - read PM, be happy
> 
> Which -seems- to be pretty much what happens in practice, though on
> that chip, I don't know for sure about others.
> 
> I'm worried of the possible side effects of the first sequence that
> you propose since it would do 2 things potentially confusing to the
> HW:
> 
>  - read PM after a short delay... it -should- be harmless but you know
> HW as well as I do ...
> 
>  - write PM to 2 a second time after the long delay. Again, it
> -should- be harmless since the chip at this stage should already be
> in D2 state but god knows how the HW will react.
> 
> I'm especially worried about the later in fact. Maybe we can minimize
> it by having pci_set_power_state() dbl check the content of the PM
> reg before writing to it...

Honestly I'm not too happy about any of the approaches, but yeah I see
your point.  The main thing is to prevent any config space access for
a specified time after the first D-state transition, which I think we
do correctly in the core.  Beyond that, we just have to make sure the
core state is updated correctly; Rafael's first patch does that
correctly I think.

Actually now that I think of it, maybe Alex can get us details on the
errata here.  If we just need a longer wait between a D-state transition
and the next config space access for this chip (or set of chips), we
could add that as a proper quirk to the core...

Alex, any thoughts about the bug & patch in
http://bugzilla.kernel.org/show_bug.cgi?id=12846 ?  Looks like old
radeon chips need a workaround when transitioning from D0 -> D2...

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
