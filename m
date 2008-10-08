Return-Path: <linux-kernel-owner+w=401wt.eu-S1755965AbYJHUvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965AbYJHUvZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 16:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754760AbYJHUvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 16:51:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40940 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754650AbYJHUvQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 16:51:16 -0400
Message-ID: <48ED1D62.8080100@redhat.com>
Date: Wed, 08 Oct 2008 16:51:46 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Stefan Monnier <monnier@iro.umontreal.ca>
CC: linux-kernel@vger.kernel.org
Subject: Re: Filesystem for block devices using flash storage?
References: <jwvvdw33v5p.fsf-monnier+gmane.linux.kernel@gnu.org>
In-Reply-To: <jwvvdw33v5p.fsf-monnier+gmane.linux.kernel@gnu.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Monnier wrote:
> Google finds some people asking this same question, but I couldn't find
> any answer to it: what filesystem is recommended to use on an flash
> based disk that does not give access to the MTD layer (e.g. USB keys,
> most SSDs, ...)?

Unless you really know what you're doing, you should use a general-purpose disk 
filesystem.  You probably also want to use the relatime mount option, which is 
default on some distros.

> Since they do their own wear-levelling, any filesystem should be "safe",
> but I expect there is still a lot of variance in terms of performance,
> wear, robustness, ...

Writes to magnetic disks are functionally atomic at the sector level.  With 
SSDs, writing requires an erase followed by rewriting the sectors that aren't 
changing.  This means that an ill-timed power loss can corrupt an entire erase 
block, which could be up to 256k on some MLC flash.  Unless you have a RAID card 
with a battery-backed write cache, your best bet is probably data journaling. 
On ext3, you can enable this with the data=journal mount option or the 
rootflags=data=journal kernel parameter for your root filesystem.  It's entirely 
possible that doing this will severely harm your performance, though it's also 
possible that it may actually help it if you use a larger-than-default journal, 
thanks to improved write coalescing.

> Has anyone conducted serious experiemnts to try and find out what works
> better?  Also, since it appears that such devices are here to stay,
> would there be a need to design a new filesystem or to tune existing
> filesystems for this particular kind of device?

logfs tries to solve the write amplification problem by forcing all write 
activity to be sequential.  I'm not sure how mature it is.

> Or is there some hope for SSDs to provide access to the MTD layer in the
> not too distant future?

I hope not.  The proper fix is to have the devices report their physical 
topology via SCSI/ATA commands.  This allows dumb software to function 
correctly, albeit inefficiently, and allows smart software to optimize itself. 
This technique also helps with RAID arrays, large-sector disks, etc.

I suspect that in the long run, the problem will go away.  Erase blocks are a 
relic of the days when flash was used primarily for low-power, read-mostly 
applications.  As the SSD market heats up, the flash vendors will move to 
smaller erase blocks, possibly as small as the sector size.  Intel is already 
boasting that their new SSDs have a write amplification factor of only 1.1, 
which leaves very little room for improvement with erase-block-aware filesystems.

-- Chris
