Return-Path: <linux-kernel-owner+w=401wt.eu-S1754906AbZDFCgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906AbZDFCgo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 22:36:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753718AbZDFCge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 22:36:34 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:53750 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700AbZDFCgd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 22:36:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QXLGJszJ1KF6Sq5XDegfI2RIkIeOPjaCS45PnGhr/L3arZadkAEnymgkQ+jbEL95z2
         +y8z3deC2eRMvJScPk0XgW3y5CUKjZ9UlO1zR2YvCEr1jXDv8U4LcepIJkHSaT8BvvOi
         D9qxa55YDwPuEe7Nw6OUOo9wKGFShZ+KngACw=
MIME-Version: 1.0
In-Reply-To: <49D93756.2080608@gmail.com>
References: <49D93756.2080608@gmail.com>
Date: Sun, 5 Apr 2009 20:36:30 -0600
Message-ID: <9b1675090904051936s1859d09ap7dbe4862437d5960@mail.gmail.com>
Subject: Re: What would cause freezes that numlock fixes?
From: "Trenton D. Adams" <trenton.d.adams@gmail.com>
To: John Moser <john.r.moser@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Your pressing of numlock thing is odd to me.  But as for the rest...

The kernel folks are trying to work on these issues already.  There
are many similar reports, including from myself.  Here are some things
to try.

echo "1" > /proc/sys/vm/dirty_ratio
echo "2" > /proc/sys/vm/dirty_background_ratio

This sets the amount of dirty memory, in percentage of memory in the
system, before a process or the pdflush background daemon start
writing out dirty data.  Dirty data is data that has not been
committed to disk yet.

See /usr/src/linux/Documentation/sysctl/vm.txt for more information,
if you have the kernel sources installed.

If you switched to 2.6.29, it gets even more tuneable.  2.6.29 adds
"dirty_bytes" and "dirty_background_bytes" respectively.  They
override the "ratio" versions.  For me, that is important, as I find
that anything beyond 5M or so produces really bad hangs.

Another thing you can do is force your ext3 filesystem to mount with
data=writeback.  I just issued the following command, and then
rebooted...
tune2fs -o journal_data_writeback /dev/s/sys

tune2fs -l /dev/s/sys | grep journal

If you want to switch it back to the default, just issue...
tune2fs -o journal_data_ordered /dev/s/sys

But yes, using ext4 helps the issue as well.  I have a hunch that the
ext3 issues are just a tangent issue to the real problem, as I never
had a problem before 2.6.18.  It used to be that I could run a heavy
dd without any problems at all.  But, alas, I don't know enough about
the kernel source to look into it myself, nor do I have the time
learn.

Using the "writeback" option above, I am finding that I can set my
dirty_ratio to 40, and not have many problems.  I have not yet tried
ext4, but I may in the future.

On Sun, Apr 5, 2009 at 4:57 PM, John Moser <john.r.moser@gmail.com> wrote:
> I'm using Ubuntu's current beta 9.04 and it's having issues.  I think it's a
> kernel thing, but I have no debug data or anything; if anyone has any
> insight as to what might be happening I'd like that.  I can't do debugging
> here (unless they package a debugging kernel).
>
> I'm using what Ubuntu calls "2.6.28-11.40" "generic", on x86-64, with the
> uname:
>
> Linux icebox 2.6.28-11-generic #40-Ubuntu SMP Fri Apr 3 17:39:41 UTC 2009
> x86_64 GNU/Linux
>
>
> What's happening is this:
>
> I noticed immediately that the system lags a lot, especially when under
> load, sometimes when not under load.  I figured bad scheduling at first.
> Switching to ext4 helped.
>
> Oddly enough, switching to elevator=as instead of CFQ helps as well. This
> helps, but doesn't fix the problem.  So, I'm guessing there's no bug in CFQ
> or EXT3, but running these rather than AS and EXT4 aggravates symptoms.
>
> Occasionally almost everything in X will freeze.  Some programs (like, a
> terminal) still work until they try to access the disk (say, if I run a
> command, bash hangs).  I eventually had this happen while top was running
> and noticed stuff going into state D and staying there for up to 5 minutes,
> while the disk halts.  I can still shift between virtual desktops in Gnome,
> with the stipulation that every application is frozen and I can't start any
> others.
>
> At some point (today, actually) I found a workaround.  When applications--
> either one, or all of them-- start to freeze, if I press (specifically) the
> Num Lock key, everything suddenly wakes up.  Disk starts cranking like
> crazy, windows redraw, and I assume everything instantly comes back out of D
> state.
>
> Just Num Lock.  Not A, not CTRL, not Tab.  Just Num Lock.
>
> Anyone have any guesses?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
