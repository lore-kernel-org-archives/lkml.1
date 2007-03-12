Return-Path: <linux-kernel-owner+w=401wt.eu-S1030721AbXCLRSK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030721AbXCLRSK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 13:18:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030730AbXCLRSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 13:18:10 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:42687 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030721AbXCLRSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 13:18:08 -0400
Message-ID: <45F58B91.4060001@sw.ru>
Date: Mon, 12 Mar 2007 20:19:13 +0300
From: Pavel Emelianov <xemul@sw.ru>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Dave Hansen <hansendc@us.ibm.com>
CC: Kirill Korotaev <dev@sw.ru>, "Eric W. Biederman" <ebiederm@xmission.com>,
       containers@lists.osdl.org, Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 3/7] Data structures changes for RSS accounting
References: <45ED7DEC.7010403@sw.ru> <45ED8181.2060905@sw.ru>	 <m18xe3wq3t.fsf@ebiederm.dsl.xmission.com>  <45F57CFB.9010707@sw.ru> <1173718084.11945.51.camel@localhost.localdomain>
In-Reply-To: <1173718084.11945.51.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> On Mon, 2007-03-12 at 19:16 +0300, Kirill Korotaev wrote:
>> now VE2 maps the same page. You can't determine whether this page is mapped
>> to this container or another one w/o page->container pointer. 
> 
> Hi Kirill,
> 
> I thought we can always get from the page to the VMA.  rmap provides
> this to us via page->mapping and the 'struct address_space' or anon_vma.
> Do we agree on that?

Not completely. When page is unmapped from the *very last*
user its *first* toucher may already be dead. So we'll never
find out who it was.

> We can also get from the vma to the mm very easily, via vma->vm_mm,
> right?
> 
> We can also get from a task to the container quite easily.  
> 
> So, the only question becomes whether there is a 1:1 relationship
> between mm_structs and containers.  Does each mm_struct belong to one

No. The question is "how to get a container that touched the
page first" which is the same as "how to find mm_struct which
touched the page first". Obviously there's no answer on this
question unless we hold some direct page->container reference.
This may be a hash, a direct on-page pointer, or mirrored
array of pointers.

> and only one container?  Basically, can a threaded process have
> different threads in different containers?
> 
> It seems that we could bridge the gap pretty easily by either assigning
> each mm_struct to a container directly, or putting some kind of
> task-to-mm lookup.  Perhaps just a list like
> mm->tasks_using_this_mm_list.

This could work for reclamation: we scan through all the
mm_struct-s within the container and shrink its' pages, but
we can't make LRU this way.

> Not rocket science, right?
> 
> -- Dave
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

