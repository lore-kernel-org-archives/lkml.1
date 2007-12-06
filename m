Return-Path: <linux-kernel-owner+w=401wt.eu-S1754429AbXLFF7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429AbXLFF7n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 00:59:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752054AbXLFF7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 00:59:36 -0500
Received: from smtpoutm.mac.com ([17.148.16.73]:55060 "EHLO smtpoutm.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752012AbXLFF7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 00:59:35 -0500
In-Reply-To: <1196908955.10819.64.camel@localhost>
References: <1196359724.22120.22.camel@localhost> <20071129102400.dac158d8.randy.dunlap@oracle.com> <1196361860.22120.27.camel@localhost> <474F0A68.1080809@oracle.com> <1196369873.22120.69.camel@localhost> <474F28EB.20608@oracle.com> <Pine.LNX.4.64.0711292206450.3089@fbirervta.pbzchgretzou.qr> <1196378922.22120.72.camel@localhost> <20071205160133.0766c4f5.akpm@linux-foundation.org> <1196907017.10819.49.camel@localhost> <47575C07.1080001@oracle.com> <1196908955.10819.64.camel@localhost>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <831AEA99-3615-4015-9415-A4572D690095@mac.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, jengelh@computergmbh.de,
       linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [PATCH] Reduce stack used by lib/hexdump.c
Date: Thu, 6 Dec 2007 00:58:38 -0500
To: Joe Perches <joe@perches.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 05, 2007, at 21:42:35, Joe Perches wrote:
> On Wed, 2007-12-05 at 18:18 -0800, Randy Dunlap wrote:
>> Joe Perches wrote:
>>> Maybe just eliminate the 16 or 32 byte width option and force it  
>>> to only 16 byte widths.
>> Have you checked users (callers)?  I'm pretty sure that one of the  
>> callers wanted 32 and that's why it's there.
>
> I did.  There is only 1 subsystem.  That's easy to change.
>
> drivers/mtd/ubi/debug.c:  print_hex_dump(KERN_DEBUG, "",  
> DUMP_PREFIX_OFFSET, 32, 1,
> drivers/mtd/ubi/io.c:     print_hex_dump(KERN_DEBUG, "",  
> DUMP_PREFIX_OFFSET, 32, 1,
>
> Long lines in the log file are not too easy to read anyway.  Using  
> 16 byte dumps per line instead of 32 isn't painful.
>
> It gets rid of the allocation, reduces the argument count and makes  
> the kernel smaller.  I think it's all good.
>
> Every current caller would have to change though.

Alternatively, since print_hex_dump is not a performance-critical  
path (and usually indicates an error/debug condition), you could  
probably just make a static "hexdump_lock" spinlock and  
spin_lock_irqsave()/spin_unlock_irqrestore().  It would always nest  
inside any other lock (except during crash, where we break locks  
already for printk()), and I doubt any of the callers would notice  
the serialization since they're already serialized on the printk buffer.

Cheers,
Kyle Moffett

