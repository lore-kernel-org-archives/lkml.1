Return-Path: <linux-kernel-owner+w=401wt.eu-S1753562AbYDWPhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562AbYDWPhs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 11:37:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319AbYDWPhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 11:37:40 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53053 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbYDWPhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 11:37:40 -0400
Date: Wed, 23 Apr 2008 17:43:23 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andi Kleen <andi@firstfloor.org>, wli@holomorphy.com, agl@us.ibm.com,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Reserve huge pages for reliable MAP_PRIVATE hugetlbfs mappings
Message-ID: <20080423154323.GA29087@one.firstfloor.org>
References: <20080421183621.GA13100@csn.ul.ie> <87hcdsznep.fsf@basil.nowhere.org> <20080423151428.GA15834@csn.ul.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080423151428.GA15834@csn.ul.ie>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If the large pages exist to satisfy the mapping, the application will not
> even notice this change. They will only break if the are creating larger
> mappings than large pages exist for (or can be allocated for in the event
> they have enabled dynamic resizing with nr_overcommit_hugepages). If they
> are doing that, they are running a big risk as they may get arbitrarily
> killed later. 

The point is it is pretty common (especially when you have enough 
address space) just create a huge mapping and only use the begining.
This avoids costly resize operations later and is a quite useful
strategy on 64bit (but even on 32bit).  Now the upper size will
likely be incredibly huge (far beyond available physical memory), but it's 
obviously impossible really uses all of it.

It's also common in languages who don't support dynamic allocation well (like 
older fortran dialects). Given these won't use hugetlbfs directly either, 
but I couldn't rule out that someone wrote a special fortran run time library 
which transparently allocates large arrays from hugetlbfs. 

In fact i would be surprised if a number of such beasts don't exist -- it is 
really an obvious simple tuning option for old HPC fortran applications.

> Sometimes their app will run, other times it dies. If more
> than one application is running on the system that is behaving like this,
> they are really playing with fire.

With your change such an application will not run at all. Doesn't
seem like an improvement to me.

> With this change, a mmap() failure is a clear indication that the mapping
> would have been unsafe to use and they should try mmap()ing with small pages
> instead. 

I don't have a problem with having an optional strict overcommit checking 
mode (similar to what standard VM has), but it should be configurable
and off by default.

-Andi

