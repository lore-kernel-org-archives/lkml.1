Return-Path: <linux-kernel-owner+w=401wt.eu-S1758236AbYEYAVF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236AbYEYAVF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 20:21:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753614AbYEYAUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 20:20:54 -0400
Received: from nospam3.slac.stanford.edu ([134.79.18.120]:60599 "EHLO
	nospam3.slac.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933AbYEYAUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 20:20:53 -0400
From: Steven Fuerst <sfuerst@stanford.edu>
To: linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] kconfig: introduce KCONFIG_* symbols for .c files
Date: Sat, 24 May 2008 17:20:51 -0700
User-Agent: KMail/1.5.3
Cc: "Tom Spink" <tspink@gmail.com>
References: <200805241636.22242.sfuerst@stanford.edu> <7b9198260805241700o2bc38848m60d5853b63e6ff26@mail.gmail.com>
In-Reply-To: <7b9198260805241700o2bc38848m60d5853b63e6ff26@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805241720.51669.sfuerst@stanford.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<snip>
> >
> > #include <stdio.h>
> >
> > #define CONFIG_FOO      1
> > /* #define CONFIG_BAR   1 */
> >
> > #define STR2(x) #x
> > #define STR(x) STR2(x)
> >
> > #define PASTE2(x, y) x##y
> > #define PASTE(x, y) PASTE2(x, y)
> >
> > #define KCONFIG2(x, y) STR(PASTE(CONFIG_, x))[y]
> > #define KCONFIG(x) (!((KCONFIG2(x, 0) == 'C') && \
> >                                        (KCONFIG2(x, 1) == 'O') && \
> >                                        (KCONFIG2(x, 2) == 'N') && \
> >                                        (KCONFIG2(x, 3) == 'F') && \
> >                                        (KCONFIG2(x, 4) == 'I') && \
> >                                        (KCONFIG2(x, 5) == 'G') && \
> >                                        (KCONFIG2(x, 6) == '_')))
> >
> > int main()
> > {
> >        if (KCONFIG(FOO)) printf("FOO\n");
> >        if (KCONFIG(BAR)) printf("BAR\n");
> >        return 0;
> > }
> >
> >
> > It of course assumes that the result of all defined macros you want to
> > test for do not start with "CONFIG_", so this doesn't work generally. 
> > However, nearly all of the time the arguement to KCONFIG() will be
> > defined to be "1" an integer, or some other known string that doesn't
> > begin with "CONFIG_", so this trick is fairly robust.
>
> I've seen worse abuse of the preprocessor[1]. ;-)

True...  Here's a "nicer" version, that even gets empty defines right.  I've 
checked that gcc is smart enough to compile away the constant string 
comparison.  The only thing wrong with this now is that it'll fail to get
#define CONFIG_BLAH	CONFIG_BLAH
correct, but that's a rather silly corner case.

#include <stdio.h>

#define CONFIG_FOO	1
/* #define CONFIG_BAR	1 */
#define CONFIG_BAZ

#define STR2(x) #x
#define STR(x) STR2(x)

#define PASTE(x, y) x##y

#define KCONFIG(x) \
	(__builtin_strcmp("Z" STR(PASTE(CONFIG_, x)), "ZCONFIG_" #x))

int main()
{
	if (KCONFIG(FOO)) printf("FOO\n");
	if (KCONFIG(BAR)) printf("BAR\n");
	if (KCONFIG(BAZ)) printf("BAZ\n");
	
	return 0;
}

Steven

