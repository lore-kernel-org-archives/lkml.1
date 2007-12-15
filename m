Return-Path: <linux-kernel-owner+w=401wt.eu-S1763852AbXLOAaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763852AbXLOAaf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 19:30:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754072AbXLOAa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 19:30:28 -0500
Received: from ruby.spiritone.com ([216.99.193.130]:47077 "EHLO
	ruby.spiritone.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbXLOAa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 19:30:27 -0500
Message-ID: <47632010.6030709@BitWagon.com>
Date: Fri, 14 Dec 2007 16:30:08 -0800
From: John Reiser <jreiser@BitWagon.com>
Organization: -
User-Agent: Mozilla Thunderbird 1.0.8-1.1.fc4 (X11/20060501)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>
CC: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       security@kernel.org
Subject: Re: /dev/urandom uses uninit bytes, leaks user data
References: <4762DAB1.1020807@BitWagon.com> <20071214201305.GL19691@waste.org> <4762EB63.8070100@BitWagon.com> <20071214232322.GE17344@thunk.org>
In-Reply-To: <20071214232322.GE17344@thunk.org>
X-Enigmail-Version: 0.92.0.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> On Fri, Dec 14, 2007 at 12:45:23PM -0800, John Reiser wrote:
> 
>>>It's getting folded into the random number pool, where it will be
>>>impossible to recover it unless you already know what was in the
>>>pool.  And if you know what's in the pool, you've already broken into
>>>the kernel.
>>
>>The combination of capturing data from other users, plus seeding
>>the pool with your own data, just might be powerful enough to help
>>steal secrets, sometime in the next five years, from data that is
>>recorded today.
> 
> 
> Um, no.  Just seeding the pool with your own data won't help, since
> that still won't tell you the initial contents of the pool.  And if
> you know the initial contents of the pool, then you've broken root.
> And being able to steal from the pool also assumes that you've broken
> into the system; it is never, ever exported to userspace, even if
> you're root (unless you use something like /dev/kmem).  Furthermore,
> if you don't know the previous contents of the pool, you'll never be
> able to recover the information, either now or five years in the
> future, since information is XOR'ed into the pool.

There is a path that goes from user data into the pool.  This path
is subject to manipulation by an attacker, for both reading and
writing.  Are you going to guarantee that in five years nobody
will discover a way to take advantage of it?  Five years ago
there were no public attacks against MD5 except brute force;
now MD5 is on the "weak" list.

>>>But I'm sympathetic to making Valgrind happy.  ...
> 
> 
> How about wrapping it in a #ifdef CONFIG_UML, which is the only way
> you can use Valgrind?  The memset will slow down things unnecessarily,
> and mixing in the unknown previous contents of the stack (a) doesn't
> hurt, and (b) could make life more complicated for an attacker.

If speed matters that much, then please recoup 33 cycles on x86
by using shifts instead of three divides, such as (gcc 4.1.2):

                add_entropy_words(r, tmp, (bytes + 3) / 4);

0x8140689 <xfer_secondary_pool+206>:    lea    0x3(%esi),%eax
0x814068c <xfer_secondary_pool+209>:    mov    $0x4,%dl
0x814068e <xfer_secondary_pool+211>:    mov    %edx,%edi
0x8140690 <xfer_secondary_pool+213>:    cltd
0x8140691 <xfer_secondary_pool+214>:    idiv   %edi

-- 
John Reiser, jreiser@BitWagon.com
