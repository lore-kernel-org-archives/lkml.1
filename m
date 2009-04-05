Return-Path: <linux-kernel-owner+w=401wt.eu-S1758916AbZDEEKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758916AbZDEEKz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 00:10:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758327AbZDEEHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 00:07:52 -0400
Received: from main.gmane.org ([80.91.229.2]:33878 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758318AbZDEEHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 00:07:37 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bojan Smojver <bojan@rexursive.com>
Subject: Re: Ext4 and the "30 second window of death"
Date: Sun, 5 Apr 2009 04:07:19 +0000 (UTC)
Message-ID: <loom.20090405T034232-367@post.gmane.org>
References: <200903291224.21380.info@gnebu.es> <20090331122540.GB13356@mit.edu> <loom.20090403T060217-420@post.gmane.org>
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

Bojan Smojver <bojan <at> rexursive.com> writes:

> Maybe it would be useful if we had IN_SYNC event in inotify

Or, maybe we can just (ab)use aio_fsync() for all this. This could be useful for
renaming of configuration files, less so for rsync (although it could be done
there too, I guess; rsync would just have to wait for synchronisation at the end
of the run). It would work like this:

1. Open "foo" and read it.
2. Open mktemp()-ed "foo.XXXXXX".
3. Write into the temp file.
4. Call aio_fsync().

Then, in the signal handler or the thread created on completion we'd have:

1. Rename the fully synced temp file into "foo".

If we made aio_fsync() wait in laptop mode for the regular commit interval,
instead of writing to disk right away (because it is an async interface after
all, so nobody expects it to finish immediately), we could preserve the normal
fsync() in laptop mode to mean write to disk now. DBs and similar stuff would
then get what they needed too, without complications.

For machines that are not laptops, with a constantly spinning disk and a decent
file system (such as ext4 :-), this should not be a problem performance wise.
And, the program asking for aio_fsync() could still continue without blocking,
therefore being fully interactive.

PS. Disclaimer: I never used this call in any of my programs, so I'm just
guessing that it works the way I understood the docs.

--
Bojan

