Return-Path: <linux-kernel-owner+w=401wt.eu-S1755211AbZLDKmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211AbZLDKmV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 05:42:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753854AbZLDKmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 05:42:20 -0500
Received: from mailgw3.ericsson.se ([193.180.251.60]:50846 "EHLO
	mailgw3.ericsson.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754139AbZLDKmT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 05:42:19 -0500
X-AuditID: c1b4fb3c-b7b08ae000000935-3a-4b18e7900087
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [POWER] battery calibration parameters from sysfs
Date: Fri, 4 Dec 2009 11:42:22 +0100
Message-ID: <A6D19A13FE030A409EC4362C172E091F0E0495F6@eseldmw101.eemea.ericsson.se>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [POWER] battery calibration parameters from sysfs
Thread-Index: Acp0znXnOmxIv2oXSTmM0iIHa/QHMA==
From: "Linus Walleij" <linus.walleij@stericsson.com>
To: <cbou@mai.ru>, <dwmw2@infradead.org>
Cc: "LKML" <linux-kernel@vger.kernel.org>, <linux-embedded@vger.kernel.org>
X-OriginalArrivalTime: 04 Dec 2009 10:42:24.0218 (UTC) FILETIME=[7701EBA0:01CA74CE]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

we're working on battery charging support for ST-Ericsson MFD ASICs
like AB3100 and later series. I have this issue about battery
calibration
parameters that I need advice on, and more specifically on how to use
sysfs to get that data in.

Most devices of this kind does not need the stuff we're doing so we're
the odd bird here. Other batteries are "smart" (contain factory
calibration inside of them) or get calibration from some BIOS or such.

In our code we have a number of (x,y) pair tables like this:

/* Vbat mV to Battery capacity % */
struct voltage_vs_capacity {
	int voltage;
	int capacity;
};

/*
 * Default calibration table for voltage vs battery capacity.
 * Voltage in millivolts, capacity given in permil.
 */
struct voltage_vs_capacity voltage_to_battery_capacity_init[] = {
	{ 4177, 1000 },
	{ 4070,  900 },
	{ 3988,  800 },
	{ 3834,  570 },
	{ 3797,  470 },
	{ 3768,  320 },
	{ 3721,  190 },
	{ 3633,   60 },
	{ 3523,   30 },
	{ 3200,    0 },
};

We then interpolate between two subsequent (xn,yn),(xn+1,yn+1)
pairs to get a calibrated capacity value from the voltage
level measured.

This is all good as long as you compile the calibration into the kernel
like this.

However we want to override the default table with one fed in
though e.g. sysfs, so calibration data for the battery can reside
in the file system. NOTE: this table is NOT of fixed length, i.e.
we don't know how many (x,y) pairs will be passed in.

Whereas the rule for sysfs is one value per file, creating an arbitrary
large hirarchy like this:

/sys/.../v_vs_cap/x0
/sys/.../v_vs_cap/y0
/sys/.../v_vs_cap/x1
/sys/.../v_vs_cap/y2
...
/sys/.../v_vs_cap/xN
/sys/.../v_vs_cap/yN

Is probably not very elegant. (Or is it?) Would it be permissible to
pass in a table like:

cat >/sys/.../v_vs_cap <<EOF
x0,y0
x1,y1
x2,y2
EOF

And have the kernel parse x,y pairs up to EOF?

Or would it be preferable to do this thing by creating some
misc device node like /dev/battery0 and a custom ioctl()?

Or is there some other way I haven't thought of?

Yours,
Linus Walleij
ST-Ericsson
