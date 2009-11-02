Return-Path: <linux-kernel-owner+w=401wt.eu-S1754302AbZKBKjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302AbZKBKjO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 05:39:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754214AbZKBKjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 05:39:14 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:35845 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163AbZKBKjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 05:39:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Haon97WCQ5P0J/jDJWWqHErF4EiQExAF3f4o/+oTHPCiDzmW9neJ9pM0vjH41AQjJ2
         0zXqy1HAKeJlRrO/2Ggh9tpdiZiCOofHR6f0ZMYM73MXqlEFdc6fHP0hl8aZV5MPn9vD
         cJuaa7V6P62p2Z4wCP+PsCGTeLgS0PYERtp3Q=
Message-ID: <4AEEB6D2.7090505@gmail.com>
Date: Mon, 02 Nov 2009 05:39:14 -0500
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: [net-next-2.6 PATCH RFC] TCPCT part 1d: generate Responder Cookie
References: <4AEAC763.4070200@gmail.com> <4AED86AD.6010906@gmail.com> <4AEDCD7C.2010403@gmail.com>
In-Reply-To: <4AEDCD7C.2010403@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> William Allen Simpson a écrit :
>> Since October 4th, I've repeatedly asked publicly for assistance with these
>> Linux-specific memory locking constructs and cryptography.  I've also sent
>> private messages.  No help has been forthcoming.  None.  Nada.
>>
>> At this point, I've spent weeks re-spinning code that I'd understood was
>> approved a year ago.  The whole project should have been finished by now!
> 
> Your messages on netdev are two weeks old, not one year, and came during
> LKS. Many developpers were busy in Japan.
> 
Thank you for your helpful comments.  I'm not familiar with LKS.  Is that a
month long project?

The message in question was "query: per cpu hash pool spinlock", sent:
   "Sun, 04 Oct 2009 06:37:39 -0400".

My initial query for this series was "query: adding a sysctl", sent:
   "Fri, 02 Oct 2009 00:00:05 -0400".

The earlier RFC approval was circa 1 year, 11 weeks, 2 days, 23 hours ago:

http://article.gmane.org/gmane.linux.network/102779


>> So, I'll try a larger audience.  Could somebody take a look at my usage of
>> read and write locking?
>>
>> NB, I'm trying to port some 15-year-old fairly simple and straightforward
>> (single cpu) code from the KA9Q cooperative multitasking platform.
>>
>> I've examined existing code used for syncookies and TCP MD5 authenticators.
>> Neither meets my needs, as this secret is updated every few minutes.  Both
>> have very different approaches.  They are rarely used.  My code will be
>> used on the order of tens of thousands of connections per second.
>>
>> Moreover, it seems to my naive eye that the syncookie per cpu code simply
>> doesn't work properly.  The workspace is allocated per cpu, but the cpu
>> could change during the extensive SHA1 computations.  Bug?
>>
The (buggy?) syncookie code that I'm avoiding/replacing is:

static DEFINE_PER_CPU(__u32 [16 + 5 + SHA_WORKSPACE_WORDS],
		      ipv4_cookie_scratch);

static u32 cookie_hash(__be32 saddr, __be32 daddr, __be16 sport, __be16 dport,
		       u32 count, int c)
{
	__u32 *tmp = __get_cpu_var(ipv4_cookie_scratch);

	memcpy(tmp + 4, syncookie_secret[c], sizeof(syncookie_secret[c]));
	tmp[0] = (__force u32)saddr;
	tmp[1] = (__force u32)daddr;
	tmp[2] = ((__force u32)sport << 16) + (__force u32)dport;
	tmp[3] = count;
	sha_transform(tmp + 16, (__u8 *)tmp, tmp + 16 + 5);

	return tmp[17];
}

It appears to me that the operations could be interrupted at any time, and
the fairly expensive sha transform (or probably any of the assignments)
could be corrupted?

That is, cpu0 grabs a scratch area, copies some data into it, interrupts,
cpu0 comes along again with another packet, points into the same workspace,
mashes the data, while cpu1 completes the previous operation with the
old tmp pointer on the stack.

Worse, this is called twice, each time getting tmp, and mashing the data,
and at the same time others are calling it twice more for verification.

Since syncookies only occur under stress, the code isn't well tested, and
the only symptom would be the returned packet would be dropped after
failing to verify.  Since this only happens when lots of packets are
arriving, dropped packets probably aren't noticed.

However, that would be unacceptable for my code.


> This patch looks fine, but I dont see how this new function is used.
> 
It is used at the places in the previous numbered patch (part 1c) that
currently say, "secret recipe not yet implemented".

And perhaps to replace the syncookie code mentioned above.


> Some points :
> 
> 1) We are working hard to remove rwlocks from network stack, so please dont
> add a new one. 

Botheration!  I wish that was *documented* somewhere, perhaps in:
   Documentation/spinlocks.txt

> add a new one. You probably can use a seqlock or RCU, or a server handling 
> 10.000 connections request per second on many NIC will hit this rwlock.
> 
Yep.  Nobody in the tcp code is using them, but RCU looks interesting, and
may be well suited.  I'll read up on it.


> 2) 
> 
> 	} else if (unlikely(time_after(jiffy, tcp_secret_primary->expires))) {
> 		get_random_bytes(secrets, sizeof(secrets));
> 
> 		write_lock(&tcp_secret_locker);
> 
> It would be better to first get the lock, then get random_bytes, in order
> not wasting entropy.
> 
I'd put that outside the locked section as it's considerably more expensive
(hashing) than a memcpy.  Entropy is never "wasted", as good cryptographic
random functions never reveal underlying entropy.  I know there were some
papers a few years ago that found flaws in Linux random functions, but
surely that's been fixed.  I assume you folks are using Yarrow or its
successors by now.

In any case, perhaps this RCU thingy obviates that issue.

> 
> 3) If you change secret ever 600 seconds, it might be better to use a timer
> so that you dont have to check expiration and this logic at each SYN packet.
> (Disociate the lookup (read-only, done many time per second) from the updates
> (trigerred by a timer every 600 secs))
> 
Part of the logic is not to update the generation secret until a new packet
arrives, allowing maximal entropy to be gathered beforehand.  This is
especially worrisome for the first packets after booting.  It takes into
account inter-packet arrival timing, and expiring after MSL.  So, a timer
isn't feasible in this instance.


> (Not counting you'll probably need to use a similar lookup algo for the ACK
> packet coming from client)
> 
Yes.  A timer could be used to expire and clear old verification secrets,
and I'll look into that in the future ACK patch.

Thanks again.
