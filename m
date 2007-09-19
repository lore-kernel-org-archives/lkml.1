Return-Path: <linux-kernel-owner+w=401wt.eu-S1759876AbXISONy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759876AbXISONy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 10:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755016AbXISONr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 10:13:47 -0400
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:45872 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754931AbXISONr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 10:13:47 -0400
Date: Wed, 19 Sep 2007 15:13:38 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Frantisek Rysanek <Frantisek.Rysanek@post.cz>
cc: linux-kernel@vger.kernel.org
Subject: Re: PCI Interrupt
In-Reply-To: <46F12244.22016.47D8DCD0@localhost>
Message-ID: <Pine.LNX.4.64N.0709191500400.24627@blysk.ds.pg.gda.pl>
References: <200709181642.23070.rjw@sisk.pl> <46F12244.22016.47D8DCD0@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2007, Frantisek Rysanek wrote:

> On IBM PC compatible hardware, there's always a risky "window of 
> opportunity" that a shared edge-triggered interrupt line gets 
> electrically re-triggered before your ISR manages to service all the 
> devices and ACK the interrupt (I believe RTAI does that in reverse 
> order). In that case, you get a missed interrupt, and your 
> peripherial device may wait for service indefinitely.

 That's because the 8259A does not support truly edge-triggered interrupts 
-- what it supports is a signalling model where the rising edge asserts 
the interrupt and the falling edge negates it if unhandled.  So in some 
sense it is a level-triggered interrupt with no retrigger before the 
falling edge.

> I don't recall if the i8259 AT-pic has some useable "retrigger while 
> in service" register, maybe the APIC does. (I do recall that the 
> 8259's two-register IO footprint is rather convoluted.) I seriously 
> doubt that the presence of such a register would completely eliminate 
> the critical window of time.

 The APIC can support truly edge-triggered interrupts as it only records 
one of the edges (which one of the two it is, depends on the polarity 
setting).  It also records another edge happening between an ACK and an 
EOI and signals another interrupt immediately after the EOI, so nothing is 
lost if pulses are short (assuming there is a reasonably small number of 
sources so that overlapping pulses do not continue for too long).  There 
are subtle differences, as usually with Intel, between APIC 
implementations that may have to be taken into account here.

 Also sharing at the vector level poses interesting issues, but that's 
different matter.

  Maciej
