Return-Path: <linux-kernel-owner+w=401wt.eu-S1754587AbZGOMwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587AbZGOMwp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 08:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753318AbZGOMwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 08:52:45 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:44055 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754397AbZGOMwo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 08:52:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=uEYYjxiqfBW5NPpeLb13AurSIW2rj7XN66dWqa/L8uzSQEHkobRS9vm66PkIXoXuSZ
         1gXqmPFMQhntrfa8KUFigAZgv8R1roZbXhBeoa6ujNCOqKwNOIVpyOxkRpRNR4/nxwA1
         uVsBNFx8uGehynI1fsyeqr4/7FMjfKZLkmLYE=
MIME-Version: 1.0
In-Reply-To: <3751.1247660742@redhat.com>
References: <1247591665-12000-1-git-send-email-vapier@gentoo.org> 
	<20090714161416.GA19147@cmpxchg.org> <6206.1247592126@redhat.com> 
	<4A5CFFD8.7020106@t-online.de> <12377.1247654255@redhat.com> 
	<8bd0f97a0907150412h234cf4d6l439d92d832055373@mail.gmail.com> 
	<2898.1247658300@redhat.com> <8bd0f97a0907150455l59a86540l655604579ab70b4f@mail.gmail.com> 
	<3751.1247660742@redhat.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 15 Jul 2009 08:52:23 -0400
Message-ID: <8bd0f97a0907150552rb69b953t85e73d14a995efb3@mail.gmail.com>
Subject: Re: [Uclinux-dist-devel] [PATCH v2] NOMMU: add support for Memory 
	Protection Units (MPU)
To: David Howells <dhowells@redhat.com>
Cc: Bernd Schmidt <bernds_cb1@t-online.de>,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 15, 2009 at 08:25, David Howells wrote:
> Mike Frysinger wrote:
>> yes, you can see page_rwx_mask in our mmu.h's mm_context_t.  this is
>> what the protect_page/update_protections operate on.  we have a global
>> current_rwx_mask that gets updated during context changes and the CPLB
>> miss handler uses that to keep things simple.
>
> Interesting.
>
> Since FRV does not really allow separate execute permissions (it has a very
> few separate static I and D protection/mapping registers and a shared TLB), I
> could do it with just pairs of bits.
>
> Also, how do you deal with mappable devices that lie outside of RAM?  I'm
> guessing from the code that you don't cover those with the bitmap, but rather
> just grant userspace RW access.

yes, there are really only three such regions on Blackfin systems:
 - on-chip rom
 - async memory banks
 - on-chip sram

since the first is read-only, letting random things execute/read there
isnt going to cause a problem.  any supervisor-only
accesses/instructions would be caught anyways if userspace attempted
it.

the second could (should?) be restricted like normal (granting access
via ioremap/mmap), but right now we just grant full access to
everyone.  the banks are largely used for drivers only
(usb/eth/flash/fpga/etc...), so having protection for that region
doesnt gain us too much.  perhaps down the line we'll look into it.

the on-chip srams are so small that 4k (or even 1k -- the smallest
page we can handle) would waste most resources.  so we either lock a
CPLB entry for full access (L1), or always grant it (L2).  and again,
experience has shown that it is largely used by drivers only, so
protection here wouldnt gain much as there is so rarely bad behavior
going on.
-mike
