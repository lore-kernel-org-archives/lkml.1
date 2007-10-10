Return-Path: <linux-kernel-owner+w=401wt.eu-S1756507AbXJJSDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507AbXJJSDn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 14:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752543AbXJJSDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 14:03:36 -0400
Received: from gw.goop.org ([64.81.55.164]:50049 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752346AbXJJSDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 14:03:35 -0400
Message-ID: <470D13CA.3000202@goop.org>
Date: Wed, 10 Oct 2007 11:02:50 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Zachary Amsden <zach@vmware.com>,
       Anthony Liguori <anthony@codemonkey.ws>, Avi Kivity <avi@qumranet.com>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       "Nakajima, Jun" <jun.nakajima@intel.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>
Subject: Re: [PATCH RFC REPOST 1/2] paravirt: refactor struct paravirt_ops
 into smaller pv_*_ops
References: <470BC758.1030504@goop.org> <200710101635.10139.rusty@rustcorp.com.au>
In-Reply-To: <200710101635.10139.rusty@rustcorp.com.au>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Huh, thought I did a more complete reply to this.  Must have farted on it.

Rusty Russell wrote:
> Thanks Jeremy, I've actually taken time to finally review this in detail (I'm 
> assuming you'll refactor as necessary after the x86 arch merger).
>   

Yep.

>> +struct paravirt_ops paravirt_ops;
>> +
>>     
>
> Do you actually need to define this?  See below...
>
>   
>> +DEF_NATIVE(, ud2a, "ud2a");
>>     
>
> Hmm, that's ugly.  It was ugly before, but it's uglier now.  Maybe just 
> use "unsigned char ud2a[] = { 0x0f, 0x0b };" in paravirt_patch_default?
>   

Yeah, its not pretty.  I'll have another go.

>>  }
>>
>>  struct paravirt_ops paravirt_ops = {
>>     
> ...
>   
>> +	.pv_info = {
>> +		.name = "bare hardware",
>> +		.paravirt_enabled = 0,
>> +		.kernel_rpl = 0,
>> +		.shared_kernel_pmd = 1,	/* Only used when CONFIG_X86_PAE is set */
>> +	},
>>     
>
> This is the bit I don't get.  Why not just declare struct pv_info pvinfo, etc, 
> and use the declaration of struct paravirt_ops to get your unique 
> offset-based identifiers for patching?
>   

Given an op id number in .parainstructions, the patching code needs to
be able to index into something to get the corresponding function
pointer.  If each pv_* structure is its own little unrelated structure,
then the id has to be a <structure, id> tuple, which just complicates
things.  If I pack them all into a single structure then it becomes a
simple offset calculation.

That said, there's no need for pv_info to be in that structure, since it
contains no function pointers.  I'll move it out.

    J
