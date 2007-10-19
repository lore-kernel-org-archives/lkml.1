Return-Path: <linux-kernel-owner+w=401wt.eu-S1765645AbXJSHRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765645AbXJSHRd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 03:17:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751312AbXJSHR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 03:17:26 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:23208 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751975AbXJSHRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 03:17:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Message-Id;
  b=UWLY8HmwfATueEwtMoNFsyX2bcullNsPTOTwJhKGM4naFaKljrLfP63is586PtxBEFJzt59eJxzg9oGIpTksKWWgMR9bbjJryY7l8fbQkwqhe1s5UMwYGVUWvQG5yaVuw4iZHw1kXUzJtRB/g9gjJctiGdBDubw7VmcPn35cgEc=  ;
X-YMail-OSG: ljMVDL8VM1kIKoK87mU1N4eczIvTQJa1vI9vGtvofKaX1PYJRys_2gYctJKLRTIvj6scwxkuyA--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Erez Zadok <ezk@cs.sunysb.edu>
Subject: Re: BUG at mm/filemap.c:1749 (2.6.24, jffs2, unionfs)
Date: Fri, 19 Oct 2007 17:16:53 +1000
User-Agent: KMail/1.9.5
Cc: dwmw2@infradead.org, jffs-dev@axis.com, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org
References: <200710190605.l9J65kDe008069@agora.fsl.cs.sunysb.edu> <200710191703.12026.nickpiggin@yahoo.com.au>
In-Reply-To: <200710191703.12026.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_lnFGHwOggSRGKPd"
Message-Id: <200710191716.53470.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_lnFGHwOggSRGKPd
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Friday 19 October 2007 17:03, Nick Piggin wrote:
> On Friday 19 October 2007 16:05, Erez Zadok wrote:
> > David,
> >
> > I'm testing unionfs on top of jffs2, using 2.6.24 as of linus's commit
> > 4fa4d23fa20de67df919030c1216295664866ad7.  All of my unionfs tests pass
> > when unionfs is stacked on top of jffs2, other than my truncate test --
> > whic tries to truncate files up/down (through the union, which then is
> > passed through to the lower jffs2 f/s).  The same truncate test passes on
> > all other file systems I've tried unionfs/2.6.24 with, as well as all of
> > the earlier kernels that unionfs runs on (2.6.9--2.6.23).  So I tend to
> > think this bug is more probably due to something else going on in 2.6.24,
> > possibly wrt jffs2/mtd.  (Of course, it's still possible that unionfs
> > isn't doing something right -- any pointers?)
> >
> > The oops trace is included below.  Is this a known issue and if so, any
> > fixes?  If this is the first you hear of this problem, let me know and
> > I'll try to narrow it down further.
>
> It's had quite a lot of recent changes in that area -- the "new aops"
> patches.
>
> They've been getting quite a bit of testing in -mm and no such problems,
> but I doubt anyone was doing much unionfs over jffs2, or even much jffs2
> testing with -mm.
>
> The bug smells like jffs2 is actually passing back a "written" length
> greater than the length we passed into it.
>
> The following might show what's happening.

Hmm, looks like jffs2_write_end is writing more than we actually ask it
to, and returns that back.

        unsigned aligned_start = start & ~3;

and

        if (end == PAGE_CACHE_SIZE) {
                /* When writing out the end of a page, write out the
                   _whole_ page. This helps to reduce the number of
                   nodes in files which have many short writes, like
                   syslog files. */
                start = aligned_start = 0;
        }

These "longer" writes are fine, but they shouldn't get propagated back
to the vm/vfs. Something like the following patch might fix it.


--Boundary-00=_lnFGHwOggSRGKPd
Content-Type: text/x-diff;
  charset="utf-8";
  name="jffs2-writtenlen-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="jffs2-writtenlen-fix.patch"

Index: linux-2.6/fs/jffs2/file.c
===================================================================
--- linux-2.6.orig/fs/jffs2/file.c
+++ linux-2.6/fs/jffs2/file.c
@@ -255,7 +255,7 @@ static int jffs2_write_end(struct file *
 		   _whole_ page. This helps to reduce the number of
 		   nodes in files which have many short writes, like
 		   syslog files. */
-		start = aligned_start = 0;
+		aligned_start = 0;
 	}
 
 	ri = jffs2_alloc_raw_inode();
@@ -291,14 +291,11 @@ static int jffs2_write_end(struct file *
 	}
 
 	/* Adjust writtenlen for the padding we did, so we don't confuse our caller */
-	if (writtenlen < (start&3))
-		writtenlen = 0;
-	else
-		writtenlen -= (start&3);
+	writtenlen -= min(writtenlen, (start - aligned_start));
 
 	if (writtenlen) {
-		if (inode->i_size < (pg->index << PAGE_CACHE_SHIFT) + start + writtenlen) {
-			inode->i_size = (pg->index << PAGE_CACHE_SHIFT) + start + writtenlen;
+		if (inode->i_size < pos + start + writtenlen) {
+			inode->i_size = pos + start + writtenlen;
 			inode->i_blocks = (inode->i_size + 511) >> 9;
 
 			inode->i_ctime = inode->i_mtime = ITIME(je32_to_cpu(ri->ctime));

--Boundary-00=_lnFGHwOggSRGKPd--
