Return-Path: <linux-kernel-owner+w=401wt.eu-S1762726AbZDJTLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762726AbZDJTLj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 15:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753869AbZDJTLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 15:11:30 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:54889 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbZDJTLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 15:11:30 -0400
Date: Fri, 10 Apr 2009 21:13:34 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: acpi/sleep.c saved_magic fix overflow
Message-ID: <20090410191334.GA25336@uranus.ravnborg.org>
References: <1239385015.3169.15.camel@ht.satnam> <20090410175545.GB16843@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090410175545.GB16843@elf.ucw.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 10, 2009 at 07:55:45PM +0200, Pavel Machek wrote:
> On Fri 2009-04-10 23:06:55, Jaswinder Singh Rajput wrote:
> > Impact: fix overflow
> 
> > Constant 0x123456789abcdef0 is so big for a long.
> > So using saved_magic 0x12345678 for both 32 and 64 bit.
> 
> Have you tested the patch? I have feeling that this is tested from
> assembly... Plus it is only set to long constant on 64-bit, so I don't
> think you are fixing anything. And if your code is correct the
> variable is write only...

$ git grep saved_magic
kernel/acpi/sleep.c:    saved_magic = 0x12345678;
kernel/acpi/sleep.c:    saved_magic = 0x123456789abcdef0;
kernel/acpi/sleep.h:extern long saved_magic;
kernel/acpi/wakeup_32.S:        movl    %cs:saved_magic, %eax
kernel/acpi/wakeup_32.S:ENTRY(saved_magic)      .long   0
kernel/acpi/wakeup_64.S:        movq    saved_magic, %rax
kernel/acpi/wakeup_64.S:ENTRY(saved_magic)      .quad   0


wakeup_32.S:
        movl    %cs:saved_magic, %eax
        cmpl    $0x12345678, %eax

wakeup_64.S:
        movq    saved_magic, %rax
        movq    $0x123456789abcdef0, %rdx

So patch is obviously bogus.

	Sam
