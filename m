Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936217Ab0BZN0i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 08:26:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40625 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935712Ab0BZN0g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 08:26:36 -0500
Subject: Re: [PATCH 2/5] KVM: SVM: Optimize nested svm msrpm merging
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <20100226132118.GF12689@amd.com>
Date: Fri, 26 Feb 2010 14:26:32 +0100
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <5E91C233-4FE1-43DB-A155-03F14FCEF919@suse.de>
References: <1267118149-15737-1-git-send-email-joerg.roedel@amd.com> <1267118149-15737-3-git-send-email-joerg.roedel@amd.com> <4B87A248.1050300@redhat.com> <20100226122502.GC12689@amd.com> <4E7D93ED-E5FC-4A64-B9B0-E2F644CD2B68@suse.de> <20100226130401.GD12689@amd.com> <4B87C835.4080409@redhat.com> <20100226132118.GF12689@amd.com>
To: Joerg Roedel <joerg.roedel@amd.com>
X-Mailer: Apple Mail (2.1077)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 26.02.2010, at 14:21, Joerg Roedel wrote:

> On Fri, Feb 26, 2010 at 03:10:13PM +0200, Avi Kivity wrote:
>> On 02/26/2010 03:04 PM, Joerg Roedel wrote:
>>> 
>>>> I'm still not convinced on this way of doing things. If it's static,
>>>> make it static. If it's dynamic, make it dynamic. Dynamically
>>>> generating a static list just sounds plain wrong to me.
>>> Stop. I had a static list in the first version of the patch. This list
>>> was fine except the fact that a developer needs to remember to update
>>> this list if the list of non-intercepted msrs is expanded. The whole
>>> reason for a dynamically built list is to take the task of maintaining
>>> the list away from the developer and remove a possible source of hard to
>>> find bugs. This is what the current approach does.
>> 
>> The problem was the two lists.  If you had a
>> 
>> static struct svm_direct_access_msrs = {
>>    u32 index;
>>    bool longmode_only;
>> } direct_access_msrs = {
>>   ...
>> };
>> 
>> You could generate
>> 
>> static unsigned *msrpm_offsets_longmode, *msrpm_offsets_legacy;
>> 
>> as well as the original bitmaps at module init, no?
> 
> True for the msrs the guest always has access too. But for the lbr-msrs
> the intercept bits may change at runtime. So an addtional flag is
> required to indicate if the bits should be cleared initially.

So the msrpm bitmap changes dynamically for each vcpu? Great, make it fully dynamic then, changing the vcpu->arch.msrpm only from within its vcpu context. No need for atomic ops.

Alex