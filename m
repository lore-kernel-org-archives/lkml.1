Return-Path: <linux-kernel-owner+w=401wt.eu-S1756945AbZJ3KQN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945AbZJ3KQN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 06:16:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756813AbZJ3KQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 06:16:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56286 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756803AbZJ3KQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 06:16:12 -0400
Message-ID: <4AEABD32.8010509@suse.de>
Date: Fri, 30 Oct 2009 11:17:22 +0100
From: Tejun Heo <teheo@suse.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org
Subject: Re: [PATCH 2/3] Sysfs: Allow directories to be populated dynamically
References: <20091020054740.GC29158@parisc-linux.org> <20091020055021.GE29158@parisc-linux.org> <4AE9C0B0.3030304@suse.de> <20091029162145.GM10555@parisc-linux.org> <4AE9C29E.6090706@suse.de> <20091029192414.GN10555@parisc-linux.org>
In-Reply-To: <20091029192414.GN10555@parisc-linux.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Matthew.

Matthew Wilcox wrote:
>> It feels a bit too convoluted to me.  sysfs is already pretty
>> convoluted and adding yet more convolution would require pretty good
>> justification, so I'm curious about the numbers.
> 
> It is convoluted.  The advantage of this is that we get to create many
> fewer dirents.  I wonder if we can do away with the dirents entirely, and
> have dentries constructed dynamically instead.

I think it's a bit misdirected.  It's probably better to try to reduce
the size of struct sysfs_dirent by tightly packing them and moving out
dynamic part of the data structure into a separate one which is only
allocated while the node is being accessed.  The thing is that large
number of the nodes would require struct sysfs_dirent anyway, so it
would be much more benficial and less convoluted to diet the whole
thing.

In this particular case, the trade off is actually much worse because
sysfs_dirent is being increased but the only one which is seeing any
kind of memory usage drop is the new msi-x code.  Given that there can
be only a handful of msi-x controllers even in a fairly large system,
I don't think memory usage will be reduced in any meaningful way even
on affected systems and if you think about large systems with
thousands and tens of thousands block devices, the bloat in
sysfs_dirent will waste a lot of memory.

Thanks.

-- 
tejun
