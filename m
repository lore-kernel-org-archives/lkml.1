Return-Path: <linux-kernel-owner+w=401wt.eu-S1755015AbZF1LCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015AbZF1LCU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 07:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752188AbZF1LCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 07:02:10 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58785 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752145AbZF1LCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 07:02:08 -0400
Message-ID: <4A474E04.3070608@redhat.com>
Date: Sun, 28 Jun 2009 14:03:32 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mst@redhat.com,
       paulmck@linux.vnet.ibm.com, davidel@xmailserver.org,
       rusty@rustcorp.com.au
Subject: Re: [KVM PATCH v5 0/4] irqfd fixes and enhancements
References: <20090625132441.26748.641.stgit@dev.haskins.net> <4A4382AE.8000508@novell.com>
In-Reply-To: <4A4382AE.8000508@novell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2009 04:59 PM, Gregory Haskins wrote:
> Gregory Haskins wrote:
>    
>> (Applies to kvm.git/master:4631e094)
>>
>> The following is the latest attempt to fix the races in irqfd/eventfd, as
>> well as restore DEASSIGN support.  For more details, please read the patch
>> headers.
>>
>> This series has been tested against the kvm-eventfd unit test, and
>> appears to be functioning properly.  You can download this test here:
>>
>> ftp://ftp.novell.com/dev/ghaskins/kvm-eventfd.tar.bz2
>>
>> I've included version 4 of Davide's eventfd patch (ported to kvm.git) so
>> that its a complete reviewable series.  Note, however, that there may be
>> later versions of his patch to consider for merging, so we should
>> coordinate with him.
>>
>>      
>
> So I know we talked yesterday in the review session about whether it was
> actually worth all this complexity to deal with the POLLHUP or if we
> should just revert to the prior "two syscall" model and be done with
> it.  Rusty reflected these same sentiments this morning in response to
> Davide's patch in a different thread.
>
> I am a bit torn myself, tbh.  I do feel as though I have a good handle
> on the issue and that it is indeed now fixed (at least, if this series
> is applied and the slow-work issue is fixed, still pending upstream
> ACK).  I have a lot invested in going the POLLHUP direction having spent
> so much time thinking about the problem and working on the patches, so I
> a bit of a biased opinion, I know.
>
> The reason why I am pushing this series out now is at least partly so we
> can tie up these loose ends.  We have both solutions in front of us and
> can make a decision either way.  At least the solution is formally
> documented in the internet archives forever this way ;)
>
> I took the review comments to heart that the shutdown code was
> substantially larger and more complex than the actual fast-path code.  I
> went though last night and simplified and clarified it.  I think the
> latest result is leaner and clearer, so please give it another review
> (particularly for races) before dismissing it.
>    

Yes, it's much nicer.  I can't say I'm certain it's race free but it's a 
lot more digestible

> Ultimately, I think the concept of a release notification for eventfd is
> a good thing for all eventfd users, so I don't think this thing should
> go away per se even if irqfd decides to not use it.
>    

I agree that we want POLLHUP support, it's better than holding on to the 
eventfd.  But I think we can make it even cleaner by merging it with 
deassign.  Basically, when we get POLLHUP, we launch a slow_work (or 
something) that does a regular deassign.  That slow_work can grab a ref 
to the vm, so we don't race with the VM disappearing.

But given that the current slow_work does almost nothing, I'm not sure 
it's worth it.

-- 
error compiling committee.c: too many arguments to function

