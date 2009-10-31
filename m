Return-Path: <linux-kernel-owner+w=401wt.eu-S933285AbZJaVCD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933285AbZJaVCD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 17:02:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933275AbZJaVCB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 17:02:01 -0400
Received: from gate.crashing.org ([63.228.1.57]:53293 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933270AbZJaVCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 17:02:00 -0400
Subject: Re: Help needed, Re: [Bug #14334] pcmcia suspend regression from
 2.6.31.1 to 2.6.31.2 - Dell Inspiron 600m
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Jose Marino <braket@hotmail.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>
In-Reply-To: <200910311031.17660.rjw@sisk.pl>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera>
	 <alpine.LFD.2.01.0910301228430.31845@localhost.localdomain>
	 <1256947041.6372.165.camel@pasglop>  <200910311031.17660.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 01 Nov 2009 08:01:30 +1100
Message-ID: <1257022890.7907.14.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-10-31 at 10:31 +0100, Rafael J. Wysocki wrote:

> > To me the proper approach would be to split it so that
> 
> Well, agreed, but ...
> 
> >  - early_resume() restores power & config space etc... so that existing
> > devices can move on (might check for removal). There's no other hotplug
> > activity
> 
> ... that's exactly what doesn't work at the moment.

BTW. This is a PCMCIA problem, a Cardbus or both ? I'll see if I can dig
something on monday ?

>From the little email history I caught, it smells like pcmcia old style.

I don't see a problem per-se with the mutex usage with the new interrupt
masking style as Linus says. socket_resume() also looks reasonably sane,
it's the whole handling of removal that should be deferred. Maybe
instead of doing socket_remove_drivers()...send_event() etc.. in there,
we could simply just shut the socket down (PCMCIA drivers should cope
with sockets returning ffff's for a short amount of time), flag it dead
in skt->state and have the "late" resume  actually fire off the driver
removal and sending of the event.

BTW. Have we ever documented whether it's kosher to ->remove() a driver
before ->resume()'ing it ? (In which case obviously we wouldn't resume
it).

Cheers,  
Ben.


