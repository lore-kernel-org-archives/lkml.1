Return-Path: <linux-kernel-owner+w=401wt.eu-S1754484AbYATOfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484AbYATOfz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 09:35:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753626AbYATOft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 09:35:49 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:56560 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539AbYATOfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 09:35:48 -0500
Date: Sun, 20 Jan 2008 07:35:47 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Linus Torvalds <torvalds@osdl.org>
Cc: Greg KH <greg@kroah.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: Removing PCI CRS code could cause problems
Message-ID: <20080120143546.GB27250@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I just remembered why I put in the software-visible Config Retry Status
code.  With conventional PCI, devices must return within something like
2^25 clock cycles (about a second for 33MHz busses).  PCIe devices can
return CRS to the root complex which will automatically retry -- but to
the CPU, this looks like a read that hasn't returned yet.

My concern was/is that devices which take a long time to initialise may
cause watchdog timers to fire.  I don't know if there's some CPUs which
might enter error recovery, but I think the native Linux watchdog might
well trigger.

Now, I have no evidence that this is going to happen.  And we definitely
have buggy hardware to contend with (that caused the initial reversion).
But the commit ad7edfe0490877864dc0312e5f3315ea37fc4b3a isn't as risk-free
as it might seem.

Would you accept a patch which just black-listed the bridge that was
causing problems?  Or possibly we don't even need that if we take Ivan's
patch to use conf1 accesses instead of mmconf for conventional config
space -- I understand the device in question to only have problems when
CRS is combined with mmconfig.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
