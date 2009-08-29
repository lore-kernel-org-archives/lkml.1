Return-Path: <linux-kernel-owner+w=401wt.eu-S1752384AbZH2Nvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752384AbZH2Nvy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 09:51:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752336AbZH2Nvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 09:51:51 -0400
Received: from ppp-144-74.adsl.restena.lu ([158.64.144.74]:44865 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbZH2Nvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 09:51:49 -0400
X-Greylist: delayed 487 seconds by postgrey-1.27 at vger.kernel.org; Sat, 29 Aug 2009 09:51:48 EDT
Date: Sat, 29 Aug 2009 15:43:05 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Ed Cashin <ecashin@coraid.com>
Cc: apw@canonical.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] aoe: ensure we initialise the request_queue
 correctly
Message-ID: <20090829154305.723fd86c@neptune.home>
In-Reply-To: <9ab0e087296715d764071d4d39542985@coraid.com>
References: <1250872904-10993-1-git-send-email-apw@canonical.com>
	<9ab0e087296715d764071d4d39542985@coraid.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 August 2009 Ed Cashin <ecashin@coraid.com> wrote:
> On Fri Aug 21 12:41:59 EDT 2009, apw@canonical.com wrote:
> > We have been seeing oopses in very recent kernels when using the
> > AOE driver. When attempting to mount remote devices we get a
> > warning from the kobject layer:
> > 
> >   [ 2645.959090] kobject '<NULL>' (ffff880059ca22c0): tried to add
> > 	an uninitialized object, something is seriously wrong.
> > 
> > Looking at the driver it seems to have always had an embedded
> > request_queue and it is this that is throwing the error.  It
> > appears the intent is tha these would be allocated and released
> > using helpers, and the lack of these leaves the object
> > uninitialised and throws the error.  It is unclear how this could
> > ever have worked.
> 
> This aoe driver does not handle I/O requests but provides its own
> make_request function to blk_queue_make_request and handles bios
> instead.
> 
> The reason I was interested in a git bisect is that I suspect that
> before nobody was interested in the request_queue in the aoe driver
> until recent changes to kobject code.  A couple people have indicated
> that they'd be doing such a git bisect, so if anybody has done that,
> please Cc me.
> 
I finished bisecting the NULL object and ended up at this commit:
  cd43e26f071524647e660706b784ebcbefbd2e44

  block: Expose stacked device queues in sysfs

  Currently stacking devices do not have a queue directory in sysfs.
  However, many of the I/O characteristics like sector size, maximum
  request size, etc. are queue properties.

  This patch enables the queue directory for MD/DM devices.  The elevator
  code has been modified to deal with queues that do not have an I/O
  scheduler.

  Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
  Signed-off-by: Jens Axboe <jens.axboe@oracle.com>


This seems to generate /sys/block/$device/queue and its contents for
everyone who is using queues, not just for those queues that have a
non-NULL queue->request_fn.

Bruno
