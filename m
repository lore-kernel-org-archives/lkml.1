Return-Path: <linux-kernel-owner+w=401wt.eu-S1757623AbXJXRGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757623AbXJXRGr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 13:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757012AbXJXRGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 13:06:34 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:38196 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756288AbXJXRGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 13:06:32 -0400
Date: Wed, 24 Oct 2007 19:07:01 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Paul Menage <menage@google.com>
Cc: Paul Jackson <pj@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] kernel/cgroup.c: remove dead code
Message-ID: <20071024170701.GB30533@stusta.de>
References: <20071024162534.GZ30533@stusta.de> <6599ad830710240930r6649dec0q21b8c00f7d8a796a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6599ad830710240930r6649dec0q21b8c00f7d8a796a@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2007 at 09:30:23AM -0700, Paul Menage wrote:
> I think I'd rather not make this change - if we later changed the size
> of release_agent_path[] this could silently fail. Can we get around
> the coverity checker somehow?

I do not care what the Coverity checker thinks about the code, and 
there's no reason for changing code only for the sake of this checker.

Two questions:
- Is it really intended to perhaps change release_agent_path[] to have
  less than PATH_MAX size?
- If yes, do you want to return -E2BIG for (nbytes >= PATH_MAX) or for
  (nbytes >= sizeof(root->release_agent_path)) ?

> Paul
> 
> On 10/24/07, Adrian Bunk <bunk@kernel.org> wrote:
> > This patch removes dead code spotted by the Coverity checker
> > (look at the "(nbytes >= PATH_MAX)" check).
> >
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> >
> > ---
> >
> >  kernel/cgroup.c |   18 ++++++++----------
> >  1 file changed, 8 insertions(+), 10 deletions(-)
> >
> > --- linux-2.6/kernel/cgroup.c.old       2007-10-23 18:37:43.000000000 +0200
> > +++ linux-2.6/kernel/cgroup.c   2007-10-23 18:39:15.000000000 +0200
> > @@ -1320,90 +1320,88 @@ static ssize_t cgroup_common_file_write(
> >
> >         if (nbytes >= PATH_MAX)
> >                 return -E2BIG;
> >
> >         /* +1 for nul-terminator */
> >         buffer = kmalloc(nbytes + 1, GFP_KERNEL);
> >         if (buffer == NULL)
> >                 return -ENOMEM;
> >
> >         if (copy_from_user(buffer, userbuf, nbytes)) {
> >                 retval = -EFAULT;
> >                 goto out1;
> >         }
> >         buffer[nbytes] = 0;     /* nul-terminate */
> >
> >         mutex_lock(&cgroup_mutex);
> >
> >         if (cgroup_is_removed(cgrp)) {
> >                 retval = -ENODEV;
> >                 goto out2;
> >         }
> >
> >         switch (type) {
> >         case FILE_TASKLIST:
> >                 retval = attach_task_by_pid(cgrp, buffer);
> >                 break;
> >         case FILE_NOTIFY_ON_RELEASE:
> >                 clear_bit(CGRP_RELEASABLE, &cgrp->flags);
> >                 if (simple_strtoul(buffer, NULL, 10) != 0)
> >                         set_bit(CGRP_NOTIFY_ON_RELEASE, &cgrp->flags);
> >                 else
> >                         clear_bit(CGRP_NOTIFY_ON_RELEASE, &cgrp->flags);
> >                 break;
> >         case FILE_RELEASE_AGENT:
> >         {
> >                 struct cgroupfs_root *root = cgrp->root;
> >                 /* Strip trailing newline */
> >                 if (nbytes && (buffer[nbytes-1] == '\n')) {
> >                         buffer[nbytes-1] = 0;
> >                 }
> > -               if (nbytes < sizeof(root->release_agent_path)) {
> > -                       /* We never write anything other than '\0'
> > -                        * into the last char of release_agent_path,
> > -                        * so it always remains a NUL-terminated
> > -                        * string */
> > -                       strncpy(root->release_agent_path, buffer, nbytes);
> > -                       root->release_agent_path[nbytes] = 0;
> > -               } else {
> > -                       retval = -ENOSPC;
> > -               }
> > +
> > +               /* We never write anything other than '\0'
> > +                * into the last char of release_agent_path,
> > +                * so it always remains a NUL-terminated
> > +                * string */
> > +               strncpy(root->release_agent_path, buffer, nbytes);
> > +               root->release_agent_path[nbytes] = 0;
> > +
> >                 break;
> >         }
> >         default:
> >                 retval = -EINVAL;
> >                 goto out2;
> >         }
> >
> >         if (retval == 0)
> >                 retval = nbytes;
> >  out2:
> >         mutex_unlock(&cgroup_mutex);
> >  out1:
> >         kfree(buffer);
> >         return retval;
> >  }

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

