Return-Path: <linux-kernel-owner+w=401wt.eu-S1754116AbYLGEb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbYLGEb2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 23:31:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753583AbYLGEbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 23:31:19 -0500
Received: from netgear.net.ru ([195.178.208.66]:58318 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753544AbYLGEbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 23:31:19 -0500
Date: Sun, 7 Dec 2008 07:31:16 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: Runaway loop with the current git.
Message-ID: <20081207043116.GA12161@ioremap.net>
References: <ac3eb2510812051317q79ca88e9ya876ffb94162eeca@mail.gmail.com> <20081205212428.GB8075@ioremap.net> <ac3eb2510812051810x8cf4256lf9fd31b15b9e0552@mail.gmail.com> <20081206160927.GA498@ioremap.net> <ac3eb2510812060816h4401c78bj6d656d0d5721024@mail.gmail.com> <20081206165634.GA2516@ioremap.net> <ac3eb2510812061011u7a7f0fbdtc46b95a9c642f9c7@mail.gmail.com> <1228591926.3808.6.camel@nga> <20081206202620.GA9470@ioremap.net> <ac3eb2510812061956g6bb422d9r7c8032fb68552b4c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac3eb2510812061956g6bb422d9r7c8032fb68552b4c@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 07, 2008 at 04:56:04AM +0100, Kay Sievers (kay.sievers@vrfy.org) wrote:
> I was able to reproduce it with the .config you attached, and running it in kvm.
> 
> It is caused by:
>   "modprobe cryptomgr" called from swapper[1]
> 
> This modprobe process does try to log an error, accesses /dev/console,
> which is not initialized in the kernel at that time, and the kernel
> module loader tries the load a module to support dev_t 5:1, which
> again runs modprobe, and ...
> 
> Setting CONFIG_CRYPTO_MANAGER=y makes it disapper. The patch I sent
> seems to fix it.

Great to know it works. I will test it when get access to the machine
after the weekend.

> The bug is handled here: http://bugzilla.kernel.org/show_bug.cgi?id=12153

There is a good point in the thread, that hotplug should not call
recursion, but while this may be very valid requirement, it is _very_
subtle, and something more solid should be done. Just an opinion.

Initialization reordering is likely also not what we want, but simple
dumb console (or just dummy device which will accept data and will be
replaced later) sounds like a way to go, and your patch seems to allow
that dumb class registration first.
I actually used to believe that it works that way already...

-- 
	Evgeniy Polyakov
