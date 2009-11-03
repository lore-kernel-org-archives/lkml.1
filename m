Return-Path: <linux-kernel-owner+w=401wt.eu-S1753247AbZKCXsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247AbZKCXsg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 18:48:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753160AbZKCXsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 18:48:35 -0500
Received: from adelie.canonical.com ([91.189.90.139]:52914 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417AbZKCXsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 18:48:32 -0500
From: John Johansen <john.johansen@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
Subject: [Patch 0/12] AppArmor security module
Date: Tue,  3 Nov 2009 15:48:07 -0800
Message-Id: <1257292099-15802-1-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the newest version of the AppArmor security module it has been
rewritten to use the security_path hooks instead of the previous vfs
approach.  The current implementation is aimed at being as semantically
close to previous versions of AppArmor as possible while using the
existing LSM infrastructure.

AppArmor is a wip and is roughly equivalent to previous versions with better
control of exec transitions.  Development is on going and improvements to
file, capability, network, resource usage and ipc mediation are planned.


In brief AppArmor is a security module that uses a white list to determine
permissions.  It currently provides rules for file, capability, resource
and basic network mediation.  With its file mediation using path name based
pattern matching.

Though it is possible to confine an entire system, AppArmor by design allows
for application based mediation where only a subset of a running system is
confined.  Any process that is not confined by AppArmor is only restricted
by the standard unix DAC permission model.


_Issues Addressed Since Last Time AppArmor was Posted (LSM only)_
* all issues raised have been address except for return an error out
  of the accept hook which is not a bug but could removed under the 
  current simple network mediation model.  It was decided instead that
  any development time on addressing this should go towards the new
  network controls instead.
* The code has seen further cleanups, and has been run through lindent
  and checkpatch again (its been awhile).
* several bugs have been addressed
  - change_hat auditing
  - quieting of file auditing
  - policy load failures
  - mediation of creation failure under some filesystems



A brief summary of AppArmor is below

AppArmor documentation can currently be found at
  http://developer.novell.com/wiki/index.php/Apparmor

The unflattened AppArmor git tree can be found at
  git://kernel.ubuntu.com/jj/apparmor-mainline.git


The AppArmor project is currently in transition and will be moving
away from Novell forge.  The current upstream for the AppArmor tools
can be found at
  https://launchpad.net/apparmor

The final location of the documentation and mailing lists have
not been determined and will be updated when known.

Profiles

AppArmor's base unit of confinement is a profile, which defines the
access permissions for tasks it is attached to.  Profiles are grouped in
to profile namespaces, and must have a unique name within the namespace.

Profile names provide context for when a profile should be used and
may determine the attachment of a profile to an application.  If a profile
name begins with a / character its name is considered to be a path name
and it may be matched against executable names to determine attachment.
Profile names that do not begin with a / character are not considered
during automatic profile attachment.

Profile names that begin with / characters can contain AppArmor pattern
matching and may match against multiple executables.  If multiple
profiles match an executable then the profile with the longest left
exact match wins.  If the winner can not be determined execution of the
task will fail.

Profile names that begin with / characters are consider for attachment
when an unconfined application calls exec, or when a confined application
uses a exec rules specifying that such a match should be done (px, cx).
They may also be attached using the change_profile, or change_hat directives.

Profile's names that don't begin with a / character are only attached
when they are specified by a profile exec transition, or through using
that change_profile, change_hat directives.

A partial sample profile

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

  ...
}


AppArmor allows for rules that black list permissions by prepending the deny
keyword, these rules are used to annotate known items that will be encountered
and should be rejected.

eg.
   deny /etc/shadow w,


please refer to the documentation link for further information


