Return-Path: <linux-kernel-owner+w=401wt.eu-S1756164AbXHAEbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164AbXHAEbq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 00:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751571AbXHAEbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 00:31:32 -0400
Received: from web36613.mail.mud.yahoo.com ([209.191.85.30]:29561 "HELO
	web36613.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751620AbXHAEba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 00:31:30 -0400
X-YMail-OSG: eOoR9J0VM1mzRoSXY6_7ce3V9mVOE_aGpySpelYzhsrwZ6IhQ8BzfRySsIR2Hiy2miigqdUeuRcfB7cwA51yB80hLK_Jv4s1iuCMGUP6lAtU0rKPcMQ-
X-RocketYMMF: rancidfat
Date: Tue, 31 Jul 2007 21:31:29 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: [PATCH 0/2][RFC] v8  Simplified Mandatory Access Control Kernel
To: LSM List <linux-security-module@vger.kernel.org>,
       linux-kernel List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <727133.38894.qm@web36613.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Smack is the Simplified Mandatory Access Control Kernel.

Smack implements mandatory access control (MAC) using labels
attached to tasks and data containers, including files, SVIPC,
and other tasks. Smack is a kernel based scheme that requires
an absolute minimum of application support and a very small
amount of configuration data.

Subscribers to the LSM list have seen most of this description before.

Smack is implemented as a clean LSM. It requires no external
code changes and the patch modifies only the Kconfig and Makefile
in the security directory. Smack uses extended attributes and
provides a set of general mount options, borrowing technics used
elsewhere. Smack uses netlabel for CIPSO labeling. Smack provides
a pseudo-filesystem smackfs that is used for manipulation of
task and system Smack attributes.

The patch is split into two parts because of its size.
The first (1/2) includes smackfs, the rule checking functions,
a header file, Makefile and Kconfig. It also includes the
changes to the security Makefile and Kconfig. The second
(2/2) contains the lsm hooks. Both are required.

The patch, patches for ls and sshd, a README, a startup script,
and x86 binaries for ls and sshd is also available on

    http:/www.schaufler-ca.com

The patch applies to 2.6.22. It has received minimal testing with
2.6.23-rc1 as well. Development has been done using Fedora Core 5
in a virtual machine environment.


Smack provides mandatory access controls based on the label attached
to a task and the label attached to the object it is attempting to
access. Smack labels are deliberately short (1-7 characters) text
strings. Single character labels using special characters are reserved
for system use. The only operation applied to Smack labels is equality
comparison. No wildcards or expressions, regular or otherwise, are
used.

A file always gets the Smack label of the task that created it.

Smack defines and uses these labels:

    "*" - pronounced "star"
    "_" - pronounced "floor"
    "^" - pronounced "hat"
    "?" - pronounced "huh"

The access rules enforced by Smack are, in order:

1. Any access requested by a task labeled "*" is denied.
2. A read or execute access requested by a task labeled "^"
   is permitted.
3. A read or execute access requested on an object labeled "_"
   is permitted.
4. Any access requested on an object labeled "*" is permitted.
5. Any access requested by a task on an object with the same
   label is permitted.
6. Any access requested that is explicitly defined in the loaded
   rule set is permitted.
7. Any other access is denied.

Rules may be explicitly defined by writing subject,object,access
triples to /smack/load.

Smack rule sets can be easily defined that describe Bell&LaPadula
sensitivity, Biba integrity, and a variety of interesting
configurations. Smack rule sets can be modified on the fly to
accomodate changes in the operating environment or even the time
of day.

Some practical use cases:

Hierarchical levels. The less common of the two usual uses
for MLS systems is to define hierarchical levels, often
unclassified, confidential, secret, and so on. To set up smack
to support this, these rules could be defined:

   C        Unclass rx
   S        C       rx
   S        Unclass rx
   TS       S       rx
   TS       C       rx
   TS       Unclass rx

A TS process can read S, C, and Unclass data, but cannot write it.
An S process can read C and Unclass. Note that specifying that
TS can read S and S can read C does not imply TS can read C, it
has to be explicitly stated.

Non-hierarchical categories. This is the more common of the
usual uses for an MLS system. Since the default rule is that a
subject cannot access an object with a different label no
access rules are required to implement compartmentalization.

A case that the Bell & LaPadula policy does not allow is demonstrated
with this Smack access rule:

A case that Bell&LaPadula does not allow that Smack does:

    ESPN    ABC   r
    ABC     ESPN  r

On my portable video device I have two applications, one that
shows ABC programming and the other ESPN programming. ESPN wants
to show me sport stories that show up as news, and ABC will
only provide minimal information about a sports story if ESPN
is covering it. Each side can look at the other's info, neither
can change the other. Neither can see what FOX is up to, which
is just as well all things considered.

Another case that I especially like:

    SatData Guard   w
    Guard   Publish w

A program running with the Guard label opens a UDP socket and
accepts messages sent by a program running with a SatData label.
The Guard program inspects the message to ensure it is wholesome
and if it is sends it to a program running with the Publish label.
This program then puts the information passed in an appropriate
place. Note that the Guard program cannot write to a Publish
file system object because file system semanitic require read as
well as write.

The four cases (categories, levels, mutual read, guardbox) here
are all quite real, and problems I've been asked to solve over
the years. The first two are easy to do with traditonal MLS systems
while the last two you can't without invoking privilege, at least
for a while.

There is still work to be done. Audit integration will require
changes in linux-audit, lsm, and SELinux (maybe netlink, too)
so it will be a while before that part is ready to go. There is
application work, of course.

Please give it a look over. It's been on the LSM list for a while
and I have gotten some very helpful suggestions.

Thank you.


Casey Schaufler
casey@schaufler-ca.com
