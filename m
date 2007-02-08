Return-Path: <linux-kernel-owner+w=401wt.eu-S1422744AbXBHMjH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422744AbXBHMjH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 07:39:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422969AbXBHMjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 07:39:07 -0500
Received: from raven.upol.cz ([158.194.120.4]:34789 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422744AbXBHMjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 07:39:06 -0500
Date: Thu, 8 Feb 2007 13:47:56 +0100
To: Paul Mackerras <paulus@samba.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: Kbuild change breaks the ppc64 build
Message-ID: <20070208124756.GU22699@flower.upol.cz>
References: <17867.1342.763881.188430@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17867.1342.763881.188430@cargo.ozlabs.ibm.com>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 08, 2007 at 10:10:54PM +1100, Paul Mackerras wrote:
> Commit 5de043f4bd11a9e0a3e8daec7d1905da575a76b7 breaks the build on
> 64-bit powerpc because we no longer get the -m64 flag passed to gcc.
> There is code in arch/powerpc/Makefile which adds (or used to add)
> -m64 to AS, LD and CC if we are running on a 64-bit machine (which I
> am) and have a biarch toolchain (which I do).  Without -m64, the
> toolchain assumes 32-bit and all sorts of things break spectacularly.
> 
> I haven't yet tracked down exactly why this commit has this effect,
> since I find it takes considerable time and effort to understand
> Kbuild.

As i have refactored some CC checking code in Kbuild.include, it
turned, that some versions of `make' after calling nested functions,
add (or leave) prefix whitespace to result, thus ifeq[0] fails:

 .-*- (ppc Makefile)
 |HAS_BIARCH      := $(call cc-option-yn, -m32)
0|ifeq ($(HAS_BIARCH),y)
 |AS              := $(AS) -a32
 |LD              := $(LD) -m elf32ppc
 |CC              := $(CC) -m32
 |endif

David wrote and showed a testcase.
Adding $(strip ) wrapper helped with this, but may screw many other
things. Maybe you will help, unless Linus will finally revert this :)

____
