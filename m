Return-Path: <linux-kernel-owner+w=401wt.eu-S965552AbXBSXl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965552AbXBSXl4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 18:41:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965553AbXBSXlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 18:41:55 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55951 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965552AbXBSXlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 18:41:55 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: freezer problems
Date: Tue, 20 Feb 2007 00:35:59 +0100
User-Agent: KMail/1.9.5
Cc: ego@in.ibm.com, akpm@osdl.org, paulmck@us.ibm.com, mingo@elte.hu,
       vatsa@in.ibm.com, dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
References: <20070214144031.GA15257@in.ibm.com> <200702192221.35219.rjw@sisk.pl> <20070219224141.GB5070@tv-sign.ru>
In-Reply-To: <20070219224141.GB5070@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702200036.01515.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 19 February 2007 23:41, Oleg Nesterov wrote:
> On 02/19, Rafael J. Wysocki wrote:
> >
> > On Monday, 19 February 2007 21:23, Oleg Nesterov wrote:
> > 
> > > > @@ -199,6 +189,10 @@ static void thaw_tasks(int thaw_user_spa
> > > >
> > > >         do_each_thread(g, p) {
> > > > +               if (freezer_should_skip(p))
> > > > +                       cancel_freezing(p);
> > > > +       } while_each_thread(g, p);
> > > > +       do_each_thread(g, p) {
> > > >                 if (!freezeable(p))
> > > >                         continue;
> > > 
> > > Any reason for 2 separate do_each_thread() loops ?
> > 
> > Yes.  If there is a "freeze" request pending for the vfork parent (TIF_FREEZE
> > set), we have to cancel it before the child is unfrozen, since otherwise the
> > parent may go freezing after we try to reset PF_FROZEN for it.
> 
> I see, thanks... thaw_process() doesn't take TIF_FREEZE into account.
> 
> But doesn't this mean we have a race?
> 
> Suppose that try_to_freeze_tasks() failed. It does cancel_freezing() for each
> process before return, but what if some thread already checked TIF_FREEZE and
> (for simplicity) it is preempted before frozen_process() in refrigerator().
> 
> thaw_tasks() runs, ignores this task (P), returns. P gets CPU, and becomes
> frozen, but nobody will thaw it.
> 
> No?

Well, I think this is highly theoretical.  Namely, try_to_freeze_tasks() only
fails after the timeout that's currently set to 20 sec., and it yields the CPU
in each iteration of the main loop.  The task in question would have to refuse
being frozen for 20 sec. and then suddenly decide to freeze itself right before
try_to_freeze_tasks() checks the timeout for the very last time.  Then, it
would have to get preempted at this very moment and stay unfrozen at least
until thaw_tasks() starts running and in fact even longer.

I think we may avoid this by making try_to_freeze_tasks() sleep for some time
after it has reset TIF_FREEZE for all tasks in the error path, if anyone is
ever able to trigger it.

Greetings,
Rafael
