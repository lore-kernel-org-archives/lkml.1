Return-Path: <linux-kernel-owner+w=401wt.eu-S1750943AbXB1Wc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750943AbXB1Wc0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 17:32:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752153AbXB1WcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 17:32:25 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44785 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932605AbXB1WcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 17:32:23 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [RFC][PATCH 1/3] Freezer: Fix vfork problem
Date: Wed, 28 Feb 2007 23:34:41 +0100
User-Agent: KMail/1.9.5
Cc: vatsa@in.ibm.com, Aneesh Kumar <aneesh.kumar@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Pavel Machek <pavel@ucw.cz>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
References: <200702261139.59130.rjw@sisk.pl> <200702282036.36875.rjw@sisk.pl> <20070228203028.GA131@tv-sign.ru>
In-Reply-To: <20070228203028.GA131@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702282334.42684.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 28 February 2007 21:30, Oleg Nesterov wrote:
> On 02/28, Rafael J. Wysocki wrote:
> >
> > Okay, I have added a comment to freezer.h.  Please have a look.
> >
> >
> > -extern void thaw_some_processes(int all);
> > +/*
> > + * The PF_FREEZER_SKIP flag should be set by a vfork parent right before it
> > + * calls wait_for_completion(&vfork) and reset right after it returns from this
> > + * function.  Next, the parent should call try_to_freeze() to freeze itself
> > + * appropriately in case the child has exited before the freezing of tasks is
> > + * complete.  However, we don't want kernel threads to be frozen in unexpected
> > + * places, so we allow them to block freeze_processes() instead or to set
> > + * PF_NOFREEZE if needed and PF_FREEZER_SKIP is only set for userland vfork
> > + * parents.  Fortunately, in the ____call_usermodehelper() case the parent won't
> > + * really block freeze_processes(), since ____call_usermodehelper() (the child)
> > + * does a little before exec/exit and it can't be frozen before waking up the
> > + * parent.
> > + */
> 
> I think this comment is accurate and understandable, and I am not suggesting
> to change it.
> 
> However, please note that PF_FREEZER_SKIP can be used not only for vfork().

Yes, it can.

> For example, it seems to me we can also use freezer_...count() to solve the
> problem with coredump. We can use the same "wait_for_completion_freezable"
> pattern in exit_mm() and in coredump_wait(). (i do not claim this is a best
> fix though).

You're right, but in that comment I wanted to explain why it was done this way
rather than what else it could be used for.  There may be some uses of it that
we can't even anticipate right now. :-)

Rafael
