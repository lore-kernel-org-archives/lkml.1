Return-Path: <linux-kernel-owner+w=401wt.eu-S932247AbXB1SjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247AbXB1SjU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 13:39:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932249AbXB1SjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 13:39:20 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43846 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932247AbXB1SjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 13:39:18 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ego@in.ibm.com
Subject: Re: Problem with freezable workqueues
Date: Wed, 28 Feb 2007 19:41:23 +0100
User-Agent: KMail/1.9.5
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Pavel Machek <pavel@ucw.cz>, Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>
References: <200702272251.28844.rjw@sisk.pl> <20070228030726.GK29179@in.ibm.com> <20070228181703.GC7021@in.ibm.com>
In-Reply-To: <20070228181703.GC7021@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702281941.24698.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 28 February 2007 19:17, Gautham R Shenoy wrote:
> On Wed, Feb 28, 2007 at 08:37:26AM +0530, Srivatsa Vaddagiri wrote:
> > 
> > Hmm ..good point. So can we assume that disable/enable_nonboot_cpus() are called
> > with processes frozen already?
> > 
> > Gautham, you need to take this into account in your patchset!
> 
> Yup. That would mean making the freezer reentrant since we will
> be freezing twice (once for suspend and later on for hotplug). This is
> ok since the api in my patches looks like
> freeze_processes(int freeze_event);
> 
> But thaw will be interesting. If we are thawing for hotplug, we gotta
> only thaw processes which were frozen *only* for hotplug.
> 
> Rafael, does that mean more status flags?!

Well, I don't really think so, but we need to store some information in the
freezer (eg. in a status variable).  Namely, we can define a variable, say
tasks_frozen, the value of which will be the bitwise or of the flags
SPE_SUSPEND, SPE_HOTPLUG etc.  In a fully functional system, tasks_frozen
is equal to zero.  If freeze_processes(SPE_SUSPEND) is run, it does
tasks_frozen |= SPE_SUSPEND and analogously for SPE_HOTPLUG etc.
If tasks_frozen is equal to SPE_SUSPEND|SPE_HOTPLUG,  for example, and
thaw_tasks(SPE_HOTPLUG) runs, it only thaws the tasks that need not stay frozen
for the suspend and does tasks_frozen &= ~SPE_SUSPEND etc.

I think something like this should work.

Greetings,
Rafael 
