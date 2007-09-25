Return-Path: <linux-kernel-owner+w=401wt.eu-S1759118AbXIYIGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759118AbXIYIGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 04:06:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754378AbXIYIGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 04:06:38 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:49089 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847AbXIYIGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 04:06:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=R9+HQfOILZyj5MHVaMkqbnGLKdlVoQYR8LrG5s4jb+NUduXiyNUTMtRTVudAQfkLtQ9nxeWKmpBFjLnwuyLCOTvWw/7UlzmfHwmdt3YWNczI5BfvDCaws6Qr+8+QN/imPLDJ/05CzU2X7EM00peZniCrOOvEPW3iZRZpmTCQ+pE=
Message-ID: <19f34abd0709250106n6540539ap764dfaa23958ab81@mail.gmail.com>
Date: Tue, 25 Sep 2007 10:06:35 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Joe Perches" <joe@perches.com>
Subject: Re: [RFC] New kernel-message logging API
Cc: linux@horizon.com, linux-kernel@vger.kernel.org,
       "Miguel Ojeda" <maxextreme@gmail.com>
In-Reply-To: <1190703254.3964.11.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070925045808.12273.qmail@science.horizon.com>
	 <1190703254.3964.11.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/25/07, Joe Perches <joe@perches.com> wrote:
> On Tue, 2007-09-25 at 00:58 -0400, linux@horizon.com wrote:
> > Even the "kp_" prefix is actually pretty unnecessary.  It's "info"
> > and a human-readable string that make it recognizable as a log message.
>
> While I agree a prefix isn't necessary, info, warn, err
> are already frequently #define'd and used.
>
> kp_<level> isn't currently in use.
>
> $ egrep -r -l --include=*.[ch] "^[[:space:]]*#[[:space:]]*define[[:space:]]+(info|err|warn)\b" * | wc -l
> 29

Yes, this is a very good point, they're already used. If they hadn't
been, everything would have been perfect. Actually, I'd have preferred
info/warn/err over kprint_<level> if it wasn't for the fact that
they're used (and in slightly different ways too).

As I wrote initially, one of the absolute requirements of a new API is
to retain full backwards compatibility with printk(). Which means that
using simply err()/info()/warn() is out of the question *for now*.
That is not to say we can't change this at a later time.

I think it would be good to have a base layer containing the functions
kprint_<level>(), just to have something that 1) has a meaningful
name, and 2) doesn't disturb anybody else's names. err/info/warn or
kp_err/info/warn() (in order to have shorter names) can then be
implemented in terms of this.

I suppose that another goal of a new API would be to unify the
somewhat-a-mess of API that is now, i.e. many alternatives that do the
same thing is also not good. But this can be changed with patches (to
convert to new API) later.

If you look closer at the current definitions of erro/warn/info, it
turns out that most of them also do this to automatically prefix all
messages with the driver name. This makes me realize that there really
is a need for a way to automatically prefix messages or store a
per-message "subsystem" field. I propose the following solution:

The kprint.h header file looks like this:

/* This is a back-up string to be used if the source file doesn't
define this as a macro. */
const char *SUBSYSTEM = "";

/* Call this macro whatever you want, it's just an example anyway. */
#define info(msg, ...) printf("%s: " msg, SUBSYSTEM, ## __VA_ARGS__)

Then you can have a C file that overrides SUBSYSTEM by defining it as a macro:
#include <linux/kprint.h>
#define SUBSYSTEM "usb"
info("test");
--> results in printf("%s: " "test", "usb");

Or, a C file that doesn't:
#include <linux/kprint.h>
info("test");
--> results in printf("%s: " "test", SYBSYSTEM);
--> output is ": test"


Though, instead of actually incorporating this SUBSYSTEM name into the
string, I suggest passing it off as an argument into the real kprint()
machinery, to be stored along (but seperately) with timestamp, etc.

Hm, that's a digression. But thanks for the idea :)


Vegard
