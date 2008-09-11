Return-Path: <linux-kernel-owner+w=401wt.eu-S1756085AbYIKQDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085AbYIKQDY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 12:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753322AbYIKQDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 12:03:16 -0400
Received: from av7-2-sn3.vrr.skanova.net ([81.228.9.182]:57655 "EHLO
	av7-2-sn3.vrr.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220AbYIKQDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 12:03:15 -0400
X-Greylist: delayed 1713 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Sep 2008 12:03:15 EDT
Subject: udp bind() fails with EACCESS when selinux enforcing, but no audit
	messages
From: Enrique Perez-Terron <enrio@online.no>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Thu, 11 Sep 2008 17:34:40 +0200
Message-Id: <1221147280.16999.45.camel@alabast.home.lan>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fedora core 9 stock kernel 2.6.25.108 i586

Udp bind() fails with EACCESS when selinux enforcing, but no audit
messages.

How to reproduce:

In startup scripts, configure rpc.statd to use the fixed port 34.
This port does not occur in /etc/services
(In /etc/sysconfig/nfs, STATD_PORT=34)

Write the following script, run it with bash -x.

#!/bin/bash

TESTDIR=/var/tmp/se-bind-test-$$
mkdir $TESTDIR  # to hold about 50 files
cd $TESTDIR

# Stop NFS:
service nfs stop
service nfslock stop

# Gather some baseline data for easy comparison
echo 1 /selinux/enforce  # just in case
dmesg                       > dmesg-enforc-before
wc /var/log/audit/audit.log > audit-enforc-before

# This fails
strace -o enforc -ff service nfslock start

# But no new messages in logs
dmesg                       > dmesg-enforc-after
wc /var/log/audit/audit.log > audit-enforc-after

# Try again in permissive mode
echo 0 /selinux/enforce
dmesg                       > dmesg-nonenf-before
wc /var/log/audit/audit.log > audit-nonenf-before

# Since this works, daemon starts, and strace hangs on
# Need sigkill; sigint does not work. Why?
(sleep 5; killall -9 strace) &
strace -o nonenf -ff service nfslock start

# Just for symmetry
dmesg                       > dmesg-nonenf-after
wc /var/log/audit/audit.log > audit-nonenf-after

# Check that there are no audits.
diff dmesg-enforc-before dmesg-enforc-after
diff audit-enforc-before audit-enforc-after

# There are several other calls to bind() that are not prevented
grep -E '^bind|^socket' enforc.*
grep -E '^bind|^socket' nonenf.*

Regards

