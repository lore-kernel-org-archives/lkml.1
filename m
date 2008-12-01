Return-Path: <linux-kernel-owner+w=401wt.eu-S1751322AbYLAFyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751322AbYLAFyR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 00:54:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750740AbYLAFyD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 00:54:03 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48494 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750714AbYLAFyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 00:54:01 -0500
Date: Sun, 30 Nov 2008 21:53:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, Rodolfo Giometti <giometti@linux.it>
Subject: Re: mmotm 2008-11-26-17-00 uploaded (hwmon / dev_attr_name)
Message-Id: <20081130215350.b63ed292.akpm@linux-foundation.org>
In-Reply-To: <49317AF9.5030409@oracle.com>
References: <200811270101.mAR114rp016378@imap1.linux-foundation.org>
	<4930CCA9.9070505@oracle.com>
	<20081128220659.2d5049e6.akpm@linux-foundation.org>
	<49317AF9.5030409@oracle.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Nov 2008 09:25:13 -0800 Randy Dunlap <randy.dunlap@oracle.com> wrote:

> Andrew Morton wrote:
> > On Fri, 28 Nov 2008 21:01:29 -0800 Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > 
> >> akpm@linux-foundation.org wrote:
> >>> The mm-of-the-moment snapshot 2008-11-26-17-00 has been uploaded to
> >>>
> >>>    http://userweb.kernel.org/~akpm/mmotm/
> >>
> >> I'm getting lots of these build errors:
> >>
> >> drivers/hwmon/built-in.o:(.data+0x7c70): multiple definition of `dev_attr_name'
> > 
> > -ENOREPRODUCE.  What config?
> 
> Could be some kind of tools issue, I suppose.
> 
> config attached.

OK, it was a couple of instances of

DEVICE_ATTR(name, ...)

(in hwmon and pps) which both emitted a global symbol dev_attr_name, so
the linker got upset.

This happens a lot.  Because it's a pukey macro, people don't realise
that it's declaring storage and they don't think to make it static.  It
would be good to do a tree-wide grep for non-static DEVICE_ATTRs and
fix them up where possible.


Rodolfo, I fixed pps this way:


diff -puN drivers/pps/sysfs.c~a drivers/pps/sysfs.c
--- a/drivers/pps/sysfs.c~a
+++ a/drivers/pps/sysfs.c
@@ -41,7 +41,7 @@ static ssize_t pps_show_assert(struct de
 			(long long) pps->assert_tu.sec, pps->assert_tu.nsec,
 			pps->assert_sequence);
 }
-DEVICE_ATTR(assert, S_IRUGO, pps_show_assert, NULL);
+static DEVICE_ATTR(assert, S_IRUGO, pps_show_assert, NULL);
 
 static ssize_t pps_show_clear(struct device *dev,
 				struct device_attribute *attr, char *buf)
@@ -55,7 +55,7 @@ static ssize_t pps_show_clear(struct dev
 			(long long) pps->clear_tu.sec, pps->clear_tu.nsec,
 			pps->clear_sequence);
 }
-DEVICE_ATTR(clear, S_IRUGO, pps_show_clear, NULL);
+static DEVICE_ATTR(clear, S_IRUGO, pps_show_clear, NULL);
 
 static ssize_t pps_show_mode(struct device *dev,
 				struct device_attribute *attr, char *buf)
@@ -64,7 +64,7 @@ static ssize_t pps_show_mode(struct devi
 
 	return sprintf(buf, "%4x\n", pps->info.mode);
 }
-DEVICE_ATTR(mode, S_IRUGO, pps_show_mode, NULL);
+static DEVICE_ATTR(mode, S_IRUGO, pps_show_mode, NULL);
 
 static ssize_t pps_show_echo(struct device *dev,
 				struct device_attribute *attr, char *buf)
@@ -73,7 +73,7 @@ static ssize_t pps_show_echo(struct devi
 
 	return sprintf(buf, "%d\n", !!pps->info.echo);
 }
-DEVICE_ATTR(echo, S_IRUGO, pps_show_echo, NULL);
+static DEVICE_ATTR(echo, S_IRUGO, pps_show_echo, NULL);
 
 static ssize_t pps_show_name(struct device *dev,
 				struct device_attribute *attr, char *buf)
@@ -82,7 +82,7 @@ static ssize_t pps_show_name(struct devi
 
 	return sprintf(buf, "%s\n", pps->info.name);
 }
-DEVICE_ATTR(name, S_IRUGO, pps_show_name, NULL);
+static DEVICE_ATTR(name, S_IRUGO, pps_show_name, NULL);
 
 static ssize_t pps_show_path(struct device *dev,
 				struct device_attribute *attr, char *buf)
@@ -91,7 +91,7 @@ static ssize_t pps_show_path(struct devi
 
 	return sprintf(buf, "%s\n", pps->info.path);
 }
-DEVICE_ATTR(path, S_IRUGO, pps_show_path, NULL);
+static DEVICE_ATTR(path, S_IRUGO, pps_show_path, NULL);
 
 struct device_attribute pps_attrs[] = {
 	__ATTR(assert, S_IRUGO, pps_show_assert, NULL),
_

and the x86_64 build got noisier:

drivers/pps/sysfs.c:44: warning: 'dev_attr_assert' defined but not used
drivers/pps/sysfs.c:58: warning: 'dev_attr_clear' defined but not used
drivers/pps/sysfs.c:67: warning: 'dev_attr_mode' defined but not used
drivers/pps/sysfs.c:76: warning: 'dev_attr_echo' defined but not used
drivers/pps/sysfs.c:85: warning: 'dev_attr_name' defined but not used
drivers/pps/sysfs.c:94: warning: 'dev_attr_path' defined but not used
drivers/pps/clients/pps-ldisc.c: In function 'pps_tty_dcd_change':
drivers/pps/clients/pps-ldisc.c:32: warning: cast from pointer to integer of different size
drivers/pps/clients/pps-ldisc.c: In function 'pps_tty_open':
drivers/pps/clients/pps-ldisc.c:77: warning: cast to pointer from integer of different size
drivers/pps/clients/pps-ldisc.c:82: warning: cast from pointer to integer of different size
drivers/pps/clients/pps-ldisc.c: In function 'pps_tty_close':
drivers/pps/clients/pps-ldisc.c:91: warning: cast from pointer to integer of different size


For the ->disc_data warnings you could perhaps just make all the
relevant scalar types `long', not `int'.

