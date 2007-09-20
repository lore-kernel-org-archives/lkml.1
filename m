Return-Path: <linux-kernel-owner+w=401wt.eu-S1754450AbXITWTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450AbXITWTA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 18:19:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752843AbXITWSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 18:18:53 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:42589
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752336AbXITWSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 18:18:52 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: "Indan Zupancic" <indan@nul.nu>
Subject: Re: [Announce] Linux-tiny project revival
Date: Thu, 20 Sep 2007 18:18:41 -0500
User-Agent: KMail/1.9.6
Cc: linux-tiny@selenic.com, "Michael Opdenacker" <michael@free-electrons.com>,
       "CE Linux Developers List" <celinux-dev@tree.celinuxforum.org>,
       "linux kernel" <linux-kernel@vger.kernel.org>
References: <46F1645D.9050406@am.sony.com> <200709201538.43093.rob@landley.net> <59465.81.207.0.53.1190323573.squirrel@secure.samage.net>
In-Reply-To: <59465.81.207.0.53.1190323573.squirrel@secure.samage.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709201818.42125.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 September 2007 4:26:13 pm Indan Zupancic wrote:
> On Thu, September 20, 2007 22:38, Rob Landley wrote:
> > I've been playing with an idea for a while to improve the printk()
> > situation, but it's a more intrusive change than I've had time to bang
> > on.
> >
> > Right now, the first argument to printk() is a loglevel, but it's handled
> > via string concatenation.  I'd like to change that to be an integer, and
> > make it an actual comma-separated first argument.  (Mandatory, not
> > optional.)
> >
> > So instead of:
> >   printk(KERN_NOTICE "Fruit=%d\n", banana);
> > It would now be:
> >   printk(KERN_NOTICE, "Fruit=%d\n", banana);
> >
> > Change the header from:
> >   #define KERN_NOTICE "<5>"
> > to:
> >   #define KERN_NOTICE 5
>
> You have to jump through less hoops if you do:
>
> #define KERN_NOTICE 5,

Less change to the source, but the result is less obvious about what it's 
doing.  I'd personally rather have the churn than wind up with magic 
syntax...

> But the problem remains that there are printk's which don't have
> a KERN_* as the first argument. Those are also impossible to get
> rid off in this way, as the loglevel is unknown (and you don't want
> partially printed messages).
>
> So adding the comma is really needed and in addition all printk's
> without a loglevel should get one. Which clutters the code and may
> increase codesize.

It's ok to _explicitly_ not have a loglevel, and thus take a known default.  
The problem is printing out less than a full line, continuing it later, and 
not making obvious at compile time what the level of this chunk is.

> A quick scroll through a vmlinux binary shows that there are quite a
> lot areas consisting only of some repeated pattern. Mostly 0x00, but
> also 0x90 and ".GCC: (GNU) 4.2.1.". Getting rid of those would save
> something between 50 and 100KB.

Worse, if you feed an absolute path to O= when you build the kernel out of 
tree, then it uses absolute paths for all the __FILE__ strings and that makes 
kernel BIIIIIG.  (Did that by accident a while back.)  Too bad there's no way 
to keep the __FILE__ strings compressed at runtime and gunzip them as needed 
like busybox does with help messages... :)

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
