Return-Path: <linux-kernel-owner+w=401wt.eu-S1753722AbZDOPap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722AbZDOPap (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 11:30:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751284AbZDOPag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 11:30:36 -0400
Received: from [212.69.161.110] ([212.69.161.110]:37348 "EHLO
	mail09.linbit.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbZDOPaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 11:30:35 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
Organization: LINBIT
To: Nikanth Karthikesan <knikanth@suse.de>
Subject: Re: [PATCH 02/14] DRBD: lru_cache
Date: Wed, 15 Apr 2009 17:29:36 +0200
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Greg KH <gregkh@suse.de>, Neil Brown <neilb@suse.de>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Andi Kleen <andi@firstfloor.org>, Sam Ravnborg <sam@ravnborg.org>,
       Dave Jones <davej@redhat.com>, "Lars Marowsky-Bree" <lmb@suse.de>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       Lars Ellenberg <lars.ellenberg@linbit.com>
References: <1239365545-10356-1-git-send-email-philipp.reisner@linbit.com> <1239365545-10356-3-git-send-email-philipp.reisner@linbit.com> <200904141724.07927.knikanth@suse.de>
In-Reply-To: <200904141724.07927.knikanth@suse.de>
X-OTRS-FollowUp-SenderType: agent
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904151729.38109.philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[...]
> > +struct lc_element *lc_find(struct lru_cache *lc, unsigned int enr)
> > +{
> > +	struct hlist_node *n;
> > +	struct lc_element *e;
> > +
> > +	BUG_ON(!lc);
> > +	BUG_ON(!lc->nr_elements);
>
> This BUG_ON() could be moved/added to lc_init().
>

You are right. Done.

> > +struct lc_element *lc_get(struct lru_cache *lc, unsigned int enr)
> > +{
> > +	struct lc_element *e;
> > +
> > +	BUG_ON(!lc);
> > +	BUG_ON(!lc->nr_elements);
> > +
> > +	PARANOIA_ENTRY();
> > +	if (lc->flags & LC_STARVING) {
> > +		++lc->starving;
> > +		RETURN(NULL);
> > +	}
> > +
>
> Even if LC_STARVING, the element could still be available in the cache?
> Shouldn't this check be done after lc_find()?
>

[...]
> > +/* similar to lc_get,
> > + * but only gets a new reference on an existing element.
> > + * you either get the requested element, or NULL.
> > + */
> > +struct lc_element *lc_try_get(struct lru_cache *lc, unsigned int enr)
> > +{
> > +	struct lc_element *e;
> > +
> > +	BUG_ON(!lc);
> > +	BUG_ON(!lc->nr_elements);
> > +
> > +	PARANOIA_ENTRY();
> > +	if (lc->flags & LC_STARVING) {
> > +		++lc->starving;
> > +		RETURN(NULL);
> > +	}
> > +
>
> This check shouldn't be done at all, as we are not at all trying to add a
> new element?
>

That check is okay. 

We set LC_STARVING if we need to change a cache slot to an other object
of the space of cacheable objects, but not a single slot was available.

If LC_STARVING is set we do not give out any further references, since we
want to finish that ongoing single object change first.

With this policy the changes in the LRU cache will never deadlock, and
eventually delay others trying to get new references to already cached 
objects.

-Phil
-- 
: Dipl-Ing Philipp Reisner
: LINBIT | Your Way to High Availability
: Tel: +43-1-8178292-50, Fax: +43-1-8178292-82
: http://www.linbit.com

DRBD(R) and LINBIT(R) are registered trademarks of LINBIT, Austria.

