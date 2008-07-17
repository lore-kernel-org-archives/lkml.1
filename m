Return-Path: <linux-kernel-owner+w=401wt.eu-S1758183AbYGQOPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758183AbYGQOPe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 10:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755744AbYGQOPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 10:15:25 -0400
Received: from il.qumranet.com ([212.179.150.194]:50037 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755043AbYGQOPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 10:15:24 -0400
Message-ID: <487F53FB.20708@qumranet.com>
Date: Thu, 17 Jul 2008 17:15:23 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Roland Dreier <rdreier@cisco.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm@vger.kernel.org>,
       "Anthony N. Liguori [imap]" <aliguori@us.ibm.com>
Subject: Re: KVM overflows the stack
References: <1206479576.7562.21.camel@nimitz.home.sr71.net>	 <47EA1C63.8010202@qumranet.com>	 <1206550329.7883.5.camel@nimitz.home.sr71.net>	 <47EA80AC.4070204@qumranet.com>	 <1206551794.7883.7.camel@nimitz.home.sr71.net>	 <47EB6AAC.3040607@qumranet.com> <47EB7281.6070300@qumranet.com>	 <1206629709.7883.30.camel@nimitz.home.sr71.net>	 <47EBB63E.2060306@qumranet.com>	 <1212445810.8211.9.camel@nimitz.home.sr71.net>	 <48469BDA.3050206@qumranet.com> <1212738105.7837.3.camel@nimitz>	 <48512028.3070104@qumranet.com> <1216148242.25942.6.camel@nimitz>	 <1216244660.8711.6.camel@nimitz> <1216248527.11664.9.camel@nimitz>	 <487EDE26.8040201@qumranet.com>  <ada4p6p9h6m.fsf@cisco.com> <1216303561.11664.52.camel@nimitz>
In-Reply-To: <1216303561.11664.52.camel@nimitz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> On Wed, 2008-07-16 at 23:08 -0700, Roland Dreier wrote:
>   
>>  > Yes, things like kvm_lapic_state are way too big to be on the
>> stack.
>>
>> I had a quick look at the code, and my worry about dynamic allocation
>> would be that handling allocation failure seems like it might get
>> tricky.  Eg for handling struct kvm_pv_mmu_op_buffer (which is 528 bytes
>> on the stack in kvm_pv_mmu_op()) can you deal with an mmu op failing?
>>     
>
> Well, you *better* be able to deal with it.  :)
>
> This code is also doing a *ton* of copy_to/from_user().  If userspace
> had one of its input buffers swapped out (or one of its output buffers
> not faulted in yet) and we're out of memory enough to be failing
> kmallocs() then we're sure as heck also going to failing the user
> copies.
>
> I think it's a non-issue.
>
>   

Yes, it's designed to be restartable.  Returning 0 should be fine.

We can reduce the buffer size to 256 though.  I wouldn't want an 
allocation in this hot path.

-- 
error compiling committee.c: too many arguments to function

