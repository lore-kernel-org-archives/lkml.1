Return-Path: <linux-kernel-owner+w=401wt.eu-S1756669AbZKSPdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669AbZKSPdX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 10:33:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754290AbZKSPdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 10:33:22 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:63347 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbZKSPdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 10:33:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=D0M8HxYrOvoEaoJ/vOX2nqixuOi0PWDKQKMilNWds2HO8twopFlEiynmCogJy9zc30
         WLLVYzGJFTluE3c6Vqd7u2K1s7ZOKrVjTrIFlwkZMCavQ5XoQ55C0LPjrdzrKjIpixfl
         wdk/yn0jpalIugAE3IzUdmFrYpvgViWeMa3nY=
Date: Thu, 19 Nov 2009 23:34:08 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip 0/2] Fix mm->flags consistency issue in coredump
Message-ID: <20091119153408.GB8392@hack>
References: <20091117235305.30900.43344.stgit@dhcp-100-2-132.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091117235305.30900.43344.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 06:53:05PM -0500, Masami Hiramatsu wrote:
>
>Hi,
>
>These patches are for fixing coredump mm->flags consistency issue.
>
>---
>1787         if (mm->core_state || !get_dumpable(mm)) {  <- (1)
>1788                 up_write(&mm->mmap_sem);
>1789                 put_cred(cred);
>1790                 goto fail;
>1791         }
>1792
>[...]
>1798         if (get_dumpable(mm) == 2) {    /* Setuid core dump mode */ <-(2)
>1799                 flag = O_EXCL;          /* Stop rewrite attacks */
>1800                 cred->fsuid = 0;        /* Dump root private */
>1801         }
>---
>
>Since dumpable bits are not protected by lock, there is a
>chance to change these bits between (1) and (2).
>
>To solve this issue, this patch copies mm->flags to
>coredump_params.mm_flags at the beginning of do_coredump()                      and uses it instead of get_dumpable() while dumping core.
>This series also introduce coredump parameter structure
>for simplify bimfmt->core_dump interface.


So, this patch set hides 'mm_flags' from globally in mm_struct
to locally in do_coredump() function, by copying it to a local
data structure?

Hmm, seems reasonable.

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks.


>
>Thank you,
>
>---
>
>Masami Hiramatsu (2):
>      Pass mm->flags as a coredump parameter for consistency
>      mm: Introduce coredump parameter structure
>
>
> fs/binfmt_aout.c        |   13 ++++++-----
> fs/binfmt_elf.c         |   50 +++++++++++++++++++----------------------
> fs/binfmt_elf_fdpic.c   |   38 ++++++++++++-------------------
> fs/binfmt_flat.c        |    6 ++---
> fs/binfmt_som.c         |    2 +-
> fs/exec.c               |   58 ++++++++++++++++++++++++++++++-----------------
> include/linux/binfmts.h |   11 ++++++++-
> 7 files changed, 97 insertions(+), 81 deletions(-)
>
>-- 
>Masami Hiramatsu
>
>Software Engineer
>Hitachi Computer Products (America), Inc.
>Software Solutions Division
>e-mail: mhiramat@redhat.com
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/

-- 
Live like a child, think like the god.
 
