Return-Path: <linux-kernel-owner+w=401wt.eu-S1754133AbZAaBtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133AbZAaBtU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 20:49:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbZAaBtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 20:49:05 -0500
Received: from moutng.kundenserver.de ([212.227.126.188]:58067 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbZAaBtE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 20:49:04 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fs: Add new pre-allocation ioctls to vfs for compatibility with legacy xfs ioctls
Date: Sat, 31 Jan 2009 02:48:41 +0100
User-Agent: KMail/1.9.9
Cc: Ankit Jain <me@ankitjain.org>, viro@zeniv.linux.org.uk, hch@infradead.org,
       linux-fsdevel@vger.kernel.org, mfasheh@suse.com, joel.becker@oracle.com,
       ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
       xfs-masters@oss.sgi.com, xfs@oss.sgi.com
References: <4980C71F.1010804@ankitjain.org> <200901310138.34164.arnd@arndb.de> <20090130171423.f99c88d0.akpm@linux-foundation.org>
In-Reply-To: <20090130171423.f99c88d0.akpm@linux-foundation.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901310248.42820.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/LSDyyGb8Gt/8jQXyiM6+3HUGKwmPeWIVCB5L
 u2MGn2CvUHIIJJsKpzwyOMBK3peBlI6lyGTJ4vthJv7wxKXmX1
 sXJTxPQC5pAx1HfY3GQHA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 31 January 2009, Andrew Morton wrote:
> Is this written in a standard somewhere?  Is it guaranteed?

Alignment is defined in the architecture psABI documents. 
Unfortunately, many of them were written before the 'long long'
type became part of the C standard, so it's not strictly guaranteed.
AFAICT, the alignment of __u64 on x86 is the same as the alignment
of 'double' by convention.

However, the problem is well-understood: x86 is the only one
that has a problem in 32/64 bit compat mode. m68k has similar
issues with 16/32 bit integers, but those don't apply here.

> If some (perhaps non-gcc) compiler were to lay this out differently
> (perhaps with suitable command-line options) then that's liveable
> with - as long as the kernel never changes the layout.  Of course
> it would be better to avoid this if poss.

If a compiler was using irregular structure alignment, all sorts of
library interfaces would break. The kernel ABI is only a small part
of the problem then.

> The other potential issue with a structure like this is that there's a
> risk that it will lead us to copy four bytes of uninitialised kernel
> memory out to userspace.
> 
> IOW, it seems a generally bad idea to rely upon compiler-added padding
> for this sort of thing.

Agreed in general, but the whole point of this particular patch was to
provide compatibility with an interface that has been part of XFS for
many years.
Linux already has a better interface for new users (sys_fallocate), so
changing the patch would not be helpful and not provide any advantage.

There is also no leak of uninitialized data here, because this structure
is only read, never written.

	Arnd <><
