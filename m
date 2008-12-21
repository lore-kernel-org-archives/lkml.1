Return-Path: <linux-kernel-owner+w=401wt.eu-S1754400AbYLUOzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400AbYLUOzK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 09:55:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752176AbYLUOy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 09:54:58 -0500
Received: from www.tglx.de ([62.245.132.106]:37826 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752165AbYLUOy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 09:54:57 -0500
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, malware-list@lists.printk.net, eparis@redhat.com,
       hch@infradead.org, alan@lxorguk.ukuu.org.uk
Subject: [PATCH 0/5] VFS: DazukoFS, stackable-fs, file access control
From: John Ogness <dazukocode@ogness.net>
Date: Sun, 21 Dec 2008 15:52:36 +0100
Message-ID: <86d4flh96z.fsf@johno-ibook.fn.ogness.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset introduces a new stackable filesystem: DazukoFS.


SUMMARY

DazukoFS is a stackable filesystem that provides functionality
allowing userspace applications to perform online file access
control. When a file is accessed on DazukoFS, registered userspace
processes will be notified and given the opportunity to allow or deny
the access. To help a registered process make its decision, it
receives a read-only open file descriptor to the file being
accessed. DazukoFS uses named grouping to determine if multiple
registered processes are working together.

The features of DazukoFS can be briefly summarized as follows:

1. Parallel Event Handling
   Multiple processes (or threads) may register using the same group
   name to signify that they are working together. When a file on
   DazukoFS is accessed, a file access event will be assigned to the
   first available process in the group. If another file access event
   occurs before the first has been handled, the next available
   process in the group will be assigned the event. If no processes in
   the group are currently available, that particular file access will
   block. This allows multiple files to be processed simultaneously.

2. Multiple Groups
   Different applications may register, each using their own group
   name. Each group will be given the opportunity to determine if
   access may be allowed. Access is denied if any group decides to
   deny access. This allows different access control applications to
   run simultaneously and independent from one another.

3. Device-Determined Privileges
   Each group uses its own dedicated device. When performing file
   access control, an application only needs read/write access to its
   group device. The application does not require any other
   privileges. Since DazukoFS already opens the file being accessed
   (read-only), a non-privileged registered application is able to
   perform online file access control for all files (including those
   that it would normally not have access to).


MOTIVATION

Since 2001 various anti-virus vendors have been providing out-of-tree
solutions for online virus scanning. Although GNU/Linux systems
currently are not targets of virus authors, many organizations are
interested in online virus scanning on Linux-based servers in order to
help protect Microsoft Windows clients. It is often argued that file
scanning should be implemented in the various services (such as Samba,
Apache, vsftpd, etc.), and indeed many such solutions have been
implemented. However, there is a continued demand for a kernel-based
solution because it can guard the entire filesystem independent from
the types and numbers of services running on a system.

In 2002, the Dazuko project was started with the goal of providing a
userspace interface on top of a kernel-based file access control
mechanism. From early on, the project has aimed to support multiple
anti-virus applications simultaneously without any bias towards a
particular application. Today several anti-virus vendors choose Dazuko
as a basis for their online file scanning solution.

Dazuko originally used syscall-table hooking for its access control
mechanism. With the arrival of Linux 2.6, Dazuko switched to using
LSM. However, in February 2004, Christoph Hellwig suggested that file
access events should be intercepted using a stackable
filesystem. After many discussions and several prototypes, it was
decided that the Dazuko project would move to become a stackable
filesystem: DazukoFS.

Implementing online file access control using a stackable filesystem
has several benefits:

1. No core Linux code must be modified. As a stackable filesystem,
   DazukoFS is a separate component of the kernel. This could prove
   very useful if/when anti-virus vendors want to develop new DazukoFS
   features. With DazukoFS as a separate component, new features could
   be added without requiring core Linux code changes.

2. On LKML, an interest in a stackable filesystem framework has been
   expressed. With DazukoFS being another stackable filesystem, we can
   begin looking at common code between the stackable filesystems and
   possibly begin identifying a stackable filesystem framework. Using
   real stackable filesystems as a model is much easier than guessing
   what should go into a stackable filesystem framework.

The Dazuko project is interested in going mainline with
DazukoFS. Nearly seven years of out-of-tree development were more than
enough to prove that out-of-tree kernel drivers have an unnecessarily
large maintenance cost (which increases with each new kernel
release). With DazukoFS mainline, anti-virus vendors would finally
have an official interface and implementation on which to base their
online scanning applications.


CURRENT STATE

DazukoFS currently includes a minimal set of features. This was done
on purpose to try to minimize the amount of code for the initial
presentation for mainline acceptance. Here is a brief listing of the
current state of the project:

- Only file access events for "open" file operations are intercepted.

- Writing to memory mapped files is not supported.

- Many exotic VFS calls are not stacked upon.

- A bug was recently reported at Red Hat regarding problems using
  SElinux and stackable filesystems. This affects DazukoFS as well as
  other stackable filesystems.
  https://bugzilla.redhat.com/show_bug.cgi?id=475985

- DazukoFS has been tested primarily on top of ext3 (read/write) for
  the powerpc architecture.


A WORD ON FANOTIFY

I am aware of the current work of Eric Paris to implement a file
access control mechanism within a unified inotify/dnotify
framework. Although I welcome any official interface to provide a file
access control mechanism for userspace applications in Linux, I feel
that DazukoFS provides a more elegant solution. (Note that the two
projects do not conflict with each other.) I am open to discuss this
point further if anyone is interested.


SUBMISSION PATCHSET

A series of 5 patches will be posted. Each patch provides new features
and working code so that DazukoFS can be evaluated with various
feature (patch) subsets. The patches can be briefly summarized as
follows:

Patch 1: Introduces DazukoFS as a nullfs. This is the raw stackable
         filesystem part of DazukoFS and does nothing except stack and
         pass filesystem calls to the lower filesystem.

Patch 2: Creates /dev/dazukofs.0 for userspace applications to perform
         file access control. At this point, all applications are
         considered to be working together (in the same group).

Patch 3: Creates /dev/dazukofs.ctrl to allow for groups to be added,
         listed, and deleted. Also, /dev/dazukofs.[0-9] devices are
         created to support multiple groups.

Patch 4: Adds a new (optional) command to allow registered processes
         to be tracked. The tracking allows processes to be
         automatically unregistered if they crash and also allows
         groups to be automatically deleted if no more processes are
         registered.

Patch 5: Creates /dev/dazukofs.ign as an (optional) mechanism for any
         processes to hide themselves from DazukoFS file access
         control.

Device permissions can be best set using udev rules. The file
"Documentation/filesystems/dazukofs.txt" (also updated with each
patch) describes how to use and write applications for DazukoFS.

John Ogness
