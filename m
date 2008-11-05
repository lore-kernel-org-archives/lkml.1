Return-Path: <linux-kernel-owner+w=401wt.eu-S1756614AbYKERss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614AbYKERss (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 12:48:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754194AbYKERs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 12:48:28 -0500
Received: from qb-out-0506.google.com ([72.14.204.224]:44963 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179AbYKERs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 12:48:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=GXbS4EwL0FkiGOOtCPPGcTESFN/l6zMo2q52BQ9Ov7lx9NMrNUULr9JiHumPi9ho5H
         YVUWMSBr3bbztjFDSdLvX031VBmlp0oFpa1KHsUk04Mk2YVUUOYMyVu2yadfAOEJT23b
         R8g6B4Wb6qzchJ3n1bHjW19U3+wHGktHpE2vM=
Message-ID: <4911DC66.9090607@panasas.com>
Date: Wed, 05 Nov 2008 19:48:22 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird/3.0a2 (X11; 2008072418)
MIME-Version: 1.0
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>
CC: Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] Always include <linux/types.h>
References: <491073BB.4000900@panasas.com> <1225817069-5969-1-git-send-email-bharrosh@panasas.com> <20081104180347.GA9818@uranus.ravnborg.org> <20081105163941.GB6561@logfs.org>
In-Reply-To: <20081105163941.GB6561@logfs.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jörn Engel wrote:
> Hardly any file in the kernel can be compiled without including
> <linux/types.h>, directly or indirectly.  And I'd wager a beer that
> noone can find a non-trivial example.  I couldn't.
> 
> So instead of sprinkling even more #include <linux/types.h> everywhere -
> 140 headers in include/linux/ would need that to compile standalone -
> let us just pass it automatically.
> 
> The existing 4000 odd includes for types.h, plus some 300 each for
> compiler.h and stddef.h, which get pulled through types.h, can get
> removed at leasure.
> 
> diff --git a/Makefile b/Makefile
> index 6192922..8a3fb66 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -326,7 +326,8 @@ AFLAGS_KERNEL	=
>  # Needed to be compatible with the O= option
>  LINUXINCLUDE    := -Iinclude \
>                     $(if $(KBUILD_SRC),-Iinclude2 -I$(srctree)/include) \
> -		   -include include/linux/autoconf.h
> +		   -include include/linux/autoconf.h \
> +		   -include include/linux/types.h
>  
>  KBUILD_CPPFLAGS := -D__KERNEL__ $(LINUXINCLUDE)
>  
> --

I think that if:
[A]
<header1.h>
/* no includes pure level A header */
</header1.h>

[B]
<header2.h>
#include "header1.h"
/* Level B header depends on level A */
</header2.h>

[C]
<header3.h>
#include "header2.h"
use some types of header1.h
/* Level C header depends on level B */
</header3.h>

[D]
<source.c>
#include "header3.h"
use types from A, B, C
</source.c>

Then that's fine any other file that includes any one of A, B, or C will have
no problem compiling and headers include order does not matter. Actually it is
nice, since the reader of header3.h knows that it is derived/dependent work of
header2.h.

Now what happens in the future when at B #include "header1.h" is removed.
At C header3.h stops compiling. So here I think it is the programmer's decision.
If he thinks that usage of A types used at C are do to B and if B's implementation
changes to use another set of types, then also C should change with it. Then leave
it as above. If the programmer decides that there is independent use of A types
in C unrelated to B, then he should also include A directly. If in doubt just don't
include it.

In any case I'm still not breaking the self-contained / order-independent headers
rule.

So please don't do that, Most of these places you found are the A-B-C case

Just my $0.017
Boaz

