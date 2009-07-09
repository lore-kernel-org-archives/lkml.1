Return-Path: <linux-kernel-owner+w=401wt.eu-S1751748AbZGIXd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751748AbZGIXd2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 19:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751028AbZGIXdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 19:33:21 -0400
Received: from mail-qy0-f193.google.com ([209.85.221.193]:33929 "EHLO
	mail-qy0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbZGIXdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 19:33:20 -0400
Message-ID: <4A567E3B.90609@codemonkey.ws>
Date: Thu, 09 Jul 2009 18:33:15 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       npiggin@suse.de, akpm@osdl.org, jeremy@goop.org,
       xen-devel@lists.xensource.com, tmem-devel@oss.oracle.com,
       alan@lxorguk.ukuu.org.uk, linux-mm@kvack.org, kurt.hackel@oracle.com,
       Rusty Russell <rusty@rustcorp.com.au>, dave.mccracken@oracle.com,
       Marcelo Tosatti <mtosatti@redhat.com>, sunil.mushran@oracle.com,
       Avi Kivity <avi@redhat.com>, Schwidefsky <schwidefsky@de.ibm.com>,
       chris.mason@oracle.com, Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 0/4] (Take 2): transcendent memory ("tmem") for Linux
References: <7cb22078-f200-45e3-a265-10cce2ae8224@default>
In-Reply-To: <7cb22078-f200-45e3-a265-10cce2ae8224@default>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Magenheimer wrote:
> But this means that either the content of that page must have been
> preserved somewhere or the discard fault handler has sufficient
> information to go back and get the content from the source (e.g.
> the filesystem).  Or am I misunderstanding?
>   

As Rik said, it's the later.

> With tmem, the equivalent of the "failure to access a discarded page"
> is inline and synchronous, so if the tmem access "fails", the
> normal code immediately executes.
>   

Yup.  This is the main difference AFAICT.  It's really just API 
semantics within Linux.

You could clearly use the volatile state of CMM2 to implement tmem as an 
API in Linux.  The get/put functions would set a flag such that if the 
discard handler was invoked as long as that operation happened, the 
operation could safely fail.  That's why I claimed tmem is a subset of CMM2.

> I suppose changing Linux to utilize the two tmem services
> as described above is a semantic change.  But to me it
> seems no more of a semantic change than requiring a new
> special page fault handler because a page of memory might
> disappear behind the OS's back.
>
> But IMHO this is a corollary of the fundamental difference.  CMM2's
> is more the "VMware" approach which is that OS's should never have
> to be modified to run in a virtual environment.  (Oh, but maybe
> modified just slightly to make the hypervisor a little less
> clueless about the OS's resource utilization.)

While I always enjoy a good holy war, I'd like to avoid one here because 
I want to stay on the topic at hand.

If there was one change to tmem that would make it more palatable, for 
me it would be changing the way pools are "allocated".  Instead of 
getting an opaque handle from the hypervisor, I would force the guest to 
allocate it's own memory and to tell the hypervisor that it's a tmem 
pool.  You could then introduce semantics about whether the guest was 
allowed to directly manipulate the memory as long as it was in the 
pool.  It would be required to access the memory via get/put functions 
that under Xen, would end up being a hypercall and a copy.  Presumably 
you would do some tricks with ballooning to allocate empty memory in Xen 
and then use those addresses as tmem pools.  On KVM, we could do 
something more clever.

The big advantage of keeping the tmem pool part of the normal set of 
guest memory is that you don't introduce new challenges with respect to 
memory accounting.  Whether or not tmem is directly accessible from the 
guest, it is another memory resource.  I'm certain that you'll want to 
do accounting of how much tmem is being consumed by each guest, and I 
strongly suspect that you'll want to do tmem accounting on a per-process 
basis.  I also suspect that doing tmem limiting for things like cgroups 
would be desirable.

That all points to making tmem normal memory so that all that 
infrastructure can be reused.  I'm not sure how well this maps to Xen 
guests, but it works out fine when the VMM is capable of presenting 
memory to the guest without actually allocating it (via overcommit).

Regards,

Anthony Liguori
