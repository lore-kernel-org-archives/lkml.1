Return-Path: <linux-kernel-owner+w=401wt.eu-S1759231AbYBMT47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759231AbYBMT47 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 14:56:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754786AbYBMT4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 14:56:52 -0500
Received: from wr-out-0506.google.com ([64.233.184.233]:39067 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763AbYBMT4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 14:56:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ggq/kv2VgMQluv9hSY9RUmldDml4dhmPSGHJGj1pADu+OLhUZXzPJXZEQKMMAulypNQqOOptQPDPbxA+BHCCckTbyxWYYEZwJ2CJD1PJIP19sI/PtQSJYF3wU196Wt0BNE/xelp67K+CARrrRJ+x3PEwrgNzslxCCnYM8Xyrtfk=
Subject: Re: [PATCH] fix sparse warning from include/linux/mmzone.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org, mingo@elte.hu
In-Reply-To: <alpine.LFD.1.00.0802081421590.2896@woody.linux-foundation.org>
References: <1202417543.31361.5.camel@brick>
	 <20080208135154.ccdac0c1.akpm@linux-foundation.org>
	 <alpine.LFD.1.00.0802081401410.2896@woody.linux-foundation.org>
	 <alpine.LFD.1.00.0802081421590.2896@woody.linux-foundation.org>
Content-Type: text/plain
Date: Wed, 13 Feb 2008 11:56:46 -0800
Message-Id: <1202932606.6238.16.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maybe I'm beating a dead horse, but here's what I came up with:

include/linux/mmzone.h:640:22: warning: potentially expensive pointer subtraction

Using arch/x86/mm/highmem_32.o as an example, line 82, PageHighMem
expands to is_highmem.

	if (!PageHighMem(page))
		return page_address(page);

I've run through the current code, one of Linus' suggestions and Linus'
alternate version of my original patch without the stupid unsigned
long casts, using char *.  The best version appears to be the char *
version.  Code size will increase by one byte for each use of
is_highmem, but there is one fewer instruction (saves a sar over the
base code).  The reason for the code size increase is the two cmps
use 32-bit compares rather than 16 bit compares in the original due
to the sar beforehand. (-3 bytes for no sar +4 bytes for longer cmp)

It's a small thing, if you agree that the new code is better, I'll
send a patch.

Original:
static inline int is_highmem(struct zone *zone)
{
#ifdef CONFIG_HIGHMEM
	int zone_idx = zone - zone->zone_pgdat->node_zones;
	return zone_idx == ZONE_HIGHMEM ||
		(zone_idx == ZONE_MOVABLE && zone_movable_is_highmem());
#else
	return 0;
#endif
}

 207:	2b 80 8c 07 00 00    	sub    0x78c(%eax),%eax
 20d:	c1 f8 0b             	sar    $0xb,%eax
 210:	83 f8 02             	cmp    $0x2,%eax
 213:	74 16                	je     22b <kmap_atomic_prot+0x144>
 215:	83 f8 03             	cmp    $0x3,%eax
 218:	0f 85 8f 00 00 00    	jne    2ad <kmap_atomic_prot+0x1c6>
 21e:	83 3d 00 00 00 00 02 	cmpl   $0x2,0x0
 225:	0f 85 82 00 00 00    	jne    2ad <kmap_atomic_prot+0x1c6>
 22b:	64 a1 00 00 00 00    	mov    %fs:0x0,%eax

Linus' suggestion:
static inline int is_highmem(struct zone *zone)
{
#ifdef CONFIG_HIGHMEM
	struct zone *base = zone->zone_pgdat->node_zones;
	return zone == base + ZONE_HIGHMEM ||
		(zone == base + ZONE_MOVABLE && zone_movable_is_highmem());
#else
	return 0;
#endif
}

 202:	8d 90 00 00 00 00    	lea    0x0(%eax),%edx
 208:	8b 8a 8c 07 00 00    	mov    0x78c(%edx),%ecx
 20e:	8d 81 00 10 00 00    	lea    0x1000(%ecx),%eax
 214:	39 c2                	cmp    %eax,%edx
 216:	74 1b                	je     233 <kmap_atomic_prot+0x14c>
 218:	8d 81 00 18 00 00    	lea    0x1800(%ecx),%eax
 21e:	39 c2                	cmp    %eax,%edx
 220:	0f 85 8f 00 00 00    	jne    2b5 <kmap_atomic_prot+0x1ce>
 226:	83 3d 00 00 00 00 02 	cmpl   $0x2,0x0
 22d:	0f 85 82 00 00 00    	jne    2b5 <kmap_atomic_prot+0x1ce>
 233:	64 a1 00 00 00 00    	mov    %fs:0x0,%eax
 
An alternate suggestion (excuse the long line):

static inline int is_highmem(struct zone *zone)
{
#ifdef CONFIG_HIGHMEM
	int zone_off = (char *)zone - (char *)zone->zone_pgdat->node_zones;
	return zone_off == ZONE_HIGHMEM * sizeof(*zone) ||
		(zone_off == ZONE_MOVABLE * sizeof(*zone) && zone_movable_is_highmem());
#else
	return 0;
#endif
}

 207:	2b 80 8c 07 00 00    	sub    0x78c(%eax),%eax
 20d:	3d 00 10 00 00       	cmp    $0x1000,%eax
 212:	74 18                	je     22c <kmap_atomic_prot+0x145>
 214:	3d 00 18 00 00       	cmp    $0x1800,%eax
 219:	0f 85 8f 00 00 00    	jne    2ae <kmap_atomic_prot+0x1c7>
 21f:	83 3d 00 00 00 00 02 	cmpl   $0x2,0x0
 226:	0f 85 82 00 00 00    	jne    2ae <kmap_atomic_prot+0x1c7>
 22c:	64 a1 00 00 00 00    	mov    %fs:0x0,%eax

Cheers,

Harvey

