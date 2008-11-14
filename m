Return-Path: <linux-kernel-owner+w=401wt.eu-S1755911AbYKNTHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911AbYKNTHK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 14:07:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753943AbYKNTG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 14:06:58 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38964 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753236AbYKNTG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 14:06:57 -0500
Date: Fri, 14 Nov 2008 19:06:16 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, rml@tech9.net,
       Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
Subject: Re: Active waiting with yield()
Message-ID: <20081114190616.30dd273e@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.64.0811141327100.22830@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0811141327100.22830@hs20-bc2-1.build.redhat.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> * driver unload --- check the count of outstanding requests and call 
> yield() repeatedly until it goes to zero, then unload.

Use a wakeup when the request count hits zero

> * reduced size of data structures (and reduced cache footprint for the hot 
> path that actually processes requests)

The CPU will predict the non-wakeup path if that is normal. You can even
make the wakeup use something like

	if (exiting & count == 0)

to get the prediction righ

> The downside of yield is slower unloading of the driver by few tens of 
> miliseconds, but the user doesn't really care about fractions of a second 
> when unloading drivers.

And more power usage, plus extremely rude behaviour when virtualising.

There are cases you have to use cpu_relax/spins or yield simply because
the hardware doesn't feel like providing interrupts when you need them,
but for the general case its best to use proper sleeping.

Remember also you can use a single wait queue for an entire driver for
obscure happenings like unloads.

Alan

