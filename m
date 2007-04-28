Return-Path: <linux-kernel-owner+w=401wt.eu-S1754375AbXD1CAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375AbXD1CAh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 22:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754451AbXD1CAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 22:00:37 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:44819 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754343AbXD1CA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 22:00:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=To7ACMobghLIcOVMv3Nh4jvQSkFTl3ydJf4FckKMzBf/NVoHZ5r9K+ZkxuTuaULSoa+Odd+aWT7VvI/ZytrBD9R7uwoE0bq2nho0ZUo1lbFcPVgBrmcy5un+lL9ZBPGx9JjQS2CrTeb1rmLsNL9DIl0hfWGxJ1EgLLNYtSKDI10=  ;
Message-ID: <4632AAB4.6030303@yahoo.com.au>
Date: Sat, 28 Apr 2007 12:00:20 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: rohitseth@google.com
CC: Mike Stroyan <mike.stroyan@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>, "Luck, Tony" <tony.luck@intel.com>,
       linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Fw: [PATCH] ia64: race flushing icache in do_no_page path
References: <20070425205548.fd51b301.akpm@linux-foundation.org>	 <46305A8D.2080003@yahoo.com.au> <20070426173544.GA30744@ldl.fc.hp.com>	 <4631E49C.2030501@yahoo.com.au> <1177723479.13482.371.camel@galaxy.corp.google.com>
In-Reply-To: <1177723479.13482.371.camel@galaxy.corp.google.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rohit Seth wrote:
> On Fri, 2007-04-27 at 21:55 +1000, Nick Piggin wrote:
> 
> 
>>That's the theory. However, I'd still like to know how the arch code can
>>make the assertion that icache is known to be at all times other than at
>>the time of a fault?
>>
> 
> 
> Kernel needs to only worry about the updates that it does.  So, if
> kernel is writing into a page that is getting marked with execute
> permission then it will need to make sure that caches are coherent.
> ia64 Kernel keeps track of whether it has done any write operation on a
> page or not using PG_arch_1.  And accordingly flushes icaches.

It flushes icache at fault time, I know. What I don't know is why we
leave them to drift out of sync afterwards.


>>Ie. what if an operation which causes incoherency is carried out _after_
>>an executable mapping is installed for that page.
>>
> 
> 
> You mean by user space? If so, then it is user space responsibility to
> do the appropriate operations (like flush icache in this case).

No, I mean places that set PG_arch_1. flush_dcache_page. This can
happen for mapped pages in write, splice, install_arg_page looks
questionable, direct IO...

Actually there are various windows where mapped pages can be !uptodate,
so there is technically most of the filesystem code as well, but I'm
trying to stamp those out, so let's ignore that for now.

What if you were to say remove all the PG_arch_1 code, and do something
really simple like flush icache in flush_dcache_page? Would performance
suffer horribly?

-- 
SUSE Labs, Novell Inc.
