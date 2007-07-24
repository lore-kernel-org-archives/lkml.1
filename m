Return-Path: <linux-kernel-owner+w=401wt.eu-S1761172AbXGXHA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761172AbXGXHA1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 03:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754392AbXGXHAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 03:00:14 -0400
Received: from il.qumranet.com ([82.166.9.18]:57055 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753070AbXGXHAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 03:00:13 -0400
Message-ID: <46A5A36E.8000409@qumranet.com>
Date: Tue, 24 Jul 2007 09:59:58 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Shaohua Li <shaohua.li@intel.com>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [kvm-devel] [RFC 0/8]KVM: swap out guest pages
References: <1185173489.2645.64.camel@sli10-conroe.sh.intel.com>	 <46A4829C.9080104@qumranet.com>	 <1185232218.1803.36.camel@localhost.localdomain>	 <46A58E8B.8050507@qumranet.com>	 <1185257474.1803.216.camel@localhost.localdomain>	 <46A59A75.8050501@qumranet.com> <1185259509.1803.237.camel@localhost.localdomain>
In-Reply-To: <1185259509.1803.237.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Tue, 24 Jul 2007 09:59:58 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
>
>>> If not, it does get harder.  A callback in the mm struct to say "I want
>>> to swap your page out" is required if we don't take a reference to the
>>> page.  Dirty bit handling would be an interesting issue (maybe the
>>> callback can say "No!" and dirty the page again?).
>>>       
>> Since we have rmap, I don't see that as an issue.  Given a page, we can
>> easily drop all refs.  Though lguest doesn't do that, right?
>>     
>
> Yeah, rmap might maul some puppies.  I could do poor man's rmap tho with
> one backref and a bit to say "there are more".  Then if that bit is set,
> I just drop all 4 shadows 8)
>
>   

It's too poor.  A long running guest will eventually map all of memory
using the kernel page tables and a large proportion with user page
tables, so many pages will have that bit set.

However, you can probably work around that by not setting an rmap for
the kernel mappings, and instead have the guest teach the host where the
kernel page tables live.  You'd only be left with shared libraries,
until the kernel can share page tables for them too.

>> I'm also concerned with picking the correct page, but there's no good
>> solution here.
>>     
>
> But since you have rmap, if there was a cb when the the page was
> undirtied, you could undirty the ptes.  When there "I want to kick this
> page out" cb comes along, see if one of the ptes is now dirty, dirty the
> page and return "no".
>
> Maybe it's too simplistic, but it might work.
>   

Ah, I see what you mean now.  It could work, as far as I can tell (which
isn't very far, though).

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

