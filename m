Return-Path: <linux-kernel-owner+w=401wt.eu-S1757252AbZJ1Dgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252AbZJ1Dgr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 23:36:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756671AbZJ1Dgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 23:36:46 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40361
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756643AbZJ1Dgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 23:36:46 -0400
Date: Tue, 27 Oct 2009 20:37:09 -0700 (PDT)
Message-Id: <20091027.203709.27104760.davem@davemloft.net>
To: andi@firstfloor.org
Cc: airlied@gmail.com, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net, arnd@arndb.de
Subject: Re: is avoiding compat ioctls possible?
From: David Miller <davem@davemloft.net>
In-Reply-To: <87hbtkjkki.fsf@basil.nowhere.org>
References: <21d7e9970910271822p3751b2fdnd78e1bc3326b9b0b@mail.gmail.com>
	<87hbtkjkki.fsf@basil.nowhere.org>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>
Date: Wed, 28 Oct 2009 03:53:17 +0100

> Dave Airlie <airlied@gmail.com> writes:
> 
>> Now I thought cool I don't need to worry about compat ioctl hackery I can
>> run 32 on 64 bit apps fine and it'll all just work.
>>
>> Now Dave Miller points out that I'm obivously deluded and we really need
>> to add compat ioctls so that the kernel can truncate correctly 32-bit address
>> in case userspace shoves garbage into the top 32bits of the u64.
> 
> When the user space sees a u64 field it should never shove garbage here.

The problem is that it can if it wants to.

On sparc64, in order to make debugging easier, we trap any time
the kernel does a userspace access to a compat task and any
of the upper 32-bits are non-zero.

That's more than a reasonable assumption to make because user
pointers are either:

1) Zero chopped when passed in via register arguments to a syscall.

2) Go through the compat_uptr() interface which chops the upper bits.

So whether userland should or should not do something, we still have
to guard against it.

> You just have to cast on 32bit for this, which is a bit ugly.

Right, via the compat_*() interfaces.

> However some architectures need special operations on compat pointers
> (s390 iirc), but if you don't support those it might be reasonable
> to not support that.

s390 has to sign extend all 32-bit compat process pointers when
processing them in the 64-bit s390 kernel.  I think one other
architecture has this kind of situation too.
