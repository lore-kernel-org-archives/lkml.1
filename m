Return-Path: <linux-kernel-owner+w=401wt.eu-S932357AbZACCi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357AbZACCi6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 21:38:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758643AbZACCit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 21:38:49 -0500
Received: from mout-bounce.kundenserver.de ([212.227.17.1]:51620 "EHLO
	mout-bounce.kundenserver.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755528AbZACCis convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 21:38:48 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH] headers_install.pl: autoconvert asm/inline/volatile to __xxx__
Date: Sat, 3 Jan 2009 03:38:34 +0100
User-Agent: KMail/1.9.9
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
References: <1230364498-31620-1-git-send-email-vapier@gentoo.org> <200901030020.35237.arnd@arndb.de> <200901022024.07293.vapier@gentoo.org>
In-Reply-To: <200901022024.07293.vapier@gentoo.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901030338.34968.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18lNr7b+2kN+/xl3d9TQqic8nNJSMjDbdXlmvt
 ZEMPJMf1FAfZOdBgiRt33hJGaftL2u4Dbdf5fxFzlRc+idsxSp
 y90bBePrPSSUfUFa6p76Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 January 2009, Mike Frysinger wrote:
> how would you propose maintaining said list ?  attempting to maintain external 
> to the file in question will just lead to rot (since we dont want to whitelist 
> entire files, and we cant track line numbers, and we cant detect where the 
> keyword is being used in terms of macro/function) ... that leaves two choices 
> that i can think of:
>  - a new __asm_userok__ type marker
>  - adding a simple /* userok */ comment we can filter in the perl regex
> 
> neither of which sounds entire pleasant either ...

It all depends on how many exceptions there are. The number of instances
of asm and volatile keywords is really small (one file each, on x86), so
we can easily decide whether or not they should all be allowed or disallowed.

For inline, we already have a precedent in include/linux/socket.h,
which contains

/*
 *	This mess will go away with glibc
 */
#if    defined(__GNUC__)
#define __KINLINE static __inline__
#elif defined(__cplusplus) /* || __STDC_VERSION__ >= 199901L  --arnd */
#define __KINLINE static inline
#else
#define __KINLINE static
#endif

This demonstrates that there are additional problems to consider. In order
to do the right thing, we could first use your patch to fix up all instances
of inline, and then warn about any __inline__ and inline, converting the
legitimate ones to __KINLINE.

Again, there are very few legitimate ones, unless you count the byteorder
headers as correct, which I'm still undecided about.

	Arnd <><
