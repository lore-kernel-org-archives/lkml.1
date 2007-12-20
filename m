Return-Path: <linux-kernel-owner+w=401wt.eu-S932812AbXLTOKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932812AbXLTOKq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 09:10:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758316AbXLTOKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 09:10:36 -0500
Received: from mail.suse.de ([195.135.220.2]:40617 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759452AbXLTOKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 09:10:35 -0500
X-Mailbox-Line: From jjohansen@suse.de Thu Dec 20 06:09:41 2007
Message-Id: <20071220140910.934607826@suse.de>
User-Agent: quilt/0.46-60
Date: Thu, 20 Dec 2007 06:09:10 -0800
From: John@suse.de, Johansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [AppArmor 00/47] AppArmor security module overview
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-- 

This submission of the AppArmor security module is based against 2.6.24-rc4-mm.

Any comments and feedback to improve implementation are appreciated.

Changes since previous submission
- added apparmor security goal document.
  Documentation/lsm/AppArmor-Security-Goal.txt
- removed DAC style permissions in favor of a simpler file owner
  permissions specification
- include the fgetattr and fsetattr patches by Miklos Szeredi
  <mszeredi@suse.cz>, and update them to use ATTR_FILE to enable LSMs to
  distinguish file descriptor operations
- fix error where a NULL sock passed to socket_getsocket_getpeersec_dgram()
  was not correctly handled.
- fix error in link permission subset test

Outstanding Issues
- use of d_namespace_path and buffer allocation to obtain a pathname for
  mediation.
- conditional passing of the vfsmnt.  This can be addressed by rebasing
  on the lookup intent patches but that has not been done for this
  submission.
- ipc and signal mediation are a wip and not included.
- fine grained network mediation
- system confinement from boot is a wip and not included.
- documentation needs to be updated to include newest features


The patch series consists of five areas:

 (1) Pass struct vfsmount through to LSM hooks.

 (2) Fixes and improvements to __d_path():

     (a) make it unambiguous and exclude unreachable paths from
         /proc/mounts,

     (b) make its result consistent in the face of remounts,

     (c) introduce d_namespace_path(), a variant of d_path that goes up
         to the namespace root instead of the chroot.

     (d) the behavior of d_path() and getcwd() remain unchanged, and
     there is no hidding of unreachable paths in /proc/mounts.  The
     patches addressing these have been seperated from the AppArmor
     submission and will be introduced at a later date.
 
     Part (a) has been in the -mm tree for a while; this series includes
     an updated copy of the -mm patch. Parts (b) and (c) shouldn't be too
     controversial.

 (3) Be able to distinguish file descriptor access from access by name
     in LSM hooks.

     Applications expect different behavior from file descriptor
     accesses and accesses by name in some cases. We need to pass this
     information down the LSM hooks to allow AppArmor to tell which is
     which.

 (4) Convert the selinux sysctl pathname computation code into a standalone
     function.

 (5) The AppArmor LSM itself.

     (See below.)

A tarball of the kernel patches, base user-space utilities, example
profiles, and technical documentation (including a walk-through) are
available at:

  http://forgeftp.novell.com/apparmor/LKML_Submission-Dec-07/

Only the most recent features are covered in brief here for a more
complete explaination please refere to the technical documentation.


File ownership permissions
  The DAC style permissions mask allowing the specification of permission
  for each of user, group, and other have been removed, after further feed
  back and discussion, in favor of a simpler permission set that allows
  specifying permissions for file ownership as determined by fsuid.

  Traditional AppArmor rules map to specifying permissions for files
  all files, to reduce the permissions grant the owner keyword can
  be added to a rule.

  /foo rw,		# allow access to file /foo
  owner /foo rw,	# allow access to file /foo only if its uid == fsuid


