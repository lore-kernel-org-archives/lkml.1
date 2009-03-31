Return-Path: <linux-kernel-owner+w=401wt.eu-S1762099AbZCaRMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762099AbZCaRMg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 13:12:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761189AbZCaRMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 13:12:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37406 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761120AbZCaRMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 13:12:13 -0400
Date: Tue, 31 Mar 2009 19:11:58 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Izik Eidus <ieidus@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, linux-mm@kvack.org, avi@redhat.com,
       chrisw@redhat.com, riel@redhat.com, jeremy@goop.org,
       mtosatti@redhat.com, hugh@veritas.com, corbet@lwn.net, yaniv@redhat.com,
       dmonakhov@openvz.org
Subject: Re: [PATCH 4/4] add ksm kernel shared memory driver.
Message-ID: <20090331171158.GY9137@random.random>
References: <49D20B63.8020709@redhat.com> <49D21B33.4070406@codemonkey.ws> <20090331142533.GR9137@random.random> <49D22A9D.4050403@codemonkey.ws> <20090331150218.GS9137@random.random> <49D23224.9000903@codemonkey.ws> <20090331151845.GT9137@random.random> <49D23CD1.9090208@codemonkey.ws> <20090331162525.GU9137@random.random> <49D24A02.6070000@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D24A02.6070000@codemonkey.ws>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 31, 2009 at 11:51:14AM -0500, Anthony Liguori wrote:
> You have two things here.  CONFIG_MEM_SHARABLE and CONFIG_KSM.  
> CONFIG_MEM_SHARABLE cannot be a module. If it's set to =n, then 
> madvise(MADV_SHARABLE) == -ENOSYS.

Where the part that -ENOSYS tell userland madvise syscall table is
empty, which is obviously not the case, wasn't clear?

> If CONFIG_MEM_SHARABLE=y, then madvise(MADV_SHARABLE) will keep track of 
> all sharable memory regions.  Independently of that, CONFIG_KSM can be set 
> to n,m,y.  It depends on CONFIG_MEM_SHARABLE and when it's loaded, it 
> consumes the list of sharable vmas.

And what do you gain by creating two config params when only one is
needed other than more pain for the poor user doing make oldconfig and
being asked new zillon of questions that aren't necessary?

> But honestly, CONFIG_MEM_SHARABLE shouldn't a lot of code so I don't see 
> why you'd even need to make it configable.

Even if you were to move the registration code in madvise with a
-EINVAL retval if KSM was set to N for embedded, CONFIG_KSM would be
enough: the registration code would be surrounded by CONFIG_KSM_MODULE
|| CONFIG_KSM, just like page_wrprotect/replace_page. This
CONFIG_MEM_SHARABLE in addition to CONFIG_KSM is beyond what can make
sense to me.

> The ioctl() interface is quite bad for what you're doing.  You're telling 
> the kernel extra information about a VA range in userspace.  That's what 

The ioctl can be extended to also tell which pid to share without
having to specify VA range, and having the feature inherited by the
child. Not everyone wants to deal with VA.

But my main issue with madvise is that it's core kernel functionality
while KSM clearly is not.
