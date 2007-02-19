Return-Path: <linux-kernel-owner+w=401wt.eu-S965133AbXBSWnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965133AbXBSWnZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 17:43:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965136AbXBSWnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 17:43:25 -0500
Received: from mail.screens.ru ([213.234.233.54]:60457 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965133AbXBSWnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 17:43:24 -0500
Date: Tue, 20 Feb 2007 01:41:41 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ego@in.ibm.com, akpm@osdl.org, paulmck@us.ibm.com, mingo@elte.hu,
       vatsa@in.ibm.com, dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
Subject: Re: freezer problems
Message-ID: <20070219224141.GB5070@tv-sign.ru>
References: <20070214144031.GA15257@in.ibm.com> <200702190019.23215.rjw@sisk.pl> <20070219202349.GA87@tv-sign.ru> <200702192221.35219.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702192221.35219.rjw@sisk.pl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19, Rafael J. Wysocki wrote:
>
> On Monday, 19 February 2007 21:23, Oleg Nesterov wrote:
> 
> > > @@ -199,6 +189,10 @@ static void thaw_tasks(int thaw_user_spa
> > >
> > >         do_each_thread(g, p) {
> > > +               if (freezer_should_skip(p))
> > > +                       cancel_freezing(p);
> > > +       } while_each_thread(g, p);
> > > +       do_each_thread(g, p) {
> > >                 if (!freezeable(p))
> > >                         continue;
> > 
> > Any reason for 2 separate do_each_thread() loops ?
> 
> Yes.  If there is a "freeze" request pending for the vfork parent (TIF_FREEZE
> set), we have to cancel it before the child is unfrozen, since otherwise the
> parent may go freezing after we try to reset PF_FROZEN for it.

I see, thanks... thaw_process() doesn't take TIF_FREEZE into account.

But doesn't this mean we have a race?

Suppose that try_to_freeze_tasks() failed. It does cancel_freezing() for each
process before return, but what if some thread already checked TIF_FREEZE and
(for simplicity) it is preempted before frozen_process() in refrigerator().

thaw_tasks() runs, ignores this task (P), returns. P gets CPU, and becomes
frozen, but nobody will thaw it.

No?

Oleg.

