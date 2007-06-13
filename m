Return-Path: <linux-kernel-owner+w=401wt.eu-S1758083AbXFMOHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758083AbXFMOHi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 10:07:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbXFMOHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 10:07:30 -0400
Received: from zombie.ncsc.mil ([144.51.88.131]:42468 "EHLO jazzdrum.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751761AbXFMOH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 10:07:29 -0400
Subject: Re: [RFC] TOMOYO Linux
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Toshiharu Harada <haradats@nttdata.co.jp>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
In-Reply-To: <466FA71C.1020309@nttdata.co.jp>
References: <466FA71C.1020309@nttdata.co.jp>
Content-Type: text/plain
Organization: National Security Agency
Date: Wed, 13 Jun 2007 10:07:15 -0400
Message-Id: <1181743635.17547.350.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-13 at 17:13 +0900, Toshiharu Harada wrote:
> Hello,
> 
> A couple of years ago, we tried to build a tool to generate
> SELinux policy (*1). To do that, we had to gather the access
> requests information. So we researched a profiling method and
> got to the idea of having a process to store its invocation
> history information (or ancestors).
> 
> Here are examples:
> /bin/bash process invoked from mingetty: /sbin/mingetty /bin/bash
> /bin/bash process invoked from sshd: /usr/sbin/sshd /bin/bash
> /bin/bash process invoked from /bin/bash which was invoked from sshd: /usr/sbin/sshd /bin/bash /bin/bash

Why can't you do this via SELinux domain transitions?  That lets you do
it by equivalence class rather than per-binary, and let's you just
encode the security-relevant parts of the "invocation history" aka call
chain.  For example, the above could be expressed in SELinux policy
already as:
	domain_auto_trans(getty_t, shell_exec_t, local_shell_t)
	domain_auto_trans(sshd_t, shell_exec_t, remote_shell_t)
	domain_auto_trans(remote_shell_t, shell_exec_t, remote_subshell_t)
or whatever you like.  But you don't have to keep extending it
indefinitely when you don't need to distinguish in policy, so you might
choose to entirely omit the last one, and just have it stay in
remote_shell_t.

> It seemed to us that this clarification would be familiar to
> users/administrators and could be used for various purposes.
> We did implement this by making use of the Linux's traditional
> fork & exec mechanisms, and built a pathname-based MAC using
> this implementation. We named the result as "TOMOYO Linux"
> and made it open source at SourceForge.jp (*2).
> 
> TOMOYO Linux kernel keeps track of process invocation and
> distinguishes every different process invocation history as a "domain".
> TOMOYO Linux can accumulate the accesses requests for each domain.
> 
> TOMOYO Linux has a utility called "ccstree". It prints the invocation
> history for each process in addition to the output of "pstree" command:
> 
> [root@tomoyo ~]# ccstree
> init (1) <kernel> /sbin/init
>    +- udevd (388) <kernel> /sbin/udevd
>    ...
>    +- automount (1970) <kernel> /etc/rc.d/init.d/autofs /usr/sbin/automount
>    +- acpid (1993) <kernel> /etc/rc.d/init.d/acpid /bin/bash /usr/sbin/acpid
>    +- cupsd (2008) <kernel> /etc/rc.d/init.d/cups /bin/bash /usr/sbin/cupsd
>    +- sshd (2026) <kernel> /usr/sbin/sshd
>    +- sshd (2269) <kernel> /usr/sbin/sshd
>      +- bash (2271) <kernel> /usr/sbin/sshd /bin/bash
>        +- ccstree (15125) <kernel> /usr/sbin/sshd /bin/bash /root/ccstools/ccstree
> 
>    (symbol, "<kernel>" indicates a virtual base.)
> 
> We had a presentation and a tutorial session of TOMOYO Linux
> version 1.4 at the ELC2007 (*3). Version 1.4.1 is the latest and
> has a rich set of MAC functions for files, networking, and
> capabilities and so on. For historical reasons, it is not using
> LSM or auditd. We decided to share this idea with the Linux community
> and totally rewrote the code. The result was TOMOYO Linux 2.0,
> which is now using LSM and auditd. To make discussion smooth,
> we cut off MAC functions other than for files.
> 
> We are posting this message because we believe that this process
> invocation history idea might be a useful addition to Linux.
> Please take some time to see what this small piece of software can do
> with your own eyes. Your feedback will be greatly appreciated.
> 
> If some of you are interested in TOMOYO Linux as a method for
> access control, please be advised to try full-featured version 1.4.1 (*4).
> It is quite easy to install and maintain TOMOYO Linux, but it should
> not be considered as a replacement of SELinux.
> 
> All right, that's almost everything. Please visit the following
> URL for the code and documents:
>    http://tomoyo.sourceforge.jp/wiki-e/
> If you want to see the code first, then:
>    http://tomoyo.sourceforge.jp/cgi-bin/lxr/source/security/tomoyo/?v=linux-2.6.21.3-tomoyo-2.0
> 
> We will have a TOMOYO Linux BOF session at the OLS2007 (*5).
> Please come along and let's talk.
> 
> Thank you.
> 
> Toshiharu Harada (project manager)
> Tetsuo Handa (main architect, version 1 author)
> Kentaro Takeda (version 2.0 author)
> NTT DATA CORPORATION
> http://www.nttdata.co.jp/en/index.html
> 
> *1) http://sourceforge.jp/projects/tomoyo/document/nsf2003-en.pdf
> *2) http://tomoyo.sourceforge.jp/
> *3) http://www.celinux.org/elc2007/
>      http://tree.celinuxforum.org/CelfPubWiki/ELC2007Presentations
> *4) http://tomoyo.sourceforge.jp/en/1.4.1/
> *5) http://www.linuxsymposium.org/2007/
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Stephen Smalley
National Security Agency

