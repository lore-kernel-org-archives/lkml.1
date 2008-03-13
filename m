Return-Path: <linux-kernel-owner+w=401wt.eu-S1756376AbYCMRlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376AbYCMRlT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 13:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753914AbYCMRlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 13:41:08 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34226 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943AbYCMRlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 13:41:07 -0400
Subject: Re: BUG: lock held when returning to user space
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Walker <dwalker@mvista.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Frank Munzert <frankm@linux.vnet.ibm.com>,
       mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <1205423029.10894.75.camel@localhost.localdomain>
References: <47D7FAA0.1090802@linux.vnet.ibm.com>
	 <Pine.LNX.4.64.0803122236030.7266@twin.jikos.cz>
	 <1205423029.10894.75.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 13 Mar 2008 18:39:06 +0100
Message-Id: <1205429946.8514.255.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-03-13 at 08:43 -0700, Daniel Walker wrote:
> On Wed, 2008-03-12 at 22:40 +0100, Jiri Kosina wrote:
> 
> > No, as it is a real bug if you use mutexes in this way. What happens if 
> > process that has called open() on your device (and has not closed it yet) 
> > calls fork()? 
> > Another breakage scenario -- what if the filedescriptor is sent through 
> > unix socket to another process? etc.
> 
> There's a number of places where a semaphore is used across system
> calls. 
> 
> for instance the usb skeleton, 
> 	drivers/usb/usb-skeleton.c
> 
> Several of the watchdog drivers,
> 	drivers/watchdog/s3c2410_wdt.c
> 
> These need to be removed, but the usage is clearly not compatible with
> the mutex API ..
> 
> If you convert them to atomic counts then you loose the sleeping aspect
> of the semaphore, which you'd have to add back somehow.
> 
> The only API that seems straight forward is using complete's .. Then you
> get an atomic count and all the sleeping function calls you might want..
> (include/linux/completion.h) The problem with complete's is that you
> can't start them out at "1" or "completed" unless you actually run
> complete() once during initialization (that's kind of ugly) ..

A simple waitqueue would work.

