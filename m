Return-Path: <linux-kernel-owner+w=401wt.eu-S1755414AbZBCRpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414AbZBCRpR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 12:45:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbZBCRpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 12:45:04 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:34274 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791AbZBCRpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 12:45:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=UOTwDES7bOsOvwL6bU4R0JTG4ByfHBn9hNS28WSICYROfeKoQouxCkx1b/dZLosE/d
         W1i2SNMSPxw1FxYanRDMu1d5fE9zXoxXpf7VFFREGNwsH3EkPFtb4xB2bi7Hd2Vce5KX
         Qc6+iry47Kn0ZpNghqOUFnNSVVskoZ0auL4/U=
Subject: Re: [kernel] Question about 2.6.28 kernel
From: Alex <eosyop@gmail.com>
To: Christian Kujau <lists@nerdbynature.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.0902031730140.4084@bogon.housecafe.de>
References: <1233594684.3018.12.camel@localhost.localdomain>
	 <alpine.DEB.2.00.0902022110290.4084@bogon.housecafe.de>
	 <1233670928.28905.12.camel@localhost.localdomain>
	 <alpine.DEB.2.00.0902031730140.4084@bogon.housecafe.de>
Content-Type: text/plain
Date: Tue, 03 Feb 2009 18:27:10 +0100
Message-Id: <1233682030.28905.59.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-03 at 17:36 +0100, Christian Kujau wrote:
> On Tue, 3 Feb 2009, Alex wrote:
> > Thanks for reply. Here is the post, it appears when i try to write into
> > kernel memory.  :
> 
> Thanks for the Oops. But again, you might have to share a little more 
> information, either here on lkml on with the security team. I'm no kernel 
> developer but I wonder *what exactly* are you doing to produce this Oops.
> 
> > Pid: 3887, comm: insmod Not tainted (2.6.28 #2) HP Pavilion dv2700
> 
> Which module did you just insert? Is it your own trying to write to kernel 
> memory? Can we see the source of that? However, since you're are root 
> anyway to load this module, you can of course do all kinds of shenanigans 
> to memory and the kernel might just Oops rightfully so.
> 
> Christian.

Sorry Christian, i should have been more explicit the second time, we
are basically building our own kernel module. After finding the system
call table's address, we try to write into kernel memory to redirect to
our own idt handler : here is the main code :

(*p = s_c_t's address)
------------------------------------------
while (!((*p == 0x0f) && (*(p+1) == 0x83)))
    p++;
p -= 5; // finding 'cmp' opcode 

*p++ = 0x68; // writing push
p2 = (unsigned long *) p;
*p2++ = (unsigned long) ((void *) our_idt); // main hook

p = (unsigned char *) p2;
*p = 0xc3; // writing ret
-------------------------------------------

This code is part of our kernel module, that we want to insert into the
kernel to execute it. It actually works on 2.6.23 kernel, but we
encountered problems while loading this module into the 2.6.28 kernel
(ie: exactly when we try to write 'push' in the code above, we get the
oops). 

So yes i think the kernel is reacting rightfully, but i'm trying to
understand why. I'd just want some hints on which security concepts,
that have been taken between 2.6.23 and 2.6.28 in order to prevent those
writings, and hints for bypassing it... I think of time of translation
between virtual & physic addresses kind-of-concepts, but i'm certainly
mistaken.

Basically, we're actually trying to hook system calls on 2.6.28, as a
proof-of-concept for an university project.

Thanks for any hints.

Alex


