Return-Path: <linux-kernel-owner+w=401wt.eu-S1752223AbYELEBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223AbYELEBd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 00:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750752AbYELEBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 00:01:24 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35431 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbYELEBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 00:01:23 -0400
Date: Mon, 12 May 2008 05:01:22 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       WANG Cong <wangcong@zeuux.org>
Subject: Re: [Patch 7/9] fs/exec.c: fix wrong return value of
	prepare_binprm()
Message-ID: <20080512040122.GN13907@ZenIV.linux.org.uk>
References: <1210254754206-git-send-email-xiyou.wangcong@gmail.com> <12102548553947-git-send-email-xiyou.wangcong@gmail.com> <20080510193105.GG13907@ZenIV.linux.org.uk> <20080512035643.GE2572@hacking>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080512035643.GE2572@hacking>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2008 at 11:56:43AM +0800, WANG Cong wrote:
> On Sat, May 10, 2008 at 08:31:05PM +0100, Al Viro wrote:
> >On Thu, May 08, 2008 at 09:52:32PM +0800, WANG Cong wrote:
> >> All prepare_binprm()'s callers assume that prepare_binprm() fails
> >> when it returns negative. However, prepare_binprm() most probably returns
> >> the return value of kernel_read(), which may return positive on failure!
> >> 
> >> Thus this should be fixed.
> >
> >Since when does read return positive on failure?
> 
> When an EIO occurs, I think. For example,

No.  On EIO it returns -EIO, TYVM...

>         retval = kernel_read(interpreter, interp_elf_ex->e_phoff,
>                              (char *)elf_phdata,size);
>         error = -EIO;
>         if (retval != size) {
>                 if (retval < 0)
>                         error = retval;
>                 goto out_close;
>         }

Which is what we do on short read here.  FWIW, -EINVAL might be saner
choice - it's "binary is corrupted", not "read had failed".
