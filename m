Return-Path: <linux-kernel-owner+w=401wt.eu-S1759759AbZFWPOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759759AbZFWPOh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 11:14:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755936AbZFWPOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 11:14:24 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:42724 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753653AbZFWPOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 11:14:23 -0400
Message-ID: <4A40F14F.5050403@shipmail.org>
Date: Tue, 23 Jun 2009 17:14:23 +0200
From: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@shipmail.org>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>, Jerome Glisse <jglisse@redhat.com>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: [PATCH] radeon: use vmalloc instead of kmalloc
References: <1245691561-15336-1-git-send-email-jglisse@redhat.com>	<1245756936.19816.1652.camel@twins> <21d7e9970906230442n3dcfeff8le0ffc3b8ea0c3bd0@mail.gmail.com>
In-Reply-To: <21d7e9970906230442n3dcfeff8le0ffc3b8ea0c3bd0@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Airlie skrev:
> On Tue, Jun 23, 2009 at 9:35 PM, Peter Zijlstra<peterz@infradead.org> wrote:
>   
>> On Mon, 2009-06-22 at 19:26 +0200, Jerome Glisse wrote:
>>     
>>> We don't need to allocated contiguous pages in cs codepath
>>> so use vmalloc instead.
>>>       
>> Best would be to not require >PAGE_SIZE allocations at all of course.
>>     
>
> It gets messy when you have copy from user and spinlocks, it would be nice
> to just parse the userspace PAGE_SIZE at a time, but it would mean dropping
> a lock we probably need to hold.
>
>   
>> But barring that, it would be great to have something like:
>>
>>  ptr = kmalloc(size, GFP_KERNEL | __GFP_NOWARN);
>>  if (!ptr)
>>    ptr = vmalloc(size);
>>     
>
> we have a drm_calloc_large workaround already for the Intel driver which also
> need this.
>   
One problem with multiple vmallocs per command submission is 
performance. Judging from previous work, drivers that are doing this 
tend to get very cpu-hungry. Since Radeon is only allowing a single 
process into the command submission path at once, what about 
pre-allocating a single larger vmalloced buffer at first command 
submission and take care to flush user-space before the submitted 
command stream gets too big.

>> Also, how long do these allocations live? vmalloc space can be quite
>> limited (i386) and it can fragment too.
>>     
>
> Only an ioctl lifetime so they aren't that bad. We however do have some vmaps
> that might be quite large, mainly the fbcon framebuffer (up to 8MB in
> some cases)
>   
That one would be ioremapped, not vmapped right? Not that it matters 
because it's using vmalloc space anyway, but it wouldn't be worse than a 
traditionally ioremapped framebuffer.

Thomas

> Dave.
>
> ------------------------------------------------------------------------------
> Are you an open source citizen? Join us for the Open Source Bridge conference!
> Portland, OR, June 17-19. Two days of sessions, one day of unconference: $250.
> Need another reason to go? 24-hour hacker lounge. Register today!
> http://ad.doubleclick.net/clk;215844324;13503038;v?http://opensourcebridge.org
> --
> _______________________________________________
> Dri-devel mailing list
> Dri-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/dri-devel
>   

