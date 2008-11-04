Return-Path: <linux-kernel-owner+w=401wt.eu-S1756915AbYKDViS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915AbYKDViS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 16:38:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754848AbYKDVh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 16:37:58 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:39678 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754467AbYKDVh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 16:37:56 -0500
Date: Tue, 4 Nov 2008 15:37:54 -0600
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Dustin Kirkland <dustin.kirkland@gmail.com>,
       Eric Sandeen <sandeen@redhat.com>, Tyler Hicks <tchicks@us.ibm.com>,
       David Kleikamp <shaggy@us.ibm.com>,
       Michael Halcrow <mhalcrow@us.ibm.com>
Subject: [PATCH 0/5] eCryptfs: Filename Encryption
Message-ID: <20081104213754.GC6675@halcrowt61p.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset implements filename encryption via a passphrase-derived
mount-wide Filename Encryption Key (FNEK) specified as a mount
parameter. Each encrypted filename has a fixed prefix indicating that
eCryptfs should try to decrypt the filename. When eCryptfs encounters
this prefix, it decodes the filename into a tag 70 packet and then
decrypts the packet contents using the FNEK, setting the filename to
the decrypted filename. Both unencrypted and encrypted filenames can
reside in the same lower filesystem.

Because filename encryption expands the length of the filename during
the encoding stage, eCryptfs will not properly handle filenames that
are already near the maximum filename length.

In the present implementation, eCryptfs must be able to produce a
match against the lower encrypted and encoded filename representation
when given a plaintext filename. Therefore, two files having the same
plaintext name will encrypt and encode into the same lower filename if
they are both encrypted using the same FNEK. This can be changed by
finding a way to replace the prepended bytes in the blocked-aligned
filename with random characters; they are hashes of the FNEK right
now, so that it is possible to deterministically map from a plaintext
filename to an encrypted and encoded filename in the lower
filesystem. An implementation using random characters will have to
decode and decrypt every single directory entry in any given directory
any time an event occurs wherein the VFS needs to determine whether a
particular file exists in the lower directory and the decrypted and
decoded filenames have not yet been extracted for that directory.

Thanks to Tyler Hicks and David Kleikamp for assistance in the
development of this patchset.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
