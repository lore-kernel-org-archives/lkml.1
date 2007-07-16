Return-Path: <linux-kernel-owner+w=401wt.eu-S1762374AbXGPN7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762374AbXGPN7S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 09:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759226AbXGPN7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 09:59:03 -0400
Received: from qb-out-0506.google.com ([72.14.204.230]:12010 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759132AbXGPN7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 09:59:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mail-followup-to:mime-version:content-type:content-disposition:user-agent;
        b=WQ9NYQ1SOWoxxAF2GlqIK7Zq+8eYexkFo9kBBC/NQwqVg9G9BrXBg1fHY93+7hDWsVNs3Soy+iHhJR0E1pdJaA1l5754AERS+biAYvKI+7s8X1AUaxPcXoJ4GwBDnygHAxuPhViisYpiJ1IHwakeiSneLciWLesPqDaiGkMWIlg=
Date: Mon, 16 Jul 2007 22:48:55 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, Greg Kroah-Hartman <gregkh@suse.de>,
       Dmitriy Zavin <dmitriyz@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <andi@firstfloor.org>, Ashok Raj <ashok.raj@intel.com>
Subject: [PATCH 0/10] CPU hotplug error handling fixes
Message-ID: <20070716134855.GA1858@APFDCB5C>
Mail-Followup-To: Akinobu Mita <akinobu.mita@gmail.com>,
	linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Dmitriy Zavin <dmitriyz@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
	Ashok Raj <ashok.raj@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches fixes the error handling for cpu hotplug.
The problem is revealed by CPU hotplug/unplug test with fault-injection.

The patch 1-3 are sysfs or driver core related error handling fixes.
These are not directly related to cpu hotplug. But these are needed to
pass the stress test.

The patch 4 changes the behavior when one of the callbacks in notifier
chain returns NOTIFY_BAD with CPU_UP_PREPARE event. This change makes
cpu hotplug error handling simple.

The patch 5 simplifies the cpu hotplug event handling in topology.c
by the patch 4.

The patch 6-10 are error handling fixes in cpu hotplug event callbacks.
These fixes also depend on the change by the patch 4.

Here is the test script I have confirmed with these patches.
I guess we still have the similar bugs that I could not test due to no
hardware. So it may be worth someone trying this script.

----------[ cut here ]----------

#!/bin/bash

FAILTYPE=failslab
CPU=1
CPU_ONLINE=/sys/devices/system/cpu/cpu${CPU}/online

faulty_system()
{
        bash -c "echo 1 > /proc/self/make-it-fail && exec $*"
}

[ "$UID" == 0 ] || exit 1
[ -n "$FAILTYPE" -a -f /debug/$FAILTYPE/probability ] || exit 1
[ -f $CPU_ONLINE ] || exit 1

echo N > /debug/$FAILTYPE/ignore-gfp-wait
echo Y > /debug/$FAILTYPE/task-filter
echo 1 > /debug/$FAILTYPE/probability
echo -1 > /debug/$FAILTYPE/times

while true
do
	faulty_system "echo 0 > $CPU_ONLINE"
	faulty_system "echo 1 > $CPU_ONLINE"
done

