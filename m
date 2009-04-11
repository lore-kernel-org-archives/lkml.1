Return-Path: <linux-kernel-owner+w=401wt.eu-S1758247AbZDKTck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758247AbZDKTck (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 15:32:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755098AbZDKTcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 15:32:32 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:34979 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480AbZDKTcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 15:32:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=A7KrkEPxnvTQRbODcFA+ih7LMH6ppi4gQ9psP9rgdU7RPJqtML/iJO/I1UIVPArz0t
         pR8EWKefxdmWKSmIM81Vmc0J6r7p91NqxdLwEtu9wDzvxTMgpjL7ZHN/8iuufl7aOm1E
         L77hUBCu6ItQosEdVZ1vQTLMJcT2bpi0gr2PM=
Date: Sat, 11 Apr 2009 21:32:26 +0200
From: Andrea Righi <righi.andrea@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Krzysztof Helt <krzysztof.h1@poczta.fm>,
       Eric Miao <eric.y.miao@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrey Borzenkov <arvidjaar@gmail.com>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       linux-fbdev-devel@lists.sourceforge.net,
       linux-pm@lists.linux-foundation.org, Dave Jones <davej@redhat.com>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Johannes Weiner <hannes@cmpxchg.org>, Pavel Roskin <proski@gnu.org>
Subject: Re: [REGRESSION] commit 66c1ca0: {fbmem: fix fb_info->lock and
	mm->mmap_sem ...} causes Xfbdev not working
Message-ID: <20090411193226.GA5440@linux>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Krzysztof Helt <krzysztof.h1@poczta.fm>,
	Eric Miao <eric.y.miao@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Andrey Borzenkov <arvidjaar@gmail.com>,
	"Antonino A. Daplas" <adaplas@gmail.com>,
	linux-fbdev-devel@lists.sourceforge.net,
	linux-pm@lists.linux-foundation.org, Dave Jones <davej@redhat.com>,
	Harvey Harrison <harvey.harrison@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Pavel Roskin <proski@gnu.org>
References: <f17812d70904090436kd03744brca4a4bc4b85bba8@mail.gmail.com> <20090409125850.GA2727@linux> <20090410222122.87be60f6.krzysztof.h1@poczta.fm> <20090410220521.GB21294@linux> <20090411080415.7fe924a2.krzysztof.h1@poczta.fm> <49E05C36.9040204@s5r6.in-berlin.de> <20090411110840.GA7108@linux> <20090411150359.GA8265@linux> <20090411112131.cc38dcf0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090411112131.cc38dcf0.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 11, 2009 at 11:21:31AM -0700, Andrew Morton wrote:
> On Sat, 11 Apr 2009 17:04:00 +0200 Andrea Righi <righi.andrea@gmail.com> wrote:
> 
> > fbdev: fix info->lock deadlock in fbcon_event_notify()
> > 
> > fb_notifier_call_chain() is called with info->lock held, i.e. in
> > do_fb_ioctl() => FBIOPUT_VSCREENINFO => fb_set_var() and the some
> > notifier callbacks, like fbcon_event_notify(), try to re-acquire
> > info->lock again.
> > 
> > Remove the lock/unlock_fb_info() in all the framebuffer notifier
> > callbacks' and be sure to always call fb_notifier_call_chain() with
> > info->lock held.
> 
> Thanks.  So do you think we should proceed with this patch instead of
> reverting 66c1ca0?

Yes, there's no need to revert 66c1ca0 now, otherwise we'll simply
reintroduce the info->lock / mm->mmap_sem circular locking dependency.

I'd like to test the fbdev mode switching, but it seems intelfb doesn't
support it with LVDS ports (and at the moment I've not a CRT here...).

Anyway, if someone will have troubles with mode switching I'm quite sure
we can fix it on top of this patch.

-Andrea
