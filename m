Return-Path: <linux-kernel-owner+w=401wt.eu-S1762744AbZLKXsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762744AbZLKXsS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:48:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761582AbZLKXsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:48:12 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:44009 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761533AbZLKXsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:48:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=RQDH2pKR1mlvuPRthSQxWmvbChpr/IRs1wskt56DEHg6j33I0FRmrfJL1vvkOpZfTf
         m5WPO3ofmrLF/Jl2cEdZRE9C5cA0EfSTItZ5Ty+onuqDFyMQnM6Wvzm6tLHqbgPDBI+y
         3kVxQhcWBk5ErHFVa5aabNfVCFslPy8iTzHco=
Subject: Re: XD/smartmedia - how to implement it right?
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Alex Dubov <oakad@yahoo.com>, linux-kernel <linux-kernel@vger.kernel.org>,
       arnd@arndb.de, tglx@linutonix.de
In-Reply-To: <20091201082236.GA27691@logfs.org>
References: <109361.10237.qm@web37604.mail.mud.yahoo.com>
	 <1259589517.13049.31.camel@maxim-laptop>
	 <1259622266.6559.40.camel@maxim-laptop>  <20091201082236.GA27691@logfs.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 12 Dec 2009 01:48:11 +0200
Message-ID: <1260575291.8536.15.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-01 at 09:22 +0100, Jörn Engel wrote: 
> On Tue, 1 December 2009 01:04:26 +0200, Maxim Levitsky wrote:
> > 
> > Alex, could you do me a favor, and explain why partial block writes
> > don't work?
> > What happens if its done?
> 
> With the Alauda and the limited set of cards I tried they work.
> 
> Jörn
> 
I have few severe problems in writing the driver, but otherwise its is
almost written. I also suspect that I will have to modify mtd core in
several places to achieve what I need to. I guess Alex was right after
all...

First of all, the device I deal with supports 32 bit dma only, as well
as many other pci devices. (I know that for sure because dma register is
32 bit wide....)

Now, mtd_blkdevs doesn't ask block subsystem for 32 bit bounce, and in
addition to that there is no guarantee that my mtd driver won't be
called on unrelated kernel buffer (for example if ftl layer does
caching....)
So I guess, ether I need to try to map the buffer, and then fail back to
copying into preallocated buffer in 32 bit zone, or always use that
buffer.
MMC core seem to handle the dma bouncing inside.


But that minor problem, other problem, I revealed when I began to think
about how properly to guard against races.
Problem is that mtd core doesn't handle hot-plug well.

Suppose, user has mounted filesystem on xd card and pulls it out.
SD/MMC cards handle that case. There might be fs corruption though, but
that is the user responsibility.

Now if anything has open the mtd_blkdevs, it increments the mtd user
count, thus removal of the mtd device will just fail.
Now I really don't know how to handle that property, but I know that
yanking out usb keys, mmc cards, etc works, and all devices that were
created disappear.

I will eventually figure out how to do that right, but it would be great
if you help me a bit.

Best regards,
Maxim Levitsly 




