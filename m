Return-Path: <linux-kernel-owner+w=401wt.eu-S1758810AbXEWWHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758810AbXEWWHB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 18:07:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755439AbXEWWGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 18:06:53 -0400
Received: from outbound-mail-75.bluehost.com ([69.89.20.10]:35291 "HELO
	outbound-mail-75.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755195AbXEWWGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 18:06:53 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH] PCI MMCONFIG: add validation against ACPI motherboard resources
Date: Wed, 23 May 2007 15:06:33 -0700
User-Agent: KMail/1.9.6
Cc: Robert Hancock <hancockr@shaw.ca>, Olivier Galibert <galibert@pobox.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Chuck Ebbert <cebbert@redhat.com>, Len Brown <lenb@kernel.org>
References: <4635510D.4060103@shaw.ca> <200705231403.24439.jbarnes@virtuousgeek.org> <alpine.LFD.0.98.0705231444200.3890@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0705231444200.3890@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705231506.36229.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.102.120.196 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 23, 2007 2:54 pm Linus Torvalds wrote:
> On Wed, 23 May 2007, Jesse Barnes wrote:
> > > You told it to not forward memory. Why complain when it does as
> > > told?
> >
> > Well, because that's not actually very useful functionality, and
> > likely makes software that seems "obviously" correct wrt the PCI
> > spec break.
>
> I agree that a chip that doesn't do it isn't broken either, but the
> fact is, there is never any reason to disable MEM/IO on a host
> bridge. Doing so is senseless - it can never be a valid operation. So
> I duspute the "obviously correct" part. It's _not_ obviously correct
> at all.
>
> To get back to the MMIO example: even if you were to never shut off
> RAM, if you turn off just PCI MMIO on the northbridge, what is a
> mmconfig cycle supposed to do? It's not going to _work_ if you
> disable MEM accesses.
>
> So again, the only sane situation is: don't do it then! You claim
> that hardware shouldn't do it, but I don't think software is in any
> different situation at all! If it's insane to do, then software
> shouldn't do it.
>
> It's just insane to turn off the MEM bit. There's simply no valid
> reason to. And any PCI spec that says you should is *broken*, or
> written by somebody who really only meant to talk about normal PCI
> devices, not bridges.

Well theoretically for just sizing BARs, turning off the MEM bit should 
be fine, since your next accesses should only be to config space until 
the MEM bit is reenabled.  But if RAM accesses really are disabled, 
then you'd better be sure all the code you need is already in cache, or 
you'll get into trouble.

So yeah, I guess special handling for host bridges is needed, but that 
doesn't seem like a big deal.

> > Apparently Vista will move away from using type 1 config space
> > accesses though, so if we keep using it, we'll probably run into
> > some lame board that assumes you're using mmconfig at some point in
> > the near future.
>
> How are those boards going to set up mmconfig? The whole standard is
> broken, since there is no way to set it up.
>
> Trust the firmware? What a piece of crap!

What do you mean?  You set it up the normal way, by poking at config 
space to see what's there, then size the BARs (disabling mem and I/O 
accesses in PCI_COMMAND shouldn't affect config space cycles afaik).  
You just have to be careful to disable decoding for I/O and memory 
regions, especially if your mmconfig space overlaps with what the 
devices end up with in their BARs.  Which is why my initial patch works 
ok (because fortunately the Intel host bridges hard code the mem decode 
bit to 1 too).

Jesse

