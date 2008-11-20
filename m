Return-Path: <linux-kernel-owner+w=401wt.eu-S1756719AbYKTVOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719AbYKTVOx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 16:14:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755061AbYKTVOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 16:14:44 -0500
Received: from fk-out-0910.google.com ([209.85.128.186]:37722 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743AbYKTVOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 16:14:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=dpaWaWp7w8AYPKEeQ2cO6RcdPr4mpqb36u9ftaXDWP0IwE1MVMJRtWKY/sM9TlzVxd
         5gEOj2kTPU6HEvDccquO3Ca/kzKQCPDn2kZoY2dGXa6GAXEU0uVcDbeA6HfprWKB3TJZ
         CDZo97IfiY6hPyzXv4+vY4vMkH56AOL05Yhv8=
Message-ID: <7c86c4470811201314q564b64c0i99f3d9865d9cc8f0@mail.gmail.com>
Date: Thu, 20 Nov 2008 22:14:40 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Markus Metzger" <markus.t.metzger@googlemail.com>
Subject: Re: [patch] x86, bts: fix unlock problem in ds.c
Cc: lkml <linux-kernel@vger.kernel.org>, work <markus.t.metzger@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <1226743217.6162.4.camel@raistlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1226743217.6162.4.camel@raistlin>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Markus,

I think this patch is not quite right. You don't want to go out via out_unlock
because you're going to call ds_put_context)() when you did not invoke the
matching ds_get_context() (hidden in ds_alloc_context). It happens later in
the ds_request() function.


On Sat, Nov 15, 2008 at 11:00 AM, Markus Metzger
<markus.t.metzger@googlemail.com> wrote:
> Fix a problem where ds_request() returned an error without releasing the
> ds lock.
>
> Reported-by: Stephane Eranian <eranian@gmail.com>
> Signed-off-by: Markus Metzger <markus.t.metzger@gmail.com>
> ---
>
> Index: gits/arch/x86/kernel/ds.c
> ===================================================================
> --- gits.orig/arch/x86/kernel/ds.c      2008-11-15 10:51:51.000000000 +0100
> +++ gits/arch/x86/kernel/ds.c   2008-11-15 10:53:43.000000000 +0100
> @@ -384,8 +384,9 @@
>
>        spin_lock(&ds_lock);
>
> +       error = -EPERM;
>        if (!check_tracer(task))
> -               return -EPERM;
> +               goto out_unlock;
>
>        error = -ENOMEM;
>        context = ds_alloc_context(task);
>
>
>
