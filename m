Return-Path: <linux-kernel-owner+w=401wt.eu-S1760891AbXEWXGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760891AbXEWXGx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 19:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755709AbXEWXGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 19:06:46 -0400
Received: from outbound-mail-16.bluehost.com ([69.89.20.231]:55300 "HELO
	outbound-mail-16.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755148AbXEWXGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 19:06:46 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [RFC PATCH] PCI MMCONFIG: add validation against ACPI motherboard resources
Date: Wed, 23 May 2007 16:06:31 -0700
User-Agent: KMail/1.9.6
Cc: Olivier Galibert <galibert@pobox.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Chuck Ebbert <cebbert@redhat.com>, Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <4635510D.4060103@shaw.ca> <200705231152.57796.jbarnes@virtuousgeek.org> <4654C869.8080804@shaw.ca>
In-Reply-To: <4654C869.8080804@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705231606.31940.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.102.120.196 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 23, 2007 4:04 pm Robert Hancock wrote:
> Jesse Barnes wrote:
> > On Tuesday, May 22, 2007 6:06 pm Robert Hancock wrote:
> >> There was a big discussion about this back in 2002, in which Linus
> >> wasn't overly enthused about disabling the decode during probing
> >> due to risk of causing problems with some devices:
> >>
> >> http://lkml.org/lkml/2002/12/19/145
> >>
> >> In this particular case (64-bit BAR) we might be able to avoid the
> >> problem by changing the order in which we probe the two halves of
> >> the address, i.e. change the top half to 0xffffffff before messing
> >> with the bottom half and then change it back last. That way, we
> >> end up mapping it way to the top of 64-bit address space, which
> >> hopefully is less likely to conflict..
> >
> > Fixed it (finally).  I don't think moving the 64 bit probing around
> > would make a difference, since we'd restore its original value
> > anyway before moving on to the 32 bit probe which is where I think
> > the problem is.
>
> You couldn't just reorder the code the way it is now, you'd have to
> rearrange the way we do things for 64-bit BARs:
>
> -write FFFFFFFF to high part of 64-bit address (we end up moving the
> BAR to 0xFFFFFFFFC0000000 for example)
> -If any bits stick, we know what the size is now (more than 4GB of
> decode), so just change it back, we're done
> -If not, we need to check the low part, so write FFFFFFFF to low part
> of 64-bit address (BAR moves to 0xFFFFFFFFFFFFFFFF)
> -Check which bits stick and calculate the address
> -Change the low part of the address back (BAR moves to
> 0xFFFFFFFFC000000) -Change the high part of the address back (BAR
> moves to the original 0xC0000000 address)
>
> This means that at no point do we map the BAR anywhere near the top
> of 32-bit memory, so we should avoid this issue in this particular
> case. I don't think this strategy is too likely to break anything,
> surely less likely than disabling command bits. Jesse, you might want
> to try hacking up something like this and see what happens.

Ah yeah, that would probably work in this particular case, but doesn't 
seem very general.  I think just using type 1 accesses for non-extended 
config space is a bit more solid.

Jesse
