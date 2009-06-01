Return-Path: <linux-kernel-owner+w=401wt.eu-S1757297AbZFATzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297AbZFATzB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 15:55:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752449AbZFATyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 15:54:54 -0400
Received: from waste.org ([66.93.16.53]:55755 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751711AbZFATyx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 15:54:53 -0400
Subject: Re: [PATCH] update kernel's scripts/bloat-o-meter from busybox
From: Matt Mackall <mpm@selenic.com>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Bernhard Reutner-Fischer <rep.dot.nop@gmail.com>,
       Denis Vlasenko <vda.linux@googlemail.com>,
       Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org
In-Reply-To: <200906011526.01108.rgetz@blackfin.uclinux.org>
References: <200906011526.01108.rgetz@blackfin.uclinux.org>
Content-Type: text/plain
Date: Mon, 01 Jun 2009 14:48:52 -0500
Message-Id: <1243885732.22069.112.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-01 at 15:26 -0400, Robin Getz wrote:
> From: "Rob Landley" <rob@landley.net>
> From: "Denis Vlasenko" <vda.linux@googlemail.com>
> From: "Bernhard Reutner-Fischer" <rep.dot.nop@gmail.com>
> 
> Since bloat-o-meter was added to the kernel's source tree, it has received 
> little attention - either it works really well - or no one uses it. I suspect 
> the first :)
> 
> However - some folks who have been using it more (mainly as part of busybox) 
> have been poking at it more often - and the output is a little more friendly 
> now.
> 
> http://git.busybox.net/busybox/log/scripts/bloat-o-meter
> 
> I think Rob had been sending early patches both places, but somewhere along 
> the line things never made it to lkml.

I probably dropped them on the ground during a busy spell.

> Acked-by: Robin Getz <rgetz@blackfin.uclinux.org>
> 
> ---
> Since none of this is from me, I can only add my Acked by. Bernhard, Denis, 
> and Rob will need to add their Signed-off-by separately.
> 
> ----
> 
> 
>  bloat-o-meter |   37 +++++++++++++++++++++++++++++--------
>  1 file changed, 29 insertions(+), 8 deletions(-)
> 
> 
> 
> Index: scripts/bloat-o-meter
> ===================================================================
> --- scripts/bloat-o-meter	(revision 6437)
> +++ scripts/bloat-o-meter	(working copy)
> @@ -9,18 +9,37 @@
>  
>  import sys, os, re
>  
> -if len(sys.argv) != 3:
> +def usage():
>      sys.stderr.write("usage: %s file1 file2\n" % sys.argv[0])
>      sys.exit(-1)
>  
> +if len(sys.argv) < 3:
> +    usage()
> +
> +for f in sys.argv[1], sys.argv[2]:

in sys.argv[1:3]:  is a bit more standard

But this test should instead happen inside getsizes, no loop needed.

> +    if not os.path.exists(f):
> +        sys.stderr.write("Error: file '%s' does not exist\n" % f)
> +        usage()
> +
> +nm_args = " ".join([x for x in sys.argv[3:]])

nm_args = " ".join(sys.argv[3:])

>  def getsizes(file):
>      sym = {}
> -    for l in os.popen("nm --size-sort " + file).readlines():
> -        size, type, name = l[:-1].split()
> -        if type in "tTdDbB":
> +    for l in os.popen("nm --size-sort %s %s" % (nm_args, file)).readlines():
> +    	l = l.strip()
> +	# Skip empty lines
> +        if not len(l): continue

(seems to be some whitespace damage? there should be no tabs in this
source)

if not l

> +	# Skip archive members
> +        if len(l.split()) == 1 and l.endswith(':'):

if ' ' not in l ...

> +          continue
> +        size, type, name = l.split()
> +        if type in "tTdDbBrR":
>              # function names begin with '.' on 64-bit powerpc
>              if "." in name[1:]: name = "static." + name.split(".")[0]
>              sym[name] = sym.get(name, 0) + int(size, 16)
> +    for l in os.popen("readelf -S " + file).readlines():
> +        x = l.split()
> +        if len(x)<6 or x[1] != ".rodata": continue
> +        sym[".rodata"] = int(x[5], 16)

Not sure what this addition is about?

>      return sym
>  
>  old = getsizes(sys.argv[1])
> @@ -53,8 +72,10 @@
>  delta.sort()
>  delta.reverse()
>  
> -print "add/remove: %s/%s grow/shrink: %s/%s up/down: %s/%s (%s)" % \
> -      (add, remove, grow, shrink, up, -down, up-down)
> -print "%-40s %7s %7s %+7s" % ("function", "old", "new", "delta")
> +print "%-48s %7s %7s %+7s" % ("function", "old", "new", "delta")
>  for d, n in delta:
> -    if d: print "%-40s %7s %7s %+7d" % (n, old.get(n,"-"), new.get(n,"-"), d)
> +    if d: print "%-48s %7s %7s %+7d" % (n, old.get(n,"-"), new.get(n,"-"), d)
> +print "-"*78
> +total="(add/remove: %s/%s grow/shrink: %s/%s up/down: %s/%s)%%sTotal: %s 
> bytes"\
> +    % (add, remove, grow, shrink, up, -down, up-down)
> +print total % (" "*(80-len(total)))

Not terribly excited about this last bit, which is going out of its way
to right-align the total? Who cares about that?

-- 
http://selenic.com : development and support for Mercurial and Linux


