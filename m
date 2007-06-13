Return-Path: <linux-kernel-owner+w=401wt.eu-S1757455AbXFMJZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455AbXFMJZr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 05:25:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756142AbXFMJZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 05:25:38 -0400
Received: from ms2.nttdata.co.jp ([163.135.193.237]:54470 "EHLO
	ms2.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140AbXFMJZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 05:25:37 -0400
X-Greylist: delayed 4336 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Jun 2007 05:25:36 EDT
Message-ID: <466FA71C.1020309@nttdata.co.jp>
Date: Wed, 13 Jun 2007 17:13:16 +0900
From: Toshiharu Harada <haradats@nttdata.co.jp>
Organization: NTT DATA CORPORATION
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [RFC] TOMOYO Linux
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Jun 2007 08:13:18.0069 (UTC) FILETIME=[B2D82A50:01C7AD92]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

A couple of years ago, we tried to build a tool to generate
SELinux policy (*1). To do that, we had to gather the access
requests information. So we researched a profiling method and
got to the idea of having a process to store its invocation
history information (or ancestors).

Here are examples:
/bin/bash process invoked from mingetty: /sbin/mingetty /bin/bash
/bin/bash process invoked from sshd: /usr/sbin/sshd /bin/bash
/bin/bash process invoked from /bin/bash which was invoked from sshd: /usr/sbin/sshd /bin/bash /bin/bash

It seemed to us that this clarification would be familiar to
users/administrators and could be used for various purposes.
We did implement this by making use of the Linux's traditional
fork & exec mechanisms, and built a pathname-based MAC using
this implementation. We named the result as "TOMOYO Linux"
and made it open source at SourceForge.jp (*2).

TOMOYO Linux kernel keeps track of process invocation and
distinguishes every different process invocation history as a "domain".
TOMOYO Linux can accumulate the accesses requests for each domain.

TOMOYO Linux has a utility called "ccstree". It prints the invocation
history for each process in addition to the output of "pstree" command:

[root@tomoyo ~]# ccstree
init (1) <kernel> /sbin/init
   +- udevd (388) <kernel> /sbin/udevd
   ...
   +- automount (1970) <kernel> /etc/rc.d/init.d/autofs /usr/sbin/automount
   +- acpid (1993) <kernel> /etc/rc.d/init.d/acpid /bin/bash /usr/sbin/acpid
   +- cupsd (2008) <kernel> /etc/rc.d/init.d/cups /bin/bash /usr/sbin/cupsd
   +- sshd (2026) <kernel> /usr/sbin/sshd
   +- sshd (2269) <kernel> /usr/sbin/sshd
     +- bash (2271) <kernel> /usr/sbin/sshd /bin/bash
       +- ccstree (15125) <kernel> /usr/sbin/sshd /bin/bash /root/ccstools/ccstree

   (symbol, "<kernel>" indicates a virtual base.)

We had a presentation and a tutorial session of TOMOYO Linux
version 1.4 at the ELC2007 (*3). Version 1.4.1 is the latest and
has a rich set of MAC functions for files, networking, and
capabilities and so on. For historical reasons, it is not using
LSM or auditd. We decided to share this idea with the Linux community
and totally rewrote the code. The result was TOMOYO Linux 2.0,
which is now using LSM and auditd. To make discussion smooth,
we cut off MAC functions other than for files.

We are posting this message because we believe that this process
invocation history idea might be a useful addition to Linux.
Please take some time to see what this small piece of software can do
with your own eyes. Your feedback will be greatly appreciated.

If some of you are interested in TOMOYO Linux as a method for
access control, please be advised to try full-featured version 1.4.1 (*4).
It is quite easy to install and maintain TOMOYO Linux, but it should
not be considered as a replacement of SELinux.

All right, that's almost everything. Please visit the following
URL for the code and documents:
   http://tomoyo.sourceforge.jp/wiki-e/
If you want to see the code first, then:
   http://tomoyo.sourceforge.jp/cgi-bin/lxr/source/security/tomoyo/?v=linux-2.6.21.3-tomoyo-2.0

We will have a TOMOYO Linux BOF session at the OLS2007 (*5).
Please come along and let's talk.

Thank you.

Toshiharu Harada (project manager)
Tetsuo Handa (main architect, version 1 author)
Kentaro Takeda (version 2.0 author)
NTT DATA CORPORATION
http://www.nttdata.co.jp/en/index.html

*1) http://sourceforge.jp/projects/tomoyo/document/nsf2003-en.pdf
*2) http://tomoyo.sourceforge.jp/
*3) http://www.celinux.org/elc2007/
     http://tree.celinuxforum.org/CelfPubWiki/ELC2007Presentations
*4) http://tomoyo.sourceforge.jp/en/1.4.1/
*5) http://www.linuxsymposium.org/2007/


