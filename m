Return-Path: <linux-kernel-owner+w=401wt.eu-S1753289AbYJFKKL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbYJFKKL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 06:10:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392AbYJFKJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 06:09:59 -0400
Received: from gir.skynet.ie ([193.1.99.77]:35984 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752334AbYJFKJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 06:09:58 -0400
Date: Mon, 6 Oct 2008 11:09:55 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
       dave@linux.vnet.ibm.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Report the pagesize backing a VMA in /proc/pid/maps
Message-ID: <20081006100955.GB10212@csn.ul.ie>
References: <1223052415-18956-1-git-send-email-mel@csn.ul.ie> <1223052415-18956-3-git-send-email-mel@csn.ul.ie> <20081004221339.GA20175@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20081004221339.GA20175@x200.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (05/10/08 02:13), Alexey Dobriyan didst pronounce:
> On Fri, Oct 03, 2008 at 05:46:55PM +0100, Mel Gorman wrote:
> > This patch adds a new field for hugepage-backed memory regions to show the
> > pagesize in /proc/pid/maps.  While the information is available in smaps,
> > maps is more human-readable and does not incur the cost of calculating Pss. An
> > example of a /proc/self/maps output for an application using hugepages with
> > this patch applied is;
> > 
> > 08048000-0804c000 r-xp 00000000 03:01 49135      /bin/cat
> > 0804c000-0804d000 rw-p 00003000 03:01 49135      /bin/cat
> > 08400000-08800000 rw-p 00000000 00:10 4055       /mnt/libhugetlbfs.tmp.QzPPTJ (deleted) (hpagesize=4096kB)
> 
> > To be predictable for parsers, the patch adds the notion of reporting on VMA
> > attributes by appending one or more fields that look like "(attribute)". This
> > already happens when a file is deleted and the user sees (deleted) after the
> > filename. The expectation is that existing parsers will not break as those
> > that read the filename should be reading forward after the inode number
> > and stopping when it sees something that is not part of the filename.
> > Parsers that assume everything after / is a filename will get confused by
> > (hpagesize=XkB) but are already broken due to (deleted).
> 
> Looks like procps will start showing hpagesize tag as a mapping name
> (apologies for pasting crappy code):
> 

Looks that way. How about....

>From 0bb7a585e9c62efc675110fe50583113ded83ff5 Mon Sep 17 00:00:00 2001
From: Mel Gorman <mel@csn.ul.ie>
Date: Mon, 6 Oct 2008 10:40:33 +0100
Subject: [PATCH 1/1] procps: Strip attributes from filenames in the output of pmap

It is possible that additional attributes about a file are printed in
/proc/PID/maps such as the pagesize used to back a hugetlbfs mapping. It
is not expected that this be printed in the output of pmap. This patch
strips all attributes but (deleted) from the output of pmap. (deleted)
is left as it was historically displayed.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 pmap.c |   57 +++++++++++++++++++++++++++++++++++++++++++--------------
 1 files changed, 43 insertions(+), 14 deletions(-)

diff --git a/pmap.c b/pmap.c
index a46c696..a56ee94 100644
--- a/pmap.c
+++ b/pmap.c
@@ -17,6 +17,7 @@
 #include <fcntl.h>
 #include <string.h>
 #include <unistd.h>
+#include <errno.h>
 
 #include <sys/ipc.h>
 #include <sys/shm.h>
@@ -93,8 +94,11 @@ out_destroy:
 }
 
 
-static const char *mapping_name(proc_t *p, unsigned KLONG addr, unsigned KLONG len, const char *mapbuf, unsigned showpath, unsigned dev_major, unsigned dev_minor, unsigned long long inode){
-  const char *cp;
+static const char *mapping_name(proc_t *p, unsigned KLONG addr, unsigned KLONG len, char *mapbuf, unsigned showpath, unsigned dev_major, unsigned dev_minor, unsigned long long inode){
+
+  char *cp;
+  char *cpfull;
+  const char *anon_cp;
 
   if(!dev_major && dev_minor==shm_minor && strstr(mapbuf,"/SYSV")){
     static char shmbuf[64];
@@ -102,21 +106,46 @@ static const char *mapping_name(proc_t *p, unsigned KLONG addr, unsigned KLONG l
     return shmbuf;
   }
 
-  cp = strrchr(mapbuf,'/');
-  if(cp){
-    if(showpath) return strchr(mapbuf,'/');
-    return cp[1] ? cp+1 : cp;
-  }
+  cpfull = strchr(mapbuf,'/');
+  if(cpfull){
+    struct stat statbuf;
+
+    /*
+     * Strip out attributes from the filename. Attributes can be printed
+     * after a filename like (attribute[=value]) and we don't print them
+     * out here with the exception of (deleted). We use stat() to determine
+     * if something is part of the filename or an attribute
+     */
+    while (stat(cpfull, &statbuf) == -1 && errno == ENOENT){
+      cp = strrchr(cpfull,'(');
+
+      /* Stop if there are no other attributes */
+      if (!cp || strchr(cp,')') == NULL)
+        break;
+
+      /* If the attribute looks like deleted, just stop and leave (deleted) */
+      if (cp && !strncmp(cp+1, "deleted", 7))
+	break;
+
+      /* Move back to see if this looks like an attribute */
+      if (--cp <= cpfull)
+        break;
+
+      /* If this looks like an attribute, remove it */
+      if (cp[0] == ' ')
+        *cp = '\0';
+    }
+
+    if(showpath)
+      return cpfull;
 
-  cp = strchr(mapbuf,'/');
-  if(cp){
-    if(showpath) return cp;
-    return strrchr(cp,'/') + 1;  // it WILL succeed
+    cp = strrchr(cpfull,'/');
+    return cp[1] ? cp+1 : cp;
   }
 
-  cp = "  [ anon ]";
-  if( (p->start_stack >= addr) && (p->start_stack <= addr+len) )  cp = "  [ stack ]";
-  return cp;
+  anon_cp = "  [ anon ]";
+  if( (p->start_stack >= addr) && (p->start_stack <= addr+len) ) anon_cp = "  [ stack ]";
+  return anon_cp;
 }
 
 static int one_proc(proc_t *p){
-- 
1.5.6.5

