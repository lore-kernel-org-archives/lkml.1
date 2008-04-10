Return-Path: <linux-kernel-owner+w=401wt.eu-S1754401AbYDJFD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401AbYDJFD3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 01:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751607AbYDJFDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 01:03:19 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:5123 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbYDJFDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 01:03:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=h0jvFGE48vLKVWsd83+MDOVi4d/2Kx0OK0hXmSQewkLmhOGp9Itd1v8qadOhu5/40oWDTJDZWe0wZx8RkT7yJWFNel66p4K1j39/Ok1ZSX826j8aySA1l0R1CHi8az52HkoNAXv9NJBUHv08XwR6SkVYAih3mKrL6ovgDjaj4BI=
Message-ID: <cfd18e0f0804092203s33f0ca5as92f47c4db0b0220f@mail.gmail.com>
Date: Thu, 10 Apr 2008 07:03:18 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Davide Libenzi" <davidel@xmailserver.org>
Subject: Re: signalfd() not handling sigqueue() sigval data correctly
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0804091256490.6235@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47FBDF12.8090400@gmail.com>
	 <Pine.LNX.4.64.0804091256490.6235@alien.or.mcafeemobile.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Davide,

> > I was doing some playing about with signalfd(), and seem to have encountered a
> > bug: when a signalfd read() fetches data for a signal that was sent by
> > sigqueue(), the data accompanying the signal is not returned.  Instead
> > ssi_int/ssi_ptr is zero.
>
> Michael, can you give the patch below a spin? I tested it on my x86_64 box
> and seems to be working fine:
>
> Got signal 44
>   ssi_code= -1
>   ssi_pid = 6314
>   ssi_uid = 1000
>   ssi_int = 123
>   ssi_ptr = 7b

This works for me on x86-32.  Thanks Davide!

Cheers,

Michael

> ---
>  fs/signalfd.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> Index: linux-2.6.mod/fs/signalfd.c
> ===================================================================
> --- linux-2.6.mod.orig/fs/signalfd.c    2008-04-09 11:53:37.000000000 -0700
> +++ linux-2.6.mod/fs/signalfd.c 2008-04-09 12:05:46.000000000 -0700
> @@ -111,9 +111,14 @@
>                err |= __put_user(kinfo->si_uid, &uinfo->ssi_uid);
>                err |= __put_user((long) kinfo->si_ptr, &uinfo->ssi_ptr);
>                break;
> -       default: /* this is just in case for now ... */
> +       default:
> +               /*
> +                * This case catches also the signals queued by sigqueue().
> +                */
>                err |= __put_user(kinfo->si_pid, &uinfo->ssi_pid);
>                err |= __put_user(kinfo->si_uid, &uinfo->ssi_uid);
> +               err |= __put_user((long) kinfo->si_ptr, &uinfo->ssi_ptr);
> +               err |= __put_user(kinfo->si_int, &uinfo->ssi_int);
>                break;
>        }
>
>



-- 
Michael Kerrisk
Maintainer of the Linux man-pages project: http://www.kernel.org/doc/man-pages/
Want to report a man-pages bug? Look here:
http://www.kernel.org/doc/man-pages/reporting_bugs.html
