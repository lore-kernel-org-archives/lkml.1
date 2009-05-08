Return-Path: <linux-kernel-owner+w=401wt.eu-S1764001AbZEHVyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764001AbZEHVyn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 17:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567AbZEHVyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 17:54:35 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:65330 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbZEHVye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 17:54:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=aUbZifjOrTJ45YXqxYKut3bgywiahS5D0//CD3WspGIeisO53Ob2k6gXTCRNQH/XMt
         JJB9SG9w7RMOWdTeB1jOoC/l4cY0VAGXK8Fpl39uV8/l1UxI6cq1o6m+Nimxli4vBOD6
         +jGDE2kaoivJiS2O2BiKfwArypPXw2TCG8klc=
MIME-Version: 1.0
Date: Fri, 8 May 2009 17:54:34 -0400
Message-ID: <6041d2000905081454x4c9d8818oaccbcd14d1f4a506@mail.gmail.com>
Subject: Regression in 2.6.30 - /dev/pts - mount options - bisected
From: Marc Dionne <marc.c.dionne@gmail.com>
To: linux-kernel@vger.kernel.org, sukadev@linux.vnet.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I ran into a regression from 2.6.29 to 2.6.30 on a newly installed
fedora 11 machine.  The symptom is that things that require /dev/pts
(gnome-terminal, konsole, xterm, etc.) don't work for a regular user,
but run fine as root.  Everything is fine with the fedora 2.6.29
kernel or with a self-compiled 2.6.29, but fail with a recent
2.6.30-rc.

Bisection pinpoints this commit:
http://git.kernel.org/linus/1bd7903560f1f713e85188a5aaf4d2428b6c8b50
as the culprit, although I think that's a bit misleading.

The commit moves code around, and along the way replaces this:

  memcpy(&fsi->mount_opts, opts, sizeof(opts))

in one function where opts is a (struct pts_mount_opts *) - 8 bytes,
clearly an error, with

  memcpy(&(DEVPTS_SB(s))->mount_opts, &opts, sizeof(opts));

in a different function where opts is an actual structure (24 bytes),
which looks like what was intended.  So fixing the copy of the mount
options triggers the problem, and the real cause is probably
neighbouring commits in the same patch set.  I confirmed that using
sizeof(&opts) in the above memcpy makes the problem go away (but is
obviously not a solution).

Note that I have CONFIG_DEVPTS_MULTIPLE_INSTANCES=y.  It may be that
user space is doing something unusual, but it passes the test of
"works with 2.6.29, fails with 2.6.30".

I wasn't able to reproduce on an other system with a similar configuration.

Marc
