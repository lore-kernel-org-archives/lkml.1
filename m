Return-Path: <linux-kernel-owner+w=401wt.eu-S1758737AbYGCMnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758737AbYGCMnN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 08:43:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758768AbYGCMm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 08:42:57 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:54478 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754966AbYGCMm4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 08:42:56 -0400
Subject: Re: Intel Microcode loader, tg3 driver, and the -rc8-mmotd New
	World Order firmware...
From: Kay Sievers <kay.sievers@vrfy.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>, Valdis.Kletnieks@vt.edu,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       jonathan@jonmasters.org, Shaohua Li <shaohua.li@intel.com>,
       greg@kroah.com
In-Reply-To: <1215077028.10393.497.camel@pmac.infradead.org>
References: <4534.1215048758@turing-police.cc.vt.edu>
	 <Pine.LNX.4.61.0807030716030.10434@ginsburg.homenet>
	 <32146.1215066947@turing-police.cc.vt.edu>
	 <Pine.LNX.4.61.0807030743230.10608@ginsburg.homenet>
	 <1215077028.10393.497.camel@pmac.infradead.org>
Content-Type: text/plain; charset=utf-8
Date: Thu, 03 Jul 2008 12:22:34 +0200
Message-Id: <1215080554.9721.62.camel@linux.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V01U2FsdGVkX1/UbQ1j3zjVQ7UWqx4TpqcqVPgvtUBRFaCiDia
 3MD2YKfdMMMHhc3skm+hEfVKxJEoaHwKV8++Qr3DbK32AfehLK
 4p7HpWoBoA0K7/jQ6AMRlQrvBtvlUS+
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-03 at 10:23 +0100, David Woodhouse wrote:
> On Thu, 2008-07-03 at 07:44 +0100, Tigran Aivazian wrote:
> > On Thu, 3 Jul 2008 Valdis.Kletnieks@vt.edu wrote:
> > 
> > > On Thu, 03 Jul 2008 07:17:16 BST, Tigran Aivazian said:
> > >> Hi Valdis,
> > >>
> > >> On Wed, 2 Jul 2008 Valdis.Kletnieks@vt.edu wrote:
> > >>
> > >>> I built the -rc8-mmotd kernel, and built it with 'CONFIG_FIRMWARE_IN_KERNEL
> > > =n'.
> > >>> Lo and behold, the microcode.ko was now doing a request_firmware for
> > >>> 'intel-ucode/06-0f-06' (which makes sense, the Core2 Duo in this laptop is
> > >>> family 6, model 15, stepping 6).  However, what I had in /lib/firmware was
> > >>> the Intel-distributed 'microcode.dat' with updates for all the CPUs (which
> > >>> used to work in times past).
> > >>>
> > >>> What's the magic incantation to take the microcode.dat and create something
> > >>> that the firmware driver is willing to use, or is this all borked up and
> > >>> I need to do a major rethink or fix my config?
> > >>
> > >> that's because it expects the Intel-supplied microcode data and you are
> > >> using the old style microcode.dat data.
> > >
> > > I fed it the stuff I downloaded today from this URL:
> > >
> > > http://downloadcenter.intel.com/filter_results.aspx?strTypes=all&ProductID=2643&OSFullName=Linux*〈=eng&strOSs=39&submit=Go!
> > >
> > > which gets me a microcode-20080401.dat that does the same thing.  Is there
> > > some *other* Intel-supplied microcode data I should be getting instead?
> > 
> > Oh, sorry, I assumed that Intel distribute the data in the format that 
> > driver expects.
> 
> I think the kernel _does_ manage to extract just the part it wants from
> the data, but it expects the data in binary form. Drop the attached
> files in /lib/udev/microcode.sh and /etc/udev/rules.d/51-microcode.rules
> respectively. (There's probably a better way to handle this kind of
> thing by putting hooks in firmware.sh rather than using a special rule
> which overrides it?)
> 
> The recent firmware changes haven't modified this. The important change
> seems to have been here (in 2006):
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=a30a6a2c

This commit states:
  "so we don't need the application 'microcode_ctl' to assist".
Seems the kernel code extracts the right section, in the all-in-one
file, for the actual CPU:
  while ((offset = get_next_ucode_from_buffer(&mc, buf, size, offset))

So, maybe a:
  # rewrite firmware file name to all-in-one Intel CPU microcode data file
  SUBSYSTEM=="firmware", ENV{FIRMWARE}=="intel-ucode/*", ENV{FIRMWARE}="intel-ucode/microcode.dat"
would be enough?

Thanks,
Kay

