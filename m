Return-Path: <linux-kernel-owner+w=401wt.eu-S1752345AbXITTjF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345AbXITTjF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 15:39:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751334AbXITTiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 15:38:54 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:53637
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751243AbXITTix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 15:38:53 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: linux-tiny@selenic.com
Subject: Re: [Announce] Linux-tiny project revival
Date: Thu, 20 Sep 2007 15:38:42 -0500
User-Agent: KMail/1.9.6
Cc: Tim Bird <tim.bird@am.sony.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       CE Linux Developers List <celinux-dev@tree.celinuxforum.org>,
       Michael Opdenacker <michael@free-electrons.com>
References: <46F1645D.9050406@am.sony.com>
In-Reply-To: <46F1645D.9050406@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709201538.43093.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 September 2007 1:03:09 pm Tim Bird wrote:
> Recently, the CE Linux forum has been working to revive the
> Linux-tiny project.  At OLS, I asked for interested parties
> to volunteer to become the new maintainer for the Linux-tiny patchset.
>
> A few candidates came forward, but eventually Michael Opdenacker
> was selected as the new primary maintainer.  A few other
> people, including John Cooper of Wind River and myself
> are working to support this effort.
>
> Recently, many of the Linux-tiny patches have been brought up-to-date
> and are now available for use with a 2.6.22 kernel.  The intent
> is to test these, and begin mainlining the most effective sub-patches,
> in the next few months.

Cool!

Could you update http://www.selenic.com/linux-tiny/ to mention the new 
maintainer and new URLs?

> Some automated testing has already been set up, with some
> preliminary results published at a CELF conference in Japan.
> (See the linux-tiny page below for a link to the presentation.)
> Hopefully, results publishing will also be automated soon.
>
> We encourage anyone with interest in this project to get involved.
> If you have ideas how to reduce the static or dynamic memory footprint
> of Linux, or, even better, patches for this, please let us know about
> them.

I've been playing with an idea for a while to improve the printk() situation, 
but it's a more intrusive change than I've had time to bang on.

Right now, the first argument to printk() is a loglevel, but it's handled via 
string concatenation.  I'd like to change that to be an integer, and make it 
an actual comma-separated first argument.  (Mandatory, not optional.)

So instead of:
  printk(KERN_NOTICE "Fruit=%d\n", banana);
It would now be:
  printk(KERN_NOTICE, "Fruit=%d\n", banana);

Change the header from:
  #define KERN_NOTICE "<5>"
to:
  #define KERN_NOTICE 5

Then you can change the printk guts to do something vaguely like (untested):
#define printk(arg1, arg2, ...) actual_printk("<" #arg1 ">" arg2, __VA_ARGS__)

And so far no behavior has changed.  But now the _fun_ part is, you can add a 
config symbol for "what is the minimum loglevel I care about?"  Set that as a 
number from 0-9.  And then you can define the printk to do:

#define printk(level, str, ...) \
  do { \
    if (level < CONFIG_PRINTK_DOICARE) \
      actual_printk("<" #level ">" str, __VA_ARGS__); \
  } while(0);

And viola (however you spell that, I think I'm using the stringed instrument 
but it's french and I'm not trying to type a diacritical mark anyway), the 
compiler's dead code eliminator zaps the printks you don't care about so they 
don't bloat the kernel image.  But this doesn't _completely_ eliminate 
printks, so you can still get the panic() calls and such.  You tweak precisly 
how much bloat you want, using the granularity information that's already 
there in the source code...

Opinions?

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
