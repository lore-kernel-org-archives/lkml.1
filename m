Return-Path: <linux-kernel-owner+w=401wt.eu-S1751308AbXB1Uau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751308AbXB1Uau (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 15:30:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751900AbXB1Uat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 15:30:49 -0500
Received: from mail.screens.ru ([213.234.233.54]:53838 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308AbXB1Uat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 15:30:49 -0500
Date: Wed, 28 Feb 2007 23:30:28 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: vatsa@in.ibm.com, Aneesh Kumar <aneesh.kumar@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Pavel Machek <pavel@ucw.cz>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [RFC][PATCH 1/3] Freezer: Fix vfork problem
Message-ID: <20070228203028.GA131@tv-sign.ru>
References: <200702261139.59130.rjw@sisk.pl> <200702281157.28381.rjw@sisk.pl> <20070228110048.GA263@tv-sign.ru> <200702282036.36875.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702282036.36875.rjw@sisk.pl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28, Rafael J. Wysocki wrote:
>
> Okay, I have added a comment to freezer.h.  Please have a look.
>
>
> -extern void thaw_some_processes(int all);
> +/*
> + * The PF_FREEZER_SKIP flag should be set by a vfork parent right before it
> + * calls wait_for_completion(&vfork) and reset right after it returns from this
> + * function.  Next, the parent should call try_to_freeze() to freeze itself
> + * appropriately in case the child has exited before the freezing of tasks is
> + * complete.  However, we don't want kernel threads to be frozen in unexpected
> + * places, so we allow them to block freeze_processes() instead or to set
> + * PF_NOFREEZE if needed and PF_FREEZER_SKIP is only set for userland vfork
> + * parents.  Fortunately, in the ____call_usermodehelper() case the parent won't
> + * really block freeze_processes(), since ____call_usermodehelper() (the child)
> + * does a little before exec/exit and it can't be frozen before waking up the
> + * parent.
> + */

I think this comment is accurate and understandable, and I am not suggesting
to change it.

However, please note that PF_FREEZER_SKIP can be used not only for vfork().
For example, it seems to me we can also use freezer_...count() to solve the
problem with coredump. We can use the same "wait_for_completion_freezable"
pattern in exit_mm() and in coredump_wait(). (i do not claim this is a best
fix though).

Oleg.

