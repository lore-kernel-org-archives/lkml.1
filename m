Return-Path: <linux-kernel-owner+w=401wt.eu-S1765106AbZD3RNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765106AbZD3RNV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764393AbZD3RHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:07:30 -0400
Received: from kroah.org ([198.145.64.141]:56249 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764203AbZD3RHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:07:23 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Apr 30 09:57:40 2009
Message-Id: <20090430165740.359724200@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 30 Apr 2009 09:56:03 -0700
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
       alan@lxorguk.ukuu.org.uk, Jeff Layton <jlayton@redhat.com>,
       Steve French <sfrench@us.ibm.com>, Chris Wright <chrisw@sous-sol.org>
Subject: [patch 14/88] cifs: fix buffer format byte on NT Rename/hardlink
References: <20090430165549.117010404@mini.kroah.org>
Content-Disposition: inline; filename=0016-cifs-fix-buffer-format-byte-on-NT-Rename-hardlink.patch
In-Reply-To: <20090430170122.GA16015@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeff Layton <jlayton@tupile.poochiereds.net>

upstream commit: fcc7c09d94be7b75c9ea2beb22d0fae191c6b4b9

Discovered at Connnectathon 2009...

The buffer format byte and the pad are transposed in NT_RENAME calls
(which are used to set hardlinks). Most servers seem to ignore this
fact, but NetApp filers throw back an error due to this problem. This
patch fixes it.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/cifs/cifssmb.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -2350,8 +2350,10 @@ winCreateHardLinkRetry:
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


