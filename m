Return-Path: <linux-kernel-owner+w=401wt.eu-S1760530AbZCaVFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760530AbZCaVFg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 17:05:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753285AbZCaVFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 17:05:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49897 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246AbZCaVFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 17:05:21 -0400
Message-ID: <49D285AE.7030604@redhat.com>
Date: Wed, 01 Apr 2009 00:05:50 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: linux-kernel@vger.kernel.org, agraf@suse.de, pmullaney@novell.com,
       pmorreale@novell.com, anthony@codemonkey.ws, rusty@rustcorp.com.au,
       netdev@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 01/17] shm-signal: shared-memory signals
References: <20090331184057.28333.77287.stgit@dev.haskins.net> <20090331184252.28333.70623.stgit@dev.haskins.net> <49D280C0.8010802@redhat.com> <49D283F7.7030508@novell.com>
In-Reply-To: <49D283F7.7030508@novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
>>> +struct shm_signal_irq {
>>> +    __u8                  enabled;
>>> +    __u8                  pending;
>>> +    __u8                  dirty;
>>> +};
>>>   
>>>       
>> Some ABIs may choose to pad this, suggest explicit padding.
>>     
>
> Yeah, good idea.  What is the official way to do this these days?  Are
> GCC pragmas allowed?
>
>   

I just add a __u8 pad[5] in such cases.

>>> +
>>> +struct shm_signal;
>>> +
>>> +struct shm_signal_ops {
>>> +    int      (*inject)(struct shm_signal *s);
>>> +    void     (*fault)(struct shm_signal *s, const char *fmt, ...);
>>>   
>>>       
>> Eww.  Must we involve strings and printf formats?
>>     
>
> This is still somewhat of a immature part of the design.  Its supposed
> to be used so that by default, its a panic.  But on the host side, we
> can do something like inject a machine-check.  That way malicious/broken
> guests cannot (should not? ;) be able to take down the host.  Note today
> I do not map this to anything other than the default panic, so this
> needs some love.
>
> But given the asynchronous nature of the fault, I want to be sure we
> have decent accounting to avoid bug reports like "silent MCE kills the
> guest" ;)  At least this way, we can log the fault string somewhere to
> get a clue.
>   

I see.

This raises a point I've been thinking of - the symmetrical nature of 
the API vs the assymetrical nature of guest/host or user/kernel 
interfaces.  This is most pronounced in ->inject(); in the host->guest 
direction this is async (host can continue processing while the guest is 
handling the interrupt), whereas in the guest->host direction it is 
synchronous (the guest is blocked while the host is processing the call, 
unless the host explicitly hands off work to a different thread).


-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

