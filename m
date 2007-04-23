Return-Path: <linux-kernel-owner+w=401wt.eu-S1753532AbXDWHF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbXDWHF3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 03:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753549AbXDWHF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 03:05:29 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:15992 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532AbXDWHF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 03:05:28 -0400
Date: Mon, 23 Apr 2007 09:08:10 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <htejun@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH RFD] alternative kobject release wait mechanism
Message-ID: <20070423090810.2fc0e864@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070422174051.GA21680@kroah.com>
References: <20070421000340.GB12155@kroah.com>
	<Pine.LNX.4.44L0.0704211654080.12439-100000@netrider.rowland.org>
	<20070422174051.GA21680@kroah.com>
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

On Sun, 22 Apr 2007 10:40:51 -0700,
Greg KH <greg@kroah.com> wrote:

> > Looking some more, kobject_get_path() is used for kobject renaming,
> > uevent handling, and a little bit in the input core.  None of these things 
> > should try to access a kobject after it has been del()ed.  After all, it's 
> > no longer present in the filesystem so it doesn't _have_ a path.
> 
> But we _have_ to have a full path at that time to tell userspace what
> just went away.  That is the main reason we enforce this (there were
> tons of issues with scsi devices and this in the past which is what
> caused us to enforce this.)

What we need to ensure is that the parent device is kept at least until
all children, grandchildren and so on are done with their uevent needs.
This would imply it needed to stay as long as those children,
grandchildren, ... are still registered. Would it be save to suggest
that a ->remove callback would always need to unregister the children?
Then putting the parent reference at the end of kobject_del() (which is
after kobject_uevent() in kobject_unregister()) should be safe.
