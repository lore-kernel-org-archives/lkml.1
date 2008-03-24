Return-Path: <linux-kernel-owner+w=401wt.eu-S1755935AbYCXPkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbYCXPkB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 11:40:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752175AbYCXPjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 11:39:54 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:38605 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751692AbYCXPjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 11:39:53 -0400
Subject: Fixing the main programmer thinko with the device model
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>,
       "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>,
       Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 24 Mar 2008 10:39:48 -0500
Message-Id: <1206373188.3494.36.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Having just spent the weekend tracking two separate driver model
problems through SCSI, I believe the biggest trap everyone falls into
with the driver model (well, OK, at least with SCSI) is to try to defer
a callback to the device ->release routine without realising that
somewhere along the callback path we're going to drop a reference to the
device.

You can do this very inadvertently:  One developer didn't realise
bsg_unregister_queue() released a ref, and another didn't realise that
transport_destroy_device() held one.

The real problem is that it's fantastically easy to do this ... it's not
at all clear which of the cleanup routines actually release references
unless you dig down into them and it's very difficult to detect because
all that happens is that devices don't get released when they should,
which isn't something we ever warn about.

So, what I was wondering is:  is there any way we can reliably detect
and warn when someone does this.  Could something like lockdep (although
I can't really see how dynamic detection will work because the device
->release routine is never called) or a static code analysis tool like
sparse be modified to detect the unreleaseable references?

James


