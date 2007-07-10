Return-Path: <linux-kernel-owner+w=401wt.eu-S1763899AbXGJVoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763899AbXGJVoW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 17:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760550AbXGJVoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 17:44:14 -0400
Received: from terminus.zytor.com ([192.83.249.54]:50430 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760110AbXGJVoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 17:44:13 -0400
Message-ID: <4693FCE7.2060308@zytor.com>
Date: Tue, 10 Jul 2007 14:40:55 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Segher Boessenkool <segher@kernel.crashing.org>
CC: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [x86 setup 13/33] Header file to produce 16-bit code with gcc
References: <11840359321823-git-send-email-hpa@zytor.com> <11840373002601-git-send-email-hpa@zytor.com> <108510B6-B9BE-49D4-BDCA-E25CA20CB29B@kernel.crashing.org> <200707101721.58937.ak@suse.de> <D6BECE27-25FA-4914-B293-4070392258D2@kernel.crashing.org> <4693EF48.1080209@zytor.com> <763AC431-73A6-4A5F-9453-A66A86D7DEEB@kernel.crashing.org>
In-Reply-To: <763AC431-73A6-4A5F-9453-A66A86D7DEEB@kernel.crashing.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Segher Boessenkool wrote:
> 
>> For now, I have:
>>
>> CFLAGS          := $(LINUXINCLUDE) -g -Os -D_SETUP -D__KERNEL__ \
>>                    $(cflags-$(ARCH)) \
>>                    -Wall -Wstrict-prototypes \
>>                    -march=i386 -mregparm=3 \
>>                    -include $(srctree)/$(src)/code16gcc.h \
>>                    -fno-strict-aliasing -fomit-frame-pointer \
>>                    $(call cc-option, -ffreestanding) \
>>                    $(call cc-option, -fno-unit-at-a-time) \
>>                    $(call cc-option, -fno-toplevel-reorder) \
>>                    $(call cc-option, -fno-stack-protector) \
>>                    $(call cc-option, -mpreferred-stack-boundary=2)
>>
>> ... since that will require less violence to eventually hack in the
>> proper -m16 option if/when it becomes available.
> 
> Looks good, except you don't want -fno-unit-at-a-time if
> -fno-toplevel-reorder works.  And of course it would be
> good to get rid of -fno-strict-aliasing, but let's not
> go there today ;-P
> 

OK, how does this look:

CFLAGS          := $(LINUXINCLUDE) -g -Os -D_SETUP -D__KERNEL__ \
                   $(cflags-$(ARCH)) \
                   -Wall -Wstrict-prototypes \
                   -march=i386 -mregparm=3 \
                   -include $(srctree)/$(src)/code16gcc.h \
                   -fno-strict-aliasing -fomit-frame-pointer \
                   $(call cc-option, -ffreestanding) \
                   $(call cc-option, -fno-toplevel-reorder,\
                        $(call cc-option, -fno-unit-at-a-time)) \
                   $(call cc-option, -fno-stack-protector) \
                   $(call cc-option, -mpreferred-stack-boundary=2)

I think dropping -fno-strict-aliasing for this code is probably bad...
it's pretty low-level stuff which does a lot of bitlevel manipulation.

	-hpa

