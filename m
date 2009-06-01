Return-Path: <linux-kernel-owner+w=401wt.eu-S1758703AbZFAUyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758703AbZFAUyr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 16:54:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754241AbZFAUyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 16:54:40 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:30708 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622AbZFAUyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 16:54:39 -0400
X-IronPort-AV: E=Sophos;i="4.41,286,1241409600"; 
   d="scan'208";a="88252130"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Matt Mackall" <mpm@selenic.com>
Subject: Re: [PATCH] update kernel's scripts/bloat-o-meter from busybox
Date: Mon, 1 Jun 2009 16:57:20 -0400
User-Agent: KMail/1.9.5
CC: "Sam Ravnborg" <sam@ravnborg.org>,
       "Bernhard Reutner-Fischer" <rep.dot.nop@gmail.com>,
       "Denis Vlasenko" <vda.linux@googlemail.com>,
       "Rob Landley" <rob@landley.net>, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier@gentoo.org>
References: <200906011526.01108.rgetz@blackfin.uclinux.org> <1243885732.22069.112.camel@calx>
In-Reply-To: <1243885732.22069.112.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <200906011657.20251.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 01 Jun 2009 20:54:40.0343 (UTC) FILETIME=[2E9C3E70:01C9E2FB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 1 Jun 2009 15:48, Matt Mackall pondered:
> On Mon, 2009-06-01 at 15:26 -0400, Robin Getz wrote:
> > From: "Rob Landley" <rob@landley.net>
> > From: "Denis Vlasenko" <vda.linux@googlemail.com>
> > From: "Bernhard Reutner-Fischer" <rep.dot.nop@gmail.com>
> > 
> > Since bloat-o-meter was added to the kernel's source tree, it has
> > received little attention - either it works really well - or no
> > one uses it. I suspect the first :)
> > 
> > However - some folks who have been using it more (mainly as part 
> > of busybox) have been poking at it more often - and the output is
> > a little more friendly  now.
> > 
> > http://git.busybox.net/busybox/log/scripts/bloat-o-meter
> > 
> > I think Rob had been sending early patches both places, but
> > somewhere along the line things never made it to lkml.
> 
> I probably dropped them on the ground during a busy spell.

Sorry - I didn't mean to sound like I was trying to blame anyone. 


> > Acked-by: Robin Getz <rgetz@blackfin.uclinux.org>
> > 
> > ---
> > Since none of this is from me, I can only add my Acked by. Bernhard,
> > Denis, and Rob will need to add their Signed-off-by separately.
> > 
> > ----
> > 
> > 
> >  bloat-o-meter |   37 +++++++++++++++++++++++++++++--------
> >  1 file changed, 29 insertions(+), 8 deletions(-)
> > 
> > 
> > 
> > Index: scripts/bloat-o-meter
> > ===================================================================
> > --- scripts/bloat-o-meter	(revision 6437)
> > +++ scripts/bloat-o-meter	(working copy)
> > @@ -9,18 +9,37 @@
> >  
> >  import sys, os, re
> >  
> > -if len(sys.argv) != 3:
> > +def usage():
> >      sys.stderr.write("usage: %s file1 file2\n" % sys.argv[0])
> >      sys.exit(-1)
> >  
> > +if len(sys.argv) < 3:
> > +    usage()
> > +
> > +for f in sys.argv[1], sys.argv[2]:
> 
> in sys.argv[1:3]:  is a bit more standard
> 
> But this test should instead happen inside getsizes, no loop needed.
> 
> > +    if not os.path.exists(f):
> > +        sys.stderr.write("Error: file '%s' does not exist\n" % f)
> > +        usage()
> > +
> > +nm_args = " ".join([x for x in sys.argv[3:]])
> 
> nm_args = " ".join(sys.argv[3:])
> 
> >  def getsizes(file):
> >      sym = {}
> > -    for l in os.popen("nm --size-sort " + file).readlines():
> > -        size, type, name = l[:-1].split()
> > -        if type in "tTdDbB":
> > +    for l in os.popen("nm --size-sort %s %s" % (nm_args, file)).readlines():
> > +    	l = l.strip()
> > +	# Skip empty lines
> > +        if not len(l): continue
> 
> (seems to be some whitespace damage? there should be no tabs in this
> source)

That is the way it is in the busybox git tree (until Mike fixed it 10 minutes ago)
 - I'll fix it on the next version I send...

> if not l

same.

> > +	# Skip archive members
> > +        if len(l.split()) == 1 and l.endswith(':'):
> 
> if ' ' not in l ...

http://git.busybox.net/busybox/commit/?id=49bdf28c320bf4e02048eb0cbd115d84b8467cd9

OK with me - if it is OK with Bernhard.



> > +          continue
> > +        size, type, name = l.split()
> > +        if type in "tTdDbBrR":
> >              # function names begin with '.' on 64-bit powerpc
> >              if "." in name[1:]: name = "static." + name.split(".")[0]
> >              sym[name] = sym.get(name, 0) + int(size, 16)
> > +    for l in os.popen("readelf -S " + file).readlines():
> > +        x = l.split()
> > +        if len(x)<6 or x[1] != ".rodata": continue
> > +        sym[".rodata"] = int(x[5], 16)
> 
> Not sure what this addition is about?

I think this is from Rob.

http://git.busybox.net/busybox/commit/?id=f14f7fc5cad5cac1a0913b85c8304f6fb77697ad



> >      return sym
> >  
> >  old = getsizes(sys.argv[1])
> > @@ -53,8 +72,10 @@
> >  delta.sort()
> >  delta.reverse()
> >  
> > -print "add/remove: %s/%s grow/shrink: %s/%s up/down: %s/%s (%s)" % \
> > -      (add, remove, grow, shrink, up, -down, up-down)
> > -print "%-40s %7s %7s %+7s" % ("function", "old", "new", "delta")
> > +print "%-48s %7s %7s %+7s" % ("function", "old", "new", "delta")
> >  for d, n in delta:
> > -    if d: print "%-40s %7s %7s %+7d" % (n, old.get(n,"-"), new.get(n,"-"), d)
> > +    if d: print "%-48s %7s %7s %+7d" % (n, old.get(n,"-"), new.get(n,"-"), d)
> > +print "-"*78
> > +total="(add/remove: %s/%s grow/shrink: %s/%s up/down: %s/%s)%%sTotal: %s 
> > bytes"\
> > +    % (add, remove, grow, shrink, up, -down, up-down)
> > +print total % (" "*(80-len(total)))
> 
> Not terribly excited about this last bit, which is going out of its way
> to right-align the total? Who cares about that?

Rob did. :) Same patch as above.


