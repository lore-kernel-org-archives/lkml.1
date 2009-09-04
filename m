Return-Path: <linux-kernel-owner+w=401wt.eu-S1757230AbZIDTCH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230AbZIDTCH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 15:02:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757198AbZIDTCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 15:02:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35345 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757187AbZIDTCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 15:02:05 -0400
Message-ID: <4AA16336.3050606@zytor.com>
Date: Fri, 04 Sep 2009 11:57:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Jeff Dike <jdike@addtoit.com>,
       Sam Ravnborg <sam@ravnborg.org>
CC: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@redhat.com, sam@ravnborg.org, tglx@linutronix.de,
       David.Woodhouse@intel.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/kbuild] x86: Don't silently override CONFIG_64BIT in
 'make oldconfig'
References: <tip-5a8a2d13b1526e306ff2a9fe12dc9d5878d355f9@git.kernel.org> <20090904144857.GA12872@elte.hu> <alpine.LFD.2.00.0909041631210.14872@twosheds.infradead.org> <4AA13FE6.20807@zytor.com> <20090904183103.GA1873@elte.hu>
In-Reply-To: <20090904183103.GA1873@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2009 11:31 AM, Ingo Molnar wrote:
> 
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
>> On 09/04/2009 08:33 AM, David Woodhouse wrote:
>>> On Fri, 4 Sep 2009, Ingo Molnar wrote:
>>>
>>>
>>>>> x86: Don't silently override CONFIG_64BIT in 'make oldconfig'
>>>>
>>>> -tip testing found that this commit broke the UML build:
>>>>
>>>> /home/mingo/tip/arch/um/Makefile:52:
>>>> /home/mingo/tip/arch/um/Makefile-x86: No such file or directory
>>>> make[1]: *** No rule to make target
>>>> `/home/mingo/tip/arch/um/Makefile-x86'.  Stop.
>>>> make: *** [sub-make] Error 2
>>>
>>> Hm, doesn't that mean that UML has always been broken for ARCH=x86?
>>
>> Quite possible.  ARCH=x86 hasn't exactly been widely used.
> 
> Note, i used 'make ARCH=um' so this commit cannot be pushed upwards 
> until this problem is fixed. It could very well be some missing 
> changes on the UML side.
> 

Okay, the problem is the following: UM treats i386 and x86-64 as
separate architectures, and it gets very unhappy with SUBARCH=x86.  A
trivial attempt to fix it:

diff --git a/arch/um/Makefile b/arch/um/Makefile
index 0728def..b1cc9cf 100644
--- a/arch/um/Makefile
+++ b/arch/um/Makefile
@@ -12,6 +12,17 @@ OS := $(shell uname -s)
 # features.
 SHELL := /bin/bash

+#
+# i386 and x86_64 are separate architectures to the UM build.
+#
+ifeq ($(SUBARCH),x86)
+ifeq ($(CONFIG_64BIT),y)
+SUBARCH := x86_64
+else
+SUBARCH := i386
+endif
+endif
+
 filechk_gen_header = $<

 core-y                 += $(ARCH_DIR)/kernel/          \

... didn't fix it, as "make defconfig" promptly made a 32-bit
configuration on my 64-bit system, and the build failed.

The "obvious" change of allowing SUBARCH to take values like i386 and
x86_64 is also wrong (and possibly have a DEFAULT_ARCH which can be
different than SUBARCH), because we have several instances of:

ifneq ($(SUBARCH),$(ARCH))

... in the build tree, and even have ugliness like:

[scripts/tags.h]
# Support um (which uses SUBARCH)
if [ "${ARCH}" = "um" ]; then
        if [ "$SUBARCH" = "i386" ]; then
                archinclude=x86
        elif [ "$SUBARCH" = "x86_64" ]; then
                archinclude=x86
        else
                archinclude=${SUBARCH}
        fi
fi

Anyway... it sounds like we need to drop this commit for now and
re-merge it when there is a fix for UM.

Jeff, Sam, I would appreciate your suggestions as how best to fix this
kind of stuff...

	-hpa
