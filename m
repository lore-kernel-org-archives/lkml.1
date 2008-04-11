Return-Path: <linux-kernel-owner+w=401wt.eu-S1760293AbYDKKnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760293AbYDKKnA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 06:43:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758939AbYDKKmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 06:42:52 -0400
Received: from mail29.messagelabs.com ([216.82.249.147]:40478 "HELO
	mail29.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758703AbYDKKmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 06:42:51 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-14.tower-29.messagelabs.com!1207910571!10615206!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.21]
Date: Fri, 11 Apr 2008 12:41:54 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: "Hans J. Koch" <hjk@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] [RFC] UIO: generic platform driver
Message-ID: <20080411104154.GA18986@digi.com>
References: <1207831023-8583-1-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-2-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-3-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-4-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-5-git-send-email-Uwe.Kleine-Koenig@digi.com> <20080410224804.GI3193@local> <20080411062106.GA18096@digi.com> <20080411092449.GB3185@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080411092449.GB3185@local>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 11 Apr 2008 10:41:54.0493 (UTC) FILETIME=[A89CBED0:01C89BC0]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-5.000.1023-15842.003
X-TM-AS-Result: No--15.145700-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Hans,

Hans J. Koch wrote:
> On Fri, Apr 11, 2008 at 08:21:06AM +0200, Uwe Kleine-König wrote:
> > > > +	for (i = 0; i < pdev->num_resources; ++i) {
> > > > +		struct resource *r = &pdev->resource[i];
> > > 
> > > Please don't define new variables in the middle of a function.
> > This is a matter of taste.  In my eyes it's better to declare it here
> > because then it's easier to see where it's used.
> 
> No. It's more important to see which variables are declared in the
> function and which are declared elsewhere. If you have to search the
> whole body of a function for possible declarations, this is BAD. And if
> it's not clear where a variable is used, the function is too long or has
> other style problems. Your function is short and clean, so where's the
> problem? Please move the declaration to the top of the function.
I'm not conviced and still prefer it that way.  I gave way for your
requests in uio.c because it's your code.  I want to leave it as it is
and hope you will accept that (as this is my code).

> > BTW would you be open to redefine uio_info as:
> > 
> > 	struct uio_info {
> > 		struct uio_device       *uio_dev;
> > 		...
> > 		size_t			num_memmaps;
> > 		struct uio_mem		mem[];
> > 	}
> > 
> > This allows to allocate exactly the number of members in the mem array
> > that are needed (for the cost of a size_t).  (You just do:
> > 
> > 	uio_info uioinfo = kzalloc(sizeof(*uioinfo) + num_memmaps * sizeof(uioinfo->mem[0]), GFP_KERNEL);
> > 
> > it's still one chunk of memory and usage is similar---just with
> > MAX_UIO_MAPS substituted by uioinfo->num_memmaps.)
> 
> I don't like it. It makes things more complicated without any obvious
> gain.
Most use cases I imagine only use a single mapping, so the gain would be
to save 4 (or later more) 'struct uio_mem's per device.

>       sizeof(struct uio_info) would return wrong values,
For which definition of wrong?  sizeof(struct uio_info) don't include
space for mem then, but in my eyes that's correct.  Having to care about
the size of mem is the burden when it's not constant.

>                                                          you need to
> free the extra memory,
There is no extra memory because uioinfo and it's mem member are
allocated together with a single kzalloc (and must be).  (Thats the
difference to

	struct uio_info {
		...
		size_t			num_memmaps;
		struct uio_mem		*mem;
	};

.)
>                        userspace applications need to be able to deal
> with 10000 mappings...
For the userspace it's exactly the same, isn't it?

Best regards
Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
