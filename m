Return-Path: <linux-kernel-owner+w=401wt.eu-S1758171AbZD1Lrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758171AbZD1Lrk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 07:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751720AbZD1Lr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 07:47:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49338 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112AbZD1Lr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 07:47:28 -0400
Message-ID: <49F6ECFB.5010406@redhat.com>
Date: Tue, 28 Apr 2009 14:48:11 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, davidel@xmailserver.org
Subject: Re: [KVM PATCH v2 2/2] kvm: add support for irqfd via	eventfd-notification
 interface
References: <20090424042142.1796.60756.stgit@dev.haskins.net> <20090424042518.1796.65593.stgit@dev.haskins.net> <49F572EF.4010909@redhat.com> <49F58A8C.7090808@novell.com> <49F58D75.7040304@redhat.com> <49F5B2DA.5060207@novell.com> <49F6CDFC.6000400@redhat.com> <49F6DB9D.3080501@novell.com> <49F6E1CA.1010106@redhat.com> <49F6E2BB.9070604@novell.com> <49F6E313.7020502@redhat.com> <49F6E3B2.5010306@redhat.com> <49F6EACA.3050808@novell.com>
In-Reply-To: <49F6EACA.3050808@novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
> Avi Kivity wrote:
>   
>> Avi Kivity wrote:
>>     
>>>> So what is your proposal for such interface?
>>>>
>>>>   
>>>>         
>>> ->write().
>>>
>>>       
>> Alternatively, a new fileop ->signal_event(), which would map to
>> eventfd_signal() or irqfd_signal().  This would be defined to work in
>> irq contexts.  It may also be useful for uio interrupts.
>>
>>     
> Hmm...I'm not crazy about either of those.  write() has obvious
> limitations both from a interrupt execution context, as well as the
> awkwardness of dealing with creating+passing a viable "userspace"
> pointer from kernel code.  On the other hand, a new fileop doesn't quite
> seem appropriate either since it doesn't apply to the overall fileop
> abstraction very well.
>
> We could potentially have a separate vtable interface just for
> event-type fds, and make eventfd and irqfd the first implementations. 
> But I am not sure it is worth it.  What I suggest is that we work within
> the existing eventfd interface.  It was designed specifically to signal
> events, after all.
>
> If at some point in the future we need to ensure that the callbacks are
> not invoked from a preempt-off/irq-off critical section, we can revist
> the eventfd internals at that time.  Note that since we would like to
> support signaling from interrupt context anyway, trying to get rid of
> the wqh critical section that we have today may be a fools errand (*). 
> Instead, we should probably focus on making the injection path support
> non-preemptible contexts, as this will have the biggest benefits and
> gains in the long run.
>
>   
But again, you're forcing everyone who uses irqfd to require eventfd.

Maybe we should change eventfd_signal() to fall back to ->write if the 
file happens not to be an eventfd.  It could also handle the 
nonpreemptible context as well.


-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

