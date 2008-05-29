Return-Path: <linux-kernel-owner+w=401wt.eu-S1754146AbYE2L06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbYE2L06 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 07:26:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbYE2L0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 07:26:48 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59018 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751021AbYE2L0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 07:26:47 -0400
Date: Thu, 29 May 2008 11:41:32 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, npiggin@suse.de,
       linux-arch@vger.kernel.org, jeremy@goop.org, mingo@elte.hu,
       paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 0/2] Kill unused parameter to smp_call_function and
 friends
Message-ID: <20080529114132.663eff4b@core>
In-Reply-To: <1212051661-12733-1-git-send-email-jens.axboe@oracle.com>
References: <1212051661-12733-1-git-send-email-jens.axboe@oracle.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008 11:00:59 +0200
Jens Axboe <jens.axboe@oracle.com> wrote:

> Hi,
> 
> It bothers me how the smp call functions accept a 'nonatomic' or 'retry'
> parameter (depending on who you ask), but don't do anything with it.
> So kill that silly thing.
> 
> Two patches here, one for smp_call_function*() and one for on_each_cpu().
> This patchset applies on top of the generic-ipi patchset just sent out.

Which leads to notice that we seem to have acquired a bug somewhere on
the way. smp_call_function on x86 is it seems to me implemented as
"smp_call_function and occasionally run it multiple times"

One of the joys of the older x86 APIC setups is the APIC messaging bus.
This can get checksum errors in which case the message is retransmitted:

In the specific case a message is retransmitted and there are at least
three parties on the bus (2 CPU APICs and an IOAPIC is enough) you can
get a situation where one receiver gets the message the second receiver
errors it and the retransmit causes the IPI to be repeated which causes
the IPI to be redelivered.

This used to turn up now and then - particularly on 440BX boards.

Alan
Gnome #331: Early SMP Implementation Archive Office
