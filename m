Return-Path: <linux-kernel-owner+w=401wt.eu-S1757485AbXITUCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485AbXITUCy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 16:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755472AbXITT7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 15:59:37 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:9453 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413AbXITT7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 15:59:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=EFaNmDZ26skyepSDLbnnceC+YQpEn+MuVI8Nv2KcB4SzzQ+XCW2lNibgbSCIaqDZ8i7+Rfiq4RDt4ceqOoO2zkcNbeuaBEx7HM5f+V7Sl65XkuhKCTU78naiX0GQQjwbes6SHnl3F2PfuO9EhiUvV6RUrUisLH5cMmotVYKq1TE=
Date: Thu, 20 Sep 2007 23:58:44 +0400
To: Rob Landley <rob@landley.net>
Cc: linux-tiny@selenic.com, Tim Bird <tim.bird@am.sony.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       CE Linux Developers List <celinux-dev@tree.celinuxforum.org>,
       Michael Opdenacker <michael@free-electrons.com>
Subject: Re: [Announce] Linux-tiny project revival
Message-ID: <20070920195844.GA1805@martell.zuzino.mipt.ru>
References: <46F1645D.9050406@am.sony.com> <200709201538.43093.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709201538.43093.rob@landley.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2007 at 03:38:42PM -0500, Rob Landley wrote:
> I've been playing with an idea for a while to improve the printk() situation, 
> but it's a more intrusive change than I've had time to bang on.
> 
> Right now, the first argument to printk() is a loglevel, but it's handled via 
> string concatenation.  I'd like to change that to be an integer, and make it 
> an actual comma-separated first argument.  (Mandatory, not optional.)
> 
> So instead of:
>   printk(KERN_NOTICE "Fruit=%d\n", banana);
> It would now be:
>   printk(KERN_NOTICE, "Fruit=%d\n", banana);
> 
> Change the header from:
>   #define KERN_NOTICE "<5>"
> to:
>   #define KERN_NOTICE 5
> 
> Then you can change the printk guts to do something vaguely like (untested):
> #define printk(arg1, arg2, ...) actual_printk("<" #arg1 ">" arg2, __VA_ARGS__)
> 
> And so far no behavior has changed.  But now the _fun_ part is, you can add a 
> config symbol for "what is the minimum loglevel I care about?"

Given that
a) there're plenty of printks without any KERN_* bloat,
b) there're printks that SHOULD NOT have KERN_* bloat,
c) debugging-by-printk method is widely used and this will force
   additional typing, head-scratching  and swear words
d) time wasted on pointless discussions whether some particular
   printk ALERT or CRIT
e) flag day for printk,

I think that this idea is not worth it.

> #define printk(level, str, ...) \
>   do { \
>     if (level < CONFIG_PRINTK_DOICARE) \
>       actual_printk("<" #level ">" str, __VA_ARGS__); \
>   } while(0);

> Opinions?

Ick.

	Alexey "ignore_loglevel" Dobriyan



--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -52,6 +52,7 @@ extern const char linux_proc_banner[];
  */
 #define upper_32_bits(n) ((u32)(((n) >> 16) >> 16))
 
+#ifdef CONFIG_FOO
 #define	KERN_EMERG	"<0>"	/* system is unusable			*/
 #define	KERN_ALERT	"<1>"	/* action must be taken immediately	*/
 #define	KERN_CRIT	"<2>"	/* critical conditions			*/
@@ -59,6 +60,15 @@ extern const char linux_proc_banner[];
 #define	KERN_WARNING	"<4>"	/* warning conditions			*/
 #define	KERN_NOTICE	"<5>"	/* normal but significant condition	*/
 #define	KERN_INFO	"<6>"	/* informational			*/
+#else
+#define	KERN_EMERG	""
+#define	KERN_ALERT	""
+#define	KERN_CRIT	""
+#define	KERN_ERR	""
+#define	KERN_WARNING	""
+#define	KERN_NOTICE	""
+#define	KERN_INFO	""
+#endif
 #define	KERN_DEBUG	"<7>"	/* debug-level messages			*/
 
 extern int console_printk[];
