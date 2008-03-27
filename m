Return-Path: <linux-kernel-owner+w=401wt.eu-S1760578AbYC0Qd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760578AbYC0Qd2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 12:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758412AbYC0QdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 12:33:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45987 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758370AbYC0QdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 12:33:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: benh@kernel.crashing.org
Subject: Re: [RFC][PATCH 1/3] PM: Introduce new top level suspend and hibernation callbacks (rev. 4)
Date: Thu, 27 Mar 2008 17:33:13 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Oliver Neukum <oliver@neukum.org>
References: <200803262353.30566.rjw@sisk.pl> <200803270223.06715.rjw@sisk.pl> <1206586358.6926.68.camel@pasglop>
In-Reply-To: <1206586358.6926.68.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803271733.14480.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 27 of March 2008, Benjamin Herrenschmidt wrote:
> 
> On Thu, 2008-03-27 at 02:23 +0100, Rafael J. Wysocki wrote:
> > On Thursday, 27 of March 2008, Benjamin Herrenschmidt wrote:
> > > 
> > > > > There is absolutely no point getting a second struct anymore.
> > > > 
> > > > I obviously disagree with that opinion, so please elaborate.
> > > 
> > > Well, what does it bring you ? Why can't it be one struct ? To save
> > > space in the data area ?
> > 
> > Mostly, but not only that.
> > 
> > There are users of 'struct pm_ops' that aren't even supposed to define the
> > _noirq callbacks (device types and device classes), so I thought it would be
> > better to introduce a separate _noirq struct after all.
> 
> Make sense... USB has no use of noirq for example.

Well, FWIW, we can also do something like this:

struct pm_ops {
	int (*prepare)(struct device *dev);
	void (*complete)(struct device *dev);
	int (*suspend)(struct device *dev);
	int (*resume)(struct device *dev);
	int (*freeze)(struct device *dev);
	int (*thaw)(struct device *dev);
	int (*poweroff)(struct device *dev);
	int (*restore)(struct device *dev);
};

struct pm_ext_ops {
	struct pm_ops base;
	int (*suspend_noirq)(struct device *dev);
	int (*resume_noirq)(struct device *dev);
	int (*freeze_noirq)(struct device *dev);
	int (*thaw_noirq)(struct device *dev);
	int (*poweroff_noirq)(struct device *dev);
	int (*restore_noirq)(struct device *dev);
};

and use 'struct pm_ext_ops' for the entities that may need to implement the
_noirq callbacks.  This way we'll avoid the duplication of "_noirq" in the code
pointed to by Alex and there will be one "pm" pointer per bus type, device
type, device class, etc.

Thoughts?

Thanks,
Rafael
