Return-Path: <linux-kernel-owner+w=401wt.eu-S932186AbYGUDHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186AbYGUDHa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 23:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759045AbYGUDHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 23:07:20 -0400
Received: from mail.windriver.com ([147.11.1.11]:54318 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759759AbYGUDHT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 23:07:19 -0400
Subject: Re: [PATCH]: libata-scsi: Don't start hotplug work queue if
	hotplug is	disabled
From: Chunbo Luo <chunbo.luo@windriver.com>
Reply-To: chunbo.luo@windriver.com
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <48809BA0.8060500@kernel.org>
References: <1214533246.6284.10.camel@pek-cluo>
	 <48809BA0.8060500@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Organization: Wind River
Date: Mon, 21 Jul 2008 11:03:05 +0800
Message-Id: <1216609385.6358.14.camel@pek-cluo>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
X-OriginalArrivalTime: 21 Jul 2008 03:05:07.0129 (UTC) FILETIME=[9445A290:01C8EADE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-07-18 at 22:33 +0900, Tejun Heo wrote:
> Chunbo Luo wrote:
> > Hi
> > 
> > When ata_scsi_scan_host() scan device failed, it will start a work queue
> > unconditionally. This may cause some noisy messages. This patch fix this
> > problem.
> 
> ATA_PFLAG_SCSI_HOTPLUG doesn't mean that hotplug is enabled.  It
> indicates that EH needs to schedule a kick at SCSI's ass and make it
> scan for discovered devices && work running on ata_aux_wq testing it
> doesn't mean anything.  There's no synchronization.
> 
> >     Previously, queue_delayed_work() was started unconditionally, but if
> >     ATA_PFLAG_SCSI_HOTPLUG is not set and we do this, the work queue may
> >     cause multiple messages like this:
> >     
> >     ata3.00: WARNING: ATAPI is not supported with this driver, device ignored.
> 
> And this message has nothing to do with SCSI.  It's printed by libata
> proper for several drivers which don't support ATAPI.  Did the patch
> really kill the warning messages?  Can you please post full boot log
> from 2.6.26 w/o the patch?

If the drivers don't support ATAPI, the hotplug task cannot find linked device,
and it will start the hotplug task again. Which will print messages continously 
like this.

----------
﻿ata3.00: WARNING: ATAPI is not supported with this driver, device ignored.
﻿ata3.00: WARNING: ATAPI is not supported with this driver, device ignored.
﻿ata3.00: WARNING: ATAPI is not supported with this driver, device ignored.
﻿ata3.00: WARNING: ATAPI is not supported with this driver, device ignored.
...
------------

We should find a way to avoid this kind of noisy warning messages.

This patch cannot kill the warning messages, but it can avoid the
duplicate warning messages.




> 
> Andrew, please drop the patch from -mm.  Thanks.
> 
