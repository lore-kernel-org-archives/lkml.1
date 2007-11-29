Return-Path: <linux-kernel-owner+w=401wt.eu-S1760760AbXK2Pyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760760AbXK2Pyf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 10:54:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755470AbXK2Py1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 10:54:27 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:35692 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755230AbXK2Py1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 10:54:27 -0500
Date: Thu, 29 Nov 2007 10:54:26 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Kay Sievers <kay.sievers@vrfy.org>
cc: Cornelia Huck <cornelia.huck@de.ibm.com>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] kobject: make sure kobj->ktype is set before kobject_init
In-Reply-To: <1196333946.3242.214.camel@lov.site>
Message-ID: <Pine.LNX.4.44L0.0711291047300.4516-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007, Kay Sievers wrote:

> > And if someone calls kobject_put() after kobject_init() to clean up,
> > their release function will not be called if they didn't set the ktype.
> > So the check really belongs into kobject_init() IMO.

Right.  And even though cleaning up no longer needs to drop a reference
to the kset, it still might need to free the kobject's name.  So for 
example, either of these sequences:

	kobject_init();			kobject_set_name();
	kobject_set_name();		kobject_init();
	...				...
	kobject_free();			kobject_free();

would leak memory.

In fact, if we were designing the kobject API from scratch, I'd suggest 
making the ktype value an argument to kobject_init() so that it 
_couldn't_ be omitted.

> Hmm, will one expect that the whole object will also be free'd when we
> suggest to call kobject_put() to cleanup? That might be pretty
> unexpected, right?

I don't understand the question.  People _already_ expect the cleanup 
routine to free the kobject when the last reference is dropped.  Why 
should there be any confusion over this?

Alan Stern

