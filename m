Return-Path: <linux-kernel-owner+w=401wt.eu-S937170AbXHHVK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937170AbXHHVK2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 17:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763071AbXHHVKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 17:10:19 -0400
Received: from dvhart.com ([64.146.134.43]:44591 "EHLO dvhart.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763376AbXHHVKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 17:10:18 -0400
Message-ID: <46BA3137.3020701@mbligh.org>
Date: Wed, 08 Aug 2007 14:10:15 -0700
From: "Martin J. Bligh" <mbligh@mbligh.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, J??rn Engel <joern@logfs.org>,
       Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de,
       dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk, david@lang.hm
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
References: <20070804070737.GA940@elte.hu> <20070804103347.GA1956@elte.hu> <alpine.LFD.0.999.0708040915360.5037@woody.linux-foundation.org> <20070804163733.GA31001@elte.hu> <alpine.LFD.0.999.0708041030040.5037@woody.linux-foundation.org> <46B4C0A8.1000902@garzik.org> <20070804191205.GA24723@lazybastard.org> <20070804192130.GA25346@elte.hu> <20070804192615.GA25600@lazybastard.org> <20070804194259.GA25753@lazybastard.org> <20070805203602.GB25107@infradead.org>
In-Reply-To: <20070805203602.GB25107@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Sat, Aug 04, 2007 at 09:42:59PM +0200, J??rn Engel wrote:
>   
>> On Sat, 4 August 2007 21:26:15 +0200, J??rn Engel wrote:
>>     
>>> Given the choice between only "atime" and "noatime" I'd agree with you.
>>> Heck, I use it myself.  But "relatime" seems to combine the best of both
>>> worlds.  It currently just suffers from mount not supporting it in any
>>> relevant distro.
>>>       
>> And here is a completely untested patch to enable it by default.  Ingo,
>> can you see how good this fares compared to "atime" and
>> "noatime,nodiratime"?
>>     
>
> Umm, no f**king way.  atime selection is 100% policy and belongs into
> userspace.  Add to that the problem that we can't actually re-enable
> atimes because of the way the vfs-level mount flags API is designed.
> Instead of doing such a fugly kernel patch just talk to the handfull
> of distributions that matter to update their defaults.
>   

 From what I've seen the problem seems to be that the inode
gets marked dirty when we update atime.

Why isn't this easily fixable by just adding an additional dirty
flag that says atime has changed? Then we only cause a write
when we remove the inode from the inode cache, if only atime
is updated.

Unlike relatime, there's no user-visible change (unless the
machine crashes without clean unmount, but not sure anyone
cares that much about that cornercase). Atime changes are
thus kept in-ram until umount / inode reclaim.

