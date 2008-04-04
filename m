Return-Path: <linux-kernel-owner+w=401wt.eu-S1758672AbYDDBOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758672AbYDDBOI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 21:14:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755086AbYDDBN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 21:13:56 -0400
Received: from gw.goop.org ([64.81.55.164]:35063 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754924AbYDDBN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 21:13:56 -0400
Message-ID: <47F5809A.7040307@goop.org>
Date: Thu, 03 Apr 2008 18:12:58 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080315)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH 5 of 6] hotplug-memory: add section_ops
References: <785fe0877fea0f488bc5.1207267545@localhost> <1207270272.943.27.camel@nimitz.home.sr71.net>
In-Reply-To: <1207270272.943.27.camel@nimitz.home.sr71.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> On Thu, 2008-04-03 at 17:05 -0700, Jeremy Fitzhardinge wrote:
>   
>> Add a per-section "section_ops" structure,  allowing each section to have
>> specific functions for onlining and offlining pages within the section.
>> This is used by the Xen balloon driver to make sure that pages are not
>> onlined without some physical memory backing them.
>>     
>
> This is kinda a lot of code and mucking around for what we actually get
> out of it, especially since you just condensed down all the actual
> online_page() instances.
>   

I agree, but it seemed like the most straightforward and architecturally 
cleanest approach to me.

> I think it might just be nicer to have a global list of these handlers
> somewhere.  The Xen driver can just say "put me on the list of
> callbacks" and we'll call them at online_page().  I really don't think
> we need to be passing an ops structure around.
>   

Yes, but it seems a bit awkward.  If we assume that:

   1. Xen will be the only user of the hook, and
   2. Xen-balloon hotplug is exclusive of real memory hotplug

then I guess its reasonable (though if that's the case it would be 
simpler to just put a direct call under #ifdef CONFIG_XEN_BALLOON in there).

But if we think there can be multiple callbacks, and they all get called 
on the online of each page, and there can be multiple kinds of hotplug 
memory it gets pretty messy.  Each has to determine "why was I called on 
this page?" and you'd to work out which one actually does the job of 
onlining.  It just seems cleaner to say "this section needs to be 
onlined like this", and there's no ambiguity.

I'm already anticipating using the ops mechanism to support another 
class of Xen hotplug memory for managing large pages.

    J
