Return-Path: <linux-kernel-owner+w=401wt.eu-S1758547AbZENWux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758547AbZENWux (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 18:50:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756807AbZENWmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 18:42:36 -0400
Received: from kroah.org ([198.145.64.141]:52446 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755976AbZENWmS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 18:42:18 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu May 14 15:35:24 2009
Message-Id: <20090514223524.549113762@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 14 May 2009 15:33:01 -0700
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
       Jeff Layton <jlayton@redhat.com>, Suresh Jayaraman <sjayaraman@suse.de>,
       Steve French <sfrench@us.ibm.com>
Subject: [patch 26/51] cifs: Fix incorrect destination buffer size in cifs_strncpy_to_host
References: <20090514223235.348540705@mini.kroah.org>
Content-Disposition: inline; filename=cifs-fix-incorrect-destination-buffer-size-in-cifs_strncpy_to_host.patch
In-Reply-To: <20090514223755.GA27019@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Suresh Jayaraman <sjayaraman@suse.de>


Relevant commits 968460ebd8006d55661dec0fb86712b40d71c413 and 
066ce6899484d9026acd6ba3a8dbbedb33d7ae1b. Minimal hunks to fix buffer
size and fix an existing problem pointed out by Guenter Kukuk that length
of src is used for NULL termination of dst. 

cifs: Rename cifs_strncpy_to_host and fix buffer size

There is a possibility for the path_name and node_name buffers to
overflow if they contain charcters that are >2 bytes in the local
charset. Resize the buffer allocation so to avoid this possibility.

Also, as pointed out by Jeff Layton, it would be appropriate to
rename the function to cifs_strlcpy_to_host to reflect the fact
that the copied string is always NULL terminated.

Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>
Acked-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/cifssmb.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -91,23 +91,22 @@ static int
 cifs_strncpy_to_host(char **dst, const char *src, const int maxlen,
 		 const bool is_unicode, const struct nls_table *nls_codepage)
 {
-	int plen;
+	int src_len, dst_len;
 
 	if (is_unicode) {
-		plen = UniStrnlen((wchar_t *)src, maxlen);
-		*dst = kmalloc(plen + 2, GFP_KERNEL);
+		src_len = UniStrnlen((wchar_t *)src, maxlen);
+		*dst = kmalloc((4 * src_len) + 2, GFP_KERNEL);
 		if (!*dst)
 			goto cifs_strncpy_to_host_ErrExit;
-		cifs_strfromUCS_le(*dst, (__le16 *)src, plen, nls_codepage);
+		dst_len = cifs_strfromUCS_le(*dst, (__le16 *)src, src_len, nls_codepage);
+		(*dst)[dst_len + 1] = 0;
 	} else {
-		plen = strnlen(src, maxlen);
-		*dst = kmalloc(plen + 2, GFP_KERNEL);
+		src_len = strnlen(src, maxlen);
+		*dst = kmalloc(src_len + 1, GFP_KERNEL);
 		if (!*dst)
 			goto cifs_strncpy_to_host_ErrExit;
-		strncpy(*dst, src, plen);
+		strlcpy(*dst, src, src_len + 1);
 	}
-	(*dst)[plen] = 0;
-	(*dst)[plen+1] = 0; /* harmless for ASCII case, needed for Unicode */
 	return 0;
 
 cifs_strncpy_to_host_ErrExit:


