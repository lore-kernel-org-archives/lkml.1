Return-Path: <linux-kernel-owner+w=401wt.eu-S1756922AbZJLO2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922AbZJLO2S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 10:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756827AbZJLO2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 10:28:17 -0400
Received: from netrider.rowland.org ([192.131.102.5]:41430 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756848AbZJLO2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 10:28:16 -0400
Date: Mon, 12 Oct 2009 10:27:39 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Matthew Dharm <mdharm-usb@one-eyed-alien.net>
cc: Ben Efros <ben@pc-doctor.com>, fangxiaozhi <huananhu@huawei.com>,
       Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, Hugh Blemings <hugh@blemings.org>,
       Josua Dietze <digidietze@draisberghof.de>
Subject: Re: USB serial regression 2.6.31.1 -> 2.6.31.2 [PATCH]
In-Reply-To: <1255318095.2192.92.camel@pasglop>
Message-ID: <Pine.LNX.4.44L0.0910121012030.11420-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Oct 2009, Benjamin Herrenschmidt wrote:

> BTW. I noticed that USB storage is supposed to avoid doing the reset if
> the device is multifunction.

Not "multifunction" but "multitarget" -- which means that the device is
attached to a real SCSI bus which may have more than one target.  In
such a situation it's best to avoid bus resets when possible, since
they affect all the targets.

>  I suppose that flag gets set prior to the
> "mode switch" and so the reset happens regardless... maybe we should set
> that MF flag from the quirk that sends the mode switch ?

You mean, avoid doing a reset after an auto-sense failure if the device
has other interfaces?  Maybe...  I'm not really sure.  To tell the
truth, that comment about "failure of an auto-sense is perfectly valid"  
doesn't make much sense to me.  In principle, the SCSI core would have
to issue its own REQUEST SENSE command and the end result would be the
same.

(In your case that wouldn't happen, because the device actually did
send valid sense data before sending the failure code.  The SCSI core
would see that data sitting in the buffer and believe it.  So things
would work out okay, but only by coincidence, not by design -- unless 
we wipe the buffer before returning.)

I don't know.  Maybe it really would be best not to reset after an 
auto-sense failure, ever.  I can't recall the issue coming up in any 
bug reports before.  But then what should we do after an auto-sense 
error?  It probably should be treated the same as a normal error, which 
means doing a reset.

Alan Stern

