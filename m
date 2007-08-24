Return-Path: <linux-kernel-owner+w=401wt.eu-S1760096AbXHXMmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760096AbXHXMmX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 08:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758994AbXHXMmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 08:42:06 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:55856 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757987AbXHXMmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 08:42:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=HYauVvjzE2JiNhx8TWDVTXeaGcdBDB0rvRi+OJaBt806J1MrB3dbuwrCoDzkPgm3oObEoRKatSuu4MObDoD3BNzaIfiG0V3Yo5L3KI4RBfGBJXqNJu2oCBzOybV/SNTphhjFoYieSoZYQq9AyIgqxQVIdzBG++IHWe5jcMnmjfU=
Message-ID: <46CED214.6050505@gmail.com>
Date: Fri, 24 Aug 2007 21:41:56 +0900
From: Kentaro Takeda <k.takeda26@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       chrisw@sous-sol.org
Subject: [TOMOYO 00/15] TOMOYO Linux - MAC based on process invocation histroy
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"TOMOYO Linux" is our work in the field of security enhanced Linux.
This is the second proposal of TOMOYO Linux.

When we posted our first proposal to LKML, TOMOYO Linux's MAC was
limited to file access control. Now TOMOYO Linux has access control
functionality not only for files but also for networking, signal
transmission and namespace manipulation and we got the source code
cleaned-up.

Patches consist of three types.
    * [TOMOYO 01/15]:    Mandatory modifications against standard kernel.
    * [TOMOYO 02-14/15]: LSM implementation of TOMOYO Linux.
    * [TOMOYO 15/15]:    Optional modifications against standard kernel.


<<What you can do with TOMOYO Linux.>>

The fundamental concept of TOMOYO Linux is "tracking process
invocation history".

The "struct task_struct"->security member holds a pointer to the
"process invocation history". Thus, every process (the kernel,
/sbin/init process and any children/descendant of /sbin/init) knows
its "process invocation history" (or ancestors). Since every process
knows its ancestors, TOMOYO Linux can enforce access control over all
processes.

TOMOYO Linux splits domains using "process invocation history" and the
process transits to a different domain whenever execution of a program
(i.e. do_execve()) is requested. By transiting to a different domain
whenever execution of a program is requested, each domain will have
the minimal permissions that are essential for processes in that
domain to do their roles.

You don't need to define domains beforehand. TOMOYO Linux kernel will
automatically define new domains whenever execution of a program is
requested, and the process will automatically transit to the new
domain. (If the process's domain is in enforcing mode, TOMOYO Linux
kernel will not define new domains to avoid memory consumption attack.)

TOMOYO Linux can restrict the following requests on a per-a-domain basis:

    * opening files
    * communicating via PF_INET sockets
    * sending signals

TOMOYO Linux can also restrict the following namespace manipulation requests.

    * mounting filesystems
    * unmounting filesystems
    * using pivot_root


<<Example>>

The tree below shows a part of domain transitions generated using
Debian Etch. The domain a process is in is determined based on the
process's "process invocation history". Each domain has permissions
(or ACL), and the behavior (or requests shown above) of a process is
restricted by the ACL of the domain that the process is in.

    <kernel>
      + /sbin/init
          + /etc/init.d/rc
              + /etc/init.d/apache2
                  + /usr/bin/env
                      + /usr/sbin/apache2ctl
                          + /usr/sbin/apache2

You can assign different access control modes (or profiles) on a
per-a-domain basis. Thus, you can enforce access control partially or
entirely. Also, by assigning "learning mode" to a domain, ACL that are
requested by processes in that domain are automatically (i.e. in
real-time) accumulated. The following ACL are an excerpt from
/usr/sbin/apache2 domain generated using "learning mode".

    4 /etc/apache2/apache2.conf
    4 /var/www/apache2-default/index.html
    allow_create /var/run/apache2.pid
    allow_unlink /var/run/apache2.pid
    allow_network TCP bind 192.168.1.135 80
    allow_network TCP listen 192.168.1.135 80
    allow_network TCP accept 192.168.1.1 2389

The above ACL allows Apache to do the following behavior.

    * Opening /etc/apache2/apache2.conf and
      /var/www/apache2-default/index.html for reading.
    * Creating and deleting /var/run/apache2.pid .
    * Binding to local address (IP = 192.168.1.135, port = 80).
    * Listening at local address (IP = 192.168.1.135, port = 80).
    * Accepting from remote address (IP = 192.168.1.1, port = 2389).

You may use wildcards for pathnames, ranges for IP addresses and port
numbers, groups of pathnames and IP addresses for flexible definition.


<<Features of TOMOYO Linux.>>

TOMOYO Linux is an implementation of MAC, but you can use TOMOYO Linux
not only for MAC, but also to analyze a system's behavior, since
TOMOYO Linux can accumulate access requests raised by applications
sorted by each "process invocation history".

TOMOYO Linux and AppArmor are alike from the point of view of pathname
based access control, but TOMOYO Linux has differences in the
following points:

    * TOMOYO Linux can apply access control over the whole process
      (from the execution of /sbin/init at the startup procedure,
      till the power failure at the shutdown procedure).
    * TOMOYO Linux can apply access control not only over files but
      also over networking, signals, namespace manipulations.
    * TOMOYO Linux can accumulate ACL in real-time using
      "learning mode".

    * TOMOYO Linux allows the administrator to switch the access
      control mode on a per-domain and per-functionality basis.
    * TOMOYO Linux allows the administrator to judge (grant/reject)
      requests which that violated ACL manually while operating in
      "enforcing mode" without once rejecting these requests.
    * TOMOYO Linux supports conditional ACL (e.g. owner of
      process/files etc.).

Documents about installing and experiencing TOMOYO Linux are available
at http://tomoyo.sourceforge.jp/en/2.1.x/ . Please try TOMOYO Linux.
Feedbacks are most welcome.


<<Related links>>

OLS BoF material: http://sourceforge.jp/projects/tomoyo/document/ols2007-tomoyo-20070629.pdf
Previous submission: http://lkml.org/lkml/2007/6/13/58 , http://lkml.org/lkml/2007/6/14/55

Kentaro Takeda
NTT DATA CORPORATION
