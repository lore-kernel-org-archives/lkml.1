Return-Path: <linux-kernel-owner+w=401wt.eu-S935107AbXGYTNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935107AbXGYTNv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 15:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761004AbXGYTNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 15:13:41 -0400
Received: from wr-out-0506.google.com ([64.233.184.225]:58973 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760956AbXGYTNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 15:13:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=iY5cq7/XVV/bsOThGLvP2WQuexxZ2VthfG5MVXypHHGnspaoOslKm18LcaK6F0yzfQTOyXlCx5wQTIYgidGR6yBCBSrJqXaaBAHFQoyVoYYfh7aLNSzQzbAK/6AN0kYr/kQ/mJqDrSoIwjNU7pMMsK9RC7MZ0ikwi7t3L7aUYRU=
Message-ID: <f158dc670707251213i65501f9eh6d35a8712583cd90@mail.gmail.com>
Date: Wed, 25 Jul 2007 13:13:34 -0600
From: "Latchesar Ionkov" <lucho@ionkov.net>
To: "Eric Van Hensbergen" <ericvh@gmail.com>
Subject: Re: net/9p/mux.c: use-after-free
Cc: "Adrian Bunk" <bunk@stusta.de>, v9fs-developer@lists.sourceforge.net,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <a4e6962a0707251143ie0b0ce8s7d4a9078fed7eb26@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070723012014.GV26212@stusta.de>
	 <a4e6962a0707251143ie0b0ce8s7d4a9078fed7eb26@mail.gmail.com>
X-Google-Sender-Auth: a269294c00286a8d
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yep, it's a leak.

Thanks,
    Lucho

On 7/25/07, Eric Van Hensbergen <ericvh@gmail.com> wrote:
> On 7/22/07, Adrian Bunk <bunk@stusta.de> wrote:
> > The Coverity checker spotted the following use-after-free
> > in net/9p/mux.c:
> >
> > <--  snip  -->
> >
> > ...
> > struct p9_conn *p9_conn_create(struct p9_transport *trans, int msize,
> >                                     unsigned char *extended)
> > {
> > ...
> >         if (!m->tagpool) {
> >                 kfree(m);
> >                 return ERR_PTR(PTR_ERR(m->tagpool));
> >         }
> > ...
> >
> > <--  snip  -->
> >
>
> I've got a fix for this one:
>         if (!m->tagpool) {
>                 mtmp = ERR_PTR(PTR_ERR(m->tagpool));
>                 kfree(m);
>                 return mtmp;
>         }
>
> but I was wondering about one of the other returns further down the function:
>
> ...
>         memset(&m->poll_waddr, 0, sizeof(m->poll_waddr));
>         m->poll_task = NULL;
>         n = p9_mux_poll_start(m);
>         if (n)
>                 return ERR_PTR(n);
>
>         n = trans->poll(trans, &m->pt);
> ...
>
> lucho: doesn't that constitute a leak?  Shouldn't we be doing:
>
>         if (n) {
>                 kfree(m);
>                 return ERR_PTR(n);
>         }
>
>          -eric
>
