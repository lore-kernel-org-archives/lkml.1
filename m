Return-Path: <linux-kernel-owner+w=401wt.eu-S1752844AbYLANh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844AbYLANh3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 08:37:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751568AbYLANhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 08:37:18 -0500
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:41133 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbYLANhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 08:37:17 -0500
Date: Mon, 1 Dec 2008 05:36:50 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell2.speakeasy.net
To: Alex Chiang <achiang@hp.com>
cc: "Darrick J. Wong" <djwong@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-pci <linux-pci@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>
Subject: Problems with fakephp
In-Reply-To: <20081128231820.GA23578@ldl.fc.hp.com>
Message-ID: <Pine.LNX.4.58.0812010500330.2943@shell2.speakeasy.net>
References: <20081125212422.22631.69619.stgit@elm3a70.beaverton.ibm.com>
 <Pine.LNX.4.64.0811251919590.5161@t2.domain.actdsltmp> <20081126074808.GE6539@plum>
 <Pine.LNX.4.58.0811260131200.24816@shell4.speakeasy.net> <20081126181841.GF6539@plum>
 <Pine.LNX.4.58.0811261349120.24816@shell4.speakeasy.net>
 <20081126225535.GA27936@ldl.fc.hp.com> <Pine.LNX.4.58.0811261647410.24816@shell4.speakeasy.net>
 <20081128231820.GA23578@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Nov 2008, Alex Chiang wrote:
> I like this idea:
>
> 	Maybe we want a /sys/bus/pci/scan or
> 	/sys/bus/pci/devices/scan file that we can echo
> 	"0000:01:02.3" to scan just that function, or
> 	"0000:01:02" to scan the device.
>
> Will that work for you, Trent?

I don't think that's the best interface for it.  If you want to know what
bus number a SCSI bus was assigned, you can find that out from /proc/scsi.
The SCSI ID is usually explicitly set by the user on the device.  So if you
want to add a scsi device, you should be able to know all the parts of the
address.

But PCI is different.  If the PCI devices on your computer right now
disappeared from Linux, would you know their IDs off the top of your head?
I sure wouldn't.  And how would you find them out?  Suppose someone plugged
an FPGA card into a sever PCI system with multiple busses and bridges.  How
would they ever guess what ID to scan?  What function numbers might be
present once the FPGA is programmed?

I think a much more useful interface would be a "scan" file that will just
trigger a rescan of everything.  Even the users who know what ID to scan
would probably rather not be bothered to be forced to specify.

Maybe each PCI device could get a 'rescan' attribute that triggers a rescan
of that device for new functions and recursively rescans any subordinate
busses if it's a bridge?  That might be useful too.

But anyway, how about removing PCI devices.  I see adding a "remove"
attribute was mentioned.  When I first had the problem with getting the
FPGA re-scanned I was going to add something like that, but searching for
what people with a similar problem has done turned up fakephp as the
established interface.

I've made a patch to add the remove attribute.  It ends up not being that
much code.  fakephp is a lot more complex that it needs to be.

However, fakephp does not like this!  As I mentioned earlier, it can't
handle something other than itself causing a PCI device to be removed.

So I came up with a compatibility layer that creates directories in
bus/pci/slots the same way fakephp used too.  This layer _can_ handle
devices being removed (and added!) by other means.  It ends up being a lot
simpler than fakephp too.  It doesn't use hotplug at all and should be able
to coexist with real hotplug drivers and fakephp.

I'll followup with the patches.  So far this only handles removal.  I
haven't done bus rescanning yet.
