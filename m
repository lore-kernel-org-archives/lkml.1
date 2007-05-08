Return-Path: <linux-kernel-owner+w=401wt.eu-S1032265AbXEHVQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032265AbXEHVQA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 17:16:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1032252AbXEHVPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 17:15:55 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42502
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1032230AbXEHVPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 17:15:54 -0400
Date: Tue, 08 May 2007 14:15:54 -0700 (PDT)
Message-Id: <20070508.141554.112287211.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: bunk@stusta.de, cornelia.huck@de.ibm.com, greg@kroah.com,
       linux-kernel@vger.kernel.org
Subject: Re: Please revert 5adc55da4a7758021bcc374904b0f8b076508a11
 (PCI_MULTITHREAD_PROBE)
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.0.98.0705080819350.3974@woody.linux-foundation.org>
References: <20070508153713.344cc881@gondolin.boeblingen.de.ibm.com>
	<20070508141149.GJ4226@stusta.de>
	<alpine.LFD.0.98.0705080819350.3974@woody.linux-foundation.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 8 May 2007 08:27:34 -0700 (PDT)

> Threading at the bus level just inevitably means things like random 
> numbers for devices depending on some timing/scheduling issue. That's 
> nasty.

I hadn't considered this issue, so ignore the other reply I made to
this thread.  Although as an aside I'm starting to become of an
opinion that device numbering doesn't matter.  Every device should
have a unique ID of sorts, or a unique physical location, and that
should factor into the thing users use to refer to the object.

Whether that's an ethernet MAC address, a PCI domain:bus:devfn tuple,
or some unique ID written in the disk label or partition header, it
doesn't matter.

If that gets translated into "user_happy_sunny_day_disk0" to make
references simpler for the user, that's fine.  But probe ordering
should never break these mappings even if "user_happy_sunny_day_disk1"
is spotted by probing before "user_happy_sunny_day_disk0".  If the
system is designed properly, that should never matter, but for us
it still does.

Those mappings should exist statically somewhere, not depend upon
something as frivolous as probe ordering.

Anyways, it would be nice, however, to really deal with the case like
when the IDE layer is waiting for a probe to port X to timeout,
meanwhile we could be initializing the networking card.

Another bad case is, as you mentioned, SCSI bus resets and SAS/FC
fabric scans.  Those take several seconds if not longer and it's
really stupid to not be able to do other things during that time.

