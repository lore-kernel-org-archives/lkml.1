Return-Path: <linux-kernel-owner+w=401wt.eu-S966214AbYCTALv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966214AbYCTALv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 20:11:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932404AbYCSXZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 19:25:39 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:41057 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762583AbYCSXZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 19:25:36 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47E1A0A9.2010002@s5r6.in-berlin.de>
Date: Thu, 20 Mar 2008 00:24:25 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080219 SeaMonkey/1.1.8
MIME-Version: 1.0
To: Jarod Wilson <jwilson@redhat.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
       linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firewire: fix panic in handle_at_packet
References: <tkrat.098225020c179827@s5r6.in-berlin.de> <200803162332.02407.jwilson@redhat.com>
In-Reply-To: <200803162332.02407.jwilson@redhat.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jarod Wilson wrote:
> Panics hooking up to an x86 mac mini in target disk mode are gone on my end 
> with this patch added, and the fix makes sense -- assuming I've got it right, 
> in my head, of course. ;)
> 
> As I understand it, we'll now simply bail in handle_at_packet when we see 
> packet == NULL, rather than trying to play with already freed memory, and 
> cancelling an AT packet here should always be perfectly safe, because we're 
> already onto the AR side of this transaction, and in most cases, the AT 
> handler already fired anyway.

To expand on this a little bit:

An outbound transaction goes like this (possible retries and failures 
neglected):
   - fw-core submits a request packet to fw-ohci.
   - fw-ohci creates the DMA program and hands it over to the controller.
   - Controller sends the request packet to the remote node.
   - Remote node sends an ACK.
   - Controller generates an interrupt.
   - fw-ohci schedules the AT handler tasklet.
   - If this was a so-called unified transaction, the transaction is now
     complete.  The AT handler tasklet will eventually call into fw-core
     to let it finish the transaction.
   - If this was a so-called split transaction, the remote node will send
     a response packet.
   - Controller ACKs it and generates an interrupt.
   - fw-ohci schedules the AR handler tasklet.
   - The previously scheduled AT handler tasklet, *if* it is actually
     executed for the sent and ACKed request packet *before* the AR
     handler tasklet for the received response packet, will call into
     fw-core which simply sets a timestamp for the request packet.  (This
     timestamp should be used as the basis for split transaction timeout,
     but fw-core doesn't really look at that timestamp yet.  We discussed
     this recently.)
   - The scheduled AR handler calls into fw-core which completes the
     transaction.

We schedule the request AT handler tasklet before the response AR 
handler tasklet, but under some circumstances the kernel may decide to 
defer execution of the former tasklet but to immediately execute the 
latter tasklet.  That's why they can be reordered.

This reordering is, from fw-core's point of view, an implementation 
detail of fw-ohci and fw-core shouldn't be bothered with this.  However, 
fw-ohci is unable to figure out which responses belong to which 
requests.  (Matching requests and respnses is exclusively fw-core's 
transaction layer's job.)  Hence fw-ohci needs to be told by the 
transaction layer about which requests don't need any handling anymore 
because their transaction was already completed.

And yes, the call to cancel_packet is not only necessary, it is also safe:
   - We call it only for request packets whose response we already
     received.
   - There is nothing useful to be done by the AT handler for these
     request packets anymore at this point.
-- 
Stefan Richter
-=====-==--- --== =--==
http://arcgraph.de/sr/
