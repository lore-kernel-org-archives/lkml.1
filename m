Return-Path: <linux-kernel-owner+w=401wt.eu-S965533AbXFFXeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965533AbXFFXeX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 19:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965005AbXFFXeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 19:34:15 -0400
Received: from mga03.intel.com ([143.182.124.21]:35318 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964996AbXFFXeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 19:34:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,390,1175497200"; 
   d="scan'208";a="236415528"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
Date: Wed, 6 Jun 2007 16:34:00 -0700
User-Agent: KMail/1.9.6
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
References: <200706061229.24486.jesse.barnes@intel.com> <20070606161103.f8e3b253.randy.dunlap@oracle.com> <Pine.LNX.4.64.0706061915090.2716@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0706061915090.2716@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706061634.00937.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 6, 2007 4:15 pm Justin Piszcz wrote:
> On Wed, 6 Jun 2007, Randy Dunlap wrote:
> > On Wed, 6 Jun 2007 18:54:37 -0400 (EDT) Justin Piszcz wrote:
> >> Hm, not sure if it was from the patch or what but I ran this:
> >>
> >> 1. swapoff -a
> >> 2. ./eatmem
> >
> > You usually have to access the allocated memory, like:
> >
> > 	*d = 1.0;
> >
> > for it to actually be allocated (AFAIK).
> >
> >>    }
> >>
> >>    return 0;
> >> }
> >>
> >> Any idea why the OOM killer can or does not kill it?
> >
> > What are the values of /proc/sys/vm/overcommit* ?
> >
> > See Documentation/vm/overcommit-accounting .
>
> They should be the defaults as I do not change them:
>
> p34:~# find /proc/|grep -i overcommit
> /proc/sys/vm/overcommit_memory
> /proc/sys/vm/overcommit_ratio
> find: /proc/5128: No such file or directory
> p34:~# cat /proc/sys/vm/overcommit_memory
> 0
> p34:~# cat /proc/sys/vm/overcommit_ratio
> 50
> p34:~#
>
>
> Comments?

You can be sure your memory is available if reported in /proc/meminfo or 
at boot, since those represent the actual kernel data structures used 
for memory allocation:

[    0.000000] On node 0 totalpages: 2061783

That corresponds to 2061783*4k = 8445063168 bytes or ~8053M.  Is that 
fairly close to what's actually installed in the machine?

Note that your boot also mentions this:

[  106.449661] mtrr: no more MTRRs available

which indicates that things like X may not be able to map the 
framebuffer with the 'write-combine' attribute, which will hurt 
performance.  I've heard reports that turning of 'Intel QST fan 
control' in your BIOS settings will prevent all your MTRRs from being 
used (improperly, probably another BIOS bug) so that X will perform 
well.  But if you don't use X on this machine, you don't have to worry 
about it.  The other option would be to remap your MTRRs by hand to 
free one up for X, you can do that by combining the last one or two 
entries into a single MTRR using the API described in 
Documentation/mtrr.txt before you start X.

Jesse
