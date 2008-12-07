Return-Path: <linux-kernel-owner+w=401wt.eu-S1754032AbYLGD4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032AbYLGD4U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 22:56:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753366AbYLGD4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 22:56:08 -0500
Received: from ik-out-1112.google.com ([66.249.90.183]:28550 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbYLGD4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 22:56:06 -0500
Message-ID: <ac3eb2510812061956g6bb422d9r7c8032fb68552b4c@mail.gmail.com>
Date: Sun, 7 Dec 2008 04:56:04 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Evgeniy Polyakov" <zbr@ioremap.net>
Subject: Re: Runaway loop with the current git.
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
In-Reply-To: <20081206202620.GA9470@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081205193432.290a6f1a@lxorguk.ukuu.org.uk>
	 <ac3eb2510812051317q79ca88e9ya876ffb94162eeca@mail.gmail.com>
	 <20081205212428.GB8075@ioremap.net>
	 <ac3eb2510812051810x8cf4256lf9fd31b15b9e0552@mail.gmail.com>
	 <20081206160927.GA498@ioremap.net>
	 <ac3eb2510812060816h4401c78bj6d656d0d5721024@mail.gmail.com>
	 <20081206165634.GA2516@ioremap.net>
	 <ac3eb2510812061011u7a7f0fbdtc46b95a9c642f9c7@mail.gmail.com>
	 <1228591926.3808.6.camel@nga> <20081206202620.GA9470@ioremap.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 6, 2008 at 21:26, Evgeniy Polyakov <zbr@ioremap.net> wrote:
> On Sat, Dec 06, 2008 at 08:32:06PM +0100, Kay Sievers (kay.sievers@vrfy.org) wrote:
>> I don't know if it may have any bad side-effects. It moves the tty
>> registration earlier, before we do pci, framebuffer, video, acpi
>> registration.
>>
>> It boots fine here with and without initramfs.
>>
>> Maybe it makes the "dead" /dev/console in your initramfs working, then
>> we at least know the problem.
>
> I will try this patch this Monday and report back the results.

I was able to reproduce it with the .config you attached, and running it in kvm.

It is caused by:
  "modprobe cryptomgr" called from swapper[1]

This modprobe process does try to log an error, accesses /dev/console,
which is not initialized in the kernel at that time, and the kernel
module loader tries the load a module to support dev_t 5:1, which
again runs modprobe, and ...

Setting CONFIG_CRYPTO_MANAGER=y makes it disapper. The patch I sent
seems to fix it.

The bug is handled here: http://bugzilla.kernel.org/show_bug.cgi?id=12153

Thanks,
Kay
