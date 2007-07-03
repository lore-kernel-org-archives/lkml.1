Return-Path: <linux-kernel-owner+w=401wt.eu-S1759739AbXGCLXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759739AbXGCLXr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 07:23:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757624AbXGCLXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 07:23:39 -0400
Received: from ozlabs.org ([203.10.76.45]:56845 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756770AbXGCLXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 07:23:38 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18058.12724.163599.707035@cargo.ozlabs.ibm.com>
Date: Tue, 3 Jul 2007 21:23:32 +1000
From: Paul Mackerras <paulus@samba.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM
	pathway
In-Reply-To: <200707030944.18702.oliver@neukum.org>
References: <20070703042916.GA17240@srcf.ucam.org>
	<200707031608.06348.nigel@nigel.suspend2.net>
	<1183447184.10386.102.camel@localhost.localdomain>
	<200707030944.18702.oliver@neukum.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Neukum writes:

> At the risk of repeating myself. Character device drivers are written
> with the assumption that normal io and suspend/resume do not race
> with each other due to the freezer.
> What do you intend to do about that?

Going back to the old powerbook sleep code, we had a two-phase
suspend: drivers got notified once when userspace is still running,
with interrupts enabled, in process context; and then a second time
with interrupts disabled and with only one CPU up, so the process
that is initiating the suspend is the only process running (since
interrupts are disabled and nothing it does can sleep, no other
process can get to run).

I still believe that is the right way to go, although we currently
only have a single-phase suspend.

Most drivers suspended their hardware in the second call.  If they are
in the middle of a conversation with their device that *has* to be
completed, they can do that by polling.  If it's a character device, a
better approach would be to set a flag or whatever in the first
suspend call to make sure that no new conversations get started with
the device, sleeping if necessary.

I'm actually having a hard time thinking of how to test your assertion
since there are so few things on a typical computer that are plain
character devices driving real hardware.  A serial port would be about
the only one; keyboards and mice (and serial ports :) are USB these
days, or ADB on older powerbooks.

Or did you mean to include drivers for pseudo-devices (e.g. ptys)?  I
don't see why they would have a suspend method at all.

Paul.
