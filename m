Return-Path: <linux-kernel-owner+w=401wt.eu-S1755704AbYFYSog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704AbYFYSog (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 14:44:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752198AbYFYSo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 14:44:28 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:35941 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124AbYFYSo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 14:44:27 -0400
Date: Wed, 25 Jun 2008 13:44:09 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Benjamin Thery <benjamin.thery@bull.net>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Biederman <ebiederm@xmission.com>,
       Daniel Lezcano <dlezcano@fr.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
       linux-kernel@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH 11/11] sysfs: user namespaces: fix bug with
	clone(CLONE_NEWUSER) with fairsched
Message-ID: <20080625184409.GA8353@us.ibm.com>
References: <20080618170729.808539948@theryb.frec.bull.fr> <20080618170731.746054454@theryb.frec.bull.fr> <485F0812.4090903@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <485F0812.4090903@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tejun Heo (htejun@gmail.com):
> Benjamin Thery wrote:
> > Mark the /sys/kernel/uids directory to be tagged so that processes in
> > different user namespaces can remount /sys and see their own uid
> > listings.
> > 
> > Without this patch, having CONFIG_FAIR_SCHED=y makes user namespaces
> > unusable, because when you 
> >   clone(CLONE_NEWUSER)
> > it will auto-create the root userid and try to create
> > /sys/kernel/uids/0.  Since that already exists from the parent user
> > namespace, the create fails, and the clone misleadingly ends up
> > returning -ENOMEM.
> > 
> > This patch fixes the issue by allowing each user namespace to remount
> > /sys, and having /sys filter the /sys/kernel/uid/ entries by user
> > namespace.
> > 
> > Signed-off-by: Serge Hallyn <serue@us.ibm.com>
> > Signed-off-by: Benjamin Thery <benjamin.thery@bull.net>
> 
> Ditto as patch #10.

Except the sysfs mount holds no refcount on the userns.  So as long as we
do the ida tagging as you suggested in your response to patch 6, there
should be no reference to the user_ns left in sysfs code.

The extra reference in patch #9 is for a light ref on the network
namespace.  I'm still not sure that needs to be there, since if the
network namespace goes away, it will properly unregister its sysfs
mounts.  Eric, Benjamin, I really don't see any use for the hold_net()
from sysfs.  What is it doing?

-serge
