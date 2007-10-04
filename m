Return-Path: <linux-kernel-owner+w=401wt.eu-S932091AbXJDWqI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091AbXJDWqI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 18:46:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759553AbXJDWpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 18:45:55 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:38333 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759242AbXJDWpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 18:45:54 -0400
Date: Thu, 4 Oct 2007 17:46:05 -0500
From: "Jose R. Santos" <jrs@us.ibm.com>
To: Rusev <arusev@dev.rtsoft.ru>
Cc: linux-kernel@vger.kernel.org
Subject: Re: JBD-DEBUG /proc/sys entry (again)
Message-ID: <20071004174605.6f30c85f@gara>
In-Reply-To: <4704DC57.9040001@dev.rtsoft.ru>
References: <4704DC57.9040001@dev.rtsoft.ru>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Oct 2007 16:28:07 +0400
Rusev <arusev@dev.rtsoft.ru> wrote:

> All that should be moved to DEBUGFS under /sys/kernel/debug  and so on
> -  that's right, a bit other issue
> is of interest for me.
> 
> My suggestion is that a few other problems with PROCFS exist:
> 
> From my observation there are two major issues are involved:
> 
> 1.  /proc/sys entry has very specific readdir operation (vs. other
> entries such as /proc/drivers and others)
>     entries to /proc/sys is likely is to be performed by means of other API.
>     (quick search found thet API explanation for 2.4.xx
> http://www.opentech.at/papers/embedded_proc/node33.html,
>      yet it looks to be a little change in 2.6)
> 
> 2.  function xlate_proc_name behaves not the way it specified in it's
> header comment:
>       [1]  minor issue is that proc_match wolud likely return "equals"
> as result of comparison of "sys" and "sysvipc"
>       [2] more significant issue is that it can't properly walk long
> paths  such as /proc/sys/jbd/jbd-debug,
>            but only paths likes /proc/sys/jbd-debug  (just one step
> down, path walking is broken).
> 
> This way we can't add not only /proc/sys/jbd/jbd-debug but any path
> likes /proc/aaa/bbb/xxx-debug at one step.
> The entry /proc/sys is still specific, because even if fixing
> xlate_proc_name we can't see /proc/sys/jbd/jbd-debug
> in userspace and successfully see /proc/aaa/bbb/jbd-debug.

This patch is wrong.  xlate_pro_name() is meant to check if a given
path is valid, creating new directory entries is something that need to
be handle by the code that's creating the entries.

Also note that xlate_pro_name() is also called by remove_proc_entry()
so if I call it with a bogus path, this patch will end up creating new
directory entries which is not the intended result.

> That's because /proc/sys specific operator readdir blocks such PROCFS
> entries that they are NOTproperly registersd
>  with CTL_TABLE.
> 
> Yet I think that we have a general problem with
> adding-long-paths-in-one-step, which is addressed by the following patch:

This should not be done is user one step and for good reason.  If you
blindly create multiple directory entries in /proc, how are you going to
keep track of all the created entries when its time to remove them
(module unloading for example)?

If you enter an invalid path the original code is doing the right thing
by returning -ENOENT.

> 
> 
> 
> diff -uprN linux-2.6.21.orig/fs/proc/generic.c
> linux-2.6.21/fs/proc/generic.c
> --- linux-2.6.21.orig/fs/proc/generic.c 2007-09-13 15:36:07.000000000 +0400
> +++ linux-2.6.21/fs/proc/generic.c      2007-10-03 22:12:57.000000000 +0400
> @@ -298,6 +298,7 @@ static int xlate_proc_name(const char *n
>         int                     len;
>         int                     rtn = 0;
> 
> +

White space damage.

>         spin_lock(&proc_subdir_lock);
>         de = &proc_root;
>         while (1) {
> @@ -305,24 +306,52 @@ static int xlate_proc_name(const char *n
>                 if (!next)
>                         break;
> 
> -               len = next - cp;
> -               for (de = de->subdir; de ; de = de->next) {
> -                       if (proc_match(len, cp, de))
> -                               break;
> -               }
> -               if (!de) {
> -                       rtn = -ENOENT;
> -                       goto out;
> -               }
> -               cp += len + 1;
> -       }
> +                ++next;
> +
> +
> +                len = next - cp;
> +
> +                if(de->subdir == NULL){
> +                  /* directory "de" is empty, add myself to it now */
> +                  char* my_name = kzalloc( (len - 1)  + 1, GFP_KERNEL);

You did not check if kzalloc was successfully.  If the allocation
fails, bad things will happen here.  Need to check the return status of
my_name and return -ENOMEM if the allocation fails.  This would of
course mean an API change and you would need make sure that all the
callers of xlate_proc_name handle the new return code correctly.

> +                  memcpy(my_name, cp, len - 1);
> +                  proc_mkdir(my_name,de);
> +                  kfree(my_name);
> +                }
> +
> +
> +                struct proc_dir_entry   *parent_de = de;
> +                for (de = parent_de->subdir; de ; de = de->next) {
> +                  if (proc_match(len - 1, cp, de))
> +                                break;
> +
> +                }
> +
> +                if(de == NULL){
> +                  /* we found no appropriate subdirectory, well create
> it now */

1. Email client cut the line.  Disable line wrapping.
2. Line too long - Documentation/CodingStyle

> +                  char* my_name = kzalloc( (len - 1)  + 1, GFP_KERNEL);

Again, check for kzalloc return status.

> +                  memcpy(my_name, cp, len - 1);
> +                  de = proc_mkdir(my_name,parent_de);
> +                  kfree(my_name);
> +                }
> +
> +
> +

White space damage.  To many new lines.  One is enough.

> +                if (!de){
> +                        rtn = -ENOENT;
> +                        goto out;
> +               }

This is basically dead code since you make sure to create a directory
entry if one does not exist.  The code above makes sure you never hit
this condition, which is wrong since you should not create directory
entries blindly.  Returning -ENOENT on a invalid path is the right thing
to do here.

> +                cp += len;
> +        }
>         *residual = cp;
>         *ret = de;
>  out:
>         spin_unlock(&proc_subdir_lock);
>         return rtn;
> +
White space damage.
>  }
> 
> +
White space damage.
>  static DEFINE_IDR(proc_inum_idr);
>  static DEFINE_SPINLOCK(proc_inum_lock); /* protects the above */
> 

-JRS
