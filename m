Return-Path: <linux-kernel-owner+w=401wt.eu-S932450AbXBNTKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932450AbXBNTKE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 14:10:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932456AbXBNTKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 14:10:04 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45389 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932450AbXBNTKC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 14:10:02 -0500
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 0/6] MODSIGN: Kernel module signing 
To: torvalds@osdl.org, akpm@osdl.org, herbert.xu@redhat.com
Cc: linux-kernel@vger.kernel.org, davej@redhat.com, arjan@infradead.org,
       linux-crypto@vger.kernel.org, dhowells@redhat.com
Date: Wed, 14 Feb 2007 19:09:38 +0000
Message-ID: <20070214190938.6438.15091.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.12
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



These patches provide a GPG-based kernel module signing facility.  Their use is
not fully automated within the confines of the kernel build process because it
needs provision of keys from outside of the kernel before the kernel can be
compiled.

The patches are:

 (1) A cut-down MPI library derived from GPG with error handling added.

 (2) Permit hash algorithms to hash kernel data defined by a virtual address
     and a length rather than trying to use scattergather lists (which require
     struct page pointers to be determined).

 (3) Add extra information to the per-arch ELF headers to more fully describe
     the format of the ELF metadata.

 (4) Add module verification capabilities, including ELF metadata verification.

 (5) Add a generic DSA signature checker.  Given a SHA1 hash of the data to be
     verified and a binary blob holding a GPG signature stream, this verifies
     the signature using a built-in ring of public keys.

 (6) Add a module signature checker that applies signature checking to modules
     on module load, checking the signature against the ring of public keys
     compiled into the kernel.


These patches have been in use by RHEL and Fedora kernels for years, and so
have been thoroughly tested.  The signed modules survive both the debuginfo
separation performed by rpmbuild and the strip performed when modules are being
reduced as much as possible before being included in an initial ramdisk
composition.  Signed modules have been tested to work with LE and BE, 32- and
64-bit arch kernels, including i386, x86_64, ppc64, ia64, s390 and s390x.

There are several reasons why these patches are useful, amongst which are:

 (1) to protect against accidentally-corrupted modules causing damage;

 (2) to protect against maliciously modified modules causing damage;

 (3) to allow a sysadmin (or more likely an IT department) to enforce a policy
     that only known and approved modules shall be loaded onto machines which
     they're expected to support;

 (4) to allow other support providers to do likewise, or at least to _detect_
     the fact that unsupported modules are loaded;

 (5) to allow the detection of modules replaced by a second-order distro or a
     preloaded Linux purveyor.

Basically, these patches have two main appeals to me: (a) preventing malicious
modules from being loaded, and (b) reducing support workload by pointing out
modules on a crashing box that aren't what they're expected to be.


Now, this is not a complete solution by any means: the core kernel is not
protected, and nor are /dev/mem or /dev/kmem, but it denies (or at least
controls) one relatively simple attack vector.

This facility is optional: the builder of a kernel is by no means under any
requirement to actually enable it, let alone force the set of loadable modules
to be restricted to just those that the builder provides (there are degrees of
restriction available).


Note to Andrew and Linus: Herbert Xu and the crypto guys need to check the
crypto bits before this should be accepted.  Possibly these patches should go
via the crypto tree.

David
