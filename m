Return-Path: <linux-kernel-owner+w=401wt.eu-S938176AbXLTSQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938176AbXLTSQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 13:16:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764948AbXLTSQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 13:16:06 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:43007 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763899AbXLTSQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 13:16:05 -0500
Date: Thu, 20 Dec 2007 11:16:03 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Tony Camuso <tcamuso@redhat.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [Fwd: Re: [PATCH 0/5]PCI: x86 MMCONFIG]
Message-ID: <20071220181603.GF29690@parisc-linux.org>
References: <476A5FD0.4010804@redhat.com> <20071220172205.GB5636@suse.de> <20071220173528.GE29690@parisc-linux.org> <476AAE99.7090301@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <476AAE99.7090301@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2007 at 01:04:09PM -0500, Tony Camuso wrote:
> Sorry, that was the 82Q963/Q965 graphics controller, PCI ID 2992.
> 
> I can't remember why I thought PCI ID 2992 maps to 830M/MG. I think
> it was in some intel doc about the ICH8 or ICH9.
> 
> Nevertheless, I have an hp dc5700 microtower right here on the floor
> next to me, and it hangs when the bus sizing code does an mmconfig
> write to the BAR at offset 0x18 in this device (id 2992).

Oh, that's the same bug others (including me) have been complaining
about.

http://marc.info/?l=linux-kernel&m=118809338631160&w=2

> It hangs in exactly the same place every time.
> 
> I am surmising that the write to that BAR is causing a MCE.

Bad deduction.  What's happening is that the write to the BAR is causing
it to overlap the decode for mmconfig space.  So the mmconfig write to
set the BAR back never gets through.

I have a different idea to fix this problem.  Instead of writing
0xffffffff, we could look for an unused bit of space in the E820 map and
write, say, 0xdfffffff to the low 32-bits of a BAR.  Then it wouldn't
overlap, and we could find its size using MMCONFIG.

Does anyone know how Windows handles these machines?  Obviously, if it's
using MMCONFIG, it'd have the same problems.  Does it just use type 1
for initial sizing?  Or does it use type 1 for all accesses below 256
bytes?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
