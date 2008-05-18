Return-Path: <linux-kernel-owner+w=401wt.eu-S1756446AbYERLQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446AbYERLQr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 07:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752589AbYERLQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 07:16:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38247 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbYERLQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 07:16:40 -0400
Subject: Re: linux/a.out.h is not exported to userspace
From: David Woodhouse <dwmw2@infradead.org>
To: Khem Raj <raj.khem@gmail.com>
Cc: k.shutemov@gmail.com, linux-kernel@vger.kernel.org, avi@qumranet.com
In-Reply-To: <1210983237.8550.28.camel@isis>
References: <1210983237.8550.28.camel@isis>
Content-Type: text/plain
Date: Sun, 18 May 2008 12:16:32 +0100
Message-Id: <1211109392.3008.186.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-05-16 at 17:13 -0700, Khem Raj wrote:
> Hi,
> 
> Looking for a compile failure for a package on uclibc system using
> kernel-headers from 2.6.25 I found that linux/a.out.h is no more
> exported to userland anymore.
> 
> This commit below has disabled it from being exported. The commit Do not
> export asm/page.h during make headers_install so I was wondering if it
> was intended to unexport linux/a.out.h or not.
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=ed7b1889da256977574663689b598d88950bbd23
> 
> 
> Looking at the patch from lkml post
> 
> http://linux.derkeiler.com/Mailing-Lists/Kernel/2007-10/msg08913.html
> 
> second hunk to include/linux/Kbuild was not applied which caused this
> problem.
> 
> I think I do not fall into Signed-off-by definition. I tested the
> following patch on 2.6.25.
> 
> Thanks
> 
> -Khem
> 
> Tested-by: Khem Raj <raj.khem@gmail.com>
> 
> diff --git a/include/linux/Kbuild b/include/linux/Kbuild
> index b7d81b2..8a3d93e 100644
> --- a/include/linux/Kbuild
> +++ b/include/linux/Kbuild
> @@ -168,6 +168,7 @@ unifdef-y += acct.h
>  unifdef-y += adb.h
>  unifdef-y += adfs_fs.h
>  unifdef-y += agpgart.h
> +unifdef-y += a.out.h
>  unifdef-y += apm_bios.h
>  unifdef-y += atalk.h
>  unifdef-y += atmdev.h

That'll export <linux/a.out.h> even on architectures where <asm/a.out.h>
doesn't exist -- which will cause headers_check to fail.

Perhaps we could do it something like this:
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -168,6 +168,9 @@ unifdef-y += acct.h
 unifdef-y += adb.h
 unifdef-y += adfs_fs.h
 unifdef-y += agpgart.h
+ifeq ($(wildcard include/asm-$(SRCARCH)/a.out.h),include/asm-$(SRCARCH)/a.out.h)
+unifdef-y += a.out.h
+endif
 unifdef-y += apm_bios.h
 unifdef-y += atalk.h
 unifdef-y += atmdev.h

In fact, perhaps we could do <linux/kvm.h> that way too -- I believe I
objected to using a CONFIG symbol, but the mere existence of the file
would be fine. I don't think we thought of that at the time.

-- 
dwmw2

