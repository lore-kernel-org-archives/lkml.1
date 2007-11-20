Return-Path: <linux-kernel-owner+w=401wt.eu-S1757595AbXKTFQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757595AbXKTFQk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 00:16:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753011AbXKTFQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 00:16:29 -0500
Received: from elasmtp-scoter.atl.sa.earthlink.net ([209.86.89.67]:38068 "EHLO
	elasmtp-scoter.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752517AbXKTFQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 00:16:28 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=mindspring.com;
  b=IAfxS6AW5W9TVVgWL8RSRheB68BUid7awYI4lEj8oNjEcuqP0A5B7wCSSGL9UUKU;
  h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Date: Tue, 20 Nov 2007 00:16:07 -0500
From: Bill Fink <billfink@mindspring.com>
To: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: Jonas Danielsson <the.sator@gmail.com>, linux-kernel@vger.kernel.org,
       davem@davemloft.net, jmorris@namei.org, netdev@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] net/ipv4/arp.c: Fix arp reply when sender ip 0 (was:
 Strange behavior in arp probe reply, bug or feature?)
Message-Id: <20071120001607.916f4537.billfink@mindspring.com>
In-Reply-To: <20071119130610.GB6952@ms2.inr.ac.ru>
References: <cac0ab7d0711150340p58eda94ah92894072ba328205@mail.gmail.com>
	<20071115154032.GA30391@ms2.inr.ac.ru>
	<cac0ab7d0711151340l1cc91a2dw5ebf36e166d16d7a@mail.gmail.com>
	<20071119130610.GB6952@ms2.inr.ac.ru>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; powerpc-yellowdog-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: c598f748b88b6fd49c7f779228e2f6aeda0071232e20db4d4cbe0996ce0c7aa58118fae34dcc946b350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 68.55.21.22
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Nov 2007, Alexey Kuznetsov wrote:

> Hello!
> 
> > Is there a reason that the target hardware address isn't the target
> > hardware address?
> 
> It is bound only to the fact that linux uses protocol address
> of the machine, which responds. It would be highly confusing
> (more than confusing :-)), if we used our protocol address and hardware
> address of requestor.
> 
> But if you use zero protocol address as source, you really can use
> any hw address.
> 
> > The dhcp clients I examined, and the implementation of the arpcheck
> > that I use will compare the target hardware field of the arp-reply and
> > match it against its own mac, to verify the reply. And this fails with
> > the current implementation in the kernel.
> 
> 1. Do not do this. Mainly, because you already know that this does not work
>    with linux. :-) Logically, target hw address in arp reply is just
>    a nonsensial redundancy, it should not be checked and even looked at.

Repeating what I posted earlier from the ARP RFC 826:

	"The target hardware address is included for completeness and
	network monitoring.  It has no meaning in the request form,
	since it is this number that the machine is requesting.  Its
	meaning in the reply form is the address of the machine making
	the request.  In some implementations (which do not get to look
	at the 14.byte ethernet header, for example) this may save some
	register shuffling or stack space by sending this field to the
	hardware driver as the hardware destination address of the
	packet.

Unless there is some other RFC that supercedes this, which doesn't appear
to be the case since it's also STD37, it appears to me that the current
Linux behavior is wrong.  It clearly states that for the ARP reply, the
target hardware address is "the address of the machine making the request",
and not the address of the machine making the reply as Linux is apparently
doing.

> 2. What's about your suggestion, I thought about this and I am going to agree.
> 
>    Arguments, which convinced me are:
> 
>    - arping still works.
>    - any piece of reasonable software should work.
>    - if Windows understands DaD (is it really true? I cannot believe)
>      and it is unhappy about our responce and does not block use
>      of duplicate address only due to this, we _must_ accomodate ASAP.
>    - if we do,we have to use 0 protocol address, no choice.

I agree the target protocol address should be 0 in this case.

						-Bill
