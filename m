Return-Path: <linux-kernel-owner+w=401wt.eu-S1754196AbYCaWli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196AbYCaWli (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 18:41:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752521AbYCaWl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 18:41:29 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:36403 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752138AbYCaWl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 18:41:28 -0400
Subject: Re: [PATCH] evdev: Release eventual input device grabs
	when	getting disconnected
From: Kay Sievers <kay.sievers@vrfy.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Greg KH <greg@kroah.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bj?rn Steinbrink <B.Steinbrink@gmx.de>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <Pine.LNX.4.64.0803312326130.5541@jikos.suse.cz>
References: <20080330184259.GB21375@atjola.homenet>
	 <alpine.LFD.1.00.0803301448190.14670@woody.linux-foundation.org>
	 <200803310215.39414.dtor@insightbb.com> <20080331172813.GA11583@kroah.com>
	 <20080331135653.ZZRA012@mailhub.coreip.homeip.net>
	 <20080331204221.GA19953@kroah.com>
	 <Pine.LNX.4.64.0803312326130.5541@jikos.suse.cz>
Content-Type: text/plain
Date: Tue, 01 Apr 2008 00:46:07 +0200
Message-Id: <1207003567.20492.52.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-03-31 at 23:27 +0200, Jiri Kosina wrote:
> On Mon, 31 Mar 2008, Greg KH wrote:
> 
> > > Greg, please look at the change again. Before kobject_put(kobj->parent)
> > > was done in kobject_cleanup() and so the parent would only be freed when
> > > all its children are gone. Now parent is deleted early, even if its
> > > children are still referenced by other users. This is lifetime rule
> > > change and should really be announced as such.
> > Ugh, this was done because of scsi, they required that if you really
> > were deleting the parent, you wanted it gone.
> 
> What is the exact meaning of "gone" here please?

Gone means, that if you remove a device from sysfs, you drop the
implicit reference to the parent device, as this is no longer needed.

You are expected to keep a ref to the parent object (same way as to any
other used object) if you need to access the data. Removed objects are
isolated now, which means that you just pin their data and not their
parents.

This is the expected behavior and makes it possible to resolve refcount
loops (parent ref's child) which could not be released with the implicit
parent ref that was only released on object cleanup.

Thanks,
Kay

