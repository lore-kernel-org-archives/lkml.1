Return-Path: <linux-kernel-owner+w=401wt.eu-S1763214AbYHERWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763214AbYHERWh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 13:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761615AbYHERUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 13:20:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56386 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761335AbYHERUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 13:20:15 -0400
Subject: RE: [malware-list] [RFC 0/5] [TALPA] Intro to a linux
	interfaceforon access scanning
From: Eric Paris <eparis@redhat.com>
To: "Press, Jonathan" <Jonathan.Press@ca.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, linux-security-module@vger.kernel.org
In-Reply-To: <2629CC4E1D22A64593B02C43E855530304807436@USILMS12.ca.com>
References: <1217883616.27684.19.camel@localhost.localdomain>
	 <20080804223249.GA10517@kroah.com>
	 <1217896374.27684.53.camel@localhost.localdomain>
	 <2629CC4E1D22A64593B02C43E855530304807431@USILMS12.ca.com>
	 <1217948212.27684.120.camel@localhost.localdomain>
	 <2629CC4E1D22A64593B02C43E855530304807436@USILMS12.ca.com>
Content-Type: text/plain
Date: Tue, 05 Aug 2008 13:19:56 -0400
Message-Id: <1217956796.11547.12.camel@paris.rdu.redhat.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-08-05 at 12:37 -0400, Press, Jonathan wrote:
> Regarding self-exclusion...  We are doing write-time scanning, or more
> accurately close-time scanning.  We don't block the close, but we do
> scan the file afterwards, and if it is infected, we perform any one of
> several actions -- such as report to user, rename, quarantine, delete,
> etc.  I would not want a self-excluded executable to be able to write
> something that I don't get to scan.

With the current implementation there are 2 ways to be excluded.  Both
require root and I plan on both requiring the access to pass a
newfangled LSM hook or maybe just require CAP_RAWIO.  LSM people have
thoughts?

Method #1)  Become a client listening for access decisions, basically
just open /security/talpa/client/talpa-client and you are free of
open/close scans.  We have to make the scanner itself not cause its own
opens and closes to need scanned, think infinite recursion.

Method #2) Exclude yourself.  This involves
opening /security/talpa/exclude/talpa-exclude and writing "1" into it.
this file is owned by root and is 600.  Regular user processes cannot
exclude themselves willy nilly nor can any configuration exclude them.
It might be possible to do exclusions in userspace using the pid and
non-caching results for things other than the scanning clients
themselves.

If you can outline the design of a better method that meets your needs
I'd be glad to try to code it.  In your mind how do you see programs
being able to exclude others while not being a security risk?  I assume
your answer is that the program "giving out the exclusions" must be
root, which we already satisfy.  There is (or could be, I don't remember
offhand) the option to disable thread exclusions in kernel (except for
those threads that act as userspace clients, they MUST be excluded
somehow).  But really as it stands any root process could just enable
them again.  In the non-LSM case root processes already won so, they can
just disable the whole infrastructure send kill -9 to all your clients
and have at it.....

-Eric

