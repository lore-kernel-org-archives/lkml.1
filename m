Return-Path: <linux-kernel-owner+w=401wt.eu-S965336AbXDLJzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965336AbXDLJzH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 05:55:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965533AbXDLJyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 05:54:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56727 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945968AbXDLJkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 05:40:32 -0400
Message-Id: <20070412090809.917795000@suse.de>
User-Agent: quilt/0.46-14
Date: Thu, 12 Apr 2007 02:08:09 -0700
From: jjohansen@suse.de
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chrisw@sous-sol.org
Subject: [AppArmor 00/41] AppArmor security module overview
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This post contains patches to include the AppArmor application security
framework, with request for inclusion.

The patch series consists of four areas:

 (1) Pass struct vfsmount through to LSM hooks.

     Tony Jones has posted almost all of these patches here before on
     February 5; the feedback given has been incorporated.

 (2) Fixes and improvements to d_path:

     (a) make it unambiguous and exclude unreachable paths from
         /proc/mounts,

     (b) make its result consistent in the face of remounts,

     (c) introduce d_namespace_path(), a variant of d_path that goes up
         to the namespace root instead of the chroot.

     Part (a) has been in the -mm tree for more than a month; this
     series includes a copy of the -mm patch. Parts (b) and (c)
     shouldn't be too controversial.

 (3) Be able to distinguish file descriptor access from access by name
     in LSM hooks.

     Applications expect different behavior from file descriptor
     accesses and accesses by name in some cases. We need to pass this
     information down the LSM hooks to allow AppArmor to tell which is
     which.

 (4) The AppArmor LSM itself.

     (See below.)

A tarball of the kernel patches, base user-space utilities, example
profiles, and technical documentation (including a walk-through) are
available at:

  http://forgeftp.novell.com//apparmor/LKML_Submission-April_07/


The rest of this introduction gives a brief overview of AppArmor's
overall design. We will try to address the concerns people had when
AppArmor was previously posted here in April 06 in a follow-up post.


AppArmor's Overall Design
=========================

AppArmor protects systems from vulnerable software by confining
processes, giving them "least privilege" access to the system's
resources: with least privilege, processes are allowed exactly what they
need, nothing more, and nothing less. Systems are thus protected from
bugs in applications that would lead to privilege escalation, such as
remote system access because of a buffer overflow in a web server, etc.

AppArmor does this by defining application profiles which list allowed
accesses, and assigning those profiles to processes. AppArmor does *not*
require the user to confine all processes on the system.  Rather, you
need to provide AppArmor profiles for every process that is potentially
subject to manipulation by the attacker. For instance, to defend against
network attack, confine all process that access the network.

The corollary to this is that attacks against AppArmor that start with
"assume some unconfined process does ..." are outside the AppArmor
threat model. Any process that might do something malicious to an
AppArmor system should be confined by an AppArmor profile.

The kernel manages many different kinds of resources.  AppArmor
currently controls access to two key resources among them: files, and
POSIX Capabilities.  (Additional protection for things like rlimits,
interprocess communication, and network access are being worked on, and
are expected to become available in a future version.)


File Access Control
-------------------

Application profiles control file access by pathname: each profile
contains a list of fully qualified pathnames (potentially containing
globbing) and associated access modes: read (r), write (w), different
kinds of execute (ix, Px, px, Ux, ux), create hard-link (l), and memory
map for execution (m).

For example, the following two rules permit read access to any file
below /srv/www/htdocs/**.html, and memory map for execution (m), execute
inheriting the current profile (ix), and read (r) access to
/usr/sbin/suexec2:

    /srv/www/htdocs/**.html r,
    /usr/sbin/suexec2 mixr,


POSIX Capabilities
------------------

Application profiles enumerate the POSIX capabilites that a process may
use. (A process must have a capability both in its effective
capabilities set and in its profile in order to use it. See the
capabilities(7) manual page for details on capabilities.)

For example, the following rule allows processes to chroot(2):

    capability sys_chroot,


An Example Profile
------------------

Here is an example profile for ntpd:

    /usr/sbin/ntpd {
      #include <abstractions/base>
      #include <abstractions/nameservice>

      capability ipc_lock,
      capability net_bind_service,
      capability setgid,
      capability setuid,
      capability sys_chroot,
      capability sys_resource,
      capability sys_time,

      /drift/ntp.drift rwl,
      /drift/ntp.drift.TEMP rwl,
      /etc/ntp.conf r,
      /etc/ntp/drift* rwl,
      /etc/ntp/keys r,
      /etc/ntp/step-tickers r,
      /tmp/ntp* rwl,
      /usr/sbin/ntpd rmix,
      /var/lib/ntp/etc/ntp.conf.iburst  r,
      /var/lib/ntp/drift rwl,
      /var/lib/ntp/drift.TEMP rwl,
      /var/lib/ntp/drift/ntp.drift r,
      /var/lib/ntp/var/run/ntp/ntpd.pid w,
      /var/log/ntp w,
      /var/log/ntp.log w,
      /var/run/ntpd.pid w,
    }

Briefly, the /usr/sbin/ntpd in line 1 tells AppArmor to use this profile
for /usr/sbin/ntpd.  The include lines pull in some predefined
abstractions containing frequently used access patterns which allow to
keep profiles short, and the capability and file access rules have been
explained above.

Explaining the AppArmor design in detail would take by far too much
space here, so let me refer you to the technical documentation for that.
Included is a low-level walk-through of the system and basic tools, and
some examples.  The manual pages included in the apparmor-parser package
are worth a read as well.
