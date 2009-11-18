Return-Path: <linux-kernel-owner+w=401wt.eu-S1752393AbZKRHln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393AbZKRHln (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 02:41:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752305AbZKRHlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 02:41:42 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:54324 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbZKRHll convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 02:41:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jAq3xtdHhMNUVbIhreENdWy7fCu9yEnQEDXpQbN5aMK2fs+L7gxjDZUHjxdMnQeOld
         7X7uPNpZIBUPOnl2slyB0QH10NBb1W1+7spBIyiB+WNZJrI1AjAdRhYNepHloWccwQ0/
         BpYdwl4JIvjbxKtTyFxknTUTNMpVNGTNMS2Zc=
MIME-Version: 1.0
In-Reply-To: <2375c9f90911172317x781e22a9y56ecb8e682e8e061@mail.gmail.com>
References: <b741c2440911172154g62d7f3bcu7bafc65ad2eb4b21@mail.gmail.com>
	 <2375c9f90911172317x781e22a9y56ecb8e682e8e061@mail.gmail.com>
Date: Wed, 18 Nov 2009 15:41:46 +0800
Message-ID: <b741c2440911172341g2251707fj999482473ab97830@mail.gmail.com>
Subject: Re: [PATCH] vfs: does call expand_files when needed
From: Liu Aleaxander <aleaxander@gmail.com>
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 3:17 PM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Wed, Nov 18, 2009 at 1:54 PM, Liu Aleaxander <aleaxander@gmail.com> wrote:
> > From: Liu Aleaxander <Aleaxander@gmail.com>
> > Date: Wed, 18 Nov 2009 10:59:09 +0800
> > Subject: [PATCH] vfs: does call expand_files when needed
> >
> > I don't think we should call expand_files every time we open a
> > file for a new unused fd, so does the expand when necessary.
> >
> > Signed-off-by: Liu Aleaxander <Aleaxander@gmail.com>
> > ---
> >  fs/file.c |   27 ++++++++++++++-------------
> >  1 files changed, 14 insertions(+), 13 deletions(-)
> >
> > diff --git a/fs/file.c b/fs/file.c
> > index 87e1290..3f3d0fc 100644
> > --- a/fs/file.c
> > +++ b/fs/file.c
> > @@ -452,22 +452,22 @@ repeat:
> >        if (fd < files->next_fd)
> >                fd = files->next_fd;
> >
> > -       if (fd < fdt->max_fds)
> > +       if (likely(fd < fdt->max_fds)) {
> >                fd = find_next_zero_bit(fdt->open_fds->fds_bits,
> >                                           fdt->max_fds, fd);
> > -
> > -       error = expand_files(files, fd);
> > -       if (error < 0)
> > -               goto out;
> > -
> > -       /*
> > -        * If we needed to expand the fs array we
> > -        * might have blocked - try again.
> > -        */
> > -       if (error)
> > -               goto repeat;
> > -
> > +       } else {
> > +               error = expand_files(files, fd);
>
>
> In expand_files(), it has the check for
> ' < fdt->max_fds', so this change is not necessary.

Yeah, indeed. But why we should go into an another function to do a
_double_ check especially we mostly don't need to do that?

>
> > +               if (error < 0)
> > +                       goto out;
> > +
> > +               /*
> > +                * If we needed to expand the fs array we
> > +                * might have blocked - try again.
> > +                */
> > +               if (error)
> > +                       goto repeat;
> > +       }
> > +
> >        if (start <= files->next_fd)
> >                files->next_fd = fd + 1;
> >
> > --
> > 1.6.2.5
> >
> > --
> > regards
> > Liu Aleaxander
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >



--
regards
Liu Aleaxander
