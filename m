Return-Path: <linux-kernel-owner+w=401wt.eu-S1754873AbYEDRZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873AbYEDRZq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 13:25:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbYEDRZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 13:25:39 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:57944 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbYEDRZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 13:25:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=s8bHzFrEH3+iCS1/YiudS1uhehbzmAfi2+kc+3HvRHDi3c1h3CVBm2c8vQ/1lV5W0DIVF8eCcLRUQ3U1d9CGpEq0QtA1ARE0HCvlSQok/eoAS6fJd1RPr8vhxXS4sPRmp8yRk89s5O6BbgnnZLJJ8IBlQwDSBhrlHChCMx2xicA=
Message-ID: <386072610805041025w7120539fp1f8efb86e20da5b4@mail.gmail.com>
Date: Mon, 5 May 2008 01:25:37 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Al Viro" <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 1/1] [vfs/proc] task_nommu: fix compile failing bug because of spilt file.h
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080504153056.GJ5882@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1209913975-19242-1-git-send-email-cooloney@kernel.org>
	 <20080504153056.GJ5882@ZenIV.linux.org.uk>
X-Google-Sender-Auth: c024ff0d8c4d076c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 4, 2008 at 11:30 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Sun, May 04, 2008 at 11:12:55PM +0800, Bryan Wu wrote:
>  > diff --git a/fs/proc/task_nommu.c b/fs/proc/task_nommu.c
>  > index 6cba820..987bc69 100644
>  > --- a/fs/proc/task_nommu.c
>  > +++ b/fs/proc/task_nommu.c
>  > @@ -1,6 +1,7 @@
>  >
>  >  #include <linux/mm.h>
>  >  #include <linux/file.h>
>  > +#include <linux/fdtable.h>
>  >  #include <linux/mount.h>
>  >  #include <linux/ptrace.h>
>  >  #include <linux/seq_file.h>
>
>  Well...  I see what it's trying to do, but it's a bullshit.  Look: it's from
>         if (current->files && atomic_read(&current->files->count) > 1)
>                 sbytes += kobjsize(current->files);
>         else
>                 bytes += kobjsize(current->files);
>  Now, what we really have is size of current->files (fixed and not too large)
>  + if descriptor table is too large to be embedded,
>         size of current->files->fdt
>         size of current->files->fdt->fd
>         size of current->files->fdt->open_fds/->close_on_exec
>  And the second term there can be *large*, so if we are really serious about
>  taking descriptor table footprint into account, we'd better take care of
>  that too.  I'm not sure that we want to, though - note that we do that only
>  on nommu targets...
>
>  So what's that code really trying to achieve?
>

Wow, my patch is just to kill the compile error, I did not notice this
large size issue here.
I'd like to improve this code later.

Thanks
-Bryan
