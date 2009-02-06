Return-Path: <linux-kernel-owner+w=401wt.eu-S1759983AbZBFQck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759983AbZBFQck (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 11:32:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753048AbZBFQca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 11:32:30 -0500
Received: from mx2.redhat.com ([66.187.237.31]:57689 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752776AbZBFQc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 11:32:29 -0500
Message-ID: <498C6613.1030400@redhat.com>
Date: Fri, 06 Feb 2009 10:32:19 -0600
From: David Smith <dsmith@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: jmorris@namei.org, linux-kernel@vger.kernel.org, roland@redhat.com,
       fche@redhat.com, oleg@redhat.com, linux-security-module@vger.kernel.org
Subject: Re: [PATCH] CRED: Fix SUID exec regression
References: <20090206114546.4255.74054.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090206114546.4255.74054.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> The patch:
> 
> 	commit a6f76f23d297f70e2a6b3ec607f7aeeea9e37e8d
> 	CRED: Make execve() take advantage of copy-on-write credentials
> 
> moved the place in which the 'safeness' of a SUID/SGID exec was performed to
> before de_thread() was called.  This means that LSM_UNSAFE_SHARE is now
> calculated incorrectly.  This flag is set if any of the usage counts for
> fs_struct, files_struct and sighand_struct are greater than 1 at the time the
> determination is made.  All of which are true for threads created by the
> pthread library.
> 
> However, since we wish to make the security calculation before irrevocably
> damaging the process so that we can return it an error code in the case where
> we decide we want to reject the exec request on this basis, we have to make the
> determination before calling de_thread().
> 
> So, instead, we count up the number of threads (CLONE_THREAD) that are sharing
> our fs_struct (CLONE_FS), files_struct (CLONE_FILES) and sighand_structs
> (CLONE_SIGHAND/CLONE_THREAD) with us.  These will be killed by de_thread() and
> so can be discounted by check_unsafe_exec().

...

> Reported-by: David Smith <dsmith@redhat.com>
> Signed-off-by: David Howells <dhowells@redhat.com>

I've tested this patch (applied on top of v2.6.29-rc3-634-g9be260a) and
it applies correctly and fixes the problem.  David, thanks for fixing this.

Acked-by: David Smith <dsmith@redhat.com>

-- 
David Smith
dsmith@redhat.com
Red Hat
http://www.redhat.com
256.217.0141 (direct)
256.837.0057 (fax)
