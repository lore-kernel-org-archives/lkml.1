Return-Path: <linux-kernel-owner+w=401wt.eu-S1030654AbXBGUHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030654AbXBGUHF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 15:07:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030656AbXBGUHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 15:07:05 -0500
Received: from raven.upol.cz ([158.194.120.4]:49653 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030654AbXBGUHC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 15:07:02 -0500
Date: Wed, 7 Feb 2007 21:14:08 +0100
To: Roman Zippel <zippel@linux-m68k.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Horst Schirmeier <horst@schirmeier.com>,
       Jan Beulich <jbeulich@novell.com>, Daniel Drake <dsd@gentoo.org>,
       Andi Kleen <ak@suse.de>, Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [patch 2/3, resend] kbuild: improve option checking, Kbuild.include cleanup
Message-ID: <20070207201408.GA22699@flower.upol.cz>
References: <20070206011819.160359000@flower.upol.cz> <20070206012207.925430000@flower.upol.cz> <Pine.LNX.4.64.0702071529390.14457@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702071529390.14457@scrub.home>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 07, 2007 at 03:36:47PM +0100, Roman Zippel wrote:
[]
> Also please don't add random whitespace, Makefiles are no C files, so 
> different rules apply.

Concerning whitespaces. Unfortunately only after installing i386
distro and checking that `-mcpu' error, i've realized what exactly
whitespace you mean, doc! 

    cc-option-yn = $(call cc-option, "y", "n", $(1))

vs.

    cc-option-yn = $(call cc-option,"y","n", $(1))

gives:

    + gcc ... -mtune=i386 -S -xc /dev/null -o /dev/shm/linux-2.6.20/.22730.null
(0) + echo ' y'

vs.

    + gcc ... -mtune=i386 -S -xc /dev/null -o /dev/shm/linux-2.6.20/.22231.null
(1) + echo y

and here sh1t hits the fun.

I always wondered where are all that whitespaces appearing in gcc
command line -- somebody adds them in makefiles, somebody don't, like
in this comments:

    # cc-option
    # Usage: cflags-y += $(call cc-option, -march=winchip-c6, -march=i586)
                                          ^                  ^
further this is used as this:

    #-mtune exists since gcc 3.4
    HAS_MTUNE       := $(call cc-option-yn, -mtune=i386)
(2) ifeq ($(HAS_MTUNE),y)
    tune            = $(call cc-option,-mtune=$(1),) [note: no whitespace]
    else
    tune            = $(call cc-option,-mcpu=$(1),)
    endif

    [...]

    cflags-$(CONFIG_MPENTIUMIII)    += -march=i686 $(call tune,pentium3)
    cflags-$(CONFIG_MPENTIUMM)      += -march=i686 $(call tune,pentium3)

(2) conflicts with (0), but OK with (1).

Summary: is it better to fix comments, as they are missling?

Thanks, Roman!
____
