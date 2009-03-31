Return-Path: <linux-kernel-owner+w=401wt.eu-S1764021AbZCaX3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764021AbZCaX3d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 19:29:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762534AbZCaXUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 19:20:49 -0400
Received: from sous-sol.org ([216.99.217.87]:33202 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762510AbZCaXUs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 19:20:48 -0400
Message-Id: <20090331231511.951048737@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Tue, 31 Mar 2009 16:11:01 -0700
From: Chris Wright <chrisw@sous-sol.org>
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
       alan@lxorguk.ukuu.org.uk, Jeff Layton <jlayton@tupile.poochiereds.net>,
       Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@us.ibm.com>
Subject: [patch 16/45] cifs: fix buffer format byte on NT Rename/hardlink
References: <20090331231045.719396245@sous-sol.org>
Content-Disposition: inline; filename=cifs-fix-buffer-format-byte-on-nt-rename-hardlink.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Jeff Layton <jlayton@tupile.poochiereds.net>

upstream commit: fcc7c09d94be7b75c9ea2beb22d0fae191c6b4b9

Discovered at Connnectathon 2009...

The buffer format byte and the pad are transposed in NT_RENAME calls
(which are used to set hardlinks). Most servers seem to ignore this
fact, but NetApp filers throw back an error due to this problem. This
patch fixes it.

CC: Stable <stable@kernel.org>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 fs/cifs/cifssmb.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -2356,8 +2356,10 @@ winCreateHardLinkRetry:
 				     PATH_MAX, nls_codepage, remap);
 		name_len++;	/* trailing null */
 		name_len *= 2;
-		pSMB->OldFileName[name_len] = 0;	/* pad */
-		pSMB->OldFileName[name_len + 1] = 0x04;
+
+		/* protocol specifies ASCII buffer format (0x04) for unicode */
+		pSMB->OldFileName[name_len] = 0x04;
+		pSMB->OldFileName[name_len + 1] = 0x00; /* pad */
 		name_len2 =
 		    cifsConvertToUCS((__le16 *)&pSMB->OldFileName[name_len + 2],
 				     toName, PATH_MAX, nls_codepage, remap);

