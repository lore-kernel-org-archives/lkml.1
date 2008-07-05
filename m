Return-Path: <linux-kernel-owner+w=401wt.eu-S1754130AbYGETtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbYGETtW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 15:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752355AbYGETtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 15:49:14 -0400
Received: from mail.gmx.net ([213.165.64.20]:44242 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751826AbYGETtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 15:49:13 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX19YkQwNDQZYpdea1qg+eKI8ys7RRFtlZy7vcrQraH
	COdgncS3iOOcBj
Date: Sat, 5 Jul 2008 21:49:08 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Pavel Machek <pavel@suse.cz>, auke-jan.h.kok@intel.com,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       len.brown@intel.com, cpufreq@lists.linux.org.uk,
       davej@codemonkey.org.uk
Subject: Re: bug? acpi p-state + ondemand keeps dropping max freq
Message-ID: <20080705194908.GA13149@atjola.homenet>
References: <20080606140846.GA9580@ucw.cz> <20080607213918.GC1746@elf.ucw.cz> <20080607145435.4afc9812@infradead.org> <20080616104159.GA28659@elf.ucw.cz> <20080616074337.46d6f411@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080616074337.46d6f411@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008.06.16 07:43:37 -0700, Arjan van de Ven wrote:
> On Mon, 16 Jun 2008 12:42:00 +0200
> Pavel Machek <pavel@suse.cz> wrote:
> 
> > On Sat 2008-06-07 14:54:35, Arjan van de Ven wrote:
> > > On Sat, 7 Jun 2008 23:39:18 +0200
> > > Pavel Machek <pavel@suse.cz> wrote:
> > > 
> > > > > # echo 1866000 > scaling_max_freq ; cat scaling_max_freq
> > > > > 800000
> > > > > # echo 1866000 > scaling_max_freq ; cat scaling_max_freq
> > > > > 800000
> > > > > 
> > > > > 
> > > > > This renders my Dothan to utterly poor speeds. (standard T43)
> > > > > 
> > > > > performance cpufreq governor makes no difference - I still can't
> > > > > change the frequency upper/lower values.
> > > > 
> > > > Hmm, I have similar problem in Novell bugzilla, on very different
> > > > hw:
> > > > 
> > > > https://bugzilla.novell.com/show_bug.cgi?id=396311
> > 
> > > are either of you running gnome-power-manager or kpowersaved ?
> > > sometimes these programs (and more likely, the patches added by a
> > > distro maintainer who doesn't fully realize how power works) tend to
> > > muck with kernel settings around CPU frequency that they have
> > > absolutely no business touching...
> > 
> > In novel bugzilla case ignore_ppc=1 helped, so it seems to be BIOS
> > problem, not userland's...
> 
> well as long as the user doesn't use this for production use... the
> BIOS often reduces frequencies available to deal with thermal
> situations, so it's not a good idea to ignore that.

Yep, seems to be a thermal thing. I managed to find some time to play
around with it a bit, and running a cpu hog for a short period of time,
while watching temperature and scaling_max_freq showed this:

cpufreq# cat /proc/acpi/thermal_zone/THM0/temperature
temperature:             49 C
cpufreq# cat scaling_max_freq
1866000

cpufreq# cat /proc/acpi/thermal_zone/THM0/temperature
temperature:             51 C
cpufreq# cat scaling_max_freq
1866000

cpufreq# cat /proc/acpi/thermal_zone/THM0/temperature
temperature:             52 C
cpufreq# cat scaling_max_freq
1866000

cpufreq# cat /proc/acpi/thermal_zone/THM0/temperature
temperature:             53 C
cpufreq# cat scaling_max_freq
1866000

cpufreq# cat /proc/acpi/thermal_zone/THM0/temperature
temperature:             54 C
cpufreq# cat scaling_max_freq
800000

cpufreq# cat /proc/acpi/thermal_zone/THM0/temperature
temperature:             53 C
cpufreq# cat scaling_max_freq
800000

cpufreq# cat /proc/acpi/thermal_zone/THM0/temperature
temperature:             51 C
cpufreq# cat scaling_max_freq
800000

cpufreq# cat /proc/acpi/thermal_zone/THM0/temperature
temperature:             51 C
cpufreq# cat scaling_max_freq
800000

cpufreq# cat /proc/acpi/thermal_zone/THM0/temperature
temperature:             50 C
cpufreq# cat scaling_max_freq
800000

cpufreq# cat /proc/acpi/thermal_zone/THM0/temperature
temperature:             49 C
cpufreq# cat scaling_max_freq
1866000


So upon reaching 54°C some throttling kicks in and only when going back
to less then 50°C, that limit is lifted again. Too bad that with Linux,
this T43 already runs at about 47°C when idle, so as soon as there's any
load on the cpu, it will scale up for a few seconds and then get
throttled :-(

There's no userspace powersave foo involved here, just the plain
ondemand scaling governor, same happens with the performance governor.

Björn
