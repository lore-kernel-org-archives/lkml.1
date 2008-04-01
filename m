Return-Path: <linux-kernel-owner+w=401wt.eu-S1760618AbYDAVuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760618AbYDAVuf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 17:50:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757385AbYDAVuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 17:50:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48723 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753976AbYDAVuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 17:50:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH] PM: Introduce new top level suspend and hibernation callbacks (rev. 6)
Date: Tue, 1 Apr 2008 23:50:00 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Nigel Cunningham <ncunningham@crca.org.au>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Oliver Neukum <oliver@neukum.org>
References: <Pine.LNX.4.44L0.0804011653140.9362-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0804011653140.9362-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804012350.01407.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 1 of April 2008, Alan Stern wrote:
> On Tue, 1 Apr 2008, Rafael J. Wysocki wrote:
> 
> > > Does ..._ext_... mean extended? (external?) If 'extended' (or if not),
> > > does that imply that they're mutually exclusive alternatives for drivers
> > > to use?
> > 
> > 'ext' means 'extended'.  The idea is that the 'extended' version will be used
> > by bus types / driver types that don't need to implement the _noirq callbacks.
> 
> Something's wrong here.  This seems to say that the "extended" version
> has _fewer_ method pointers -- in which case it should be called 
> "restricted" instead.

No, it has more pointers.  Specifically, it is like

struct pm_ext_ops {
	struct pm_ops base;
	--additional pointers go here--
}
 
> > > So drivers can never validly fail to resume. That sounds fair enough. If
> > > the hardware has gone away while in lower power mode (USB, say), should
> > > the driver then just printk an error and return success?
> > 
> > I think so.
> > 
> > IMO, an error code returned by a driver's ->resume() should mean "the device
> > hasn't resumed and is presumably dead".  Otherwise, ->resume() should return
> > success.
> 
> If the device is gone, it doesn't much matter what resume() returns.

Yes, it does.  In that cases, the error code would tell the PM core not to attempt
to resume the device's children etc.  Otherwise, it's quite meaningless to the
PM core, because it really can mean anything and how's the PM core supposed
to handle _that_?

Either we decide that the error codes returned by ->resume() mean critical
errors or there's no point in returning error codes from ->resume() at all
(other than logging the errors by the core).

Well, that's getting confused.  I think I'll have to rework the patch not to
really handle the errors returned by ->resume() and friends, after all, but
I'll keep the reporting of them.

However, I'd like to add a recommendation that the _new_ "resume" callbacks
should only return errors in critical situations as the indication to the PM
core that something went _really_ wrong and the device in question is quite
surely unusable.

Thanks,
Rafael
