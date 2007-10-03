Return-Path: <linux-kernel-owner+w=401wt.eu-S1755837AbXJCFNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837AbXJCFNP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 01:13:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751438AbXJCFNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 01:13:00 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34753 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbXJCFM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 01:12:59 -0400
Date: Wed, 3 Oct 2007 06:12:54 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: torvalds@osdl.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@osdl.org, paul.moore@hp.com
Subject: Re: [PATCH] Version 4 (2.6.23-rc8-mm2) Smack: Simplified Mandatory Access Control Kernel
Message-ID: <20071003051254.GH8181@ftp.linux.org.uk>
References: <47031E76.6020801@schaufler-ca.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47031E76.6020801@schaufler-ca.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2007 at 09:45:42PM -0700, Casey Schaufler wrote:
> 
> From: Casey Schaufler <casey@schaufler-ca.com>
> 
> Smack is the Simplified Mandatory Access Control Kernel.
> 
> Smack implements mandatory access control (MAC) using labels
> attached to tasks and data containers, including files, SVIPC,
> and other tasks. Smack is a kernel based scheme that requires
> an absolute minimum of application support and a very small
> amount of configuration data.

I _really_ don't like what you are doing with these symlinks.
For one thing, you have no exclusion between reading the list
entries and modifying them.  For another...  WTF is filesystem
making assumptions about the locations where the things are
mounted?  Hell, even if you override your tmp symlink, what
happens if we want it in two chroot jails with different layouts?

I really don't get it; why not simply have something like
/smack/tmp.link resolve to tmp/<label> and have userland bind or mount
whatever you bloody like on /smack/tmp?  No problems with absolute
paths, can be used in chroot jails with whatever layouts, ditto for
namespaces, etc. and both symlink and directory get created at
the same time (by one name).  Hell, if you keep a reference
to dentry of directory in the data associated with symlink,
you can simply switch nd->dentry to that, drop the old one
and grab the reference to page containing label and return
it via nd_set_link().  No need to play with allocations, strcat,
yadda, yadda.  readlink() can stuff the ->d_name of the same
dentry plus / plus label directly into user buffer; again, no
allocations needed and works fine anywhere.
