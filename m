Return-Path: <linux-kernel-owner+w=401wt.eu-S1755995AbZDCHOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995AbZDCHOS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 03:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752097AbZDCHOB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 03:14:01 -0400
Received: from main.gmane.org ([80.91.229.2]:45945 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751271AbZDCHOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 03:14:00 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bojan Smojver <bojan@rexursive.com>
Subject: Re: Ext4 and the "30 second window of death"
Date: Fri, 3 Apr 2009 07:13:41 +0000 (UTC)
Message-ID: <loom.20090403T060217-420@post.gmane.org>
References: <200903291224.21380.info@gnebu.es> <20090331122540.GB13356@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 150.101.121.179 (Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.8) Gecko/2009032713 Fedora/3.0.8-1.fc10 Firefox/3.0.8)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso <tytso <at> mit.edu> writes:
 
> The replace-via-truncate and replace-via-rename workarounds are there
> for the benefit of KDE, and GNOME, which in some configurations
> apparently will replace hundreds of dot files when the desktop is
> started up, for no reason that I can understand.

Maybe it would be useful if we had IN_SYNC event in inotify (meaning all buffers
of a closed file have been synced to disk, either implicitly or by fsync() - not
important). Then we could have these apps to do something like this on
configuration change:

1. Backup by link("foo","foo~"), unless we are watching "foo" for IN_SYNC event.
2. Open "foo" and read it.
3. Create "foo.new" and put new stuff in it.
4. Close "foo.new".
5. Rename "foo.new" into "foo".
6. Put a watch on "foo" for IN_SYNC, unless we already have one.

In the regular loop of the app:

1. When the event IN_SYNC turns up for "foo", remove "foo~".
2. Remove the watch.

No fsync() in sight, all atomic and no chance of losing data. If things go
haywire, we shall have fully committed "foo~" on startup, which we then just
rename into most likely broken "foo" and continue. If we don't have "foo~", it
must mean "foo" is OK.

Something like this may even work for rsync (slightly different flow of events,
probably watching from another thread).

When throwing stones, please limit yourself to less than 5kg specimens... :-)

--
Bojan

