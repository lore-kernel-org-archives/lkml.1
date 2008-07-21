Return-Path: <linux-kernel-owner+w=401wt.eu-S1752308AbYGUPuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308AbYGUPuq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 11:50:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751207AbYGUPuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 11:50:37 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:34551 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751121AbYGUPuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 11:50:35 -0400
Subject: Re: [RFC] breakage in bsg
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 21 Jul 2008 10:50:31 -0500
Message-Id: <1216655432.3433.30.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Sorry for breaking threading ... this is a cut and paste from mark
since you didn't post to any list I'm subscribed to]

> 	* with "bsg: bind bsg to request_queue instead of gendisk" we
> get all requests with NULL ->rq_disk.  SCSI can cope with that, anything
> else is not promised to be able to surive that.  Indeed, quite a few
> drivers do not.

That's pretty much by design since we need to allow bsg to be used on
request queues that don't have a gendisk attached (classic example are
the transient queues belonging to SAS expanders).  Since drivers have to
actively allow bsg, we can do the local conversions as necessary.

> 	* WTF are these per-bd flags doing, seeing that you set them
> on every ->read() and ->write()?  Just what will happen if you have
> two openers?

This isn't really my area, but there's only one flag: BSG_F_BLOCK which
is used to signal a temporary blockage of the device ... by definition
that applies to all openers.

> 	* cmd_filter thing is broken as well (we have no access to
> gendisk in question and there's a lot of obvious issues when you have
> several openers).

Well, this is philosophical.  I've always maintained the command filter
to be broken by design.  BSG reinforces that because now we have actual
uses that aren't SCSI (the main use I have is to transmit Management
frames to SAS).  You can't filter something if you don't understand the
protocols and protocol independence was a requirement for the next
generation of SG.

> #2 and part of #3 are fixable, but I really don't see what to do with #1.
> If nothing else, it's absolutely incompatible with cmd_filter, even if you
> leave aside the issue with non-IDE/non-SCSI drivers.
> 
> Comments?

James


