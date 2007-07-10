Return-Path: <linux-kernel-owner+w=401wt.eu-S1763562AbXGJUqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763562AbXGJUqc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 16:46:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760223AbXGJUqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 16:46:12 -0400
Received: from terminus.zytor.com ([192.83.249.54]:50366 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759802AbXGJUqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 16:46:10 -0400
Message-ID: <4693EF48.1080209@zytor.com>
Date: Tue, 10 Jul 2007 13:42:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Segher Boessenkool <segher@kernel.crashing.org>
CC: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [x86 setup 13/33] Header file to produce 16-bit code with gcc
References: <11840359321823-git-send-email-hpa@zytor.com> <11840373002601-git-send-email-hpa@zytor.com> <108510B6-B9BE-49D4-BDCA-E25CA20CB29B@kernel.crashing.org> <200707101721.58937.ak@suse.de> <D6BECE27-25FA-4914-B293-4070392258D2@kernel.crashing.org>
In-Reply-To: <D6BECE27-25FA-4914-B293-4070392258D2@kernel.crashing.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Segher Boessenkool wrote:
> 
> Well at least with -fno-toplevel-reorder it is guaranteed
> to work (not the same thing as "is working", heh, but fairly
> close).
> 
> It seems to me GCC should grow an option to insert .code16gcc
> by itself (-m16 perhaps?)  Or GAS could get a flag to include
> a file as a prelude before the main thing.  Neither will help
> Linux right now of course.
> 

-m16 is the right thing, and it also provides a proper hook for
eventually having a real 16-bit backend (there are at least two projects
for doing that.)

For now, I have:

CFLAGS          := $(LINUXINCLUDE) -g -Os -D_SETUP -D__KERNEL__ \
                   $(cflags-$(ARCH)) \
                   -Wall -Wstrict-prototypes \
                   -march=i386 -mregparm=3 \
                   -include $(srctree)/$(src)/code16gcc.h \
                   -fno-strict-aliasing -fomit-frame-pointer \
                   $(call cc-option, -ffreestanding) \
                   $(call cc-option, -fno-unit-at-a-time) \
                   $(call cc-option, -fno-toplevel-reorder) \
                   $(call cc-option, -fno-stack-protector) \
                   $(call cc-option, -mpreferred-stack-boundary=2)

... since that will require less violence to eventually hack in the
proper -m16 option if/when it becomes available.

	-hpa
