Return-Path: <linux-kernel-owner+w=401wt.eu-S1754541AbXLSNLK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541AbXLSNLK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 08:11:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752537AbXLSNK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 08:10:57 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:11287 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbXLSNK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 08:10:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PgnbAekqtmkyyxnelq245M/+HbAhBD7B884xwMBlHMSiU+yS/wiyxTaDr4Qh2jUI++Ork7yBTAZUTUix4BXaGt4xDc66Mbwyug8OfYTzeDrKT68kID0bnVveF9L1C6BYrHdFVfAAfdIPURE72+IoQ+1bFz0nvXlypnsvP/zDzEc=
Message-ID: <a44ae5cd0712190510h72998e1dj5b03a00461a554f3@mail.gmail.com>
Date: Wed, 19 Dec 2007 08:10:54 -0500
From: "Miles Lane" <miles.lane@gmail.com>
To: "Zhu Yi" <yi.zhu@intel.com>
Subject: Re: [ipw3945-devel] 2.6.24-rc5-mm1 -- INFO: possible circular locking dependency detected -- pm-suspend/5800 is trying to acquire lock
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
       "Len Brown" <len.brown@intel.com>, netdev <netdev@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       ipw3945-devel@lists.sourceforge.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Pavel Machek" <pavel@suse.cz>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <1198033082.2857.303.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a44ae5cd0712180603v2a37023dj714a8500c14c08de@mail.gmail.com>
	 <1197986886.4885.156.camel@johannes.berg>
	 <a44ae5cd0712180641n15ceae8bp977efe9a5b45e6bc@mail.gmail.com>
	 <1197989826.4885.169.camel@johannes.berg>
	 <1198033082.2857.303.camel@debian.sh.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 18, 2007 9:58 PM, Zhu Yi <yi.zhu@intel.com> wrote:
>
> On Tue, 2007-12-18 at 15:57 +0100, Johannes Berg wrote:
> > Thanks. This is a bug in iwlwifi.
> >
> > The problem is actually another case where my workqueue debugging with
> > lockdep is triggering a warning :))
> >
> > Here's the thing:
> >
> > iwl3945_cancel_deferred_work does
> >
> > cancel_delayed_work_sync(&priv->init_alive_start);
> >
> > (which is the "(&(&priv->init_alive_start)->work)" lock)
> >
> > but it is called from within a locked section of
> > mutex_lock(&priv->mutex); (locked from iwl3945_pci_suspend)
> >
> > On the other hand, the task that runs from the init_alive_start
> > workqueue is iwl3945_bg_init_alive_start() which will lock the same
> > mutex.
> >
> > So the deadlock condition is that you can be in
> > cancel_delayed_work_sync() above while the mutex is locked, and be
> > waiting for iwl_3945_bg_init_alive_start() which tries to lock the
> > mutex.
>
> Thanks for the analysis.
>
> Miles, please try the attached patch. I'll send a patch for both 3945
> and 4965 to linux-wireless later.

I tested it and it looks good here.  Thanks!

        Miles
