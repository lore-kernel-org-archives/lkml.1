Return-Path: <linux-kernel-owner+w=401wt.eu-S1751816AbZBPTCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816AbZBPTCf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 14:02:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753614AbZBPTCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 14:02:20 -0500
Received: from mail-gx0-f222.google.com ([209.85.217.222]:62745 "EHLO
	mail-gx0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbZBPTCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 14:02:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:cc
         :content-type:content-transfer-encoding;
        b=QfHndhBm+Y5GjssOHtRB+rpf5YHBX97sytAOHC0b1xF0R3qTp10b3P2czCW7gDzdq6
         3oknBfWepnp8Q/HkdAwcvE6K6lzxwbf+k/qRPFo/0tUxSUYEBYl4kdzAZsJHkiizlvYA
         gNSbKjYUqGvDUEi0/t4D1SgA7bvhggG9RIUK4=
MIME-Version: 1.0
In-Reply-To: <20090216153351.GB27520@cmpxchg.org>
References: <20090216142926.440561506@cmpxchg.org>
	 <20090216144725.976425091@cmpxchg.org>
	 <84144f020902160713y7341b2b4g8aa10919405ab82d@mail.gmail.com>
	 <20090216153351.GB27520@cmpxchg.org>
Date: Mon, 16 Feb 2009 13:02:18 -0600
Message-ID: <524f69650902161102y78ff21b7hf8a8d318136498d5@mail.gmail.com>
Subject: Re: [patch 6/8] cifs: use kzfree()
From: Steve French <smfrench@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks fine to me:

Acked-by: Steve French <sfrench@us.ibm.com>

On Mon, Feb 16, 2009 at 9:33 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:
>
> On Mon, Feb 16, 2009 at 05:13:30PM +0200, Pekka Enberg wrote:
> > Hi Johannes,
> >
> > On Mon, Feb 16, 2009 at 4:29 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> > > @@ -2433,11 +2433,8 @@ mount_fail_check:
> > >  out:
> > >        /* zero out password before freeing */
> > >        if (volume_info) {
> > > -               if (volume_info->password != NULL) {
> > > -                       memset(volume_info->password, 0,
> > > -                               strlen(volume_info->password));
> > > -                       kfree(volume_info->password);
> > > -               }
> > > +               if (volume_info->password != NULL)
> > > +                       kzfree(volume_info->password);
> >
> > The NULL check here is unnecessary.
> >
> > >                kfree(volume_info->UNC);
> > >                kfree(volume_info->prepath);
> > >                kfree(volume_info);
> > > --- a/fs/cifs/misc.c
> > > +++ b/fs/cifs/misc.c
> > > @@ -97,10 +97,8 @@ sesInfoFree(struct cifsSesInfo *buf_to_f
> > >        kfree(buf_to_free->serverOS);
> > >        kfree(buf_to_free->serverDomain);
> > >        kfree(buf_to_free->serverNOS);
> > > -       if (buf_to_free->password) {
> > > -               memset(buf_to_free->password, 0, strlen(buf_to_free->password));
> > > -               kfree(buf_to_free->password);
> > > -       }
> > > +       if (buf_to_free->password)
> > > +               kzfree(buf_to_free->password);
> >
> > And here.
>
> Thanks, Pekka!
>
> Here is the delta to fold into the above:
>
> [ btw, do these require an extra SOB?  If so:
>  Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
>
>  And for http://lkml.org/lkml/2009/2/16/184:
>  Signed-off-by: Johannes Weiner <hannes@cmpxchg.org> ]
>
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2433,8 +2433,7 @@ mount_fail_check:
>  out:
>        /* zero out password before freeing */
>        if (volume_info) {
> -               if (volume_info->password != NULL)
> -                       kzfree(volume_info->password);
> +               kzfree(volume_info->password);
>                kfree(volume_info->UNC);
>                kfree(volume_info->prepath);
>                kfree(volume_info);
> --- a/fs/cifs/misc.c
> +++ b/fs/cifs/misc.c
> @@ -97,8 +97,7 @@ sesInfoFree(struct cifsSesInfo *buf_to_f
>        kfree(buf_to_free->serverOS);
>        kfree(buf_to_free->serverDomain);
>        kfree(buf_to_free->serverNOS);
> -       if (buf_to_free->password)
> -               kzfree(buf_to_free->password);
> +       kzfree(buf_to_free->password);
>        kfree(buf_to_free->domainName);
>        kfree(buf_to_free);
>  }
> @@ -130,8 +129,7 @@ tconInfoFree(struct cifsTconInfo *buf_to
>        }
>        atomic_dec(&tconInfoAllocCount);
>        kfree(buf_to_free->nativeFileSystem);
> -       if (buf_to_free->password)
> -               kzfree(buf_to_free->password);
> +       kzfree(buf_to_free->password);
>        kfree(buf_to_free);
>  }
>



--
Thanks,

Steve
