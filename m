Return-Path: <linux-kernel-owner+w=401wt.eu-S1754830AbYFQBLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbYFQBLZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 21:11:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752384AbYFQBLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 21:11:15 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:25850 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313AbYFQBLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 21:11:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=IGdLIaBp6uvNa2Voet6ryipiLzJvIQ9SZipWUQkJ2QhqIjy0YarQsY1mMv5T6sSSWf
         Mo5hKezxV6czpOq4VwImR9d8ii+FuMLbHhxlMkTyX176dhI0wnpu2p8kpdIxbyr5Crn+
         +Z8ClgfG1ZmrNmWPtdzFDc03y21892NvDQoV4=
Message-ID: <45a44e480806161811k423fecf2r2d79609a5c0d057@mail.gmail.com>
Date: Mon, 16 Jun 2008 18:11:14 -0700
From: "Jaya Kumar" <jayakumar.lkml@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: "fb-defio: fix page list with concurrent processes"
Cc: "Markus Armbruster" <armbru@redhat.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <4856E38E.1040203@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4856E38E.1040203@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2008 at 3:05 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> Your patch "fb-defio: fix page list with concurrent processes" definitely
> seems to help with the suspend/resume problem I had with the Xen pvfb
> device.  Is it queued up anywhere?  It seems to be a real bugfix, and should
> probably be queued for 2.6.26...

It isn't currently queued. I had intended to improve its performance
by taking advantage of Andrew's suggestion of using !list_empty on the
page->lru to avoid walking the page list to find the duplicate page,
but I ran into trouble since the page starts off being on the lru
list. I'll try to take a look at doing this next weekend.

Thanks,
jaya


>
>   J
>
> fb-defio: fix page list with concurrent processes
>
> From: Jaya Kumar <jayakumar.lkml@gmail.com>
>
> Hi Tony, Geert, Andrew, fbdev,
>
> This patch is a bugfix for how defio handles multiple processes manipulating
> the same framebuffer. Thanks to Bernard Blackham for identifying this bug.
> It occurs when two applications mmap the same framebuffer and concurrently
> write to the same page. Normally, this doesn't occur since only a single
> process mmaps the framebuffer. The symptom of the bug is that the mapping
> applications will hang. The cause is that defio incorrectly tries to add the
> same page twice to the pagelist. The solution I have is to walk the pagelist
> and check for a duplicate before adding. Since I needed to walk the
> pagelist, I now also keep the pagelist in sorted order.
>
> Thanks,
> jaya
>
> Signed-off-by: Jaya Kumar <jayakumar.lkml@gmail.com>
>
> ---
> drivers/video/fb_defio.c |   20 +++++++++++++++++++-
> 1 file changed, 19 insertions(+), 1 deletion(-)
>
> ===================================================================
> --- a/drivers/video/fb_defio.c
> +++ b/drivers/video/fb_defio.c
> @@ -74,6 +74,7 @@ static int fb_deferred_io_mkwrite(struct vm_area_struct
> *vma,
> {
>        struct fb_info *info = vma->vm_private_data;
>        struct fb_deferred_io *fbdefio = info->fbdefio;
> +       struct page *cur;
>
>        /* this is a callback we get when userspace first tries to
>        write to the page. we schedule a workqueue. that workqueue
> @@ -83,7 +84,24 @@ static int fb_deferred_io_mkwrite(struct vm_area_struct
> *vma,
>
>        /* protect against the workqueue changing the page list */
>        mutex_lock(&fbdefio->lock);
> -       list_add(&page->lru, &fbdefio->pagelist);
> +
> +       /* we loop through the pagelist before adding in order
> +       to keep the pagelist sorted */
> +       list_for_each_entry(cur, &fbdefio->pagelist, lru) {
> +               /* this check is to catch the case where a new
> +               process could start writing to the same page
> +               through a new pte. this new access can cause the
> +               mkwrite even when the original ps's pte is marked
> +               writable */
> +               if (unlikely(cur == page))
> +                       goto page_already_added;
> +               else if (cur->index > page->index)
> +                       break;
> +       }
> +
> +       list_add_tail(&page->lru, &cur->lru);
> +
> +page_already_added:
>        mutex_unlock(&fbdefio->lock);
>
>        /* come back after delay to process the deferred IO */
>
>
>
