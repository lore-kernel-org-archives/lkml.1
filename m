Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621Ab0BVS7u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 13:59:50 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:53252 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752995Ab0BVS7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 13:59:49 -0500
Date: Mon, 22 Feb 2010 19:59:28 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jean Delvare <khali@linux-fr.org>, lasse.collin@tukaani.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: ketchup was Re: [kernel.org users] XZ Migration discussion
Message-ID: <20100222185928.GA1572@ucw.cz>
References: <4B744E13.8040004@kernel.org> <20100212150137.648dca7c@hyperion.delvare> <1265988318.24271.30.camel@gandalf.stny.rr.com> <20100216153905.GA1541@ucw.cz> <1266337061.24271.138.camel@gandalf.stny.rr.com> <20100216162745.GA1660@ucw.cz> <20100221135341.GC1307@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100221135341.GC1307@ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2010-02-21 14:53:41, Pavel Machek wrote:
> On Tue 2010-02-16 17:27:45, Pavel Machek wrote:
> > Add --only-dl option -- when you want to cache the needed patches but
> > not apply anything yet.
> 
> Actually, you'll probably get a better patch if you relace 'only-dl'
> with just 'dl'. Mistaking --only-dl and --dl-only is just too easy.

This should work; save time&bandwidth by using incremental patches
between -rcX.

Is there testsuite for ketchup? It would be useful at this point...

   	 	       		   	    	      	   Pavel

--- ketchup.orig	2010-02-16 16:36:51.000000000 +0100
+++ ketchup	2010-02-22 19:53:56.000000000 +0100
@@ -107,19 +107,32 @@
 # Functions to parse version strings
 
 def tree(ver):
+    """returns 2.6"""
     return float(re.match(r'(\d+\.\d+)', ver).group(1))
 
+def rawrev(ver):
+    """given 2.6.31 or 2.6.31-rc1 returns 31"""
+    return int(re.match(r'\d+\.\d+\.(\d+)', ver).group(1))
+
 def rev(ver):
+    """given 2.6.31 or 2.6.32-rc1 returns 31"""
     p = pre(ver)
-    r = int(re.match(r'\d+\.\d+\.(\d+)', ver).group(1))
+    r = rawrev(ver)
     if p: r = r - 1
     return r
 
 def pre(ver):
+    """returns rc5"""
     try: return re.match(r'\d+\.\d+\.\d+(\.\d+)?-((rc|pre)\d+)', ver).group(2)
     except: return None
 
+def next_pre(ver, inc = 1):
+    s = pre(ver)
+    i = int(re.match(r'rc(\d+)', s).group(1))
+    return "rc%d" % (i+inc)
+
 def post(ver):
+    """given 2.6.27.1 returns 1"""
     try: return re.match(r'\d+\.\d+\.\d+\.(\d+)', ver).group(1)
     except: return None
 
@@ -132,9 +145,15 @@
     except: return None
 
 def prebase(ver):
+    """returns 2.6.13-rc1"""
     return re.match(r'(\d+\.\d+\.\d+((-(rc|pre)|\.)\d+)?)', ver).group(1)
 
+def preincr(ver):
+    """only use when incremental patches are requested"""
+    return re.match(r'(\d+\.\d+\.\d+((-(rc|pre)|\.).+)?)', ver).group(1)
+
 def revbase(ver):
+    """returns 2.6.23 for 2.6.23.15 or 2.6.24-rc5"""
     return "%s.%s" % (tree(ver), rev(ver))
 
 def base(ver):
@@ -283,8 +302,12 @@
     f = forkname(ver)
     p = pre(ver)
 
+    print "find_info (ver) ", ver, "f=", f
+
     s = b
-    if f:
+    if re.match(".*rc.*rc.*", ver):
+        s = "%s-incrc" %b
+    elif f:
         s = "%s-%s" % (b, f)
     elif p:
         s = "%s-pre" % b
@@ -297,11 +320,14 @@
     if type(i) != type([]):
         i = [i]
 
+    print "version urls i = ", i    
+
     v = {
         'full': ver,
         'tree': tree(ver),
         'base': base(ver),
-        'prebase': prebase(ver)
+        'prebase': prebase(ver),
+        'preincr': preincr(ver),
         }
 
     l = []
@@ -399,6 +425,7 @@
 def apply_patch(ver, reverse = 0):
     """Find the patch to upgrade from the predecessor of ver to ver and
     apply or reverse it."""
+    print 'apply patch ', ver, ' reverse = ', reverse
     p = get_patch(ver)
     r = ""
     if reverse:
@@ -501,6 +528,24 @@
     else:
         return ver
 
+def step_rc(a, b):
+    rc1base = "%s.%s" % (tree(b), rawrev(b))    
+    print 'stepping from ', a, ' to ', b 
+    while pre(a) != pre(b):
+        if pre(a) < pre(b):
+            next = next_pre(a, 1)
+            s = ("%s-%s-%s" % (rc1base, pre(a), next))
+            apply_patch(s)
+        else:
+            next = next_pre(a, -1)
+            s = ("%s-%s-%s" % (rc1base, next, pre(a)))
+            apply_patch(s, 1)
+
+        print "Applying ", s
+
+        a = "%s-%s" % (rc1base, next)
+        print "Should be at ", a
+
 def transform(a, b):
     if a == b:
         qprint("Nothing to do!")
@@ -514,10 +559,25 @@
     if fork(a):
         apply_patch(a, 1)
         a = prebase(a)
+
+    if base(a) == base(b):
+        if pre(a) and pre(b):
+            print a, ' to ', b, ' possible small steps'
+            step_rc(prebase(a), prebase(b))
+            a = prebase(b)
+
     if prebase(a) != prebase(b):
-        if pre(a):
-            apply_patch(a, 1)
-            a = base(a)
+        print 'prebase ', a, ' is not prebase ', b
+        if (rev(a) != rev(b)) and pre(a):
+            print 'stepping to release, first'
+            rc1base = "%s.%s" % (tree(a), rawrev(a))
+            rc1 = rc1base + '-rc1'
+            print "Base is ", rc1base, "now at ", a, " should go to ", rc1
+            step_rc(a, rc1)
+            print "Should now be on -rc1"
+            apply_patch(rc1, 1)
+            a = base(rc1)
+            print "Should now be at", a
 
         if post(a) and (post(a) != post(b) or rev(a) != rev(b)):
             apply_patch(prebase(a), 1)
@@ -536,9 +596,12 @@
             a = base(b)
 
         if pre(b):
-            apply_patch(prebase(b))
-            a = prebase(b)
-
+            rc1base = "%s.%s" % (tree(b), rawrev(b))
+            rc1 = rc1base + '-rc1'
+            print "Base is ", rc1base, "now at ", a, " should go to ", b
+            apply_patch(rc1)
+            step_rc(rc1, b)
+            
     if fork(b):
         a = apply_patch(b)
 
@@ -573,6 +636,10 @@
             kernel_url + "/v2.6" + "/patch-%(prebase)s.bz2",
             r'patch-(.*?).bz2',
             1, "current stable kernel series"),
+    '2.6-incrc': (latest_dir,
+                kernel_url + "/v2.6" + "/testing/incr/patch-%(preincr)s.bz2",
+                r'patch-(.*?).bz2',
+                1, "current stable kernel series prereleases -- incremental"),
     '2.6-rc': (latest_dir,
                 kernel_url + "/v2.6" + "/testing/patch-%(prebase)s.bz2",
                 r'patch-(.*?).bz2',




-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
