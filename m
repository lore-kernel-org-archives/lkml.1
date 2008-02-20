Return-Path: <linux-kernel-owner+w=401wt.eu-S933932AbYBTWev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933932AbYBTWev (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 17:34:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755129AbYBTWee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 17:34:34 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:45331 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbYBTWec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 17:34:32 -0500
Date: Thu, 21 Feb 2008 00:34:30 +0200 (EET)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@kivilampi-30.cs.helsinki.fi
To: Vlad Yasevich <vladislav.yasevich@hp.com>
cc: Netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [RFC PATCH 7/8] [SCTP]: uninline sctp_add_cmd_sf
In-Reply-To: <47BCA6B8.5000904@hp.com>
Message-ID: <Pine.LNX.4.64.0802210020350.17063@kivilampi-30.cs.helsinki.fi>
References: <1203515238-22848-1-git-send-email-ilpo.jarvinen@helsinki.fi>
 <1203515238-22848-2-git-send-email-ilpo.jarvinen@helsinki.fi>
 <1203515238-22848-3-git-send-email-ilpo.jarvinen@helsinki.fi>
 <1203515238-22848-4-git-send-email-ilpo.jarvinen@helsinki.fi>
 <1203515238-22848-5-git-send-email-ilpo.jarvinen@helsinki.fi>
 <1203515238-22848-6-git-send-email-ilpo.jarvinen@helsinki.fi>
 <1203515238-22848-7-git-send-email-ilpo.jarvinen@helsinki.fi>
 <1203515238-22848-8-git-send-email-ilpo.jarvinen@helsinki.fi>
 <47BCA6B8.5000904@hp.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-696243703-1782606873-1203546870=:17063"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---696243703-1782606873-1203546870=:17063
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Wed, 20 Feb 2008, Vlad Yasevich wrote:

> Ilpo Järvinen wrote:
> > I added inline to sctp_add_cmd and appropriate comment there to
> > avoid adding another call into the call chain. This works at least
> > with "gcc (GCC) 4.1.2 20070626 (Red Hat 4.1.2-13)". Alternatively,
> > __sctp_add_cmd could be introduced to .h.
> > 
> 
> My only concern was performance regressions, but it looks like it
> doesn't effect anything from the few quick runs I've made.

There was one call made anyway, it's a bit hard to see how it would hurt 
to push that BUG() deeper down (in fact, this is one of the easiest case 
in this respect, many other cases elsewhere that need uninlining don't 
currently make any calls with inlines).

> Since we are putting sctp_add_cmd_sf() on the call stack, we might
> as well get rid of sctp_add_cmd() and reduce it a bit more.

IMHO it is definately better solution for archiving the size reduction,
I just didn't know before that the only sctp_add_cmd call could be 
converted.

[...snip...]
> diff --git a/net/sctp/command.c b/net/sctp/command.c
> index bb97733..3a06513 100644
> --- a/net/sctp/command.c
> +++ b/net/sctp/command.c
> @@ -51,19 +51,16 @@ int sctp_init_cmd_seq(sctp_cmd_seq_t *seq)
>  
>  /* Add a command to a sctp_cmd_seq_t.
>   * Return 0 if the command sequence is full.
> + *
> + * Inline here is not a mistake, this way sctp_add_cmd_sf doesn't need extra
> + * calls, size penalty is of insignificant magnitude here

This won't be a necessary note anymore. :-)

[...snip...]

-- 
 i.
---696243703-1782606873-1203546870=:17063--
