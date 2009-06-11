Return-Path: <linux-kernel-owner+w=401wt.eu-S1761357AbZFKX5G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761357AbZFKX5G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 19:57:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755095AbZFKX44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 19:56:56 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:38753 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754981AbZFKX4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 19:56:55 -0400
Message-ID: <4A3199C7.5030700@msgid.tls.msk.ru>
Date: Fri, 12 Jun 2009 03:56:55 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Linux-kernel <linux-kernel@vger.kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Alain Knaff <alain@knaff.lu>
Subject: Re: initramfs unpacking failed: junk in compressed archive
References: <4A2CFC51.1040604@msgid.tls.msk.ru>
In-Reply-To: <4A2CFC51.1040604@msgid.tls.msk.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replying to my own email, after quite some talks and
debugging between HPA, Alain Knaff and me.

The problem turned out to be in LILO, not in kernel.
LILO loads initrd below 15Mb by default.  But it looks
like starting with 2.6.30 64bits, in my configuration
anyway, the kernel become larger and were overwriting
the initrd area.  LILO has an option now, "large-memory",
to remedy this situation - which in turn cured the issue
for me.

Hopefully newcomers will not hit this trap since most
distributions nowadays switched from lilo to grub or
something else, or with new installs, lilo.conf gets
that 'large-memory' parameter by default.  Because it
wasn't the easiest thing to debug ;)

I used lilo for >10 years and treated it as always
working... Not anymore ;)

By the way, syslinux was a good surprize to me too,
it looks like I'll switch from lilo to extlinux
soon.

Thanks!

/mjt

Michael Tokarev wrote:
> [Cc'd HPA since he touched this code recently]
> 
> My second issue with 2.6.30-rc8, this time without any
> additional patches.
> 
> It fails to decompress gzip-compressed initramfs here, says this
> way before many other things and continues booting, failing down
> the line obviously, but the root cause is already gone off the
> screen (previously it paniced if it were unable to unpack initramfs).
> 
> the key error message is like in $subject.
> 
> I've added a printk right when it sets the above error in 
> unpack_to_rootfs(),
> right after the ckeck for "state != Reset".  The `state' value is 0 there,
> for "Start".
> 
> The kernel is x86-64, machine is AMD x2-64 with 4G RAM.
> The problem does not occur when running in a KVM virtual machine with only
> 512 megs of ram, the same kernel and the same initramfs (so this eliminates
> corrupt initramfs, which also passes `gzip -t' test).
> 
> The same config (mkinitrd/modules/etc) worked for me on every kernel since
> a stone age maybe (early 2.6 series).
> 
> I'll do some more experiments with it later today, hopefully - like
> trying 32bits kernel, reducing amount of memory etc.
> 
> Thanks.
> 
> /mjt
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

