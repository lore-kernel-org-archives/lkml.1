Return-Path: <linux-kernel-owner+w=401wt.eu-S1753105AbXDRUDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105AbXDRUDf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 16:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753154AbXDRUDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 16:03:35 -0400
Received: from takamine.ncl.cs.columbia.edu ([128.59.18.70]:43820 "EHLO
	takamine.ncl.cs.columbia.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753105AbXDRUDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 16:03:34 -0400
Date: Wed, 18 Apr 2007 16:03:19 -0400 (EDT)
From: Shaya Potter <spotter@cs.columbia.edu>
X-X-Sender: spotter@takamine.ncl.cs.columbia.edu
To: Crispin Cowan <crispin@novell.com>
cc: James Morris <jmorris@namei.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andi Kleen <andi@firstfloor.org>,
       Casey Schaufler <casey@schaufler-ca.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: AppArmor FAQ
In-Reply-To: <4626746A.9010701@novell.com>
Message-ID: <Pine.LNX.4.64.0704181552370.10574@takamine.ncl.cs.columbia.edu>
References: <20070417181016.GA10903@one.firstfloor.org>
 <657751.18080.qm@web36614.mail.mud.yahoo.com> <20070417211653.GB11944@one.firstfloor.org>
 <20070417225815.000b0fdb@the-village.bc.nu> <Line.LNX.4.64.0704180935100.25495@d.namei>
 <4626746A.9010701@novell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Apr 2007, Crispin Cowan wrote:

> Please explain why labels are necessary for effective confinement. Many
> systems besides AppArmor have used non-label schemes for effective
> confinement: TRON, Janus, LIDS, Systrace, BSD Jail, EROS, PSOS, KeyOS,
> AS400, to name just a few. This claim seems bogus. Labels may be your
> method of choice for confinement, but they are far from the only way.

One problem with AppArmor and Janus and Systrace and everything else that 
relies on pathname resolution is the point where they do the pathname 
resolution.

If you read the janus, systrace, subdomain (apparmor's predecssor?) 
papers, you'll see how they have to jump through hoops to handle things 
like symlinks, when there's no fundamental reason why they have to.

If one simply worked at the FS level, all one cares about is lookup() and 
permission.  You have a set of rules that lookup() is able to use to 
dynamically tag dentries and permission() then checks that tag.  One 
doesn't jump through hoops anymore.

So, while I sound like a broken record, something like a stackable file 
system works wonders here (I know, I implemented one).  Now, stackable 
file systems aren't perfect here (mount point crossing, additional mounted 
file systems on top of the stackable file system) can cause problems, 
overall it seems like a cleaner solution.

Another option would be if the LSM could be extended to allow a simple 
method of storing "private" data along with every dentry/inode (the main 
reason one needs a stackable file system).  In this way, if the lookup() 
oepration was extended to be able to take a function that filled in that 
data and permission() was able to be extended to take a function that 
could use that data, one wouldn't even need a stackable file system, but 
one would still be operating at the simplest layer (which is the file 
system).
