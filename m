Return-Path: <linux-kernel-owner+w=401wt.eu-S1755946AbYCMPoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946AbYCMPoP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 11:44:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753658AbYCMPn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 11:43:57 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:20876 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500AbYCMPn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 11:43:56 -0400
Subject: Re: BUG: lock held when returning to user space
From: Daniel Walker <dwalker@mvista.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Frank Munzert <frankm@linux.vnet.ibm.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0803122236030.7266@twin.jikos.cz>
References: <47D7FAA0.1090802@linux.vnet.ibm.com>
	 <Pine.LNX.4.64.0803122236030.7266@twin.jikos.cz>
Content-Type: text/plain
Date: Thu, 13 Mar 2008 08:43:49 -0700
Message-Id: <1205423029.10894.75.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-03-12 at 22:40 +0100, Jiri Kosina wrote:

> No, as it is a real bug if you use mutexes in this way. What happens if 
> process that has called open() on your device (and has not closed it yet) 
> calls fork()? 
> Another breakage scenario -- what if the filedescriptor is sent through 
> unix socket to another process? etc.

There's a number of places where a semaphore is used across system
calls. 

for instance the usb skeleton, 
	drivers/usb/usb-skeleton.c

Several of the watchdog drivers,
	drivers/watchdog/s3c2410_wdt.c

These need to be removed, but the usage is clearly not compatible with
the mutex API ..

If you convert them to atomic counts then you loose the sleeping aspect
of the semaphore, which you'd have to add back somehow.

The only API that seems straight forward is using complete's .. Then you
get an atomic count and all the sleeping function calls you might want..
(include/linux/completion.h) The problem with complete's is that you
can't start them out at "1" or "completed" unless you actually run
complete() once during initialization (that's kind of ugly) ..

Daniel

