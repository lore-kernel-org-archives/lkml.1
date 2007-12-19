Return-Path: <linux-kernel-owner+w=401wt.eu-S1753237AbXLSNLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbXLSNLn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 08:11:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752907AbXLSNLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 08:11:30 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:62328 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752537AbXLSNL3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 08:11:29 -0500
Date: Wed, 19 Dec 2007 14:11:00 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: "Remy Bohmer" <linux@bohmer.net>
Cc: "Andrew Victor" <linux@maxim.org.za>,
       "ARM Linux Mailing List" <linux-arm-kernel@lists.arm.linux.org.uk>,
       "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] atmel_serial: Split the interrupt handler
Message-ID: <20071219141100.7384aff9@dhcp-252-066.norway.atmel.com>
In-Reply-To: <3efb10970712190450p64d4e7a2k7b80d47349be9570@mail.gmail.com>
References: <1197987255-23045-1-git-send-email-hskinnemoen@atmel.com>
	<3efb10970712180723x2cd22c5ei6b342f0ab7cc39c2@mail.gmail.com>
	<20071219133411.24d146e7@dhcp-252-066.norway.atmel.com>
	<3efb10970712190450p64d4e7a2k7b80d47349be9570@mail.gmail.com>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Dec 2007 13:50:16 +0100
"Remy Bohmer" <linux@bohmer.net> wrote:

> Hello Haavard,
> 
> > Hmm...perhaps we can eliminate the locking in the status handler
> > too...? Does anyone see a problem with this patch?  
> 
> I have not seen any problem so far, besides, I am very happy with a
> lockless interrupt handling, because this helps reducing latencies.
> 
> Tested it on top of the other 5 patches, and everything still works,
> also tested under stress conditions.
> 
> So:
> Acked-by: Remy Bohmer <linux@bohmer.net>

Thanks. I think we can actually do it even simpler -- just check if any
of the relevant bits in pending are set, and schedule the tasklet if
they are.

Now, I suspect the locking is currently broken -- we need to guard
against updates to read_status_mask and ignore_status_mask, but I think
we can get away with only adding some locking to the tasklet, not the
interrupt handler.

Hrm. We probably need to lock while updating icount. That's a problem
since we do that from the tx interrupt handler...and I don't suppose we
want to move most of the atmel_tx_chars() code into the tasklet too...?

Haavard
