Return-Path: <linux-kernel-owner+w=401wt.eu-S1752793AbYC2Xy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793AbYC2Xy1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 19:54:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750983AbYC2XyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 19:54:20 -0400
Received: from gw.goop.org ([64.81.55.164]:38283 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155AbYC2XyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 19:54:18 -0400
Message-ID: <47EED683.5030200@goop.org>
Date: Sat, 29 Mar 2008 16:53:39 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Christoph Lameter <clameter@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Anthony Liguori <anthony@codemonkey.ws>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH RFC] hotplug-memory: refactor online_pages to separate
 zone growth from page onlining
References: <47ED8685.9040409@goop.org>	 <1206751622.27091.20.camel@nimitz.home.sr71.net>	 <47EDA4B9.6030801@goop.org> <1206806774.31896.27.camel@nimitz.home.sr71.net>
In-Reply-To: <1206806774.31896.27.camel@nimitz.home.sr71.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> On Fri, 2008-03-28 at 19:08 -0700, Jeremy Fitzhardinge wrote:
>   
>> My big remaining problem is how to disable the sysfs interface for this 
>> memory.  I need to prevent any onlining via /sys/device/system/memory.
>>     
>
> I've been thinking about this some more, and I wish that you wouldn't
> just throw this interface away or completely disable it.

I had no intention of globally disabling it.  I just need to disable it 
for my use case.

>   It actually
> does *exactly* what you want in a way. :)
>
> When the /memoryXX/ directory appears, that means that the hardware has
> found the memory, and that the 'struct page' is allocated and ready to
> be initialized.
>
> When the OS actually wants to use the memory (initialize the 'struct
> page', and free_page() it), it does the 'echo online > /sys...'.  Both
> the 'struct page' and the memory represented by it are untouched until
> the "online".  This was originally in place to avoid fragmenting it
> immediately in the case that the system did not need it.
>
> To me, it sounds like the only different thing that you want is to make
> sure that only partial sections are onlined.  So, shall we work with the
> existing interfaces to online partial sections, or will we just disable
> it entirely when we see Xen?
>   

Well, yes and no.

For the current balloon driver, it doesn't make much sense.  It would 
add a fair amount of complexity without any real gain.  It's currently 
based around alloc_page/free_page.  When it wants to shrink the domain 
and give memory back to the host, it allocates pages, adds the page 
structures to a ballooned pages list, and strips off the backing memory 
and gives it to the host.  Growing the domain is the converse: it gets 
pages from the host, pulls page structures off the list, binds them 
together and frees them back to the kernel.  If it runs out of ballooned 
page structures, it hotplugs in some memory to add more.

That said, if (partial-)sections were much smaller - say 2-4 meg - and 
page migration/defrag worked reliably, then we could probably do without 
the balloon driver and do it all in terms of memory hot plug/unplug.  
That would give us a general mechanism which could either be driven from 
userspace, and/or have in-kernel Xen/kvm/s390/etc policy modules.  Aside 
from small sections, the only additional requirement would be an online 
hook which can actually attach backing memory to the pages being 
onlined, rather than just assuming an underlying DIMM as current code does.

> For Xen and KVM, how does it get decided that the guest needs more
> memory?  Is this guest or host driven?  Both?  How is the guest
> notified?  Is guest userspace involved at all?

In Xen, either the host or the guest can set the target size for the 
domain, which is capped by the host-set limit.  Aside from possibly 
setting the target size, there's no usermode involvement in managing 
ballooning.  The virtio balloon driver is similar, though from a quick 
look it seems to be entirely driven by the host side.

    J
