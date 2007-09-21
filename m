Return-Path: <linux-kernel-owner+w=401wt.eu-S1755405AbXIUG2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405AbXIUG2e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 02:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751499AbXIUG21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 02:28:27 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:59354 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbXIUG20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 02:28:26 -0400
Date: Fri, 21 Sep 2007 08:29:49 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Indan Zupancic <indan@nul.nu>
Cc: Rob Landley <rob@landley.net>, linux-tiny@selenic.com,
       Michael Opdenacker <michael@free-electrons.com>,
       CE Linux Developers List <celinux-dev@tree.celinuxforum.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Announce] Linux-tiny project revival
Message-ID: <20070921062949.GA17131@uranus.ravnborg.org>
References: <46F1645D.9050406@am.sony.com> <200709201538.43093.rob@landley.net> <59465.81.207.0.53.1190323573.squirrel@secure.samage.net> <200709201818.42125.rob@landley.net> <38197.81.207.0.53.1190329581.squirrel@secure.samage.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38197.81.207.0.53.1190329581.squirrel@secure.samage.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2007 at 01:06:21AM +0200, Indan Zupancic wrote:
> On Fri, September 21, 2007 01:18, Rob Landley wrote:
> > On Thursday 20 September 2007 4:26:13 pm Indan Zupancic wrote:
> >> A quick scroll through a vmlinux binary shows that there are quite a
> >> lot areas consisting only of some repeated pattern. Mostly 0x00, but
> >> also 0x90 and ".GCC: (GNU) 4.2.1.". Getting rid of those would save
> >> something between 50 and 100KB.
> >
> > Worse, if you feed an absolute path to O= when you build the kernel out of
> > tree, then it uses absolute paths for all the __FILE__ strings and that makes
> > kernel BIIIIIG.  (Did that by accident a while back.)  Too bad there's no way
> > to keep the __FILE__ strings compressed at runtime and gunzip them as needed
> > like busybox does with help messages... :)
> 
> I suspect that can be fixed by changing the built system. How can using O=
> change the source file path anyway? That seems unnecessary.
Thats a bit unavoidable as the build system works.
__FILE__ is passed the filename supplied as argument to gcc.

Try:
echo "char *s = __FILE__;" > sam.c

gcc -E sam.c
This gives you:
# 1 "sam.c"
# 1 "<built-in>"
# 1 "<command line>"
# 1 "sam.c"
char *s="sam.c";

gcc -E ~/sam.c
This gives you:
# 1 "/home/sam/sam.c"
# 1 "<built-in>"
# 1 "<command line>"
# 1 "/home/sam/sam.c"
char *s="/home/sam/sam.c";
 
So __FILE__ expand differently depending on the path on
the gcc command line.
I once posted a patch to fix up on this, especialy for BUG_ON and friends.
The solution was to let kbuild generate the filename and to use
this define in the source code.
But a quick grep for __FILE__ in the kernel source made me chicken out.
Simply too much chrunch at that time to justify it.

Googeling a bit I found it here: http://lkml.org/lkml/2006/7/8/22
The better approach would be to use at least the patch inside
the kernel.
This patch should be easy to update to latest kernel if anyone
is up to play with it.

I recall that there was some problems with the path used.
But I cannot remember the details.
Andrew had some inputs from his testing IIRC and google should
be able to tell the full story.

	Sam





> 
> It seems to be worse, full pathnames are also used when giving a relative path.
> (I'm using O=../obj/).
> 
> On the other hand, it doesn't seem to cause that much bloat here:
> 
> $ strings vmlinux | grep /home/ |wc
>     119     181    6400
> 
> CC'ing Sam Ravnborg, perhaps he has some ideas.
> 
> Greetings,
> 
> Indan
> 
> 
