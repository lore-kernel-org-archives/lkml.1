Return-Path: <linux-kernel-owner+w=401wt.eu-S1161456AbXB0AI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161456AbXB0AI2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 19:08:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161454AbXB0AIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 19:08:05 -0500
Received: from mail.kroah.org ([69.55.234.183]:44813 "EHLO perch.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161456AbXB0AHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 19:07:12 -0500
Date: Mon, 26 Feb 2007 16:06:35 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Shirish Pargaonkar <shirishp@us.ibm.com>,
       Steve French <sfrench@us.ibm.com>
Subject: [patch 6/9] Fix oops when Windows server sent bad domain name null terminator
Message-ID: <20070227000635.GG6283@kroah.com>
References: <20070226235248.438556696@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-oops-when-windows-server-sent-bad-domain-name-null-terminator.patch"
In-Reply-To: <20070227000538.GA6283@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Steve French <sfrench@us.ibm.com>

[CIFS] Fix oops when Windows server sent bad domain name null terminator

Fixes RedHat bug 211672

Windows sends one byte (instead of two) of null to terminate final Unicode
string (domain name) in session setup response in some cases - this caused
cifs to misalign some informational strings (making it hard to convert
from UCS16 to UTF8).

Thanks to Shaggy for his help and Akemi Yagi for debugging/testing

Signed-off-by: Shirish Pargaonkar <shirishp@us.ibm.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/sess.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- linux-2.6.19.5.orig/fs/cifs/sess.c
+++ linux-2.6.19.5/fs/cifs/sess.c
@@ -182,11 +182,14 @@ static int decode_unicode_ssetup(char **
 	cFYI(1,("bleft %d",bleft));
 
 
-	/* word align, if bytes remaining is not even */
-	if(bleft % 2) {
-		bleft--;
-		data++;
-	}
+	/* SMB header is unaligned, so cifs servers word align start of
+	   Unicode strings */
+	data++;
+	bleft--; /* Windows servers do not always double null terminate
+		    their final Unicode string - in which case we
+		    now will not attempt to decode the byte of junk
+		    which follows it */
+
 	words_left = bleft / 2;
 
 	/* save off server operating system */

--
