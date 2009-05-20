Return-Path: <linux-kernel-owner+w=401wt.eu-S1756235AbZETKOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235AbZETKOn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 06:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754184AbZETKOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 06:14:36 -0400
Received: from web32602.mail.mud.yahoo.com ([68.142.207.229]:22660 "HELO
	web32602.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754070AbZETKOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 06:14:35 -0400
Message-ID: <480189.30937.qm@web32602.mail.mud.yahoo.com>
X-YMail-OSG: VxKwMsUVM1n_y16TGLhESsl4G3OxLrICKAHFJoWnRmNoIWZGTkVsAgiQlqoGYzxPyp10tHdWPLVjvfwAiwRtBua6G1WZS6b0zGHY5L6Z.jLqT4w7EV33FUZCXjMye_fcnbqp5MXapkxnnItl3TRO27oxHIkKMeP8wDJSKz_0oWWZxBR319uVkGItRQSkMa8atW419uViAPM1RRHOKcDPc33oQO.cfICPR9oNH4sJkes.FVzdJLAMQ3eiDqUDaI6JD.ucyGZ37fLUa6_4SspZmJlisv6NqtXXU2ygEBKb6V1Bxume1JaZliff5aARNcQlDXKLTF2XZFvxkZpHlUo-
X-RocketYMMF: knobi.rm
X-Mailer: YahooMailRC/1277.43 YahooMailWebService/0.7.289.10
References: <yO1BmxN79sN.A.xAG.8_zDKB@chimera> <pQ9WADCjgyE.A.scG.LA0DKB@chimera>  <424718.52835.qm@web32607.mail.mud.yahoo.com> <ac3eb2510905181726q3b996b8ei9c6a74fe1d3bb17d@mail.gmail.com>  <783496.86803.qm@web32608.mail.mud.yahoo.com> <ac3eb2510905190158o6682f7aat62ff66ac9aaa2a74@mail.gmail.com>
Date: Wed, 20 May 2009 03:14:36 -0700 (PDT)
From: Martin Knoblauch <spamtrap@knobisoft.de>
Subject: Re: [Bug #13178] Booting very slow
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
In-Reply-To: <ac3eb2510905190158o6682f7aat62ff66ac9aaa2a74@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




 ------------------------------------------------------
Martin Knoblauch
email: k n o b i AT knobisoft DOT de
www:   http://www.knobisoft.de



----- Original Message ----
> From: Kay Sievers <kay.sievers@vrfy.org>
> To: Martin Knoblauch <spamtrap@knobisoft.de>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>; Linux Kernel Mailing List <linux-kernel@vger.kernel.org>; Kernel Testers List <kernel-testers@vger.kernel.org>
> Sent: Tuesday, May 19, 2009 10:58:24 AM
> Subject: Re: [Bug #13178] Booting very slow
> 
> On Tue, May 19, 2009 at 09:22, Martin Knoblauch wrote:
> >> >  The issue is still open. It turns out that starting with 2.6.29-rc1
> >> /proc/mounts already has a "sysfs" line when entering the startup scripts 
> from
> >> initrd. This breaks the RHEL4 firmware hotplug script.
> >>
> >> Is that possibly a missing/failing "umount /sys" _in_ initramfs, which
> >> leaves the sysfs entry in /proc/mounts behind, which then shows up as
> >> a duplicate when running in the real rootfs?
> >
> >  could be. Remains the question, why it never showed up before 2.6.29. I 
> compared my initrd images for 2.6.28 and 2.6.29-rc1, and they only differ in the 
> module-binaries.
> 
> I wouldn't be surprised if we are just "too fast" again now with the
> async stuff, for another piece of rather fragile userspace bootup
> logic, making some wrong assumptions. Are you compiling-in the modules
> for the root disk and the root filesystem?
> 
> Cheers,
> Kay

 timing may actually be the answer. I finally manged to bisect the thing and the first bad commit is this one:

|commit 1120f8b8169fb2cb51219d326892d963e762edb6
|Author: Stephen Hemminger <shemminger@vyatta.com>
|Date:   Thu Dec 18 09:17:16 2008 -0800
|
|    PCI: handle long delays in VPD access
|
|    Accessing the VPD area can take a long time.  The existing
|    VPD access code fails consistently on my hardware. There are comments
|
|    Change the access routines to:
|      * use a mutex rather than spinning with IRQ's disabled and lock held
|      * have a much longer timeout
|      * call cond_resched while spinning
|
|    Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
|    Reviewed-by: Matthew Wilcox <willy@linux.intel.com>
|    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>

  And no, the "cciss", "ext3" and "jbd" are modules in my intrd image.

 I will continue the discussion under the original topic.

Cheers
