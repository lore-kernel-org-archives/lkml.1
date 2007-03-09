Return-Path: <linux-kernel-owner+w=401wt.eu-S2992952AbXCIFB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992952AbXCIFB0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 00:01:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992970AbXCIFB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 00:01:26 -0500
Received: from yvrmail01.intrinsyc.com ([209.139.192.246]:51632 "EHLO
	yvrmail01.intrinsyc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992952AbXCIFBZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 00:01:25 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] Software Suspend: Fix suspend when console is in VT_AUTO/KD_GRAPHICS mode
Date: Thu, 8 Mar 2007 21:01:22 -0800
Message-ID: <DBC923D919FAB345973A94E6E194E8490438088E@yvrmail01.itc.intrinsyc.com>
In-Reply-To: <45F09E2E.4050309@gentoo.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] Software Suspend: Fix suspend when console is in VT_AUTO/KD_GRAPHICS mode
Thread-Index: Acdh2q8roJ9pW1xGSL6ZQ7FIGh1fAgALF0Xg
References: <1173394485.28589.17.camel@localhost.localdomain> <45F09E2E.4050309@gentoo.org>
From: "Andrew Johnson" <ajohnson@intrinsyc.com>
To: "Daniel Drake" <dsd@gentoo.org>
Cc: <pavel@suse.cz>, <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Drake wrote:
> Andrew Johnson wrote:
> > When the console is in VT_AUTO/KD_GRAPHICS mode, switching to the
> > SUSPEND_CONSOLE fails, resulting in vt_waitactive() waiting
indefinately
> > or until the task is interrupted.  The following patch tests if a
> > console switch can occur in set_console() and returns early if a
console
> > switch is not possible.
> >
> > Signed-off-by: Andrew Johnson <ajohnson@intrinsyc.com>
> >
> > diff -rup linux-2.6.20.1/drivers/char/vt.c linux/drivers/char/vt.c
> > --- linux-2.6.20.1/drivers/char/vt.c	2007-02-19
22:34:32.000000000 -
> 0800
> > +++ linux/drivers/char/vt.c	2007-03-08 14:15:41.000000000 -0800
> > @@ -2188,10 +2188,20 @@ static void console_callback(struct work
> >  	release_console_sem();
> >  }
> >
> > -void set_console(int nr)
> > +extern char vt_dont_switch;
> > +
> > +int set_console(int nr)
> >  {
> > +	struct vc_data *vc = vc_cons[fg_console].d;
> > +
> > +	if(!vc_cons_allocated(nr) || vt_dont_switch || vc->vc_mode ==
> > KD_GRAPHICS) {
> > +		return -EINVAL;
> > +	}
> > +
> >  	want_console = nr;
> >  	schedule_console_callback();
> > +
> > +	return 0;
> >  }
> 
> I haven't tested, but I think the above -EINVAL return will break
chvt.
> chvt uses the VT_ACTIVATE ioctl which calls set_console(), and it is
> valid for chvt to be used to change away from a graphics-mode console
--
> that shouldn't be an error condition.

Currently the VT_ACTIVATE ioctl will eventually result in a call to
change_console() which will ignore the change if the console is in
KD_GRAPHICS+VT_AUTO mode.  Thus, chvt should fail.  However, the return
code from set_console() is ignored in vt_ioctl so no error code will
result (which is the same as current behavior).

-- Andrew
