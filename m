Return-Path: <linux-kernel-owner+w=401wt.eu-S1754528AbZKRIyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbZKRIyA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 03:54:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753421AbZKRIx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 03:53:59 -0500
Received: from mail-px0-f180.google.com ([209.85.216.180]:38288 "EHLO
	mail-px0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbZKRIx6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 03:53:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tR8LgtZU8RkMrAIrz+vYYZT2Ms8cNYFie4zmVKkHfyHgx44VZUb7KPAx1k6l29ao7b
         ZTlXd9vDxditm7iqO66rUj02JDQY7ZuTohxEmMBeoUFWMw2yb5ZxMTDezwERTOHQGV85
         YQ8kh48sD+fhkXPUZxyXUQBXSFUr9dCvi8yFI=
MIME-Version: 1.0
In-Reply-To: <2375c9f90911180035v45b3f732gfe898092583a667a@mail.gmail.com>
References: <b741c2440911172154g62d7f3bcu7bafc65ad2eb4b21@mail.gmail.com>
	 <2375c9f90911172317x781e22a9y56ecb8e682e8e061@mail.gmail.com>
	 <b741c2440911172341g2251707fj999482473ab97830@mail.gmail.com>
	 <2375c9f90911180035v45b3f732gfe898092583a667a@mail.gmail.com>
Date: Wed, 18 Nov 2009 16:54:04 +0800
Message-ID: <b741c2440911180054u1e610829g3646ec65701818ab@mail.gmail.com>
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

On Wed, Nov 18, 2009 at 4:35 PM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> On Wed, Nov 18, 2009 at 3:41 PM, Liu Aleaxander <aleaxander@gmail.com> wrote:
>> On Wed, Nov 18, 2009 at 3:17 PM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
>>>
>>> On Wed, Nov 18, 2009 at 1:54 PM, Liu Aleaxander <aleaxander@gmail.com> wrote:
>>> > From: Liu Aleaxander <Aleaxander@gmail.com>
>>> > Date: Wed, 18 Nov 2009 10:59:09 +0800
>>> > Subject: [PATCH] vfs: does call expand_files when needed
>>> >
>>> > I don't think we should call expand_files every time we open a
>>> > file for a new unused fd, so does the expand when necessary.
>>> >
>>> > Signed-off-by: Liu Aleaxander <Aleaxander@gmail.com>
>>> > ---
>>> >  fs/file.c |   27 ++++++++++++++-------------
>>> >  1 files changed, 14 insertions(+), 13 deletions(-)
>>> >
>>> > diff --git a/fs/file.c b/fs/file.c
>>> > index 87e1290..3f3d0fc 100644
>>> > --- a/fs/file.c
>>> > +++ b/fs/file.c
>>> > @@ -452,22 +452,22 @@ repeat:
>>> >        if (fd < files->next_fd)
>>> >                fd = files->next_fd;
>>> >
>>> > -       if (fd < fdt->max_fds)
>>> > +       if (likely(fd < fdt->max_fds)) {
>>> >                fd = find_next_zero_bit(fdt->open_fds->fds_bits,
>>> >                                           fdt->max_fds, fd);
>>> > -
>>> > -       error = expand_files(files, fd);
>>> > -       if (error < 0)
>>> > -               goto out;
>>> > -
>>> > -       /*
>>> > -        * If we needed to expand the fs array we
>>> > -        * might have blocked - try again.
>>> > -        */
>>> > -       if (error)
>>> > -               goto repeat;
>>> > -
>>> > +       } else {
>>> > +               error = expand_files(files, fd);
>>>
>>>
>>> In expand_files(), it has the check for
>>> ' < fdt->max_fds', so this change is not necessary.
>>
>> Yeah, indeed. But why we should go into an another function to do a
>> _double_ check especially we mostly don't need to do that?
>
> You only optimized one call path,
Yes, and that's the intent of this patch.

>it's trivial, not so much an improvement, IMO.
So, shouldn't we do the optimize when there is a way to do that?

While, I don't think so. And BTW, it's not just a problem of
optimization, but also make it be more sense: JUST call expand when
need. I don't know why you are rejecting about this, especially it did
optimized one call path(as you said), and it doesn't make the code
uglier than before but making it be more sense, and, in fact, a kind
of more readable.

-- 
regards
Liu Aleaxander
