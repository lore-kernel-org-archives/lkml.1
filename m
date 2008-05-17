Return-Path: <linux-kernel-owner+w=401wt.eu-S1757405AbYEQHrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405AbYEQHrh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 03:47:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752099AbYEQHrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 03:47:25 -0400
Received: from gw.goop.org ([64.81.55.164]:58635 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756786AbYEQHrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 03:47:19 -0400
Message-ID: <482E8D75.10606@goop.org>
Date: Sat, 17 May 2008 08:47:01 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: "H. Peter Anvin" <hpa@zytor.com>, Theodore Tso <tytso@mit.edu>,
       Herbert Xu <herbert@gondor.apana.org.au>, Jeff Garzik <jeff@garzik.org>,
       LKML <linux-kernel@vger.kernel.org>,
       virtualization@lists.linux-foundation.org,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Matt Mackall <mpm@selenic.com>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 2/2] lguest: virtio-rng support
References: <482C8595.5030509@garzik.org>	<200805171446.39814.rusty@rustcorp.com.au>	<482E6417.8040602@zytor.com> <200805171628.03801.rusty@rustcorp.com.au>
In-Reply-To: <200805171628.03801.rusty@rustcorp.com.au>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Saturday 17 May 2008 14:50:31 H. Peter Anvin wrote:
>   
>> Rusty Russell wrote:
>>     
>>> On Friday 16 May 2008 20:49:41 Johannes Berg wrote:
>>>       
>>>>> +
>>>>> +/* Our random number generator device reads from /dev/urandom into the
>>>>> Guest's + * input buffers.  The usual case is that the Guest doesn't
>>>>> want random numbers + * and so has no buffers although /dev/urandom is
>>>>> still readable, whereas + * console is the reverse.
>>>>>           
>>>> Is it really a good idea to use the hosts /dev/urandom to fill the
>>>> guests /dev/random?
>>>>         
>>> Technically it's up to rngd in the guest to decide whether to feed
>>> entropy or not (ie. /dev/urandom or /dev/random).
>>>       
>> Uhm, no.  It's not.  Unless the host provides actual entropy
>> information, you have a security hole.
>>     
>
> Huh?  We just can't assume it adds entropy.  AFAICT rngd -H0 is what we want 
> here.
>   

Hm, the Fedora manpage doesn't mention a -H option.

But the host->guest protocol should include the number of bits estimated 
entropy along with the bits themselves.

>>> If we use /dev/random in the host, we risk a DoS.  But since /dev/random
>>> is 0666 on my system, perhaps noone actually cares?
>>>       
>> There is no point in feeding the host /dev/urandom to the guest (except 
>> for seeding, which can be handled through other means); it will do its 
>> own mixing anyway.
>>     
>
> Seeding is good, but unlikely to be done properly for first boot of some 
> standard virtualized container.  In practice, feeding /dev/urandom from the 
> host will make /dev/urandom harder to predict in the guest.
>   

Yes, but only because the host /dev/urandom has some amount of real 
entropy in it, in which case you may as well use some bits from 
/dev/random.  The guests are perfectly capable of implementing all the 
/dev/urandom mixing algorithms for themselves; all they need is some 
real entropy to start working with.

>> The reason to provide anything at all from the host 
>> is to give it "golden" entropy bits.
>>     
>
> But you did not address the DoS question: can we ignore it?  Or are we trading 
> off a DoS in the host against a potential security weakness in the guest?
>
> If so, how do we resolve it?

Entropy is a (typically) scarce resource which is generated at X 
bits/second.  If you're worried about an entropy-eating DoS, then you 
deal with it like any other resource you're providing to guests: make 
the host side rate-limit the guest entropy consumption to Y bits/sec (Y 
<= X).  And if you can estimate how much remaining entropy exists in the 
host /dev/random, you can set a lower bound on what you provide to 
guests so that the host always has something to work with.

Of course, there's no real reason that we need to provide guest entropy 
from the host's /dev/random at all.  If we're collecting entropy from 
various entropy sources and feeding them all into a usermode daemon to 
do all the whitening, etc, then we can just provide it directly from 
that, leaving /dev/random available for purely host use. (There's 
probably be some entropy exchange between the daemon and host 
/dev/random, depending on what entropy sources are available to the host.)

    J
