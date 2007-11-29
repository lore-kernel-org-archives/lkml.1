Return-Path: <linux-kernel-owner+w=401wt.eu-S1762283AbXK2QGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762283AbXK2QGK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 11:06:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752574AbXK2QF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 11:05:57 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:57489 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbXK2QFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 11:05:55 -0500
Subject: Re: [PATCH] kobject: make sure kobj->ktype is set before
	kobject_init
From: Kay Sievers <kay.sievers@vrfy.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.44L0.0711291047300.4516-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0711291047300.4516-100000@iolanthe.rowland.org>
Content-Type: text/plain
Date: Thu, 29 Nov 2007 17:04:40 +0100
Message-Id: <1196352280.3118.11.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19QHzkDXMxxM6YLArQOz8Y3kvzIAlz1Dv6BVQt
 sGVoa2PMYR7oiLl3IJCDgsm3hgEsG5sJwsEybMXtqkOgOT/wrl
 8zZdlYSXseGGEtWLm9FKDc0atNoudZ3
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-11-29 at 10:54 -0500, Alan Stern wrote:
> On Thu, 29 Nov 2007, Kay Sievers wrote:
> 
> > > And if someone calls kobject_put() after kobject_init() to clean up,
> > > their release function will not be called if they didn't set the ktype.
> > > So the check really belongs into kobject_init() IMO.
> 
> Right.  And even though cleaning up no longer needs to drop a reference
> to the kset, it still might need to free the kobject's name.  So for 
> example, either of these sequences:
> 
> 	kobject_init();			kobject_set_name();
> 	kobject_set_name();		kobject_init();
> 	...				...
> 	kobject_free();			kobject_free();
> 
> would leak memory.

Yeah, only the kobject_put() would free the name.

> In fact, if we were designing the kobject API from scratch, I'd suggest 
> making the ktype value an argument to kobject_init() so that it 
> _couldn't_ be omitted.

Sounds fine, maybe we should also pass the name along, so it will be
obvious what happens here:
  int kobject_init(struct kobject *kobj, struct kobj_type *type, const char *fmt, ...)

> > Hmm, will one expect that the whole object will also be free'd when we
> > suggest to call kobject_put() to cleanup? That might be pretty
> > unexpected, right?
> 
> I don't understand the question.  People _already_ expect the cleanup 
> routine to free the kobject when the last reference is dropped.  Why 
> should there be any confusion over this?

Oh, if you want to rewind on error and have an initialized but still
unregistered kobject, and just want to free the allocated name by
calling kobject_cleanup() or kobject_put() you might not expect, that
your whole object that embeds the kobject will be gone. Just something
we need to document ...

Kay

