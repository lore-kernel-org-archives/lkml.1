Return-Path: <linux-kernel-owner+w=401wt.eu-S1759659AbXE2Gjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759659AbXE2Gjw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 02:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752190AbXE2Gjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 02:39:44 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:21488 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751113AbXE2Gjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 02:39:43 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type;
  b=ZgBmrkOy/2rcUnb/liXj7HSFdGo6qMeX/XUBV1tMG9QjqChkezztcT2ayq9k+nZAjW+/l2fLoxaZkFAqjsJPgqAfXgbaNDHs85XcleOl7KdeeTJy3IyHsqScJzjf8DPl2M5GIdTnUwp1xnLJGIS3STe62Ri+LK2Ig8HIN10ltr8=  ;
X-YMail-OSG: dcUpNvMVM1kG9iqlIS.mkJiHoixDASnwh648u3urrEPDXcvtpdGTMzQOqaEDDtO_lLSj8lQLhw--
Message-ID: <465BCAA9.3070707@yahoo.com.au>
Date: Tue, 29 May 2007 16:39:37 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Neil Brown <neilb@suse.de>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Peter Linich <plinich@cse.unsw.edu.au>
Subject: Re: [PATCH/RFC] Is it OK for 'read' to return nuls for a file   that
 never had nuls in it?
References: <18011.51290.257450.26100@notabene.brown>
In-Reply-To: <18011.51290.257450.26100@notabene.brown>
Content-Type: multipart/mixed;
 boundary="------------040000020905030103030706"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040000020905030103030706
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Neil Brown wrote:
> [resending with correct To address - please reply to this one]
> 
> It appears that there is a race when reading from a file that is
> concurrently being truncated.  It is possible to read a number of
> bytes that matches the size of the file before the truncate, but the
> actual bytes are all nuls - values that had never been in the file.
> 
> Below is a simple C program to demonstrate this, and a patch that
> might fix it (initial testing is positive, but it might just make the
> window smaller).
> To trial the program run two instances, naming the same file as the
> only argument.  Every '!' indicates a read that found a nul.  I get
> one every few minutes.
> e.g.  cc -o race race.c ; ./race /tmp/testfile & ./race /tmp/tracefile
> 
> My exploration suggests the problem is in do_generic_mapping_read in
> mm/filemap.c. 
> This code:
>    gets the size of the file
>    triggers readahead
>    gets the appropriate page
>    If the page is up-to-date, return data.
> 
> If a truncate happens just before readahead is triggered, then
> the size will be the pre-truncate size of the file, while the page
> could have been read by the readahead and so will be up-to-date and
> full of nuls.
> 
> Note that if do_generic_mapping_read calls readpage explicitly, it
> samples the value of inode->i_size again after the read.  However if
> the readpage is called by the readahead code, i_size is not
> re-sampled.
> 
> I am not 100% confident of every aspect of this explanation (I haven't
> traced all the way through the read-ahead code) but it seems to fit
> the available data including the fact that if I disable read-ahead
> (blockdev --setra 0) then the apparent problem goes away.
> 
> The patch below moves the code for re-sampling i_size from after the
> readpage call to before the "actor" call.
> 
> Questions:
>   - Is this a problem, and should it be fixed (I think "yes").

I think you are right.

>   - Is the patch appropriate, and does it have no negative
>     consequences?.
>     (Obviously some comments should be tidied up to reflect the new
>     reality).

Would it be better (and closer to following the existing logic) if
we sampled i_size before testing each page for uptodateness? It might
also cost a little less in the fastpath case of finding an uptodate
page.

-- 
SUSE Labs, Novell Inc.

--------------040000020905030103030706
Content-Type: text/plain;
 name="mm-ra-zerofill-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mm-ra-zerofill-fix.patch"

Index: linux-2.6/mm/filemap.c
===================================================================
--- linux-2.6.orig/mm/filemap.c	2007-05-29 16:34:38.000000000 +1000
+++ linux-2.6/mm/filemap.c	2007-05-29 16:35:42.000000000 +1000
@@ -863,13 +863,11 @@ void do_generic_mapping_read(struct addr
 {
 	struct inode *inode = mapping->host;
 	unsigned long index;
-	unsigned long end_index;
 	unsigned long offset;
 	unsigned long last_index;
 	unsigned long next_index;
 	unsigned long prev_index;
 	unsigned int prev_offset;
-	loff_t isize;
 	struct page *cached_page;
 	int error;
 	struct file_ra_state ra = *_ra;
@@ -882,15 +880,17 @@ void do_generic_mapping_read(struct addr
 	last_index = (*ppos + desc->count + PAGE_CACHE_SIZE-1) >> PAGE_CACHE_SHIFT;
 	offset = *ppos & ~PAGE_CACHE_MASK;
 
-	isize = i_size_read(inode);
-	if (!isize)
-		goto out;
-
-	end_index = (isize - 1) >> PAGE_CACHE_SHIFT;
 	for (;;) {
+		loff_t isize;
 		struct page *page;
+		unsigned long end_index;
 		unsigned long nr, ret;
 
+		isize = i_size_read(inode);
+		if (!isize)
+			goto out;
+		end_index = (isize - 1) >> PAGE_CACHE_SHIFT;
+
 		/* nr is the maximum number of bytes to copy from this page */
 		nr = PAGE_CACHE_SIZE;
 		if (index >= end_index) {

--------------040000020905030103030706--
