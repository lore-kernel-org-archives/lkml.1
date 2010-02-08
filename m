Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933847Ab0BHAvR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 19:51:17 -0500
Received: from smtp-out.google.com ([216.239.33.17]:43896 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757852Ab0BHAqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 19:46:34 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=A3C6K7hq6nT04Kra85UEcwP7uwFgeVrNvk7fJftC+hIHzteXIMNCtQGRbNBLPupj3
	mEiSGqRuuNZB8obqlBi8g==
Date: Sun, 7 Feb 2010 16:46:25 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: [Bug #15202] lockdep warning during elevator_switch
In-Reply-To: <alpine.LSU.2.00.1002072334290.22220@sister.anvils>
Message-ID: <alpine.DEB.2.00.1002071646150.4520@chino.kir.corp.google.com>
References: <4Ht3jFrT7uE.A.JI.-nzbLB@chimera> <445R0ey9hAI.A.h3.RozbLB@chimera> <alpine.LSU.2.00.1002072334290.22220@sister.anvils>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 Feb 2010, Hugh Dickins wrote:

> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.32.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15202
> > Subject		: lockdep warning during elevator_switch
> > Submitter	: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> > Date		: 2010-01-31 23:55 (8 days old)
> > References	: http://marc.info/?l=linux-kernel&m=126498212613051&w=4
> 
> Yes, still so in 2.6.33-rc7.
> 

This type of lock dependency is always going to exist whenever a write to 
a sysfs file causes the kernel to remove its dirent.  In this case, 
writing to /sys/devices/block/xxx/queue/scheduler takes sd->dep_map and 
sd->parent->dep_map via sysfs_get_active_two() to pin both via 
sysfs_write_file().  The call to kobject_del() removes its directory 
from the hierarchy which takes sd->dep_map in sysfs_deactivate() because 
of 846f99749a.  Eric, do we need to preempt the rwsem from being acquired 
here when the dirent is already pinned because of a store to one of its 
files?
