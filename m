Return-Path: <linux-kernel-owner+w=401wt.eu-S1754783AbYCCOfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783AbYCCOfU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 09:35:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbYCCOfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 09:35:07 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:50801 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723AbYCCOfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 09:35:05 -0500
Message-ID: <47CC0C95.1030709@s5r6.in-berlin.de>
Date: Mon, 03 Mar 2008 15:35:01 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.12) Gecko/20080201 SeaMonkey/1.1.8
MIME-Version: 1.0
To: Gabriel Paubert <paubert@iram.es>
CC: Jarod Wilson <jwilson@redhat.com>, benh@kernel.crashing.org,
       Kristian Hoegsberg <krh@bitplanet.net>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, sparclinux@vger.kernel.org,
       linux1394-devel@lists.sourceforge.net, Sam Ravnborg <sam@ravnborg.org>,
       Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH 1/2] firewire: endianess fix
References: <20080220220326.GA22328@uranus.ravnborg.org> <200802272221.38985.jwilson@redhat.com> <1204179959.15052.372.camel@pasglop> <200802281342.06493.jwilson@redhat.com> <1204241162.15052.393.camel@pasglop> <47C79CB1.6050104@redhat.com> <20080303091927.GA27105@iram.es>
In-Reply-To: <20080303091927.GA27105@iram.es>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gabriel Paubert wrote:
> I have a Pismo which I use on a virtually
> daily basis (and about to remove the last remnants of MacOS on it). 
> However I have disabled Firewire because it would not sleep and wake 
> up properly. 
> 
> I can test it on Wednesday with a 5GB fireflly disk from 2001.
> 
> Please tell me which configuration options I need to set for
> Firewire (which stack, etc...).

Config options of the new stack:
FIREWIRE=m
FIREWIRE_OHCI=m
FIREWIRE_SBP2=m

Config options of the old stack:
IEEE1394=m
IEEE1394_OHCI1394=m
IEEE1394_SBP2=m
and if desired also the other drivers for raw userspace access,
isochronous I/O (alias video1394 even though it can also be used for
other purposes), DV I/O, and IPv4 over 1394.

The two SBP2 drivers also need SCSI and BLK_DEV_SD a.k.a. SCSI disk
support or/and BLK_DEV_SR a.k.a. SCSI CDROM support.

You can also set the options to Y but I find loadable and hence
unloadable modules more practical... 'cause I unload and reload them all
the time.  :-)

Regarding which of the two stacks to build:  If you are going to test
FireWire with a storage device only, then you can choose either stack.
Caveats:
  - You could build and install both stacks but should then blacklist
    at least one of ohci1394 or firewire-ohci.  Better keep it simple
    and install only one of the stacks at a time.
  - We still have a serious use-after-free bug in the new stack.  This
    may lead to kernel panic if the kernel was build with (slab? or
    page allocation?) debugging enabled.
Users of IP over 1394 and pro/semipro audio still need the old stack.
Users of video should stick with the stack which their distribution has
enabled because our support in the lowlevel libraries libraw1394 and
libdc1394 to switch between the stacks is not quite comfortable yet.

Suspend (to RAM) and resume worked for me [TM] when I last tested them
with each stack.  I tested i586/APM, x86-64/ACPI, and last weekend ppc32
on 1st generation PowerBook G4.  I haven't tested hibernate (to disk)
and restore yet.

For successful resume on the Pismo with the new stack, you will most
certainly need the brand new patches which add PPC_PMAC platform support
to firewire-ohci.  From what I saw with the PowerBook, you will also
need the UniNorth rev1 related patch.  I wasn't able to fully test that
patch though because the electrical interface of my PowerBook's onboard
FireWire is dead.  You can get the patches from kernel.org's
linux1394-2.6.git (master branch, close to Linus's latest linux-2.6.git)
or http://me.in-berlin.de/~s5r6/linux1394/updates/ (for a few kernel.org
kernels).

The old stack as found in any remotely recent 2.6 kernel should be OK
out of the box without patches... in theory.  I wouldn't be surprised of
until now unreported bugs or old reported but forgotten bugs though.
-- 
Stefan Richter
-=====-==--- --== ---==
http://arcgraph.de/sr/
