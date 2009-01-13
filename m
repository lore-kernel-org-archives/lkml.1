Return-Path: <linux-kernel-owner+w=401wt.eu-S1757975AbZAMXOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757975AbZAMXOx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 18:14:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758899AbZAMXO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 18:14:26 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:59167 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757782AbZAMXOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 18:14:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=G16VY3un5W8orpUsjBJCbph216QgRB6sFV0PyIUqlxyoAfRmQoSO/ftAls4TrUNSn5
         UyttaJSAUJFEmvaUcc7Y8sogg98gSX8SDJKZ/l/qN/ykDs1cpYOliuOxobJcRnN3Sc6o
         Ns7e24XkdNbv19/lodMKvORp/ETWqwJ1LfIqU=
Message-ID: <cfd18e0f0901131514i2f7be7f1t2c6275c26dbb6874@mail.gmail.com>
Date: Wed, 14 Jan 2009 12:14:20 +1300
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: "Roland McGrath" <roland@redhat.com>
Subject: Re: [PATCH] sys_waitid: return -EFAULT for NULL
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "Ulrich Drepper" <drepper@redhat.com>,
       "Vegard Nossum" <vegard.nossum@gmail.com>,
       "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>
In-Reply-To: <20090113224941.36F19FC3DD@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cfd18e0f0901131436ud2cf61bkf0e6b00f4b765bb5@mail.gmail.com>
	 <cfd18e0f0901131438n232ba114n27ea2d7964d071de@mail.gmail.com>
	 <20090113224759.7DFB7FC3DD@magilla.sf.frob.com>
	 <20090113224941.36F19FC3DD@magilla.sf.frob.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 11:49 AM, Roland McGrath <roland@redhat.com> wrote:
> It's always been invalid to call waitid() with a NULL pointer.  It was an
> oversight that it was allowed (and acts like a wait4() call instead).
>
> Signed-off-by: Roland McGrath <roland@redhat.com>

Modulo the observation that this change will break any Linux-specific
application that violate POSIX.1's requirement that infop not be NULL
(*), and rely on the existing Linux behavior for
waitd(idtype,id,NULL,options):

Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>

(*) It seems unlikely that such applications exist, and we really
should make this change for POSIX.1 conformance.

> ---
>  kernel/exit.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/kernel/exit.c b/kernel/exit.c
> index c7740fa..fa25790 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -1760,6 +1760,8 @@ asmlinkage long sys_waitid(int which, pid_t upid,
>        enum pid_type type;
>        long ret;
>
> +       if (unlikely(!infop))
> +               return -EFAULT;
>        if (options & ~(WNOHANG|WNOWAIT|WEXITED|WSTOPPED|WCONTINUED))
>                return -EINVAL;
>        if (!(options & (WEXITED|WSTOPPED|WCONTINUED)))
>



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
