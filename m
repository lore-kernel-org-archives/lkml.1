Return-Path: <linux-kernel-owner+w=401wt.eu-S1759425AbYFXJ2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759425AbYFXJ2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 05:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759225AbYFXJ23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 05:28:29 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42726 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758881AbYFXJ21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 05:28:27 -0400
Date: Tue, 24 Jun 2008 10:10:40 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Elias Oltmanns <eo@nebensachen.de>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] IDE: Fix HDIO_DRIVE_RESET handling
Message-ID: <20080624101040.0c9d7f9c@lxorguk.ukuu.org.uk>
In-Reply-To: <873an3tixa.fsf@denkblock.local>
References: <87k5gmz596.fsf@denkblock.local>
	<200806192247.25063.bzolnier@gmail.com>
	<87wskhuk98.fsf@denkblock.local>
	<87r6apuk16.fsf@denkblock.local>
	<20080623101600.391e5245@lxorguk.ukuu.org.uk>
	<873an3tixa.fsf@denkblock.local>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> alternative to the out of band approach for the purposes you described.
> Now, I even think that I could perhaps fix the request aborting properly

I'm not sure the two are mutually conflicting. The queued reset you've
done is very much cleaner so in theory you can abort the command in the
ioctl and then queue the rest of the reset/recovery as you have done

> equivalent for HDIO_DRIVE_RESET in libata which makes me wonder whether
> this ioctl has actually been used in real life for the purposes you
> described.

Its on the todo list along with more speed control - it gets hard to do
right and cleanly.

> My idea to solve this would be roughly this: Change ide_set_handler to
> leave the ->handler and ->expiry members alone if they have been set on
> entry. If a request is being processed by the time a HDIO_DRIVE_RESET

The basic problem is that we have to issue a speed change and the driver
layer speed change code assumed this was issued polled with a wait (in
fact for some controllers/disks it has to be polled). Not a good thing to
discover you are doing in an IRQ handler ...

> Comments?

I think your basic approach is right. It might be that the abort path
wants to abort and then queue the rest. I could of course be completely
wrong too 8)

Alan
