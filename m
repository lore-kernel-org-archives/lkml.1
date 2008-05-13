Return-Path: <linux-kernel-owner+w=401wt.eu-S1761601AbYEMRYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761601AbYEMRYT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 13:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753154AbYEMRYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 13:24:09 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:47736 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758313AbYEMRYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 13:24:08 -0400
Message-ID: <4829CEAF.9020806@us.ibm.com>
Date: Tue, 13 May 2008 12:23:59 -0500
From: Jon Tollefson <kniht@us.ibm.com>
Reply-To: kniht@linux.vnet.ibm.com
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org,
       Linux Memory Management List <linux-mm@kvack.org>,
       linuxppc-dev <linuxppc-dev@ozlabs.org>
CC: Paul Mackerras <paulus@samba.org>, Nick Piggin <npiggin@suse.de>,
       Nishanth Aravamudan <nacc@us.ibm.com>, Andi Kleen <andi@firstfloor.org>,
       Adam Litke <agl@us.ibm.com>
Subject: [PATCH 5/6 v2] check for overflow
References: <4829CAC3.30900@us.ibm.com>
In-Reply-To: <4829CAC3.30900@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds a check for an overflow in the filesystem size so if someone is
checking with statfs() on a 16G hugetlbfs  in a 32bit binary that it
will report back EOVERFLOW instead of a size of 0.

Are other places that need a similar check?  I had tried a similar
check in put_compat_statfs64 too but it didn't seem to generate an
EOVERFLOW in my test case.


Signed-off-by: Jon Tollefson <kniht@linux.vnet.ibm.com>
---

 fs/compat.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/compat.c b/fs/compat.c
index 2ce4456..6eb6aad 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -196,8 +196,8 @@ static int put_compat_statfs(struct compat_statfs __user *ubuf, struct kstatfs *
 {
 	
 	if (sizeof ubuf->f_blocks == 4) {
-		if ((kbuf->f_blocks | kbuf->f_bfree | kbuf->f_bavail) &
-		    0xffffffff00000000ULL)
+		if ((kbuf->f_blocks | kbuf->f_bfree | kbuf->f_bavail |
+		     kbuf->f_bsize | kbuf->f_frsize) & 0xffffffff00000000ULL)
 			return -EOVERFLOW;
 		/* f_files and f_ffree may be -1; it's okay
 		 * to stuff that into 32 bits */


