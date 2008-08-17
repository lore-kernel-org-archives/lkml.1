Return-Path: <linux-kernel-owner+w=401wt.eu-S1753905AbYHQMJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbYHQMJS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 08:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752582AbYHQMJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 08:09:04 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:38220 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbYHQMJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 08:09:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=BTnoEvi4fOEZ6kq9kc7D+lJb6jSqu8kW9izXBafjhJ/cz1DHIF0Vx1ghewV7CuX4VM
         wHSboPxZQ0Ke/vQUZBdlAcUWOuEVPx1oARYhfZMCKjlpT6r1673NKKoPeLM7eYOgSac1
         5MWFB7MyqnNqaZNe6cWbZXbXJSpdyOcTlUrs0=
Message-ID: <45a44e480808170509r48060254w7d85e51e8f09ffd0@mail.gmail.com>
Date: Sun, 17 Aug 2008 08:09:01 -0400
From: "Jaya Kumar" <jayakumar.lkml@gmail.com>
To: "Markus Armbruster" <armbru@redhat.com>
Subject: Re: kernel BUG at lib/radix-tree.c:473!
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>, "Hugh Dickins" <hugh@veritas.com>,
       "Ian Campbell" <ijc@hellion.org.uk>, linux-kernel@vger.kernel.org,
       "Kel Modderman" <kel@otaku42.de>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <m33al7ciwr.fsf@crossbow.pond.sub.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1218697362.26014.9.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0808141347480.11013@blonde.site>
	 <48A48879.2000309@goop.org>
	 <Pine.LNX.4.64.0808142104080.29719@blonde.site>
	 <48A4AC01.7040402@goop.org> <m33al7ciwr.fsf@crossbow.pond.sub.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2008 at 6:48 PM, Markus Armbruster <armbru@redhat.com> wrote:
> Jeremy Fitzhardinge <jeremy@goop.org> writes:
>
>> Hugh Dickins wrote:
>>> As you can see, I'm still groping towards the right answer.
>>> The driver probably needs to provide its own backing_dev_info
>>> (or point to a suitable default), and its own address_space_ops,
>>> and perhaps more (there should be examples elsewhere).  But whether
>>> it is actually wrong, or whether I was wrong to mess it up, I've
>>> not yet decided.
>>>
>>
>> My understanding is that the driver is doing something a bit clever:
>> it uses the page dirty flags to determine which parts of the
>> framebuffer have been written to, and uses that information to
>> minimize the amount of stuff that needs to be copied out.  The writes
>
> Yes.
>
>> to the pages are not expected to generate actual page faults.
>>
>> But I haven't really looked at it closely, and I'm not at all familiar
>> with the vm at this layer.  I'm not sure how it actually allocates the
>> framebuffer memory for example (vmalloc?  incrementally on faults?).
>
> vmalloc()
>
>> I'm hoping Markus will leap in, since wrote this stuff.  Or, gasp,
>> I'll read the code myself.
>
> The actual cleverness is in fb_defio[*], which was written by Jaya
> Kumar (cc'ed).  I merely ripped out the old, somewhat racy cleverness
> I inherited from Anthony Liguori (which you can still admire in Xen's
> 2.6.18 kernel), and switched over to use fb_defio instead.  Because
> one instance of clever code is enough.
>
> My understanding of fb_defio's inner workings is rather limited I
> fear.  I'm just using it.
>
> Jaya, could you help?
>

I will try my best. Ok, I read through the thread. My current
understanding is as follows:

- Jeremy observed this issue when starting Xorg with Xen pvfb on 2.6.27-rc1
- Ian bisected it to 14fcc23fdc78e9d32372553ccf21758a9bd56fa1
- Peter pointed out from the trace we may be dirtying a page not in
the page cache
- Hugh mentioned prior to the bisected patch maybe the faulting page
had a .set_page_dirty that was ok but now it doesn't.
- Jeremy pointed out that the fault is at 1 page in to the /dev/fb0 mapping
- Hugh mentioned:
"  The driver probably needs to provide its own backing_dev_info
(or point to a suitable default), and its own address_space_ops,
and perhaps more (there should be examples elsewhere).  But whether
it is actually wrong, or whether I was wrong to mess it up, I've
not yet decided. "

In defio, the page mapping is provided through the vm_file that got
setup during mmap.
                page->mapping = vma->vm_file->f_mapping;

I haven't figured how setting inode->i_mapping->a_ops is affecting
this. I will pull tip and test with metronomefb and see if I can
reproduce the issue when starting Xfbdev on that and start debugging
from there.

Thanks,
jaya
