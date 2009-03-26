Return-Path: <linux-kernel-owner+w=401wt.eu-S1758609AbZCZQOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758609AbZCZQOq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 12:14:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753900AbZCZQOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 12:14:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45124 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752583AbZCZQOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 12:14:36 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090326155357.GS28946@ZenIV.linux.org.uk>
References: <20090326155357.GS28946@ZenIV.linux.org.uk> <13750.1237997653@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: dhowells@redhat.com, Kentaro Takeda <takedakn@nttdata.co.jp>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       Toshiharu Harada <haradats@nttdata.co.jp>, linux-kernel@vger.kernel.org
Subject: Re: Are path-based LSM hooks called from the wrong places?
Date: Thu, 26 Mar 2009 16:14:26 +0000
Message-ID: <18658.1238084066@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> wrote:

> If you start from inode (or dentry, for that matter), you don't *have*
> a pathname at all.

When I'm starting from a dentry, I do have a vfsmount as well - it's just that
vfs_mkdir() or whatever doesn't currently take it (which is perhaps reasonable
as NFSD and eCryptFS might not have it available).

> The real question is, do you want these checks to apply and if you do -
> which path do you want to use (esp. if you have multiple namespaces)?

The path to be used is straightforward: I do, after all, have a vfsmount, and
that plus dentry is all that is required for security_path_*() - which seems
slightly odd since it takes no account of chroot(), but that's probably fine.

As to whether these checks should be applied...  The SELinux ones need to be,
so I'd've thought the same would be true for TOMOYO.

Seems I might need to split such as sys_mkdirat() to separate the path lookup
from the security checks:-/

As I said, what I don't want to have to do is attempt to regenerate the full
pathname, especially if the pathname isn't accessible from within the current
process's chroot or namespace.

David
