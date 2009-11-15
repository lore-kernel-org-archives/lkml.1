Return-Path: <linux-kernel-owner+w=401wt.eu-S1752162AbZKOXmF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162AbZKOXmF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 18:42:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751621AbZKOXmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 18:42:05 -0500
Received: from mail-iw0-f178.google.com ([209.85.223.178]:64703 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbZKOXmD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 18:42:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SoT0eQ/lCvV8MQcGnUpTBIS/y641oE4DADM2uwi2OZ/Se11fQ4LsxfQx2kh0ywvm+a
         lYxIffYUQ4OBUEfVwNJ5DKy+VKHXjdrZPyIu729n3BuqTX20ibudexaAZv9D4tzqhVBY
         Vz80HgwdnPYzPgrVbX1QvRid6YROx+9cgohoQ=
MIME-Version: 1.0
In-Reply-To: <1258142218-2070-1-git-send-email-jglisse@redhat.com>
References: <1258142218-2070-1-git-send-email-jglisse@redhat.com>
Date: Mon, 16 Nov 2009 09:42:08 +1000
Message-ID: <21d7e9970911151542n49f15a9dn6481d0bc2bdfbc45@mail.gmail.com>
Subject: Re: [PATCH 2/2] drm: mm always protect change to unused_nodes with 
	unused_lock spinlock
From: Dave Airlie <airlied@gmail.com>
To: Jerome Glisse <jglisse@redhat.com>
Cc: dri-devel@lists.sf.net, LKML <linux-kernel@vger.kernel.org>,
       Thomas Hellstrom <thellstrom@vmware.com>,
       Chris Wilson <chris@chris-wilson.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 14, 2009 at 5:56 AM, Jerome Glisse <jglisse@redhat.com> wrote:
> unused_nodes modification needs to be protected by unused_lock spinlock.
> Here is an example of an usage where there is no such protection without
> this patch.
>
>  Process 1: 1-drm_mm_pre_get(this function modify unused_nodes list)
>             2-spin_lock(spinlock protecting mm struct)
>             3-drm_mm_put_block(this function might modify unused_nodes
>               list but doesn't protect modification with unused_lock)
>             4-spin_unlock(spinlock protecting mm struct)
>  Process2:  1-drm_mm_pre_get(this function modify unused_nodes list)
> At this point Process1 & Process2 might both be doing modification to
> unused_nodes list. This patch add unused_lock protection into
> drm_mm_put_block to avoid such issue.

Have we got a bug number or reproducer for this?

I've cc'ed Thomas and Chris who were last ppl to touch drm_mm.c for some
sort of acks.

Dave.

>
> Signed-off-by: Jerome Glisse <jglisse@redhat.com>
> ---
>  drivers/gpu/drm/drm_mm.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/gpu/drm/drm_mm.c b/drivers/gpu/drm/drm_mm.c
> index c861d80..97dc5a4 100644
> --- a/drivers/gpu/drm/drm_mm.c
> +++ b/drivers/gpu/drm/drm_mm.c
> @@ -103,6 +103,11 @@ static struct drm_mm_node *drm_mm_kmalloc(struct drm_mm *mm, int atomic)
>        return child;
>  }
>
> +/* drm_mm_pre_get() - pre allocate drm_mm_node structure
> + * drm_mm:     memory manager struct we are pre-allocating for
> + *
> + * Returns 0 on success or -ENOMEM if allocation fails.
> + */
>  int drm_mm_pre_get(struct drm_mm *mm)
>  {
>        struct drm_mm_node *node;
> @@ -253,12 +258,14 @@ void drm_mm_put_block(struct drm_mm_node *cur)
>                                prev_node->size += next_node->size;
>                                list_del(&next_node->ml_entry);
>                                list_del(&next_node->fl_entry);
> +                               spin_lock(&mm->unused_lock);
>                                if (mm->num_unused < MM_UNUSED_TARGET) {
>                                        list_add(&next_node->fl_entry,
>                                                 &mm->unused_nodes);
>                                        ++mm->num_unused;
>                                } else
>                                        kfree(next_node);
> +                               spin_unlock(&mm->unused_lock);
>                        } else {
>                                next_node->size += cur->size;
>                                next_node->start = cur->start;
> @@ -271,11 +278,13 @@ void drm_mm_put_block(struct drm_mm_node *cur)
>                list_add(&cur->fl_entry, &mm->fl_entry);
>        } else {
>                list_del(&cur->ml_entry);
> +               spin_lock(&mm->unused_lock);
>                if (mm->num_unused < MM_UNUSED_TARGET) {
>                        list_add(&cur->fl_entry, &mm->unused_nodes);
>                        ++mm->num_unused;
>                } else
>                        kfree(cur);
> +               spin_unlock(&mm->unused_lock);
>        }
>  }
>
> --
> 1.6.5.2
>
>
