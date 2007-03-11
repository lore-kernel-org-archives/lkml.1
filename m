Return-Path: <linux-kernel-owner+w=401wt.eu-S932507AbXCKC20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932507AbXCKC20 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 21:28:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932635AbXCKC20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 21:28:26 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:12662 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932507AbXCKC2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 21:28:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=oHxG6lYlw3vhWnGZyIpdrnS+y0QXxKg4sBVlLYMmFntMQWel19BGydJmSJMfA3FWIVCZN5pxzhdFAnRMBa8R9P49Z4Qv47Qkf0qA8RoG8MFNSE91iIbbuNd1C6yfRkGG72Go383NhjXzgt65cmpZeiR7sWeplXHFrxm8vxGxX+I=
Message-ID: <8cd998d50703101828l71fbec7bi9a819ad7b7fd9828@mail.gmail.com>
Date: Sun, 11 Mar 2007 13:28:22 +1100
From: "Con Kolivas" <kernel@kolivas.org>
To: "Matt Mackall" <mpm@selenic.com>
Subject: Re: RSDL-mm 0.28
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>, ck@vds.kolivas.org
In-Reply-To: <20070311013506.GD10459@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070311013506.GD10459@waste.org>
X-Google-Sender-Auth: e58c8b2ad19d8e36
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/07, Matt Mackall <mpm@selenic.com> wrote:
> I've tested -mm2 against -mm2+noyield and -mm2+rsdl+noyield. The
> noyield patch simply makes the sched_yield syscall return immediately.
> Xorg and all tests are run at nice 0.
>
> Loads:
>  memload: constant memcpy of 16MB buffer
>  execload: constant re-exec of a trivial shell script
>  forkload: constant fork and exit of a trivial shell script
>  make -j 5: hot-cache kernel build without ccache
>  make -j 5 ccache: hot-cache kernel build with ccache
>
> Tests:
>  beryl - 3D window manager, wiggle windows, spin desktop, etc.
>  galeon - web browser, rapidly scrolling long web pages by grabbing
>     the scroll bar
>  mp3 - XMMS on a FUSE sshfs over wireless (during all tests)
>  terminal - responsiveness of ssh and local terminal sessions
>  mouse - responsiveness of mouse pointer
>
> Results:
>  great = completely smooth
>  good = fully responsive
>  ok = visible latency
>  bad = becomes difficult to use (or mp3 skips)
>  awful = make it stop, please
>
>           -mm2        -mm2+noyield   rsdl+noyield
> no load
>  beryl    great       great          great
>  galeon   good        good           good
>  mp3      good        good           good
>  terminal good        good           good
>  mouse    good        good           good
> memload x10
>  beryl    awful/bad   great          good
>  galeon   good        good           ok/good
>  mp3      good        good           good
>  terminal good        good           good
>  mouse    good        good           good
> execload x10
>  beryl    awful/bad   bad/good       good
>  galeon   good        bad/good       ok/good
>  mp3      good        bad            good
>  terminal good        bad/good       good
>  mouse    good        bad/good       good
> forkload x10
>  beryl    good        good           great
>  galeon   good        good           ok/good
>  mp3      good        good           good
>  terminal good        good           ok/good
>  mouse    good        good           good
> make -j 5
>  beryl    ok          good           good/great
>  galeon   good        good           ok/good
>  mp3      good        good           good
>  terminal good        good           good
>  mouse    good        good           good
> make -j 5 ccache
>  beryl    ok          good           awful
>  galeon   good        good           bad
>  mp3      good        good           bad
>  terminal good        good           bad/ok
>  mouse    good        good           bad/ok
>
> make -j 5
> real      8m1.857s    8m50.659s      8m9.282s
> user      7m19.127s   8m3.494s       7m30.740s
> sys       0m30.910s   0m33.722s      0m29.542s
>
> make -j 5 ccache
> real      2m6.182s    2m19.032s      2m1.832s
> user      1m39.466s   1m48.787s      1m37.250s
> sys       0m19.741s   0m22.993s      0m20.109s

Thanks very much for that comprehensive summary and testing!

> There's a substantial performance hit for not yield, so we probably
> want to investigate alternate semantics for it. It seems reasonable
> for apps to say "let me not hog the CPU" without completely expiring
> them. Imagine you're in the front of the line (aka queue) and you
> spend a moment fumbling for your wallet. The polite thing to do is to
> let the next guy in front. But with the current sched_yield, you go
> all the way to the back of the line.

Well... are you advocating we change sched_yield semantics to a
gentler form? This is a cinch to implement but I know how Ingo feels
about this. It will only encourage more lax coding using sched_yield
instead of proper blocking (see huge arguments with the ldap people on
this one who insist it's impossible not to use yield).

> RSDL makes most of the noyield hit back in normal make and then some
> with ccache. Impressive. But ccache is still destroying interactivity
> somehow. The ccache effect is fairly visible even with non-parallel
> 'make'.

Ok I don't think there's any actual accounting problem here per se
(although I did just recently post a bugfix for rsdl however I think
that's unrelated). What I think is going on in the ccache testcase is
that all the work is being offloaded to kernel threads reading/writing
to/from the filesystem and the make is not getting any actual cpu
time. This is "worked around" in mainline thanks to the testing for
sleeping on uninterruptible sleep in the interactivity estimator. What
I suspect is happening is kernel threads that are running nice -5 are
doing all the work on make's behalf in the setting of ccache since it
is mostly i/o bound. The reason for -nice values on kernel threads is
questionable anyway. Can you try renicing your kernel threads all to
nice 0 and see what effect that has? Obviously this doesn't need a
recompile, but is simple enough to implement in kthread code as a new
default.

> Also note I could occassionally trigger nasty multi-second pauses with
> -mm2+noyield under exectest that didn't show up elsewhere. That's
> probably a bug in the mainline scheduler.

Ew. It's probably not a bug but a good example of some of the
starvation scenarios we're hitting on mainline (hence the need for a
rewrite ;))

Thanks!

---
ck
