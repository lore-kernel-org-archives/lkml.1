Return-Path: <linux-kernel-owner+w=401wt.eu-S1752783AbYLAN5H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbYLAN5H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 08:57:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbYLAN4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 08:56:55 -0500
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:36190 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbYLAN4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 08:56:54 -0500
Date: Mon, 1 Dec 2008 14:56:34 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Message-ID: <20081201135634.GC6932@gundam.enneenne.com>
References: <200811270101.mAR114rp016378@imap1.linux-foundation.org> <4930CCA9.9070505@oracle.com> <20081128220659.2d5049e6.akpm@linux-foundation.org> <49317AF9.5030409@oracle.com> <20081130215350.b63ed292.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081130215350.b63ed292.akpm@linux-foundation.org>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SA-Exim-Connect-IP: 192.168.32.254
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: mmotm 2008-11-26-17-00 uploaded (hwmon / dev_attr_name)
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 30, 2008 at 09:53:50PM -0800, Andrew Morton wrote:
> On Sat, 29 Nov 2008 09:25:13 -0800 Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
> > Andrew Morton wrote:
> > > On Fri, 28 Nov 2008 21:01:29 -0800 Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > > 
> > >> akpm@linux-foundation.org wrote:
> > >>> The mm-of-the-moment snapshot 2008-11-26-17-00 has been uploaded to
> > >>>
> > >>>    http://userweb.kernel.org/~akpm/mmotm/
> > >>
> > >> I'm getting lots of these build errors:
> > >>
> > >> drivers/hwmon/built-in.o:(.data+0x7c70): multiple definition of `dev_attr_name'
> > > 
> > > -ENOREPRODUCE.  What config?
> > 
> > Could be some kind of tools issue, I suppose.
> > 
> > config attached.
> 
> OK, it was a couple of instances of
> 
> DEVICE_ATTR(name, ...)
> 
> (in hwmon and pps) which both emitted a global symbol dev_attr_name, so
> the linker got upset.
> 
> This happens a lot.  Because it's a pukey macro, people don't realise
> that it's declaring storage and they don't think to make it static.  It
> would be good to do a tree-wide grep for non-static DEVICE_ATTRs and
> fix them up where possible.
> 
> 
> Rodolfo, I fixed pps this way:

This is not correct, the right patch is:

diff --git a/drivers/pps/sysfs.c b/drivers/pps/sysfs.c
index 99528a8..7c2b0c4 100644
--- a/drivers/pps/sysfs.c
+++ b/drivers/pps/sysfs.c
@@ -41,7 +41,6 @@ static ssize_t pps_show_assert(struct device *dev,
                        (long long) pps->assert_tu.sec,
			pps->assert_tu.nsec,
                        pps->assert_sequence);
 }
-DEVICE_ATTR(assert, S_IRUGO, pps_show_assert, NULL);
 
 static ssize_t pps_show_clear(struct device *dev,
                                struct device_attribute *attr, char
				*buf)
@@ -55,7 +54,6 @@ static ssize_t pps_show_clear(struct device *dev,
                        (long long) pps->clear_tu.sec,
			pps->clear_tu.nsec,
                        pps->clear_sequence);
 }
-DEVICE_ATTR(clear, S_IRUGO, pps_show_clear, NULL);
 
 static ssize_t pps_show_mode(struct device *dev,
                                struct device_attribute *attr, char
				*buf)
@@ -64,7 +62,6 @@ static ssize_t pps_show_mode(struct device *dev,
 
        return sprintf(buf, "%4x\n", pps->info.mode);
 }
-DEVICE_ATTR(mode, S_IRUGO, pps_show_mode, NULL);
 
 static ssize_t pps_show_echo(struct device *dev,
                                struct device_attribute *attr, char
				*buf)
@@ -73,7 +70,6 @@ static ssize_t pps_show_echo(struct device *dev,
 
        return sprintf(buf, "%d\n", !!pps->info.echo);
 }
-DEVICE_ATTR(echo, S_IRUGO, pps_show_echo, NULL);
 
 static ssize_t pps_show_name(struct device *dev,
                                struct device_attribute *attr, char
				*buf)
@@ -82,7 +78,6 @@ static ssize_t pps_show_name(struct device *dev,
 
        return sprintf(buf, "%s\n", pps->info.name);
 }
-DEVICE_ATTR(name, S_IRUGO, pps_show_name, NULL);
 
 static ssize_t pps_show_path(struct device *dev,
                                struct device_attribute *attr, char
				*buf)
@@ -91,7 +86,6 @@ static ssize_t pps_show_path(struct device *dev,
 
        return sprintf(buf, "%s\n", pps->info.path);
 }
-DEVICE_ATTR(path, S_IRUGO, pps_show_path, NULL);
 
 struct device_attribute pps_attrs[] = {
        __ATTR(assert, S_IRUGO, pps_show_assert, NULL),

We can just remove the DEVICE_ATTR(name, ...) since all the variables
are into pps_attrs[].

Please, let me know if you wish a proper patch for this or you can do
it by yourself.

> and the x86_64 build got noisier:
> 
> drivers/pps/sysfs.c:44: warning: 'dev_attr_assert' defined but not used
> drivers/pps/sysfs.c:58: warning: 'dev_attr_clear' defined but not used
> drivers/pps/sysfs.c:67: warning: 'dev_attr_mode' defined but not used
> drivers/pps/sysfs.c:76: warning: 'dev_attr_echo' defined but not used
> drivers/pps/sysfs.c:85: warning: 'dev_attr_name' defined but not used
> drivers/pps/sysfs.c:94: warning: 'dev_attr_path' defined but not used

This will be fixed by the above patch.

> drivers/pps/clients/pps-ldisc.c: In function 'pps_tty_dcd_change':
> drivers/pps/clients/pps-ldisc.c:32: warning: cast from pointer to integer of different size
> drivers/pps/clients/pps-ldisc.c: In function 'pps_tty_open':
> drivers/pps/clients/pps-ldisc.c:77: warning: cast to pointer from integer of different size
> drivers/pps/clients/pps-ldisc.c:82: warning: cast from pointer to integer of different size
> drivers/pps/clients/pps-ldisc.c: In function 'pps_tty_close':
> drivers/pps/clients/pps-ldisc.c:91: warning: cast from pointer to integer of different size
> 
> 
> For the ->disc_data warnings you could perhaps just make all the
> relevant scalar types `long', not `int'.

But doing like this will breaks 32bit archs... =:-o

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
