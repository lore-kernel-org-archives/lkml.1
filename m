Return-Path: <linux-kernel-owner+w=401wt.eu-S1753377AbXDMOYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377AbXDMOYh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 10:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753425AbXDMOYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 10:24:37 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:2759 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377AbXDMOYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 10:24:35 -0400
Date: Fri, 13 Apr 2007 16:27:01 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Markus Rechberger" <markus.rechberger@amd.com>
Cc: "Alan Stern" <stern@rowland.harvard.edu>,
       "USB development list" <linux-usb-devel@lists.sourceforge.net>,
       "Kernel development list" <linux-kernel@vger.kernel.org>
Subject: Re: How should an exit routine wait for release() callbacks?
Message-ID: <20070413162701.4e7342a9@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <461F9076.4070209@amd.com>
References: <Pine.LNX.4.44L0.0704121706040.2472-100000@iolanthe.rowland.org>
	<20070413110313.352330ce@gondolin.boeblingen.de.ibm.com>
	<461F6C8C.1020901@amd.com>
	<20070413152453.571e887a@gondolin.boeblingen.de.ibm.com>
	<461F9076.4070209@amd.com>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.8.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2007 16:15:18 +0200,
"Markus Rechberger" <markus.rechberger@amd.com> wrote:

> most dvb usb drivers call the device node unregistration when a device 
> gets unplugged (when
> At this time the filehandle can still be open, the patch on that site 
> sets a flag that disallows
> any further access to the device node (in the DVB framework there are 4 
> of such nodes)
> This can happen any time, so while someone is reading or accessing the 
> device some structures
> might have gone away already and this could cause an oops.
> The problem of the DVB framework is file operation related, the last 
> user calls fops_put on the existing
> structure and sets the pointer to NULL before it wakes up the other 
> function which frees the file operation
> structure.

OK, thanks for the explanation.

> In Alan's case isn't there any users flag available that shows that the 
> structure is still beeing accessed?
> If that would be the case he could set a flag when he enters my_exit 
> which would disable access to all other
> functions by returning an error value at the beginning of the other 
> functions, the only way out would be
> to call my_release for existing users and wake up my_exit when the last 
> reference to that structure is gone.
> 
> Some more information about the whole driver/scenario would be helpful.

In this case the race is not a user space vs. kernel object one (where
you can track users). Basically the problem is as follows:

- A module registers a device. The device's release function is defined
in the module.
- Since the device can now be looked up in the device tree, someone can
obtain a reference to it (e. g. by walking the tree).
- The module is unloaded. In its exit function, it deregisters the
device. The module has now given up any reference to the device it
held, however the someone from above still holds a reference. While no
new reference to the device can be obtained, the device still exists.
- After the module is unloaded, the device's release function goes away.
- The last reference to the device is given up. The driver core now
tries to call the device's release function, which was in the deleted
module. Oops.

The completion approach unfortunately still leaves a race window, as
Alan explained in his original mail.
