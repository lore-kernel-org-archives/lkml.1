Return-Path: <linux-kernel-owner+w=401wt.eu-S932771AbXCLRVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932771AbXCLRVg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 13:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933535AbXCLRVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 13:21:36 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:4499 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932771AbXCLRVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 13:21:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:reply-to:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=E7ZhQcQM4enO/0rs/1VDt+nTGlMjE/LN5dN7g0Rq9f5I1F5rJnj7xafPYaI4i+bgFilpqRk6IO+xci5sw8/HRAfZSX2guDYTm8xK8AdMu/lo8LWj0xLYATOxGJ3TNEFV3kW/WcnJxLbQj7KGSx9GfidOBhktlnpElgDClrlyCm4=
Message-ID: <661de9470703121021y9b16becm4859d2bd1e5691c0@mail.gmail.com>
Date: Mon, 12 Mar 2007 22:51:30 +0530
From: "Balbir Singh" <balbir@in.ibm.com>
Reply-To: balbir@in.ibm.com
To: "Dave Hansen" <hansendc@us.ibm.com>
Subject: Re: [RFC][PATCH 3/7] Data structures changes for RSS accounting
Cc: "Kirill Korotaev" <dev@sw.ru>, "Eric W. Biederman" <ebiederm@xmission.com>,
       containers@lists.osdl.org, "Paul Menage" <menage@google.com>,
       "Pavel Emelianov" <xemul@sw.ru>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <1173718084.11945.51.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45ED7DEC.7010403@sw.ru> <45ED8181.2060905@sw.ru>
	 <m18xe3wq3t.fsf@ebiederm.dsl.xmission.com> <45F57CFB.9010707@sw.ru>
	 <1173718084.11945.51.camel@localhost.localdomain>
X-Google-Sender-Auth: 002567c9fe1bc7d3
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/12/07, Dave Hansen <hansendc@us.ibm.com> wrote:
> On Mon, 2007-03-12 at 19:16 +0300, Kirill Korotaev wrote:
> > now VE2 maps the same page. You can't determine whether this page is mapped
> > to this container or another one w/o page->container pointer.
>
> Hi Kirill,
>
> I thought we can always get from the page to the VMA.  rmap provides
> this to us via page->mapping and the 'struct address_space' or anon_vma.
> Do we agree on that?
>
> We can also get from the vma to the mm very easily, via vma->vm_mm,
> right?
>
> We can also get from a task to the container quite easily.
>
> So, the only question becomes whether there is a 1:1 relationship
> between mm_structs and containers.  Does each mm_struct belong to one
> and only one container?  Basically, can a threaded process have
> different threads in different containers?
>
> It seems that we could bridge the gap pretty easily by either assigning
> each mm_struct to a container directly, or putting some kind of
> task-to-mm lookup.  Perhaps just a list like
> mm->tasks_using_this_mm_list.
>
> Not rocket science, right?
>
> -- Dave
>
These patches are very similar to what I posted at
                    http://lwn.net/Articles/223829/
In my patches, the thread group leader owns the mm_struct and all
threads belong to the same container. I did not have a per container
LRU, walking the global list for reclaim was a bit slow, but otherwise
my patches did not add anything to struct page

I used rmap information to get to the VMA and then the mm_struct.
Kirill, it is possible to determine all the containers that map the
page. Please see the page_in_container() function of
http://lkml.org/lkml/2007/2/26/7.

I was also thinking of using the page table(s) to identify all pages
belonging to a container, by obtaining all the mm_structs of tasks
belonging to a container. But this approach would not work well for
the page cache controller, when we add that to our memory controller.

Balbir
