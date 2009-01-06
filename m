Return-Path: <linux-kernel-owner+w=401wt.eu-S1752655AbZAFBNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbZAFBNd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 20:13:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbZAFBNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 20:13:21 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:41013 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119AbZAFBNU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 20:13:20 -0500
Message-Id: <20090106011314.534653345@us.ibm.com>
User-Agent: quilt/0.46-1
Date: Mon, 05 Jan 2009 17:13:14 -0800
From: Matt Helsley <matthltc@us.ibm.com>
To: Linux Containers <containers@lists.linux-foundation.org>
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
       Cedric Le Goater <clg@fr.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-nfs@vger.kernel.org, Trond Myklebust <trond.myklebust@fys.uio.no>,
       Chuck Lever <chuck.lever@oracle.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [RFC][PATCH 0/4] utsns: RPC/NFS bug rework
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series replaces the workaround for a bug reported by Cedric Le Goater 
<clg@fr.ibm.com> back in September:

> On a system with nfs mounts, if a task unshares its mount namespace,
> a oops can occur when the system is rebooted if the task is the last
> to unreference the nfs mount. It will try to create a rpc request
> using utsname() which has been invalidated by free_nsproxy().

Cedric worked around this bug by always using the initial uts namespace's
nodename (see commit: 63ffc23d307c9534c732edd87895e37b223004a3).

This is a non-ideal solution because uts namespace nodenames are reported
as the hostname during RPC authentication. Consider a machine configured
to export directories via NFS from a parent container to designated "trusted"
child containers. It would be unable to rely on the hostname during RPC
authentication -- forcing the administration of more advanced authentication
systems than might otherwise be necessary.

The goal of this series is to report a namespace's UTS nodename rather than 
the initial UTS namespace's nodename during RPC-call authentication -- much as
before Cedric's workaround. By changing the way that the nodename is cached and
fetched we can simultaneously avoid the NULL dereference during shutdown and
ensure that amalgamated RPC services (such as statd, lockd, mountd for NFS) see
a consistent nodename.

Cheers,
	-Matt Helsley

-- 
