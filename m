Return-Path: <linux-kernel-owner+w=401wt.eu-S1754039AbZBWISQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039AbZBWISQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 03:18:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752889AbZBWISA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 03:18:00 -0500
Received: from mail-fx0-f167.google.com ([209.85.220.167]:49542 "EHLO
	mail-fx0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719AbZBWIR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 03:17:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JK4daYlbzAkU86dTm8xGg61OeT6xtiHDbAWikl6IM7WkzAfuHxB3yQ4kIJxe/masDs
         iX59CfyOPp68YlicE2zHqINrZ4Cqh0OXvKb33aKWtGSID6oElS6y3y7CHSZvpY19b8yS
         FLU37etfixedwYqRk/zRj+Gwky5NpLh2Mqh/I=
Date: Mon, 23 Feb 2009 11:17:57 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Paul Menage <menage@google.com>
Cc: Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Paul Jackson <pj@sgi.com>, Simon Derr <simon.derr@bull.net>
Subject: Re: [PATCH] Remove some pointless conditionals before kfree() in
	kernel/cgroup.c
Message-ID: <20090223081757.GC29898@localhost>
References: <alpine.LNX.2.00.0902222254350.1236@swampdragon.chaosbits.net> <6599ad830902230012x170e2183q1540670d761ef80e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830902230012x170e2183q1540670d761ef80e@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Paul Menage - Mon, Feb 23, 2009 at 12:12:51AM -0800]
| On Sun, Feb 22, 2009 at 2:05 PM, Jesper Juhl <jj@chaosbits.net> wrote:
| > Hi,
| >
| > Here's a small patch for kernel/cgroup.c
| >
| > Removes a few pointless tests of pointer == 0 before kfree() in
| > kernel/cgroup.c.
| > If the pointer we hand to kfree() is 0, then kfree() is a noop, so there
| > is no need to test.
| >
| > Reduces object file size a bit :
| >
| > Before:
| > $ size kernel/cgroup.o
| >   text    data     bss     dec     hex filename
| >  21593    7804    4924   34321    8611 kernel/cgroup.o
| > After:
| > $ size kernel/cgroup.o
| >   text    data     bss     dec     hex filename
| >  21537    7744    4924   34205    859d kernel/cgroup.o
| 
| Thanks. I'm a bit surprised that it also shrunk the data segment size
| (and in fact, by more than the text segment size). Any idea how that
| came about?

Maybe kfree was inlined by gcc for some reason?

| 
| >
| > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
| 
| Acked-by: Paul Menage <menage@google.com>
| 
| Paul
| 
| > ---
| >
| > diff --git a/kernel/cgroup.c b/kernel/cgroup.c
| > index 9edb5c4..1c0a9b5 100644
| > --- a/kernel/cgroup.c
| > +++ b/kernel/cgroup.c
| > @@ -865,8 +865,7 @@ static int cgroup_remount(struct super_block *sb, int *flags, char *data)
| >        if (opts.release_agent)
| >                strcpy(root->release_agent_path, opts.release_agent);
| >  out_unlock:
| > -       if (opts.release_agent)
| > -               kfree(opts.release_agent);
| > +       kfree(opts.release_agent);
| >        mutex_unlock(&cgroup_mutex);
| >        mutex_unlock(&cgrp->dentry->d_inode->i_mutex);
| >        return ret;
| > @@ -969,15 +968,13 @@ static int cgroup_get_sb(struct file_system_type *fs_type,
| >        /* First find the desired set of subsystems */
| >        ret = parse_cgroupfs_options(data, &opts);
| >        if (ret) {
| > -               if (opts.release_agent)
| > -                       kfree(opts.release_agent);
| > +               kfree(opts.release_agent);
| >                return ret;
| >        }
| >
| >        root = kzalloc(sizeof(*root), GFP_KERNEL);
| >        if (!root) {
| > -               if (opts.release_agent)
| > -                       kfree(opts.release_agent);
| > +               kfree(opts.release_agent);
| >                return -ENOMEM;
| >        }
| >
| >
| >
| > --
| > Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
| > Plain text mails only, please      http://www.expita.com/nomime.html
| > Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
| >
| >
| 
	- Cyrill -
