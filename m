Return-Path: <linux-kernel-owner+w=401wt.eu-S1755120AbZGELAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120AbZGELAh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 07:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752817AbZGELA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 07:00:29 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:49833 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644AbZGELA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 07:00:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ZV3Yyc4nkbutCfN6kgzqG8miZ/IZhcOpoTKVYPMzVJzsruRw7PdJzs1X5C1DxTB8Jf
         VeCLXvPNxaXofuQ8FNASg35KEHmqYqK2ecPlLBGMe3s0X6VOpSZTWGDLnb8i5F8CIYcN
         6jW1oE0AaQ1QsTr+Fy3zBNWMlBGsp4jKAeQWY=
MIME-Version: 1.0
Date: Sun, 5 Jul 2009 12:00:31 +0100
Message-ID: <6278d2220907050400k1359df3av4045d3bba07d2be7@mail.gmail.com>
Subject: Re: >10% performance degradation since 2.6.18
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Matthew Wilcox <matthew@wil.cx>, Andi Kleen <andi@firstfloor.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Arjan van de Ven <arjan@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 3, 9:10 pm, Arjan van de Ven <ar...@infradead.org> wrote:
> On Fri, 3 Jul 2009 21:54:58 +0200
>
> Andi Kleen <a...@firstfloor.org> wrote:
> > > That would seem to be a fruitful avenue of
> > > investigation -- whether limiting the cards to a single RX/TX
> > > interrupt would be advantageous, or whether spreading the eight
> > > interrupts out over the CPUs would be advantageous.
>
> > The kernel should really do the per cpu binding of MSIs by default.
>
> ... so that you can't do power management on a per socket basis?
> hardly a good idea.
>
> just need to use a new enough irqbalance and it will spread out the
> interrupts unless your load is low enough to go into low power mode.

I was finding newer kernels (>~2.6.24) would set the Redirection Hint
bit in the MSI address vector, allowing the processors to deliver the
interrupt to the lowest interrupt priority (eg idle, no powersave)
core (http://www.intel.com/Assets/PDF/manual/253668.pdf pp10-66) and
older irqbalance daemons would periodically naively rewrite the
bitmask of cores, delivering the interrupt to a static one.

Thus, it may be worth checking if disabling any older irqbalance
daemon gives any win.

Perhaps there is value in writing different subsets of cores to the
MSI address vector core bitmask (with the redirection hint enabled)
for different I/O queues on heavy interrupt sources? By default, it's
all cores.

Daniel
-- 
Daniel J Blueman
