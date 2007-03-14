Return-Path: <linux-kernel-owner+w=401wt.eu-S933869AbXCNFk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933869AbXCNFk0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 01:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933840AbXCNFkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 01:40:25 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:58074 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933869AbXCNFkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 01:40:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=naxM7duECMeYvehewokBP7CXMXxwVMag3uIxLyLQLITZu30YyB2jB7KNB49fn6Tq8zwGKB6KesMW/jlEDrawK0K2k1s7SXm0/sejoCiy1PHwET6htJtMykxctC2OSyG0hH/p2uC3iqHfuqBcc/WiehOR3VJgIfDmUuj27yVx0o0=
Message-ID: <5c49b0ed0703132240h2087eb12xb44652bf0d235521@mail.gmail.com>
Date: Tue, 13 Mar 2007 22:40:22 -0700
From: "Nate Diller" <nate.diller@gmail.com>
To: "Vladimir V. Saveliev" <vs@namesys.com>
Subject: [BUG] reiser4: page lock recursion in reiser4_write_extent
Cc: reiserfs-dev <reiserfs-dev@namesys.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This little code snippet seems to have a page_lock recursion, in
addition to overall looking particularly fragile to me.  It seems to
be handling the case where a page needs to be brought uptodate because
a partial page write is being done.  The page gets locked as many as 3
times, each checking PageUptodate, however the two failure cases here
go BUG() instead of returning an error.  I'm starting to think that
somehow the whole suspect branch just never gets taken, because
otherwise I would expect to see bug reports related to -EIO, -ENOMEM,
etc causing this to barf.

either way, it seems there's a lock recursion if another thread races
to bring @page uptodate while we're waiting on the first lock_page()
call.

---

                page = jnode_page(jnodes[i]);
                if (page_offset(page) < inode->i_size &&
                    !PageUptodate(page) && to_page != PAGE_CACHE_SIZE) {
                        /*
                         * the above is not optimal for partial write to last
                         * page of file when file size is not at boundary of
                         * page
                         */
takes the lock
                        lock_page(page);
raced with readpage?
                        if (!PageUptodate(page)) {
readpage drops lock
                                result = readpage_unix_file(NULL, page);
                                BUG_ON(result != 0);
-ENOMEM?
                                /* wait for read completion */
                                lock_page(page);
                                BUG_ON(!PageUptodate(page));
-EIO?
                                unlock_page(page);
                        } else
still have the lock here
                                result = 0;
                }

                BUG_ON(get_current_context()->trans->atom != NULL);
                fault_in_pages_readable(buf, to_page);
                BUG_ON(get_current_context()->trans->atom != NULL);

BOOM!!!
                lock_page(page);
                if (!PageUptodate(page) && to_page != PAGE_CACHE_SIZE) {

---

NATE
