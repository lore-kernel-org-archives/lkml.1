Return-Path: <linux-kernel-owner+w=401wt.eu-S1758076AbYHVUOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076AbYHVUOc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 16:14:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754473AbYHVUOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 16:14:23 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:36798 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754147AbYHVUOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 16:14:23 -0400
Message-ID: <48AF1E67.2030509@keyaccess.nl>
Date: Fri, 22 Aug 2008 22:15:35 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Dave Airlie <airlied@gmail.com>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Dave Jones <davej@codemonkey.org.uk>
Subject: Re: [PATCH] x86: have set_memory_array_{uc,wb} coalesce memtypes.
References: <48ABF6DC.8070305@keyaccess.nl> <48AC29CA.1060203@keyaccess.nl> <20080820194127.GA10887@linux-os.sc.intel.com> <48AC8F69.4050201@keyaccess.nl> <21d7e9970808201446k3c1a6bc1naf04568a8ad06ed4@mail.gmail.com> <20080820221630.GA3598@linux-os.sc.intel.com> <20080821120626.GG5615@elte.hu> <48ADA2C2.8090905@keyaccess.nl> <48ADF3FC.7070002@keyaccess.nl> <20080822041544.GF30284@elte.hu> <20080822190817.GA17381@linux-os.sc.intel.com>
In-Reply-To: <20080822190817.GA17381@linux-os.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: 0.7 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22-08-08 21:08, Venki Pallipadi wrote:

> On Thu, Aug 21, 2008 at 09:15:44PM -0700, Ingo Molnar wrote:

>> Venki, Suresh, Shaohua, Dave, Arjan - any observations about this
>> line of action?
> 
> The concern I have here is that the coalescing is not guaranteed to
> work. We may still end up having horrible worst case latency, even
> though this improves the normal case (boot the system, start X, exit
> X, reboot the system). It depends on how pages are allocated and how
> much memory is there in the system and what else is running etc.

Yes, I agree. Independent of the current trigger PAT wants a more 
scalable approach and yes, worst case is still single page entries.

That worst case is the guaranteed case now though, so I do feel it's a 
generic fix. After all, there wouldn't seem to be a reason to _not_ 
coalesce in set_memory_array_{uc,wb}().

> Here on my test system, without this coalescing change I see
> 
> [root@localhost ~]# cat /proc/sys/debug/x86/pat_memtype_list | wc -l
> 19528
> 
> With the coalescing change I see
> [root@localhost ~]# cat /proc/sys/debug/x86/pat_memtype_list | wc -l
> 135
> 
> quit and restart X
> [root@localhost ~]# cat /proc/sys/debug/x86/pat_memtype_list | wc -l
> 985

[ constantly growing number of entries ]

Yes, absolutely right, PAT definitely needs something other than the 
simple linked list. I do believe we also want the coalescing change 
though - it seems to make sense regardless of trigger and it's only 
little code.

> I think this as a good workaround for now. But, for long run we still need to
> look at other ways of eliminating this overhead (like using page struct
> that Suresh mentioned in the other thread).
> 
> 
> Also, there seems to be a bug in the error path of the patch. Below should
> fix it.

Ah, yes, thanks, just sent out a final version with this fixed as well.

Rene.

