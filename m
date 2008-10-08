Return-Path: <linux-kernel-owner+w=401wt.eu-S1754860AbYJHI5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860AbYJHI5c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 04:57:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754199AbYJHI5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 04:57:23 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:16824 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158AbYJHI5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 04:57:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=X3khLknsioKLNmzvYIXbvzUFxhrFkUXuKFekjebxY4tds/obBS1pfv3b5O1hpUZgmg
         xmeNJjsZJbKf0825LSGhiAzzuWKOAoYMJm6M9V0Qz0MvVVVREqa3+SZyYuQTn9t3NssT
         uFQMd5AYQeesI/7NqcY7lRLrRIG4WfJoD6v7I=
Message-ID: <517f3f820810080157j3994ff10j8518178af02e5b22@mail.gmail.com>
Date: Wed, 8 Oct 2008 10:57:21 +0200
From: "Michael Kerrisk" <mtk.manpages@gmail.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH, v3] shmat: introduce flag SHM_MAP_NOT_FIXED
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       "Andi Kleen" <andi@firstfloor.org>, "Ingo Molnar" <mingo@redhat.com>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Hugh Dickins" <hugh@veritas.com>,
       "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Ulrich Drepper" <drepper@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>, linux-api@vger.kernel.org
In-Reply-To: <1223396117-8118-1-git-send-email-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1223396117-8118-1-git-send-email-kirill@shutemov.name>
X-Google-Sender-Auth: 823a28cbdd3afe65
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kirill,

On Tue, Oct 7, 2008 at 6:15 PM, Kirill A. Shutemov <kirill@shutemov.name> wrote:
> If SHM_MAP_NOT_FIXED specified and shmaddr is not NULL, then the kernel takes
> shmaddr as a hint about where to place the mapping. The address of the mapping
> is returned as the result of the call.
>
> It's similar to mmap() without MAP_FIXED.

Please CC linux-api@vger.kernel.org on patches that change the
kernel-userspace interface.

Cheers,

Michael

> Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
> Cc: Andi Kleen <andi@firstfloor.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Arjan van de Ven <arjan@infradead.org>
> Cc: Hugh Dickins <hugh@veritas.com>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Cc: Ulrich Drepper <drepper@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
>  include/linux/shm.h |    2 ++
>  ipc/shm.c           |    7 ++++---
>  2 files changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/shm.h b/include/linux/shm.h
> index eca6235..fd288eb 100644
> --- a/include/linux/shm.h
> +++ b/include/linux/shm.h
> @@ -55,6 +55,8 @@ struct shmid_ds {
>  #define        SHM_RND         020000  /* round attach address to SHMLBA boundary */
>  #define        SHM_REMAP       040000  /* take-over region on attach */
>  #define        SHM_EXEC        0100000 /* execution access */
> +#define        SHM_MAP_NOT_FIXED 0200000 /* interpret attach address as a search
> +                                  * hint */
>
>  /* super user shmctl commands */
>  #define SHM_LOCK       11
> diff --git a/ipc/shm.c b/ipc/shm.c
> index e77ec69..54f3c61 100644
> --- a/ipc/shm.c
> +++ b/ipc/shm.c
> @@ -819,7 +819,7 @@ long do_shmat(int shmid, char __user *shmaddr, int shmflg, ulong *raddr)
>        if (shmid < 0)
>                goto out;
>        else if ((addr = (ulong)shmaddr)) {
> -               if (addr & (SHMLBA-1)) {
> +               if (!(shmflg & SHM_MAP_NOT_FIXED) && (addr & (SHMLBA-1))) {
>                        if (shmflg & SHM_RND)
>                                addr &= ~(SHMLBA-1);       /* round down */
>                        else
> @@ -828,7 +828,8 @@ long do_shmat(int shmid, char __user *shmaddr, int shmflg, ulong *raddr)
>  #endif
>                                        goto out;
>                }
> -               flags = MAP_SHARED | MAP_FIXED;
> +               flags = MAP_SHARED |
> +                               (shmflg & SHM_MAP_NOT_FIXED ? 0 : MAP_FIXED);
>        } else {
>                if ((shmflg & SHM_REMAP))
>                        goto out;
> @@ -892,7 +893,7 @@ long do_shmat(int shmid, char __user *shmaddr, int shmflg, ulong *raddr)
>        sfd->vm_ops = NULL;
>
>        down_write(&current->mm->mmap_sem);
> -       if (addr && !(shmflg & SHM_REMAP)) {
> +       if (addr && !(shmflg & (SHM_REMAP|SHM_MAP_NOT_FIXED))) {
>                err = -EINVAL;
>                if (find_vma_intersection(current->mm, addr, addr + size))
>                        goto invalid;
> --
> 1.5.6.5.GIT
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/ Found a documentation bug?
http://www.kernel.org/doc/man-pages/reporting_bugs.html
