Return-Path: <linux-kernel-owner+w=401wt.eu-S1755546AbXFKWjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546AbXFKWjh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 18:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752354AbXFKWj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 18:39:29 -0400
Received: from max.aladin.ro ([80.96.155.2]:33379 "EHLO aladin.ro"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752224AbXFKWj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 18:39:28 -0400
Message-ID: <466DCF1D.9050508@aladin.ro>
Date: Tue, 12 Jun 2007 01:39:25 +0300
From: Eduard-Gabriel Munteanu <maxdamage@aladin.ro>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Jeff Dike <jdike@addtoit.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] UML: fix missing non-blocking I/O, now DEBUG_SHIRQ
 works
References: <1181512917.3157.8.camel@localhost> <20070611173154.GA6889@c2.user-mode-linux.org> <466DA50C.5050301@aladin.ro> <20070611211604.GA8859@c2.user-mode-linux.org>
In-Reply-To: <20070611211604.GA8859@c2.user-mode-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

*This message was transferred with a trial version of CommuniGate(r) Pro*
Jeff Dike wrote:
> *This message was transferred with a trial version of CommuniGate(r) Pro*
> *This message was transferred with a trial version of CommuniGate(r) Pro*
> On Mon, Jun 11, 2007 at 10:39:56PM +0300, Eduard-Gabriel Munteanu wrote:
>> No offense, but this is an ugly hack. 
> 
> I'm not going to defend it too much, but the alternatives don't seem any
> better to me.
> 
>> What if sizeof(int) !=  sizeof(long)?
> 
> Doesn't matter - the casting will preserve the value.  Of greater
> concern is the relationship between sizeof(void *) and sizeof(long).
> That's not guaranteed by the standard, but is by gcc.
> 

The cast isn't done right. Doing "fd = (long) dev_id;" doesn't help, 
since you pass fd to mconsole_get_request() as is. And 
mconsole_get_request() expects an integer:
int mconsole_get_request(int fd, struct mc_request *req)

This will generate at least a warning on arches where sizeof(int) != 
sizeof(long). And as you say, then there is the problem with void 
pointers and longs.

And by the way, AFAIK, GCC has the habit of breaking compatibility with 
some userspace apps when a new GCC major version is released. And, 
AFAIK, they're moving towards standards, so relying on GCC's 
"guarantees" may backfire.

>> You're calling glibc functions
>> with that fd as a parameter. On some arches, compiling will issue
>> warnings or simply fail. 
> 
> Which ones?
>

An example is sparc64:
quote from http://lxr.linux.no/source/include/asm-sparc64/types.h#L49

38 #define BITS_PER_LONG 64
39
40 #ifndef __ASSEMBLY__
41
42 typedef __signed__ char s8;
43 typedef unsigned char u8;
44
45 typedef __signed__ short s16;
46 typedef unsigned short u16;
47
48 typedef __signed__ int s32;
49 typedef unsigned int u32;
50
51 typedef __signed__ long s64;
52 typedef unsigned long u64

>> An alternative would be to use kmalloc instead of a global static 
>> variable. Do you like this one more?
> 
> No, that trades the global variable for a new point of failure.
> 
> The main reason I like the current casting better than your global
> (not by a lot) is that globals have to be audited for SMP safety.  So,
> I don't want any globals which don't need to be.  This implies a
> local, and to minimize the machinery associated with that (kmalloc, or
> passing a pointer and synchronizing to avoid returning too soon), just
> passing the descriptor in the pointer and accepting the casting needed
> to get it through the compiler.
> 
> 				Jeff
> 

Really, a kmalloc() isn't such a big deal, it only happens once and 
we're not in interrupt context. One the other hand, ensuring safety and 
portability on other arches is something that needs to be taken care of.

Of course, you could also cast to int when calling 
mconsole_get_request(), but IMO that doesn't look nicer.
