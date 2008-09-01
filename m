Return-Path: <linux-kernel-owner+w=401wt.eu-S1753615AbYIAQll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615AbYIAQll (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 12:41:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755185AbYIAQlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 12:41:31 -0400
Received: from qb-out-0506.google.com ([72.14.204.230]:11909 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755108AbYIAQla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 12:41:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=EsDzOYBM2sxi4TqxRoV4AmrTpW56jGBH8ENGyVPotXvohz72p3m+nxs36kNRgfejKi
         v93CRFPG6IC8Vm7Z04fsiqwHrfKT7CM7u2c/M0cOr9i6+eAHyoEzjmDD8dXBRXz4mThI
         gs/e7YCv2kq2PDAV3B6AJ/+v2Ybb/nOZj12us=
Message-ID: <48BC1B31.1050306@panasas.com>
Date: Mon, 01 Sep 2008 19:41:21 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Ivo van Doorn <IvDoorn@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Rusty Russell <rusty@rustcorp.com.au>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] debug: BUILD_BUG_ON: error on non-const			 expressions
References: <48BBE77D.7070007@panasas.com> <48BBEE04.30903@panasas.com> <48BC1065.76E4.0078.0@novell.com> <48BBFA67.9070305@panasas.com> <48BC1A10.76E4.0078.0@novell.com> <48BC037F.5010305@panasas.com> <48BC267E.76E4.0078.0@novell.com>
In-Reply-To: <48BC267E.76E4.0078.0@novell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
>>>> Boaz Harrosh <bharrosh@panasas.com> 01.09.08 17:00 >>>
>> What is broken with my BUILD_BUG_ON_ZERO(). I tried all tests and
>> it works fine. Do you have a test with unwanted results?
>> (Actually it's the original one I have not touched it).
> 
> That's the problem - it uses the same sizeof(char[]) approach, and hence
> has the same problems that you just try to fix for BUILD_BUG_ON().
> 

No it does not have this problem. Have you tested it? 
I have! It works fine. (Complains on non-const expressions)

The problem with the original BUILD_BUG_ON was the 
(void)() cast and the interaction with the optimizer.

>>>>> Of course you could wrap the whole thing in ({}),
>>>> "do{}while(0)" is effectively an "{}" plus the added bonus
>>>> of demanding an ";" ;-)
>>> An expression likewise demands a terminating ; (or a continuation of the
>>> expression, i.e. by using an operator)
>>>
>> I was not criticizing your approach, I was commenting on:
>> "{}" vs. do{}while(0) 
> 
> I think we're having some mis-understanding here: What I'm concerned
> about is that you can't use statements where-ever expressions can be
> used (the opposite is true, because expressions are statements). My
> main concern is the limitation of its use inside macros, where one could
> try to use comma expressions to combine multiple BUILD_BUG_ON()-s.
> 

So it has not been used and it will not in the future.
In macros just use multiple statements separated by ";"
and surrounded by do{}while(0). To reach the same effect.

Note that BUG_ON is a statement and now BUILD_BUG_ON() is also.
for expressions use BUILD_BUG_ON_ZERO() 

> Jan
> 

OK I have tested with your version of BUILD_BUG_ON{,_ZERO} and I have
two problems with it.

[1] Problem number one is with this sequence of code:

(a)
static inline bool __virtio_has_feature(const struct virtio_device *vdev,
				      unsigned int fbit)
{
	virtio_check_driver_offered_feature(vdev, fbit);
	return test_bit(fbit, vdev->features);
}

/* Did you forget to fix assumptions on max features? */
#define virtio_has_feature(vdev, fbit) \
	((__builtin_constant_p(fbit) ? BUILD_BUG_ON_ZERO(fbit >= 32) : 0) + \
	__virtio_has_feature(vdev, fbit))

...
(b)
static inline int virtio_config_buf(struct virtio_device *vdev,
				    unsigned int fbit,
				    unsigned int offset,
				    void *buf, unsigned len)
{
	if (!virtio_has_feature(vdev, fbit))
		return -ENOENT;
...
(c)
	if (data && !virtio_has_feature(vdev, VIRTIO_NET_F_CSUM))
		return -ENOSYS;

I have not fount a way to code (a) in a way that actually works
for both (b) and (c). That is, good with const expressions and
bypassed with non-const. (See explanations below)

with your code:
> --- linux-2.6.27-rc5/include/linux/virtio_config.h	2008-08-21 14:37:35.000000000 +0200
> +++ 2.6.27-rc5-build-bug-on/include/linux/virtio_config.h	2008-08-28 15:08:47.000000000 +0200
> @@ -96,8 +96,7 @@ static inline bool virtio_has_feature(co
>  				      unsigned int fbit)
>  {
>  	/* Did you forget to fix assumptions on max features? */
> -	if (__builtin_constant_p(fbit))
> -		BUILD_BUG_ON(fbit >= 32);
> +	MAYBE_BUILD_BUG_ON(fbit >= 32);
>  
>  	virtio_check_driver_offered_feature(vdev, fbit);
>  	return test_bit(fbit, vdev->features);

The MAYBE_BUILD_BUG_ON just gets ignored in all cases and
coding (c) as:

	if (data && !virtio_has_feature(vdev, 717))
		return -ENOSYS;

Will not complain at all.

[2] Problem number two is with this sequence of code:

#define is_power_of_two(x)	( !((x) & ((x)-1)) )
#define low_bit_mask(x)		( ((x)-1) & ~(x) )
#define is_valid_mask(x)	is_power_of_two(1 + (x) + \
					low_bit_mask(x))

#define FIELD_CHECK(__mask, __type)			\
	BUILD_BUG_ON(!__builtin_constant_p(__mask) ||	\
		     !(__mask) ||			\
		     !is_valid_mask(__mask) ||		\
		     (__mask) != (__type)(__mask))	\

#define FIELD8(__mask)				\
({						\
	FIELD_CHECK(__mask, u8);		\
	(struct rt2x00_field8) {		\
		compile_ffs8(__mask), (__mask)	\
	};					\
})

I expect the compiler to complain since I'm abusing the
"sign-bit" and need unsigned calculations, but the 
(void)() cast musks the all operation off. Actually the 
all FIELD_CHECK is ignored, I have tried illegal values
and they are let through.



>From what I understand the (void)() cast gets thrown away
by the optimizer very fast before it is fully generated hence
the silence in lots of "bad" cases. The BUILD_BUG_ON_ZERO does
not have this problem because it cannot be optimized out.
On the other hand with your bit field approach the constant-expression
is requested by the compiler very early and cannot be
"optimized out" earlier like in the problem [1] case.

I agree that this is all very ugly in theory. But in practice
it is simple, works(*), and lets me do things like problem[1]
that still produce results.

(*) By works I mean:
 Has no false-positives and no false-negatives. On two accounts:
 constness is enforced, condition is fully checked.

Please show example code that fails my bold (maybe even blunt)
statements, where you would expect one result and the compiler
does something else.

Boaz
