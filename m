Return-Path: <linux-kernel-owner+w=401wt.eu-S1760648AbYC0Rhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760648AbYC0Rhe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 13:37:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755448AbYC0RhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 13:37:24 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:40524 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755412AbYC0RhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 13:37:23 -0400
Date: Thu, 27 Mar 2008 12:36:47 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Andrew Morton <akpm@osdl.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cgroups: devices: add Documentation/ file
Message-ID: <20080327173647.GA8169@sergelap.austin.ibm.com>
References: <20080327151227.GA11581@sergelap.austin.ibm.com> <20080327085837.c51ebe6d.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080327085837.c51ebe6d.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Randy Dunlap (randy.dunlap@oracle.com):
> On Thu, 27 Mar 2008 10:12:27 -0500 Serge E. Hallyn wrote:
> 
> > Fill a Documentation/controllers/devices.txt file with a
> > modified text from the patch description.
> > 
> > Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
> > ---
> >  Documentation/controllers/devices.txt |   48 +++++++++++++++++++++++++++++++++
> >  1 files changed, 48 insertions(+), 0 deletions(-)
> >  create mode 100644 Documentation/controllers/devices.txt
> > 
> > diff --git a/Documentation/controllers/devices.txt b/Documentation/controllers/devices.txt
> > new file mode 100644
> > index 0000000..a157f53
> > --- /dev/null
> > +++ b/Documentation/controllers/devices.txt
> > @@ -0,0 +1,48 @@
> > +Device Whitelist Controller
> > +
> > +1. Description:
> > +
> 
> ...
> 
> > +The root device cgroup starts with rwm to 'all'.  A child devices
> 
>                                                              device's

That's actually not right, but 'child device cgroup' does sound better.

> 
> > +cgroup gets a copy of the parent.  Administrators can then remove
> > +devices from the whitelist or add new entries.  A child cgroup can
> > +never receive a device access which is denied its parent.  However
> > +when a device access is removed from a parent it will not also be
> > +removed from the child(ren).
> > +
> > +2. User Interface
> > +
> ...
> > +
> > +3. Security
> > +
> > +Any task can move itself between cgroups.  This of clearly won't
> 
> s/of//

Yup, oops.

New patch attached.  Thanks, Randy.

-serge

> > +suffice, but we can decide the best way to adequately restrict
> > +movement as people get some experience with this.  We may just want
> > +to require CAP_SYS_ADMIN, which at least is a separate bit from
> > +CAP_MKNOD.  We may want to just refuse moving to a cgroup which
> > +isn't a descendent of the current one.  Or we may want to use
> > +CAP_MAC_ADMIN, since we really are trying to lock down root.
> > +
> > +CAP_SYS_ADMIN is needed to modify the whitelist or move another
> > +task to a new cgroup.  (Again we'll probably want to change that).
> > +
> > +A cgroup may not be granted more permissions than the cgroup's
> > +parent has.  
> > -- 
> 
> ---
> ~Randy


>From c5a7bd6599ebe47b8711ba66b1c41a81935a12af Mon Sep 17 00:00:00 2001
From: Serge E. Hallyn <serue@us.ibm.com>
Date: Thu, 27 Mar 2008 08:11:10 -0700
Subject: [PATCH 1/1] cgroups: devices: add Documentation/ file

Fill a Documentation/controllers/devices.txt file with a
modified text from the patch description.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
---
 Documentation/controllers/devices.txt |   48 +++++++++++++++++++++++++++++++++
 1 files changed, 48 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/controllers/devices.txt

diff --git a/Documentation/controllers/devices.txt b/Documentation/controllers/devices.txt
new file mode 100644
index 0000000..a157f53
--- /dev/null
+++ b/Documentation/controllers/devices.txt
@@ -0,0 +1,48 @@
+Device Whitelist Controller
+
+1. Description:
+
+Implement a cgroup to track and enforce open and mknod restrictions
+on device files.  A device cgroup associates a device access
+whitelist with each cgroup.  A whitelist entry has 4 fields.
+'type' is a (all), c (char), or b (block).  'all' means it applies
+to all types and all major and minor numbers.  Major and minor are
+either an integer or * for all.  Access is a composition of r
+(read), w (write), and m (mknod).
+
+The root device cgroup starts with rwm to 'all'.  A child device
+cgroup gets a copy of the parent.  Administrators can then remove
+devices from the whitelist or add new entries.  A child cgroup can
+never receive a device access which is denied its parent.  However
+when a device access is removed from a parent it will not also be
+removed from the child(ren).
+
+2. User Interface
+
+An entry is added using devices.allow, and removed using
+devices.deny.  For instance
+
+	echo 'c 1:3 mr' > /cgroups/1/devices.allow
+
+allows cgroup 1 to read and mknod the device usually known as
+/dev/null.  Doing
+
+	echo a > /cgroups/1/devices.deny
+
+will remove the default 'a *:* mrw' entry.
+
+3. Security
+
+Any task can move itself between cgroups.  This clearly won't
+suffice, but we can decide the best way to adequately restrict
+movement as people get some experience with this.  We may just want
+to require CAP_SYS_ADMIN, which at least is a separate bit from
+CAP_MKNOD.  We may want to just refuse moving to a cgroup which
+isn't a descendent of the current one.  Or we may want to use
+CAP_MAC_ADMIN, since we really are trying to lock down root.
+
+CAP_SYS_ADMIN is needed to modify the whitelist or move another
+task to a new cgroup.  (Again we'll probably want to change that).
+
+A cgroup may not be granted more permissions than the cgroup's
+parent has.  
-- 
1.5.1

