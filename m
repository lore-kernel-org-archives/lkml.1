Return-Path: <linux-kernel-owner+w=401wt.eu-S1752813AbZGXMSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813AbZGXMSl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 08:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752673AbZGXMSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 08:18:41 -0400
Received: from smtp.nokia.com ([192.100.122.233]:26206 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669AbZGXMSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 08:18:40 -0400
Subject: Re: ubifs: error unwinding trouble
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Daniel Mack <daniel@caiaq.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>,
       "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
       "Bityutskiy Artem (Nokia-M/Helsinki)" <Artem.Bityutskiy@nokia.com>
In-Reply-To: <4A6991A5.4020105@nokia.com>
References: <20090724103038.GN19257@buzzloop.caiaq.de>
	 <4A6991A5.4020105@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 24 Jul 2009 15:17:46 +0300
Message-Id: <1248437866.24676.79.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 24 Jul 2009 12:18:17.0222 (UTC) FILETIME=[D31FEA60:01CA0C58]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-24 at 13:49 +0300, Adrian Hunter wrote:
> Daniel Mack wrote:
> > On a recent git kernel, the error unwinding for UBIFS seems to have some
> > problem, most probably a double-free or something similar.
> > 
> > When UBI is pointed to the right mtd partition (using command line
> > arguments) , everything is fine. But when it's (accidentionally) set to
> > some very small mtd, the attach process fails. Which wouldn't be a bad
> > thing by itself, but it somehow messes up the slub/slab allocators then
> > which causes very strange memory corruption effects - see the backtrace
> > below.
> > 
> > The Ooops itself is unreleated to UBI, but it does not occur when UBI
> > succeeds in attaching the volume.
> > 
> > Any idea? I searched for awhile but couldn't see anything obvious.
> 
> Looks like a double free of the eba_tbl
> 
> This might help:
> 
> diff --git a/drivers/mtd/ubi/eba.c b/drivers/mtd/ubi/eba.c
> index 0f2034c..e4d9ef0 100644
> --- a/drivers/mtd/ubi/eba.c
> +++ b/drivers/mtd/ubi/eba.c
> @@ -1254,6 +1254,7 @@ out_free:
>                 if (!ubi->volumes[i])
>                         continue;
>                 kfree(ubi->volumes[i]->eba_tbl);
> +               ubi->volumes[i]->eba_tbl = NULL;
>         }
>         return err;
>  }

You are right. I've just pushed your patch to ubi-2.6.git/master.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

