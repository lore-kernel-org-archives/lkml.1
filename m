Return-Path: <linux-kernel-owner+w=401wt.eu-S1755964AbYDJHgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964AbYDJHgn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 03:36:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbYDJHgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 03:36:35 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:51529 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbYDJHgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 03:36:35 -0400
Subject: Re: [RFC][PATCH 0/7] Clone PTS namespace
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Containers <containers@lists.osdl.org>,
       clg@fr.ibm.com, linux-kernel@vger.kernel.org,
       Pavel Emelyanov <xemul@openvz.org>
In-Reply-To: <20080410015955.GA18227@sergelap.austin.rr.com>
References: <20080408215333.GA8799@us.ibm.com> <47FC138B.4070408@zytor.com>
	 <1207779313.16926.12.camel@x61.ebiederm.org>
	 <20080410015955.GA18227@sergelap.austin.rr.com>
Content-Type: text/plain
Date: Thu, 10 Apr 2008 00:36:20 -0700
Message-Id: <1207812980.7509.25.camel@x61.ebiederm.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Rcpt-To: serue@us.ibm.com, hpa@zytor.com, containers@lists.osdl.org, clg@fr.ibm.com, linux-kernel@vger.kernel.org, xemul@openvz.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on mgr1.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-09 at 20:59 -0500, Serge E. Hallyn wrote:

> Feh, so of course sysfs would have the most interactions for a device
> namespace, but now we have pty, network, and user namespace all needing
> some sort of sysfs solution.  For a quickfix for
> CONFIG_USER_SCHED+CONFIG_USER_NS, I just moved /sys/kernel/uids/<uid>
> to /sys/kernel/uids/<userns_address>/<uid>.  But what would be a *good*
> general solution?
> 
> ln -s /sys /proc/self/sys?

LOL

In /proc I prefer the /proc/self approach because we can do it and it is
just much easier to setup and use.  (Plus we have weird problems if we
try and capture more then the pid namespace).

For other filesystems the only really viable option is to capture
namespaces at mount time, as we are doing for devpts and proc with
respect to the pid namespace.

For the network namespace where it is very much more then a single
directory with symlinks from physical devices pointing at logical
network interfaces.

My last effort in that area was ok'd by Tejun lightly tested by a few
others and misplaced by gregkh so I don't think we have a real problem
with resurrecting those patches cleaning them up a bit and merging them.

The biggest gotcha with sysfs is that the VFS locking for the dcache
is in the wrong order for distributed filesystems, where we would like
to make the change atomically on the server and them make the change in
the local cache.  Or in this case the sysfs internal data structures.
The truly nasty case is supporting rename (as sysfs does) as the VFS
is not at all happy if you just punt and shoot down the dentries and 
instantiate new ones.

I'm hoping to be able to get back at this in the week or so as things
settle down from my move.  My last patches should be in my proof of
concept network namespace tree, if they don't show up elsewhere.

It isn't my perception that we have a design problem rather, we just
need to move an important piece of code in a subtle and moderately
uninteresting direction for it's primary maintainer.  

Further what I did for the network namespace should easily handle the
uid/gid namespace and should be a good starting place for a general
device namespace.

Eric


