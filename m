Return-Path: <linux-kernel-owner+w=401wt.eu-S1758055AbYCWSmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055AbYCWSmf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 14:42:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754464AbYCWSmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 14:42:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51499 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941AbYCWSmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 14:42:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH] PM: Introduce new top level suspend and hibernation callbacks (rev. 2)
Date: Sun, 23 Mar 2008 19:41:39 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <Pine.LNX.4.44L0.0803222157550.13906-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0803222157550.13906-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803231941.41079.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 23 of March 2008, Alan Stern wrote:
> On Sun, 23 Mar 2008, Rafael J. Wysocki wrote:
> 
> > On Sunday, 23 of March 2008, Alan Stern wrote:
> > > On Sat, 22 Mar 2008, Rafael J. Wysocki wrote:
> > > 
> > [--snip--]
> > > 
> > > No, you have missed the entire point.  The problem doesn't exist in the
> > > current code; it exists only if we switch over to using a single list.  
> > > Routines like dpm_suspend() won't be able to use list_for_each_entry()
> > > to traverse the list because entries may be removed by other threads
> > > during the traversal.  Even list_for_each_entry_safe() won't work
> > > correctly without careful attention to details.
> > 
> > Ah, ok.  Thanks for the clarification.
> > 
> > Doesn't it help that we traverse the list under dpm_list_mtx?  Anyone who
> > removes an entry is required to take dpm_list_mtx that we're holding while
> > the list is traversed except when the callbacks are invoked.
> 
> It doesn't help.  What _does_ help is the fact that these traversals 
> are all serialized (since only one thread can carry out a system sleep 
> at any time).
> 
> > The only problem I see is when the device currently being handled is removed
> > from the list by a concurrent thread.  Is that you were referring to?
> 
> Yes, that is the problem.  If you try to work around it by using
> list_for_each_entry_safe() then you run into a problem when a
> concurrent thread removes the device _following_ the one being handled
> (or when the device being handled is the last one on the list and a
> concurrent thread registers a new device, which can only happen in
> dpm_prepare()).
> 
> It's not hard to fix.  Just something to be aware of.

Yes, I've almost finished a new patch taking that into account.  I'll send it
soon in a separate thread.
 
> P.S.: Oh yes, another related issue...  We should call get_device() and 
> put_device() while holding dpm_list_mtx.  Otherwise the device 
> structure might vanish when the callbacks are invoked.

Good idea.

Thanks,
Rafael
