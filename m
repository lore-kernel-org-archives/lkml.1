Return-Path: <linux-kernel-owner+w=401wt.eu-S1757707AbZEZVXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757707AbZEZVXs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 17:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754938AbZEZVXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 17:23:39 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:40374 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754553AbZEZVXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 17:23:38 -0400
Subject: Re: Bug in SCSI async probing
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       SCSI development list <linux-scsi@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0905261658430.11998-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0905261658430.11998-100000@iolanthe.rowland.org>
Content-Type: text/plain
Date: Tue, 26 May 2009 21:23:39 +0000
Message-Id: <1243373019.2815.83.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-26 at 17:04 -0400, Alan Stern wrote:
> On Tue, 26 May 2009, James Bottomley wrote:
> 
> > > > > (Which reminds me...  Are the calls in wait_scan_init() really enough?  
> > > > > wait_for_device_probe() does async_synchronize_full() and then
> > > > > scsi_complete_async_scans() finishes the SCSI scanning.  But if this
> > > > > scanning involves calling sd_probe(), then more async work will be
> > > > > queued.  Maybe a second call to wait_for_device_probe() is needed.)
> > > 
> > > You didn't respond to this point.
> > 
> > Well this was the response:
> > 
> > > > None of this really got reviewed through the SCSI list, so I'll let
> > > > Arjan answer.
> 
> Whoops, for some reason I had gotten the idea that you wrote 
> wait_scan_init().
> 
> > > Well then, how does this patch look?
> > 
> > Well, it's adding complexity, the best fix is to let async only take
> > care of the pieces which can't fail, that way we don't need complex
> > error handling.  The piece that slows probing isn't really the sysfs
> > appearances, it's the SCSI probing, and the last piece that needs error
> > handling is the device_add() for sysfs visibility, so that should be the
> > dividing line between sync and async.
> 
> I had exactly the same thought, but it seemed less intrusive to keep
> the dividing line where Arjan put it.

Not really ... the problem where it is becomes one of error handling.
It's better to complete all the inline error handling before becoming
async ... given the code state, that's provably correct (assuming the
original was).

> > This should restore the logical flow and fix all the error leg problems
> > (by eliminating the error legs).
> 
> You forgot to move the dev_set_drvdata() call into the synchronous 
> part.  Apart from that it looks fine.  Should I submit it officially?

Well, no ... I forgot to get the drive data after the async_synchronize.
Since this is an sd bug fix, I'll take it through the SCSI trees.

> Also, I do still think that wait_scan_init() needs an extra call to 
> async_synchronize_full() at the end.

I need to understand it before commenting ... I'm slowly working my way
through the async patches.

James


