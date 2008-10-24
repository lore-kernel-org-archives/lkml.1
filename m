Return-Path: <linux-kernel-owner+w=401wt.eu-S1756694AbYJXEof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694AbYJXEof (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 00:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbYJXEj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 00:39:27 -0400
Received: from kroah.org ([198.145.64.141]:51785 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752625AbYJXEjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 00:39:19 -0400
Date: Thu, 23 Oct 2008 21:34:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
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
       Steve French <sfrench@us.ibm.com>
Subject: [patch 14/27] CIFS: fix saving of resume key before CIFSFindNext
Message-ID: <20081024043434.GO30828@kroah.com>
References: <20081024042023.054190751@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="cifs-fix-saving-of-resume-key-before-cifsfindnext.patch"
In-Reply-To: <20081024043303.GA30828@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us 
know.

------------------
From: Jeff Layton <sfrench@us.ibm.com>

commit a364bc0b37f14ffd66c1f982af42990a9d77fa43 upstream

We recently fixed the cifs readdir code so that it saves the resume key
before calling CIFSFindNext. Unfortunately, this assumes that we have
just done a CIFSFindFirst (or FindNext) and have resume info to save.
This isn't necessarily the case. Fix the code to save resume info if we
had to reinitiate the search, and after a FindNext.

This fixes connectathon basic test6 against NetApp filers.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/readdir.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -762,14 +762,15 @@ static int find_cifs_entry(const int xid
 				 rc));
 			return rc;
 		}
+		cifs_save_resume_key(cifsFile->srch_inf.last_entry, cifsFile);
 	}
 
 	while ((index_to_find >= cifsFile->srch_inf.index_of_last_entry) &&
 	      (rc == 0) && !cifsFile->srch_inf.endOfSearch) {
 		cFYI(1, ("calling findnext2"));
-		cifs_save_resume_key(cifsFile->srch_inf.last_entry, cifsFile);
 		rc = CIFSFindNext(xid, pTcon, cifsFile->netfid,
 				  &cifsFile->srch_inf);
+		cifs_save_resume_key(cifsFile->srch_inf.last_entry, cifsFile);
 		if (rc)
 			return -ENOENT;
 	}

-- 
