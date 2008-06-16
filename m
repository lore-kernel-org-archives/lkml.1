Return-Path: <linux-kernel-owner+w=401wt.eu-S1755251AbYFPPP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251AbYFPPP4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 11:15:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678AbYFPPPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 11:15:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54092 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257AbYFPPPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 11:15:48 -0400
Subject: Re: [PATCH v2] export linux/a.out.h
From: David Woodhouse <dwmw2@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Korsgaard <jacmet@sunsite.dk>, linux-kernel@vger.kernel.org,
       sam@ravnborg.org, dhowells@redhat.com,
       "Kirill A. Shutemov" <k.shutemov@gmail.com>, rth@twiddle.net
In-Reply-To: <48567B52.4050901@firstfloor.org>
References: <1213565555.26255.522.camel@pmac.infradead.org>
	 <1213604973-7073-1-git-send-email-jacmet@sunsite.dk>
	 <1213617663.26255.708.camel@pmac.infradead.org>
	 <48567B52.4050901@firstfloor.org>
Content-Type: text/plain
Date: Mon, 16 Jun 2008 16:15:35 +0100
Message-Id: <1213629335.26255.792.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-16 at 16:40 +0200, Andi Kleen wrote:
> >  We should get rid of CONFIG_ARCH_SUPPORTS_AOUT entirely. The only
> > remaining users of it are fs/exec.c, which uses it entirely redundantly:
> >	#if defined(__alpha__) && defined(CONFIG_ARCH_SUPPORTS_AOUT)
> >
> > ...and (indirectly, by virtue of being the only other file that includes
> > <linux/a.out.h> when ARCH_SUPPORTS_AOUT might be unset) fs/binfmt_elf.c,
> > which still has unnecessary references to 'struct exec' even though Andi
> > removed the support for a.out interpreters a few months ago. That can
> > just go away.
> 
> I didn't think the Alpha /sbin/loader stuff was an a.out interpreter for ELF.
>
> Also pure a.out is still supported.
> 
> It might be ok to remove it anyways, but you should check with someone
> who knows Alpha first. cc Richard.

The Alpha /sbin/loader support, and the a.out-interpreter-for-ELF, are
two completely separate issues -- you're right that /sbin/loader isn't
an a.out interpreter for ELF files.

They're the two places which rely on '#ifdef CONFIG_ARCH_SUPPORTS_AOUT'
in <linux/a.out.h>, because they include <linux/a.out.h> on platforms
which might not have <asm/a.out.h>.

In the Alpha case in fs/exec.c, we can simply include <linux/a.out.h>
only #ifdef __alpha__ -- while noting that that code could probably do
with a little more cleanup and turning into a properly registered binfmt
rather than a special case, if possible.

In the case of fs/binfmt_elf.c, we can simply remove the inclusion of
<linux/a.out.h> and all references to 'struct exec'. You removed the
rest of the a.out interpreter support already; that last part probably
should have gone away at the same time.

Proper a.out support in fs/binfmt_aout.c can stay as it is; you won't be
building binfmt_aout.c unless your platform supports a.out anyway.

And then we can remove the #ifdef CONFIG_ARCH_SUPPORTS_AOUT in
<linux/a.out.h>, and export it to userspace again, which was the point
of Peter's patch that started this thread.

-- 
dwmw2

