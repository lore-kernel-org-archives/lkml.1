Return-Path: <linux-kernel-owner+w=401wt.eu-S1752033AbZH0EvB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033AbZH0EvB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 00:51:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751382AbZH0EvB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 00:51:01 -0400
Received: from mail-px0-f174.google.com ([209.85.216.174]:62340 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbZH0EvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 00:51:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=aeIqYQADFX8XSPJgJ+ePp02KQ4Vyk0vTgNAAKHFVAja6AlDxjxlj66phXuTd1YyGLo
         DC380j/ZBorR610tKmJ4ZCEoTuBg4pD5+0YPH+PSzLyjlly6uYq9xcIfRrsrOh6908ud
         IQD7T80fj92cbUY+u6obhgIfhYphLNy9mF95Q=
Date: Thu, 27 Aug 2009 12:53:14 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Helge Deller <deller@gmx.de>
Subject: Re: [PATCH 2/2] module: workaround duplicate section names
Message-ID: <20090827045314.GA4689@cr0.nay.redhat.com>
References: <200908262202.54457.rusty@rustcorp.com.au> <200908262204.13395.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908262204.13395.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 26, 2009 at 10:04:12PM +0930, Rusty Russell wrote:
>From: James Bottomley <James.Bottomley@HansenPartnership.com>
>
>(This patch leaves other problems, particularly the sections
> directory, but recent parisc toolchains seem to produce these
> modules and this prevents a crash and is a minimal change -- RR).
>
>The root cause is a duplicate section name (.text); is this legal?

AFAIK, yes.


>
>However, there's a problem with commit
>6d76013381ed28979cd122eb4b249a88b5e384fa in that if you fail to allocate
>a mod->sect_attrs (in this case it's null because of the duplication),
>it still gets used without checking in add_notes_attrs()
>
>This should fix it
>
>Signed-off-by: James Bottomley <James.Bottomley@suse.de>
>Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
>Tested-by: Helge Deller <deller@gmx.de>

Looks fine for me.

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks.


>---
>
>diff --git a/kernel/module.c b/kernel/module.c
>index fd14114..a703c49 100644
>--- a/kernel/module.c
>+++ b/kernel/module.c
>@@ -2353,7 +2353,8 @@ static noinline struct module *load_module(void __user *umod,
> 	if (err < 0)
> 		goto unlink;
> 	add_sect_attrs(mod, hdr->e_shnum, secstrings, sechdrs);
>-	add_notes_attrs(mod, hdr->e_shnum, secstrings, sechdrs);
>+	if (mod->sect_attrs)
>+		add_notes_attrs(mod, hdr->e_shnum, secstrings, sechdrs);
> 
> 	/* Get rid of temporary copy */
> 	vfree(hdr);
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
