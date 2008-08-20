Return-Path: <linux-kernel-owner+w=401wt.eu-S1758973AbYHTO7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758973AbYHTO7P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 10:59:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963AbYHTO67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 10:58:59 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:49486 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907AbYHTO67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 10:58:59 -0400
Subject: Re: powerpc/cell/oprofile: fix mutex locking for spu-oprofile
From: Carl Love <cel@us.ibm.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>,
       oprofile-list@lists.sourceforge.net, cel <cel@linux.vnet.ibm.com>,
       cbe-oss-dev@ozlabs.org
In-Reply-To: <20080820123907.GP13011@erda.amd.com>
References: <1217620879.15667.145.camel@carll-linux-desktop>
	 <200808110925.08485.arnd@arndb.de> <20080820115750.GO13011@erda.amd.com>
	 <200808201405.32101.arnd@arndb.de>  <20080820123907.GP13011@erda.amd.com>
Content-Type: text/plain
Date: Wed, 20 Aug 2008 07:58:16 -0700
Message-Id: <1219244296.6637.223.camel@carll-linux-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-08-20 at 14:39 +0200, Robert Richter wrote:
> On 20.08.08 14:05:31, Arnd Bergmann wrote:
> > On Wednesday 20 August 2008, Robert Richter wrote:
> > > I am fine with the changes with the exception of removing
> > > add_event_entry() from include/linux/oprofile.h. Though there is no
> > > usage of the function also in other architectures anymore, this change
> > > in the API should be discussed on the oprofile mailing list. Please
> > > separate the change in a different patch and submit it to the mailing
> > > list. If there are no objections then, this change can go upstream as
> > > well.
> > 
> > As an explanation, the removal of add_event_entry is the whole point
> > of this patch. add_event_entry must only be called with buffer_mutex
> > held, but buffer_mutex itself is not exported.
> 
> Thanks for pointing this out.
> 

We originally added add_event_entry() to include/linux/oprofile.h
specifically because it was needed for the CELL SPU support.  As it
turns out it the approach was not completely thought through.  We were
using the function call without holding the mutex lock.  As we
discovered later, this can result in corrupting the data put into the
event buffer.  So exposing the function without a way to hold the mutex
lock is actually a really bad idea as it would encourage others to fall
into the same mistake that we made.  So, as Arnd said, the whole point
of this patch is to come up with a correct approach to adding the data.

> > I'm pretty sure that no other user of add_event_entry exists, as it
> > was exported specifically for the SPU support and that never worked.
> > Any other (theoretical) code using it would be broken in the same way
> > and need a corresponding fix.
> > 
> > We can easily leave the declaration in place, but I'd recommend removing
> > it eventually. If you prefer to keep it, how about marking it as
> > __deprecated?
> 
> No, since this is broken by design we remove it. The patch can go
> upstream as it is.
> 
> Thanks,

> -Robert
> 

It really is best to remove it.  Thank you for taking the time to review
and comment on the patch.

               Carl Love

