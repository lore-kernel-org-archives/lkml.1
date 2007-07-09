Return-Path: <linux-kernel-owner+w=401wt.eu-S1755895AbXGIP0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895AbXGIP0V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 11:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753749AbXGIP0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 11:26:13 -0400
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:40457 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbXGIP0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 11:26:13 -0400
Date: Mon, 9 Jul 2007 17:26:23 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Tejun Heo <htejun@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Sysfs and suicidal attributes
Message-ID: <20070709172623.0c87aafd@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <Pine.LNX.4.44L0.0707081015430.5323-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.0707081015430.5323-100000@netrider.rowland.org>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Jul 2007 10:31:21 -0400 (EDT),
Alan Stern <stern@rowland.harvard.edu> wrote:

> There are some ways around this such as using a different workqueue, 
> one that could safely be blocked during the suspend.

This would be the simplest solution, I think.

> 	The user writes to an attribute file.
> 
> 	The sysfs core calls the attribute's store method.
> 
> 	The method tells the sysfs core to pretend that the call
> 	temporarily doesn't exist, or has completed, or something
> 	like that.

Or add an ignore-for-now-flag to the buffer? It would need to be
processed in a second pass.

> 	The method safely unregisters the attribute file, with no
> 	mutual exclusion problems and no deadlock.  Of course, the
> 	unregistration will still block until all _other_ method
> 	calls for this attribute are complete.
> 
> 	The method tells the sysfs core to stop pretending and
> 	go back to its normal state.
> 
> 	The method returns, and the sysfs core takes whatever actions
> 	are needed to fully release the attribute file.

It would need to retain a reference to the buffer collection so it can
get rid of the formerly-ignored buffer.

> The idea is that there could be a way to allow unregistration while a 
> method is still running, if the method specifically requests it.  If we 
> could do this then device_schedule_callback() would be unnecessary.
> 
> What do you think?

I don't think that this is easy to get correct. Another workqueue looks
like a solution which is easy to get right, even if it may not seem so
nice.
