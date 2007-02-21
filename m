Return-Path: <linux-kernel-owner+w=401wt.eu-S1423212AbXBUWg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423212AbXBUWg0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 17:36:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423214AbXBUWgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 17:36:25 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60293 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423212AbXBUWgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 17:36:25 -0500
Message-ID: <45DCC8A7.1020908@redhat.com>
Date: Wed, 21 Feb 2007 17:33:11 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 00/21] 2.6.19-stable review
References: <20070221013619.GA30227@kroah.com>
In-Reply-To: <20070221013619.GA30227@kroah.com>
Content-Type: multipart/mixed;
 boundary="------------000603020406050009090803"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000603020406050009090803
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Greg KH wrote:
> This is the start of the stable review cycle for the 2.6.19.5 release.
> 
> This will probably be the last release of the 2.6.19-stable series, so
> if there are patches that you feel should be applied to that tree,
> please let me know.

This patch should go in 2.6.19 and 2.6.20 -stable as well.
(It's in 2.6.21-rc.)


--------------000603020406050009090803
Content-Type: text/plain;
 name="linux-2.6-CIFS-null-terminator.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="linux-2.6-CIFS-null-terminator.patch"

From: Steve French <sfrench@us.ibm.com>
Date: Mon, 22 Jan 2007 01:19:30 +0000 (+0000)
Subject: [CIFS] Fix oops when Windows server sent bad domain name null terminator
X-Git-Tag: v2.6.20^0~147^2
X-Git-Url: http://www2.kernel.org/git/?p=linux%2Fkernel%2Fgit%2Fsfrench%2Fcifs-2.6.git;a=commitdiff_plain;h=8e6f195af0e1f226e9b2e0256af8df46adb9d595

[CIFS] Fix oops when Windows server sent bad domain name null terminator

Fixes RedHat bug 211672

Windows sends one byte (instead of two) of null to terminate final Unicode
string (domain name) in session setup response in some cases - this caused
cifs to misalign some informational strings (making it hard to convert
from UCS16 to UTF8).

Thanks to Shaggy for his help and Akemi Yagi for debugging/testing

Signed-off-by: Shirish Pargaonkar <shirishp@us.ibm.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
---

diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index bbdda99..7584646 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -182,11 +182,14 @@ static int decode_unicode_ssetup(char ** pbcc_area, int bleft, struct cifsSesInf
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

--------------000603020406050009090803--
