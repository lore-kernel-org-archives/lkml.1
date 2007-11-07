Return-Path: <linux-kernel-owner+w=401wt.eu-S1755624AbXKGEfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624AbXKGEfA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 23:35:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756903AbXKGEeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 23:34:46 -0500
Received: from wx-out-0506.google.com ([66.249.82.225]:51726 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756741AbXKGEeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 23:34:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iDIoYMpG8wNbhNXO69xrGMNYJ35iNsTLmifOkN5e05fszk+fuLeK+sUuqW6PXKczEErTRPrESKn/aFUxJMDIeFO83WcSkjzJ9NAOyEtCVgDODpFb9dZfxOW285wAU6zAwJ9SbprC+qHK/mvnAN8cSL56OMeJxwPaEuJ6TGS7ixo=
Message-ID: <e7d8f83e0711062034l399273a2h88d408940ea90fba@mail.gmail.com>
Date: Wed, 7 Nov 2007 14:34:42 +1000
From: "Peter Dolding" <oiaohm@gmail.com>
To: "Tetsuo Handa" <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: Defense in depth: LSM *modules*, not a static interface
Cc: casey@schaufler-ca.com, crispin@crispincowan.com, simon@fire.lp0.eu,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       cliffe@ii.net
In-Reply-To: <200711070411.lA74Bdvn041341@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <671729.27434.qm@web36604.mail.mud.yahoo.com>
	 <200711070411.lA74Bdvn041341@www262.sakura.ne.jp>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 7, 2007 2:11 PM, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp> wrote:
> Hello.
>
> Casey Schaufler wrote:
> > Fine grained capabilities are a bonus, and there are lots of
> > people who think that it would be really nifty if there were a
> > separate capability for each "if" in the kernel. I personally
> > don't see need for more than about 20. That is a matter of taste.
> > DG/UX ended up with 330 and I say that's too many.
>
> TOMOYO Linux has own (non-POSIX) capability that can support 65536 capabilities
> if there *were* a separate capability for each "if" in the kernel.
> http://svn.sourceforge.jp/cgi-bin/viewcvs.cgi/trunk/2.1.x/tomoyo-lsm/patches/tomoyo-capability.diff?root=tomoyo&view=markup
>
> The reason I don't use POSIX capability is that the maximum types are limited to
> bitwidth of a variable (i.e. currently 32, or are we going to extend it to 64).
> This leads to abuse of CAP_SYS_ADMIN capability.
> In other words, it makes fine-grained privilege division impossible.
>
> Since security_capable() cannot receive fine-grained values,
> TOMOYO can't do fine-grained privilege division.
>
Seen same problem.  Tetsuo Handa.

Capabilities alone does not.   Capabilities make up part of the engine.

As you can see currently it allows controls by block.  Now if
something has no network access at all does it have filtering rules no
it does not.  Same with file access.  There are some applications that
never need write or read from file systems.  So why are they granted
that.

These broad area covering controls can be provided to applications
without very much complexity.  Applications can use these features
internally to harden their security.  Make sections of program only
have read only file access other sections having read write other
sections have no file access.  Same with network access.  This is a
layer that is over looked and lacking power.

Capabilities do big blocks of security.  Bottom point of capabilities
should be a static application that loads into ram runs but cannot
report or allocate any memory.  Ie basically contained harmless and
useless.

The LSM takes control of permission allocation not enforcement in my
model.  The enforcement are done by sections like Capabilities and
Netlabels and some filesystem part that is missing.  Other parts might
be missing too.  Really need to be bashed out.   The Capabilities
could even tell you if those features are applied to your application.
 Now application can respond more correctly to user cannot access
directory because blocked by LSM/Application security settings not
just failed access.

Note Capabilities can provide a nice central point to give a basic
quick overview of what a application can and cannot do.  This
application does not have network access and is locked that way no
need to process Netlabels.  Same with filesystem.

330 is not too many if they exist for valid reasons.  20 appears to be
too few.  Most of the capabilities have be designed with the idea of
breaking up root powers.   This does not provide enough for
applications own internal security.

Its like currently you have a under 1024 port access switch and a Raw
network access switch.  Now there is no mirror switch for over 1024 so
all networking to application could be turned off.  Also applications
under 1024 then many not have the right to magically open up a back
door on higher user like ports.

On filesystem Read Write Execute and Change stat.   Memory allowed to
Allocate memory,  Memory map.    Device access limitations flags.
This is quickly list getting to 10 more at least needed.

Basically there are quite a few still missing in Capabilities that are
needed for application own security.  No permissions issued threw
Capabilities should equal application paper weight.   There are also
missing engine parts.   Netlabels is only one part.

Basically Capabilities flags as the hub.  With sections like Netlabels
and other security processing engines forking off it.  Sections like
Netlabels only need settings if Capabilities allows anything in the
first place.  This allows special engines for sections.  Yet not
having to allocate the memory when you don't need it.

Peter Dolding
