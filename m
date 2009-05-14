Return-Path: <linux-kernel-owner+w=401wt.eu-S1762278AbZENXH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762278AbZENXH4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 19:07:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762290AbZENW6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 18:58:47 -0400
Received: from kroah.org ([198.145.64.141]:46067 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762240AbZENW6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 18:58:40 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu May 14 15:52:38 2009
Message-Id: <20090514225238.810281932@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 14 May 2009 15:51:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Steve French <smfrench@gmail.com>,
       Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@us.ibm.com>,
       Suresh Jayaraman <sjayaraman@suse.de>
Subject: [patch 15/28] cifs: Fix buffer size for tcon->nativeFileSystem field
References: <20090514225126.907908936@mini.kroah.org>
Content-Disposition: inline; filename=cifs-fix-buffer-size-for-tcon-nativefilesystem-field.patch
In-Reply-To: <20090514225413.GA705@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeff Layton <jlayton@redhat.com>

Commit f083def68f84b04fe3f97312498911afce79609e refreshed.

cifs: fix buffer size for tcon->nativeFileSystem field

The buffer for this was resized recently to fix a bug. It's still
possible however that a malicious server could overflow this field
by sending characters in it that are >2 bytes in the local charset.
Double the size of the buffer to account for this possibility.

Also get rid of some really strange and seemingly pointless NULL
termination. It's NULL terminating the string in the source buffer,
but by the time that happens, we've already copied the string.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Cc: Suresh Jayaraman <sjayaraman@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/connect.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3549,16 +3549,12 @@ CIFSTCon(unsigned int xid, struct cifsSe
 			    BCC(smb_buffer_response)) {
 				kfree(tcon->nativeFileSystem);
 				tcon->nativeFileSystem =
-				    kzalloc(2*(length + 1), GFP_KERNEL);
+				    kzalloc((4 * length) + 2, GFP_KERNEL);
 				if (tcon->nativeFileSystem)
 					cifs_strfromUCS_le(
 						tcon->nativeFileSystem,
 						(__le16 *) bcc_ptr,
 						length, nls_codepage);
-				bcc_ptr += 2 * length;
-				bcc_ptr[0] = 0;	/* null terminate the string */
-				bcc_ptr[1] = 0;
-				bcc_ptr += 2;
 			}
 			/* else do not bother copying these information fields*/
 		} else {


