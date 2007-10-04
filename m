Return-Path: <linux-kernel-owner+w=401wt.eu-S1758232AbXJDNHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758232AbXJDNHh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 09:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755105AbXJDNHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 09:07:30 -0400
Received: from rtsoft2.corbina.net ([85.21.88.2]:50074 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with SMTP id S1753877AbXJDNH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 09:07:29 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Oct 2007 09:07:28 EDT
Message-ID: <4704DC57.9040001@dev.rtsoft.ru>
Date: Thu, 04 Oct 2007 16:28:07 +0400
From: Rusev <arusev@dev.rtsoft.ru>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: JBD-DEBUG /proc/sys entry (again)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

All that should be moved to DEBUGFS under /sys/kernel/debug  and so on
-  that's right, a bit other issue
is of interest for me.

My suggestion is that a few other problems with PROCFS exist:

>From my observation there are two major issues are involved:

1.  /proc/sys entry has very specific readdir operation (vs. other
entries such as /proc/drivers and others)
    entries to /proc/sys is likely is to be performed by means of other API.
    (quick search found thet API explanation for 2.4.xx
http://www.opentech.at/papers/embedded_proc/node33.html,
     yet it looks to be a little change in 2.6)

2.  function xlate_proc_name behaves not the way it specified in it's
header comment:
      [1]  minor issue is that proc_match wolud likely return "equals"
as result of comparison of "sys" and "sysvipc"
      [2] more significant issue is that it can't properly walk long
paths  such as /proc/sys/jbd/jbd-debug,
           but only paths likes /proc/sys/jbd-debug  (just one step
down, path walking is broken).

This way we can't add not only /proc/sys/jbd/jbd-debug but any path
likes /proc/aaa/bbb/xxx-debug at one step.
The entry /proc/sys is still specific, because even if fixing
xlate_proc_name we can't see /proc/sys/jbd/jbd-debug
in userspace and successfully see /proc/aaa/bbb/jbd-debug.

That's because /proc/sys specific operator readdir blocks such PROCFS
entries that they are NOTproperly registersd
 with CTL_TABLE.

Yet I think that we have a general problem with
adding-long-paths-in-one-step, which is addressed by the following patch:



diff -uprN linux-2.6.21.orig/fs/proc/generic.c
linux-2.6.21/fs/proc/generic.c
--- linux-2.6.21.orig/fs/proc/generic.c 2007-09-13 15:36:07.000000000 +0400
+++ linux-2.6.21/fs/proc/generic.c      2007-10-03 22:12:57.000000000 +0400
@@ -298,6 +298,7 @@ static int xlate_proc_name(const char *n
        int                     len;
        int                     rtn = 0;

+
        spin_lock(&proc_subdir_lock);
        de = &proc_root;
        while (1) {
@@ -305,24 +306,52 @@ static int xlate_proc_name(const char *n
                if (!next)
                        break;

-               len = next - cp;
-               for (de = de->subdir; de ; de = de->next) {
-                       if (proc_match(len, cp, de))
-                               break;
-               }
-               if (!de) {
-                       rtn = -ENOENT;
-                       goto out;
-               }
-               cp += len + 1;
-       }
+                ++next;
+
+
+                len = next - cp;
+
+                if(de->subdir == NULL){
+                  /* directory "de" is empty, add myself to it now */
+                  char* my_name = kzalloc( (len - 1)  + 1, GFP_KERNEL);
+                  memcpy(my_name, cp, len - 1);
+                  proc_mkdir(my_name,de);
+                  kfree(my_name);
+                }
+
+
+                struct proc_dir_entry   *parent_de = de;
+                for (de = parent_de->subdir; de ; de = de->next) {
+                  if (proc_match(len - 1, cp, de))
+                                break;
+
+                }
+
+                if(de == NULL){
+                  /* we found no appropriate subdirectory, well create
it now */
+                  char* my_name = kzalloc( (len - 1)  + 1, GFP_KERNEL);
+                  memcpy(my_name, cp, len - 1);
+                  de = proc_mkdir(my_name,parent_de);
+                  kfree(my_name);
+                }
+
+
+
+                if (!de){
+                        rtn = -ENOENT;
+                        goto out;
+               }
+                cp += len;
+        }
        *residual = cp;
        *ret = de;
 out:
        spin_unlock(&proc_subdir_lock);
        return rtn;
+
 }

+
 static DEFINE_IDR(proc_inum_idr);
 static DEFINE_SPINLOCK(proc_inum_lock); /* protects the above */

