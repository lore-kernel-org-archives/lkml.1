Return-Path: <linux-kernel-owner+w=401wt.eu-S932202AbYB0XiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202AbYB0XiU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 18:38:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759557AbYB0XiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 18:38:11 -0500
Received: from el-out-1112.google.com ([209.85.162.182]:41137 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759007AbYB0XiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 18:38:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=RX6u4FzwGhimwM4e84GTDq3iVFehCSt0hJwJzNuIcA9X+EjK0Q3DFiuT+Dmh5n2nIfaKrE3FeY4sfyaMt55AJc2xZHpQYUF4eKC01ngVxv85e243n2c3uKVqZSQIh3YO6t+DLCpv3TsZJ1/2SjVk+ynOlbAS3C5q0Kmwug+aiyI=
Subject: Re: [PATCH] char: fix sparse variable shadowing and int as NULL
	pointer in rocket.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080227152948.34b6e295.akpm@linux-foundation.org>
References: <1203702419.5962.8.camel@brick>
	 <20080227152948.34b6e295.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 27 Feb 2008 15:38:07 -0800
Message-Id: <1204155487.20280.20.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-02-27 at 15:29 -0800, Andrew Morton wrote:
> On Fri, 22 Feb 2008 09:46:59 -0800
> Harvey Harrison <harvey.harrison@gmail.com> wrote:
> >
> > Subject: [PATCH] char: fix sparse variable shadowing and int as NULL pointer in rocket.c
> >
> 
> Please try to make the patch titles big-endian.  This one could have been
> 
> char: rocket.c: fix sparse variable shadowing and int as NULL pointer
> 

OK.

> or even
> 
> rocket.c: fix sparse variable shadowing and int as NULL pointer
> 
> > Nested min() macros shadow _x, separate into two lines.
> > drivers/char/rocket.c:451:7: warning: symbol '_x' shadows an earlier one
> > drivers/char/rocket.c:451:7: originally declared here
> > drivers/char/rocket.c:451:7: warning: symbol '_x' shadows an earlier one
> > drivers/char/rocket.c:451:7: originally declared here
> > drivers/char/rocket.c:451:7: warning: symbol '_y' shadows an earlier one
> > drivers/char/rocket.c:451:7: originally declared here
> > drivers/char/rocket.c:1754:7: warning: symbol '_x' shadows an earlier one
> > drivers/char/rocket.c:1754:7: originally declared here
> > drivers/char/rocket.c:1754:7: warning: symbol '_x' shadows an earlier one
> > drivers/char/rocket.c:1754:7: originally declared here
> > drivers/char/rocket.c:1754:7: warning: symbol '_y' shadows an earlier one
> > drivers/char/rocket.c:1754:7: originally declared here
> > drivers/char/rocket.c:1751:20: warning: Using plain integer as NULL pointer
> > 
> 
> That's really a sparse glitch.  There's nothing we can sanely do about it.
> 

Well, we can at least get rid of the warnings when min/max are nested.
I sent you a patch earlier today that uses different temp variables in
min/max/min_t/max_t to avoid this.  min/min and max/max nesting will
always see this.  I also introduced clamp()/clamp_t() in that patch
for use in libata and drivers/media.

> > ---
> >  drivers/char/rocket.c |    9 +++++----
> >  1 files changed, 5 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/char/rocket.c b/drivers/char/rocket.c
> > index 72f2892..2778d64 100644
> > --- a/drivers/char/rocket.c
> > +++ b/drivers/char/rocket.c
> > @@ -448,7 +448,8 @@ static void rp_do_transmit(struct r_port *info)
> >  	while (1) {
> >  		if (tty->stopped || tty->hw_stopped)
> >  			break;
> > -		c = min(info->xmit_fifo_room, min(info->xmit_cnt, XMIT_BUF_SIZE - info->xmit_tail));
> > +		c = min(info->xmit_fifo_room, info->xmit_cnt);
> > +		c = min(c, XMIT_BUF_SIZE - info->xmit_tail);
> 
> Apart from things like that.
> 
> Probably this code is cleaner than the old version so let's do it, but it
> seems that we need a general fix.

min3()?  No _good_ ideas I'm afraid.

Cheers,

Harvey

