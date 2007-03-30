Return-Path: <linux-kernel-owner+w=401wt.eu-S1754008AbXC3VMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008AbXC3VMr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 17:12:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753999AbXC3VMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 17:12:43 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51730 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998AbXC3VMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 17:12:19 -0400
Date: Fri, 30 Mar 2007 14:06:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Alan Tyso <atyson@hp.com>,
       Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@us.ibm.com>
Subject: [patch 31/37] CIFS: reset mode when client notices that
	ATTR_READONLY is no longer set
Message-ID: <20070330210647.GH29450@kroah.com>
References: <20070330205938.984247529@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="cifs-reset-mode-when-client-notices-that-attr_readonly-is-no-longer-set.patch"
In-Reply-To: <20070330210334.GA29450@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Alan Tyson <atyson@hp.com>

[CIFS] reset mode when client notices that ATTR_READONLY is no longer set

[<cebbert@redhat.com>: removed changelog part of patch]

Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Alan Tyso <atyson@hp.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 fs/cifs/inode.c   |    6 ++++++
 fs/cifs/readdir.c |    4 ++++
 2 files changed, 10 insertions(+)

--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -488,6 +488,12 @@ int cifs_get_inode_info(struct inode **p
 			   mode e.g. 555 */
 			if (cifsInfo->cifsAttrs & ATTR_READONLY)
 				inode->i_mode &= ~(S_IWUGO);
+			else if ((inode->i_mode & S_IWUGO) == 0)
+				/* the ATTR_READONLY flag may have been	*/
+				/* changed on server -- set any w bits	*/
+				/* allowed by mnt_file_mode		*/
+				inode->i_mode |= (S_IWUGO &
+						  cifs_sb->mnt_file_mode);
 		/* BB add code here -
 		   validate if device or weird share or device type? */
 		}
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -215,6 +215,10 @@ static void fill_in_inode(struct inode *
 		tmp_inode->i_mode |= S_IFREG;
 		if (attr & ATTR_READONLY)
 			tmp_inode->i_mode &= ~(S_IWUGO);
+		else if ((tmp_inode->i_mode & S_IWUGO) == 0)
+			/* the ATTR_READONLY flag may have been changed on   */
+		   	/* server -- set any w bits allowed by mnt_file_mode */
+			tmp_inode->i_mode |= (S_IWUGO & cifs_sb->mnt_file_mode);
 	} /* could add code here - to validate if device or weird share type? */
 
 	/* can not fill in nlink here as in qpathinfo version and Unx search */

-- 
