Return-Path: <linux-kernel-owner+w=401wt.eu-S1756925AbYLOU5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925AbYLOU5n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 15:57:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754621AbYLOU5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 15:57:32 -0500
Received: from mx2.redhat.com ([66.187.237.31]:55450 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751604AbYLOU5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 15:57:30 -0500
Message-ID: <4946C4B4.1020605@redhat.com>
Date: Mon, 15 Dec 2008 21:57:24 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Ralf Baechle <ralf@linux-mips.org>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       linux-api@vger.kernel.org
Subject: Re: [PATCH v3 0/3] preadv & pwritev syscalls.
References: <1229340977-24345-1-git-send-email-kraxel@redhat.com> <20081215160311.GA23153@linux-mips.org>
In-Reply-To: <20081215160311.GA23153@linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ralf Baechle wrote:
> On Mon, Dec 15, 2008 at 12:36:14PM +0100, Gerd Hoffmann wrote:
> 
>> Next revision of the patch series, with the alignment issue fixed by
>> swapping the last two arguments as suggested by arch maintainers.
>>
>> I've dropped the now-obsolete wrappers for mips.  Ralf, please
>> double-check.
> 
> It fixes the alignment issue but still won't work; on MIPS 32-bit userspace
> will pass the 64-bit argument in two registers but the 64-bit kernel code
> will assume it to be passed in a single registers.  It'd be ugly but passing
> a pointer to a 64-bit argument would solve the issue; something like this:
>
> sys_preadv(unsigned long fd, const struct iovec __user *vec,
>                   unsigned long vlen, loff_t __user *pos);
> compat_sys_preadv(unsigned long fd, const struct compat_iovec __user *vec,
>                   unsigned long vlen, loff_t __user *pos);

Suggestion from the s390 front was to explicitly pass high and low part
of pos as two arguments.  A bit ugly too, but should work fine as well
and it avoids the user pointer dereference.  What do you think about this?

> sys_splice uses loff_t __user * arguments as well and that's why it's
> doesn't need any compat wrapper.

Well, avoiding the compat wrapper altogether unfortunately isn't going
to work because struct iovec looks different in 32 and 64 bit.

> I'm surprised this works for x86; does x86-64 code really expect 64-bit
> arguments as 2 32-bit arguments?

Args are passed on the stack, not in registers.

> Patch 1/3 looks like it's a bug fix and you may want to submit this
> separate from the remainder of the series for 2.6.28?

Yep, it is a separate bugfix.  Spotted by Christoph while reviewing v1,
but there are no other dependencies to this patch series.

cheers,
  Gerd

