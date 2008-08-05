Return-Path: <linux-kernel-owner+w=401wt.eu-S1758280AbYHEHmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758280AbYHEHmY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 03:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752734AbYHEHmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 03:42:14 -0400
Received: from ik-out-1112.google.com ([66.249.90.177]:52107 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbYHEHmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 03:42:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=vAg7bo+1V/zBCwuCI8sQPbkef4/vGWF2gnir5juoELihP1hr/rgHJqZXeo88Fq7mUt
         bzeEfnntLENG7cPT5THD0VtlXyvT4HOTl6e1bpDgkFfd+n/Krod1F1khEml/LAFfVDVf
         vmU4enfz4ACmRuo+NMqB9GN7OAIGmKMProXNE=
Message-ID: <ac9c93b10808050042u496bfa10nad7962eb0e9ec015@mail.gmail.com>
Date: Tue, 5 Aug 2008 09:42:11 +0200
From: "Frans Meulenbroeks" <fransmeulenbroeks@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: initramfs optimization suggestions
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Upfront apologies if this is the wrong place to post this to.Just
give me a gentle redirect to the right place in that case.]

I've been looking into improving the boot time of an embedded linux
system (monta vista based).
While doing so I detected that initramfs initialisation was one of the
places where a lot of time was spent, so I looked into it in some more
detail and came up with the following findings & suggestions.

First proposal:
==========

initramfs is build from a compressed cpio archive.
Proposal is to introduce a build option to make the compression and
decompression optional.
Rationale 1: could be faster as it trades off I/O time (to read the
image) against decompression time
Rationale 2: for architectures that use compressed images (bzImage)
actually we compress twice, which is not really efficient.

I can implement this, but before spending time on it I would like to know if
a) people consider this a good idea
b) no one else already has doen this.


Second proposal:
============

after decompressing the cpio archive all files are made using
sys_open/sys_write/sys_close and friends.
This implies that a lot of system calls and data copying is done.
It would be nice if that could be avoided.
I'm not fully into all details of how ramfs is implemented, but would
it be possible to e.g. dump all blocks of a tmp ram fs into a data
structure (e.g.an array of blocks) while making the kernel, and while
booting the kernel initialise the fs cache with these data? (I guess
this would be around fs/dcache.c; I understand the data here is
kmalloc-ed, but it might be possible to initialise the cache with
pointers to that data structure; due to the nature of ramfs they won't
be deallocated anyway I assume).
Does this sound feasible? Hidden snags? Appreciate your
opinion/feedback/suggestions.

Best regards, Frans.

PS: if anyone has a pointer to a place which explains in full detail
how linux fs internally works (apart from the source :-) ) I
appreciate a reference. FM
