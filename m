Return-Path: <linux-kernel-owner+w=401wt.eu-S1756525AbYHTNIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525AbYHTNIy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 09:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754627AbYHTNIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 09:08:45 -0400
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:15446 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754134AbYHTNIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 09:08:45 -0400
Message-ID: <48AC170A.2070702@panasas.com>
Date: Wed, 20 Aug 2008 16:07:22 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: adobriyan@gmail.com
CC: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] debug: fix BUILD_BUG_ON() for non-constant expressions
References: <20080816100948.GB19926@martell.zuzino.mipt.ru> <alpine.LFD.1.10.0808170936260.3324@nehalem.linux-foundation.org> <20080817173319.GA2450@elte.hu> <200808181109.43203.rusty@rustcorp.com.au> <20080818075459.GH30694@elte.hu> <48A9472F.908@panasas.com> <20080819133422.GA24369@elte.hu> <48AAF5F7.6040709@panasas.com> <20080820105922.GC18524@elte.hu> <48AC0EB9.3080708@panasas.com> <20080820123929.GA29972@x200.localdomain>
In-Reply-To: <20080820123929.GA29972@x200.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Aug 2008 13:06:40.0097 (UTC) FILETIME=[95BFFD10:01C902C5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

adobriyan@gmail.com wrote:
> On Wed, Aug 20, 2008 at 03:31:53PM +0300, Boaz Harrosh wrote:
>> Ingo Molnar wrote:
>>> * Boaz Harrosh <bharrosh@panasas.com> wrote:
>>>
>>>> If the user of virtio_has_feature() must pass a compile-time constant 
>>>> then it must be converted to a MACRO, and then the BUILD_BUG_ON will 
>>>> work. Or it should be changed to a BUG_ON() if fbit is a runtime 
>>>> variable.
>> The use of __builtin_constant_p in inline functions is broken. This
>> is because it will give different results depending on the -O level
>> used. So I think that using it in the Kernel with inlines is plain
>> broken. And should be discouraged.
> 
> See how kmalloc() works.
> 
Right:

static inline void *kmalloc(size_t size, gfp_t flags)
{
	if (__builtin_constant_p(size)) {
	 	... do some stuff
	else
		return __kmalloc_xxx(..)
}

So if optimization is on we might gain some cycles
but we must make sure we have the proper else clause.

In any way virtio_has_feature() is broken and no amount
of optimization may ever fix it. Please look at it:

static inline bool virtio_has_feature(const struct virtio_device *vdev,
				      unsigned int fbit)
{
	/* Did you forget to fix assumptions on max features? */
	if (__builtin_constant_p(fbit))
		BUILD_BUG_ON(sizeof(fbit) >= 32);


the __builtin_constant_p(fbit) will never help.
sizeof(fbit) is always sizeof(unsigned int) in any case. Only
a macro can help here. Sorry

Boaz

