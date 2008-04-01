Return-Path: <linux-kernel-owner+w=401wt.eu-S1755264AbYDAHU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264AbYDAHU2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 03:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbYDAHUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 03:20:17 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:49090 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbYDAHUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 03:20:15 -0400
Date: Tue, 01 Apr 2008 16:17:38 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH RFC] hotplug-memory: refactor online_pages to separate zone growth from page onlining
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <clameter@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Anthony Liguori <anthony@codemonkey.ws>, Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <47F1282E.3020503@goop.org>
References: <1206981741.31896.51.camel@nimitz.home.sr71.net> <47F1282E.3020503@goop.org>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20080401150408.F77C.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.45 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Dave Hansen wrote:
> > On Sat, 2008-03-29 at 16:53 -0700, Jeremy Fitzhardinge wrote:
> >   
> >> Dave Hansen wrote:
> >>     
> >>> On Fri, 2008-03-28 at 19:08 -0700, Jeremy Fitzhardinge wrote:
> >>>   
> >>>       
> >>>> My big remaining problem is how to disable the sysfs interface for this 
> >>>> memory.  I need to prevent any onlining via /sys/device/system/memory.
> >>>>     
> >>>>         
> >>> I've been thinking about this some more, and I wish that you wouldn't
> >>> just throw this interface away or completely disable it.
> >>>       
> >> I had no intention of globally disabling it.  I just need to disable it 
> >> for my use case.
> >>     
> >
> > Right, but by disabling it for your case, you have given up all of the
> > testing that others have done on it.  Let's try and see if we can get
> > the interface to work for you.
> >   
> 
> I suppose, but I'm not sure I see the point.  What are the benefits of 
> using this interface?  You mentioned that the interface exists so that 
> its possible to defer using a newly added piece of memory to avoid 
> fragmentation.  I suppose I can see the point of that

Not only to avoid fragmentation, but also for notification
to user level for preparing memory add event.
When memory is added, there is a notification via udev for each memory
device.
In our box, one node which includes some DIMMs and CPUs can be added by
hot-add, and there is another notification for 1 node by ACPI's
container device.
After user level check for preparing, user(or shell script) can
online memory.

IIRC, some of user level application would require this notification.
ex) resource manager over physical/logical partitioning.

>
> But in the xen-balloon case, the memory is added on-demand precisely 
> when its about to be used, and then onlined in pieces as needed.  
> Extending the usermode interface to allow partial onlining/offlining 
> doesn't seem very useful for the case of physical hotplug memory, and 
> its not at all clear how to do it in a useful way for the xen-balloon 
> case.  Particularly for offlining, since you'd need to guarantee that 
> any page chosen for offlining isn't currently in use.
> 

Basically, I hope there is no change for user level interface between
physical hotplug and Xen as much as possible. 
So, I would like to make sense why memory is added "on-demand" on Xen.
I thought the hypervisor gathers a section's memory and moves all of them
from one guest to another at a time. Its gathering time may be long time.
But, each per page moving may cause of fragmentation, if my understanding
is correct....


> >>> To me, it sounds like the only different thing that you want is to make
> >>> sure that only partial sections are onlined.  So, shall we work with the
> >>> existing interfaces to online partial sections, or will we just disable
> >>> it entirely when we see Xen?
> >>>   
> >>>       
> >> Well, yes and no.
> >>
> >> For the current balloon driver, it doesn't make much sense.  It would 
> >> add a fair amount of complexity without any real gain.  It's currently 
> >> based around alloc_page/free_page.  When it wants to shrink the domain 
> >> and give memory back to the host, it allocates pages, adds the page 
> >> structures to a ballooned pages list, and strips off the backing memory 
> >> and gives it to the host.  Growing the domain is the converse: it gets 
> >> pages from the host, pulls page structures off the list, binds them 
> >> together and frees them back to the kernel.  If it runs out of ballooned 
> >> page structures, it hotplugs in some memory to add more.
> >>     
> >
> > How does this deal with things like present_pages in the zones?  Does
> > the total ram just grow with each hot-add, or does it grow on a per-page
> > basis from the ballooning?
> >   
> 
> Well, there are two ways of looking at it:
> 
>     either hot-plugging memory immediately adds pages, but they're also
>     all immediately allocated and therefore unavailable for general use, or
> 
>     the pages are notionally physically added as they're populated by
>     the host
> 
> 
> In principle they're equivalent, but I could imagine the former has the 
> potential to make the VM waste time scanning unfreeable pages.
> 
> I'm not sure the patches I've posted are doing this stuff correctly 
> either way.

I don't make sense both your idea yet. Could you tell me more?
One of them may be same to my understanding. But I'm not sure.


Thanks.

-- 
Yasunori Goto 


