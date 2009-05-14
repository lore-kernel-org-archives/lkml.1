Return-Path: <linux-kernel-owner+w=401wt.eu-S1761570AbZENXI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761570AbZENXI1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 19:08:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762269AbZENW6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 18:58:49 -0400
Received: from kroah.org ([198.145.64.141]:46107 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762275AbZENW6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 18:58:44 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu May 14 15:52:39 2009
Message-Id: <20090514225239.495123865@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 14 May 2009 15:51:45 -0700
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
Subject: [patch 19/28] cifs: Fix unicode string area word alignment in session setup
References: <20090514225126.907908936@mini.kroah.org>
Content-Disposition: inline; filename=cifs-fix-unicode-string-area-word-alignment-in-session-setup.patch
In-Reply-To: <20090514225413.GA705@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit 27b87fe52baba0a55e9723030e76fce94fabcea4 refreshed.

cifs: fix unicode string area word alignment in session setup

The handling of unicode string area alignment is wrong.
decode_unicode_ssetup improperly assumes that it will always be preceded
by a pad byte. This isn't the case if the string area is already
word-aligned.

This problem, combined with the bad buffer sizing for the serverDomain
string can cause memory corruption. The bad alignment can make it so
that the alignment of the characters is off. This can make them
translate to characters that are greater than 2 bytes each. If this
happens we can overflow the allocation.

Fix this by fixing the alignment in CIFS_SessSetup instead so we can
verify it against the head of the response. Also, clean up the
workaround for improperly terminated strings by checking for a
odd-length unicode buffers and then forcibly terminating them.

Finally, resize the buffer for serverDomain. Now that we've fixed
the alignment, it's probably fine, but a malicious server could
overflow it.

A better solution for handling these strings is still needed, but
this should be a suitable bandaid.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Cc: Suresh Jayaraman <sjayaraman@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/sess.c |   44 +++++++++++++++++++++++---------------------
 1 file changed, 23 insertions(+), 21 deletions(-)

--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -202,27 +202,26 @@ static int decode_unicode_ssetup(char **
 	int words_left, len;
 	char *data = *pbcc_area;
 
-
-
 	cFYI(1, ("bleft %d", bleft));
 
-
-	/* SMB header is unaligned, so cifs servers word align start of
-	   Unicode strings */
-	data++;
-	bleft--; /* Windows servers do not always double null terminate
-		    their final Unicode string - in which case we
-		    now will not attempt to decode the byte of junk
-		    which follows it */
+	/*
+	 * Windows servers do not always double null terminate their final
+	 * Unicode string. Check to see if there are an uneven number of bytes
+	 * left. If so, then add an extra NULL pad byte to the end of the
+	 * response.
+	 *
+	 * See section 2.7.2 in "Implementing CIFS" for details
+	 */
+	if (bleft % 2) {
+		data[bleft] = 0;
+		++bleft;
+	}
 
 	words_left = bleft / 2;
 
 	/* save off server operating system */
 	len = UniStrnlen((wchar_t *) data, words_left);
 
-/* We look for obvious messed up bcc or strings in response so we do not go off
-   the end since (at least) WIN2K and Windows XP have a major bug in not null
-   terminating last Unicode string in response  */
 	if (len >= words_left)
 		return rc;
 
@@ -260,13 +259,10 @@ static int decode_unicode_ssetup(char **
 		return rc;
 
 	kfree(ses->serverDomain);
-	ses->serverDomain = kzalloc(2 * (len + 1), GFP_KERNEL); /* BB FIXME wrong length */
-	if (ses->serverDomain != NULL) {
+	ses->serverDomain = kzalloc((4 * len) + 2, GFP_KERNEL);
+	if (ses->serverDomain != NULL)
 		cifs_strfromUCS_le(ses->serverDomain, (__le16 *)data, len,
 				   nls_cp);
-		ses->serverDomain[2*len] = 0;
-		ses->serverDomain[(2*len) + 1] = 0;
-	}
 	data += 2 * (len + 1);
 	words_left -= len + 1;
 
@@ -616,12 +612,18 @@ CIFS_SessSetup(unsigned int xid, struct 
 	}
 
 	/* BB check if Unicode and decode strings */
-	if (smb_buf->Flags2 & SMBFLG2_UNICODE)
+	if (smb_buf->Flags2 & SMBFLG2_UNICODE) {
+		/* unicode string area must be word-aligned */
+		if (((unsigned long) bcc_ptr - (unsigned long) smb_buf) % 2) {
+			++bcc_ptr;
+			--bytes_remaining;
+		}
 		rc = decode_unicode_ssetup(&bcc_ptr, bytes_remaining,
-						   ses, nls_cp);
-	else
+					   ses, nls_cp);
+	} else {
 		rc = decode_ascii_ssetup(&bcc_ptr, bytes_remaining,
 					 ses, nls_cp);
+	}
 
 ssetup_exit:
 	if (spnego_key)


