Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260Ab0BUT3b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 14:29:31 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:48954 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751959Ab0BUT3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 14:29:30 -0500
Date: Sun, 21 Feb 2010 20:28:55 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jean Delvare <khali@linux-fr.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, lasse.collin@tukaani.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: ketchup was Re: [kernel.org users] XZ Migration discussion
Message-ID: <20100221192854.GA2217@ucw.cz>
References: <4B744E13.8040004@kernel.org> <20100212150137.648dca7c@hyperion.delvare> <1265988318.24271.30.camel@gandalf.stny.rr.com> <20100216153905.GA1541@ucw.cz> <1266337061.24271.138.camel@gandalf.stny.rr.com> <20100216162745.GA1660@ucw.cz> <20100221135341.GC1307@ucw.cz> <20100221152621.4e3d5389@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100221152621.4e3d5389@hyperion.delvare>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2010-02-21 15:26:21, Jean Delvare wrote:
> On Sun, 21 Feb 2010 14:53:41 +0100, Pavel Machek wrote:
> > On Tue 2010-02-16 17:27:45, Pavel Machek wrote:
> > > Add --only-dl option -- when you want to cache the needed patches but
> > > not apply anything yet.
> > 
> > Actually, you'll probably get a better patch if you relace 'only-dl'
> > with just 'dl'. Mistaking --only-dl and --dl-only is just too easy.
> 
> Or --download. Acronyms just suck.

Works for me.

And here's quick patch to show what I'm doing: it teaches ketchup
about 2.6.33-rc1-rc2 patches, thus saving lot of bandwidth. Of course,
I'll need to get it to work for more than 2.6.A->2.6.B-rcC case,
but...

If there are some comments, or maybe better approach, let me know...
diff --git a/ketchup b/ketchup
index 3249cbc..dc1bbf8 100755
--- a/ketchup
+++ b/ketchup
@@ -107,19 +107,28 @@ local_trees = {}
 # Functions to parse version strings
 
 def tree(ver):
+    """returns 2.6"""
     return float(re.match(r'(\d+\.\d+)', ver).group(1))
 
 def rev(ver):
+    """given 2.6.31 or 2.6.32-rc1 returns 31"""
     p = pre(ver)
     r = int(re.match(r'\d+\.\d+\.(\d+)', ver).group(1))
     if p: r = r - 1
     return r
 
 def pre(ver):
+    """returns rc5"""
     try: return re.match(r'\d+\.\d+\.\d+(\.\d+)?-((rc|pre)\d+)', ver).group(2)
     except: return None
 
+def next_pre(ver):
+    s = pre(ver)
+    i = int(re.match(r'rc(\d+)', s).group(1))
+    return "rc%d" % (i+1)
+
 def post(ver):
+    """given 2.6.27.1 returns 1"""
     try: return re.match(r'\d+\.\d+\.\d+\.(\d+)', ver).group(1)
     except: return None
 
@@ -132,9 +141,15 @@ def prenum(ver):
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
@@ -283,8 +298,12 @@ def find_info(ver):
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
@@ -297,11 +316,14 @@ def version_urls(ver):
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
@@ -399,6 +421,7 @@ def get_patch(ver):
 def apply_patch(ver, reverse = 0):
     """Find the patch to upgrade from the predecessor of ver to ver and
     apply or reverse it."""
+    print 'apply patch ', ver, ' reverse = ', reverse
     p = get_patch(ver)
     r = ""
     if reverse:
@@ -501,6 +524,15 @@ def find_ver(ver):
     else:
         return ver
 
+def remove_pre(a):
+    print 'remove -pre ' + a
+    apply_patch(a, 1)
+
+def goto_pre(a):
+    print 'goto -pre ' + a
+    apply_patch(base(a)+'-rc1', 0)
+    return base(a)+'-rc1'
+
 def transform(a, b):
     if a == b:
         qprint("Nothing to do!")
@@ -514,9 +546,16 @@ def transform(a, b):
     if fork(a):
         apply_patch(a, 1)
         a = prebase(a)
+
+    if base(a) == base(b):
+        if pre(a) and pre(b) and pre(a) < pre(b):
+            print a, ' to ', b, ' possible small steps'
+
     if prebase(a) != prebase(b):
+        print 'prebase ', a, ' is not prebase ', b
         if pre(a):
-            apply_patch(a, 1)
+            print 'pre (a)', pre(a)
+            remove_pre(a)
             a = base(a)
 
         if post(a) and (post(a) != post(b) or rev(a) != rev(b)):
@@ -536,8 +575,21 @@ def transform(a, b):
             a = base(b)
 
         if pre(b):
-            apply_patch(prebase(b))
-            a = prebase(b)
+            print "Now at ", a, " should go to ", b
+            rb = rev(a)
+            rc1base = "%s.%s" % (t, rb+1)
+            print "... ", rc1base
+            a = goto_pre(rc1base)
+
+            print "Now at ", a
+            
+            while pre(a) < pre(b):
+                s = ("%s-%s-%s" % (rc1base, pre(a), next_pre(a)))
+                print "Applying ", s
+                apply_patch(s, 0)
+                a = "%s-%s" % (rc1base, next_pre(a))
+                print "Should be at ", a
+            
 
     if fork(b):
         a = apply_patch(b)
@@ -573,6 +625,10 @@ version_info = {
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
