Return-Path: <linux-kernel-owner+w=401wt.eu-S1757808AbXGDW7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757808AbXGDW7i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 18:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754641AbXGDW7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 18:59:30 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:20063 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201AbXGDW73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 18:59:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Ij4ljcjuofom2hxEBs8eQs/flLUMoxpmW/GmpOfeom04jBKHN/G26e3ZaXTDzWFk4Yc6q3VaMJelJQ/TgXw20XoP2H7Ba1diK9h+e/Y/Qpi2RO+uV+t+jiWzuMiT0GyBIHm7a7GLrTUFKqnt8gH6aF/vrR+s75piFQOvkjz8HC4=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: [PATCH][isapnp] Remove pointless check of 'type' against 0 in isapnp_read_tag()
Date: Thu, 5 Jul 2007 00:59:12 +0200
User-Agent: KMail/1.9.7
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jaroslav Kysela" <perex@suse.cz>, jesper.juhl@gmail.com
References: <200707010138.32075.jesper.juhl@gmail.com> <20070703130318.9dbec3ac.akpm@linux-foundation.org> <9a8748490707031804v51ca1c79kdf55150c47b01b3d@mail.gmail.com>
In-Reply-To: <9a8748490707031804v51ca1c79kdf55150c47b01b3d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707050059.12310.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 July 2007 03:04:13 Jesper Juhl wrote:
> On 03/07/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Sun, 1 Jul 2007 01:38:31 +0200
> >
> > Jesper Juhl <jesper.juhl@gmail.com> wrote:
> > > The Coverity checker spotted (as bug #809) that we dereference 'type'
> > > long before we actually test it against NULL in
> > > drivers/pnp/isapnp/core.c::isapnp_read_tag() - both branches of the
> > > 'if (tag & 0x80)' dereference type, and since this 'if' is before the
> > > test against NULL and the return of -1, this will blow up is ever type
> > > is NULL. This is easy to fix by simply moving the NULL test to the
> > > beginning of the function.
>
> [snip]
>
> > dood, look at the callers.  NULL is not possible here.
>
> You are right, there's absolutely no way that we could get a NULL
> pointer there - that was sloppy of me :-(
>
> I guess we should just get rid of the check completely.  I'll cook up
> a patch for that tomorrow.

Ok, here's a patch to just remove the check.



In drivers/pnp/isapnp/core.c::isapnp_read_tag() there is a test of 
'type' being == 0 a bit down in the function. That test doesn't make 
any sense. If 'type' could indeed be NULL, then the test happens way 
too late as we'd already have tried to dereference the pointer 
earlier and looking at the callers it also turns out that there is 
no way type can ever actually be NULL.
So the test is completely pointless and should just be removed.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 drivers/pnp/isapnp/core.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/pnp/isapnp/core.c b/drivers/pnp/isapnp/core.c
index a0b1587..914d00c 100644
--- a/drivers/pnp/isapnp/core.c
+++ b/drivers/pnp/isapnp/core.c
@@ -370,8 +370,6 @@ static int __init isapnp_read_tag(unsigned char *type, unsigned short *size)
 #if 0
 	printk(KERN_DEBUG "tag = 0x%x, type = 0x%x, size = %i\n", tag, *type, *size);
 #endif
-	if (type == 0)				/* wrong type */
-		return -1;
 	if (*type == 0xff && *size == 0xffff)	/* probably invalid data */
 		return -1;
 	return 0;


