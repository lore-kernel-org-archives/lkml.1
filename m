Return-Path: <linux-kernel-owner+w=401wt.eu-S1755894AbXERUad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894AbXERUad (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 16:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbXERUa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 16:30:26 -0400
Received: from smtp2-g19.free.fr ([212.27.42.28]:59586 "EHLO smtp2-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100AbXERUaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 16:30:25 -0400
Message-ID: <464E0CDF.3030703@free.fr>
Date: Fri, 18 May 2007 22:30:23 +0200
From: matthieu castet <castet.matthieu@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.3) Gecko/20070217 Iceape/1.1.1 (Debian-1.1.1-2)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ubi: kill homegrown endian macros
References: <20070517143200.GA30850@lst.de>	 <1179413443.3642.49.camel@sauron> <20070517145653.GA968@lst.de>	 <1179414590.3642.69.camel@sauron>	 <20070517102931.6bbbad1a.akpm@linux-foundation.org>	 <pan.2007.05.17.20.30.30@free.fr> <1179455959.2859.527.camel@shinybook.infradead.org>
In-Reply-To: <1179455959.2859.527.camel@shinybook.infradead.org>
Content-Type: multipart/mixed;
 boundary="------------020207000607070509010609"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020207000607070509010609
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

David Woodhouse wrote:
> On Thu, 2007-05-17 at 20:30 +0000, Matthieu CASTET wrote:
>> On arch that don't support aligned access, packed struct access will be 
>> done byte per byte (but it could be the expected behavior if there 
>> unaligned access).
> 
> When I tested this on ARM, the output for je32_to_cpu et al was fine.
> For _other_ structures where I'd used __attribute__((packed)) to be
> safe, gcc would emit code to handle unaligned loads. But not in the
> simple case where the struct has only one member.
> 
> Are you suggesting that this has changed since I did my testing?
> 
here a small example I made and try with a sourcery 2006q3-27


/tmp/arm-2006q3/bin/arm-none-linux-gnueabi-gcc -S test.c -O3 -o 
test.s.packed
/tmp/arm-2006q3/bin/arm-none-linux-gnueabi-gcc -S test.c -DNOP -O3 -o test.s

$diff test.s test.s.packed                                     19,23c19,34
<       @ link register save eliminated.
<       ldrh    r2, [r1, #0]
<       ldrh    r1, [r0, #2]
<       ldr     r0, [r0, #4]
<       @ lr needed for prologue
---
 >       stmfd   sp!, {r4, r5, r6, lr}
 >       ldrb    r2, [r0, #5]    @ zero_extendqisi2
 >       ldrb    r3, [r0, #4]    @ zero_extendqisi2
 >       mov     lr, r1
 >       ldrb    r4, [r0, #6]    @ zero_extendqisi2
 >       ldrb    r5, [r0, #3]    @ zero_extendqisi2
 >       ldrb    r6, [r1, #1]    @ zero_extendqisi2
 >       orr     r3, r3, r2, asl #8
 >       ldrb    r1, [r0, #2]    @ zero_extendqisi2
 >       ldrb    ip, [r0, #7]    @ zero_extendqisi2
 >       ldrb    r2, [lr, #0]    @ zero_extendqisi2
 >       orr     r3, r3, r4, asl #16
 >       orr     r0, r3, ip, asl #24
 >       orr     r1, r1, r5, asl #8
 >       orr     r2, r2, r6, asl #8
 >       ldmfd   sp!, {r4, r5, r6, lr}


Matthieu

--------------020207000607070509010609
Content-Type: text/x-csrc;
 name="test.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="test.c"

#include <stdint.h>
#ifdef NOP
#define jint32_t uint32_t
#define jint16_t uint16_t

#define je16_to_cpu(x) ((x))
#define je32_to_cpu(x) ((x))
#else

typedef struct {
    uint32_t v32;
} __attribute__((packed)) jint32_t;

typedef struct {
    uint16_t v16;
} __attribute__((packed)) jint16_t;
#define je16_to_cpu(x) ((x).v16)
#define je32_to_cpu(x) ((x).v32)
#endif
struct jffs2_sum_unknown_flash
{
	    jint16_t nodetype;  /* node type */
};

struct jffs2_unknown_node
{
    /* All start like this */
    jint16_t magic;
    jint16_t nodetype;
    jint32_t totlen; /* So we can skip over nodes we don't grok */
    jint32_t hdr_crc;
};


int boo(struct jffs2_unknown_node *node, void *sp)
{
	
	foo(je32_to_cpu(node->totlen), je16_to_cpu(node->nodetype), je16_to_cpu(((struct jffs2_sum_unknown_flash *)sp)->nodetype));
}

--------------020207000607070509010609--
