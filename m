Return-Path: <linux-kernel-owner+w=401wt.eu-S1030190AbXDPIuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030190AbXDPIuu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 04:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030192AbXDPIuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 04:50:50 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:15014 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030190AbXDPIut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 04:50:49 -0400
Date: Mon, 16 Apr 2007 10:53:16 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Tejun Heo <htejun@gmail.com>,
       Markus Rechberger <markus.rechberger@amd.com>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: How should an exit routine wait for release() callbacks?
Message-ID: <20070416105316.0b91c2fd@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <Pine.LNX.4.44L0.0704131049380.3407-100000@iolanthe.rowland.org>
References: <20070413162701.4e7342a9@gondolin.boeblingen.de.ibm.com>
	<Pine.LNX.4.44L0.0704131049380.3407-100000@iolanthe.rowland.org>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.8.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2007 11:24:58 -0400 (EDT),
Alan Stern <stern@rowland.harvard.edu> wrote:

> I have to admit, this is a puzzler.  I'm beginning to think there should 
> be two types of module references: Those which (like module dependency) 
> will prevent rmmod from running, and those which (like the one here) would 
> automatically be dropped by deregistration.  Then every kobject could have 
> an owner and could hold a reference of the second type to its owner until 
> its release routine returns.

This sounds like the most promising idea yet.

We could make kobject_add() bump up this second-type refcount (since
from now on it may be looked up). kobject_get()/kobject_put() wouldn't
need to grab an extra reference (we already have refcounting for this
object in place). kobject_cleanup() could do something like:

struct module * kobject_owner = kobj->owner;
...
call_release();
put_second_module_refcount(kobject_owner);

combined with the module unloading code waiting after calling the exit
function until the second type refcount dropped to 0. This would make
sure that the module is not deleted until the last release function has
been called.

The module would stay in memory (not be unloaded) until the last
kobject created by the module is deleted, but I think that is just what
we want. At least this doesn't mean that the module blocks its own
unloading.
