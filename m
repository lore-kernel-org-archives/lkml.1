Return-Path: <linux-kernel-owner+w=401wt.eu-S1757510AbYEVTNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510AbYEVTNZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 15:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753727AbYEVTNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 15:13:12 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:28299 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948AbYEVTNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 15:13:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=gjxjsk1BgisW8qb6K+OoSu6k6dR6FplW025yF339t5po2+8o5FcWZUywkZRNy1SmXfQo1mmNrmruX2tM6EEKulaBDzpXswI7urWGHZ3G2BAoaCpM63bcMLX1wvSJYEKH050PsQnOh5ipAUVPCUQ1mG9IjfbaYRUCx4YagQpOVdA=
Message-ID: <524f69650805221213i62488a4fk5a906b2726b9b96a@mail.gmail.com>
Date: Thu, 22 May 2008 14:13:07 -0500
From: "Steve French" <smfrench@gmail.com>
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: pagevecs of more than PAGEVEC_SIZE pages
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that various servers support processing larger than 64K file
writes, it would be helpful to have pagevecs that are larger than 14
pages (PAGEVEC_SIZE).so an array of more pages could be passed to
kernel_sendmsg (thus allowing writes larger than 56K, depending on
wsize - the server limit is currently 8MB)

pagevec_lookup_tag (and the inline function pagevec_space which I
don't use) is the main place that cifs needs a pagevec instead of
simply an array of pages and PAGEVEC_SIZE does not seem to matter
there (it works if I malloc a structure with more pages and request
more than 14 pages out of pagevec_lookup_tag).  Is there another
better alternative other than defining a larger pagevec (pagevec2 or
cifs_pagevec)?  Should I simply kmalloc something larger than a
pagevec and cast a (struct pagevec *) to it?

 static int cifs_writepages(struct address_space *mapping,
                           struct writeback_control *wbc)
 {
@@ -1209,7 +1216,7 @@ static int cifs_writepages(struct address_space *mapping,
        __u64 offset = 0;
        struct cifsFileInfo *open_file;
        struct page *page;
-       struct pagevec pvec;
+       struct pagevec2 pvec;
        int rc = 0;
        int scanned = 0;
        int xid;
@@ -1229,7 +1236,7 @@ static int cifs_writepages(struct address_space *mapping,
                        if (!experimEnabled)
                                return generic_writepages(mapping, wbc);

-       iov = kmalloc(32 * sizeof(struct kvec), GFP_KERNEL);
+       iov = kmalloc(maximum_pages_to_write_based_on_wsize *
sizeof(struct kvec), GFP_KERNEL);
        if (iov == NULL)
                return generic_writepages(mapping, wbc);

@@ -1261,7 +1268,7 @@ retry:
        while (!done && (index <= end) &&
               (nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
                        PAGECACHE_TAG_DIRTY,
-                       min(end - index, (pgoff_t)PAGEVEC_SIZE - 1) + 1))) {
+                       min(end - index,
(pgoff_t)maximum_pages_to_write_based_on_wsize - 1) + 1))) {
                int first;
                unsigned int i;



-- 
Thanks,

Steve
