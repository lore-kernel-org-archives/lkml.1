Return-Path: <linux-kernel-owner+w=401wt.eu-S1765082AbYBUJuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765082AbYBUJuc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 04:50:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753695AbYBUJuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 04:50:22 -0500
Received: from mga07.intel.com ([143.182.124.22]:12306 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752556AbYBUJuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 04:50:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,385,1199692800"; 
   d="scan'208";a="381813776"
Message-ID: <2422.172.16.116.56.1203587019.squirrel@linux.intel.com>
Date: Thu, 21 Feb 2008 01:43:39 -0800 (PST)
Subject: From 2.6.24 to 2.6.25-rc2,
      CPU can not do hotplug when one task set affinity to it
From: youquan_song@linux.intel.com
To: linux-kernel@vger.kernel.org
Cc: youquan.song@intel.com
User-Agent: SquirrelMail/1.4.8-4.0.1.el4.centos
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In SMP sever platform, with kernel 2.6.24-rc2 and kernel 2.6.25-rc2,
Set one task affinity to one CPU core, then set offline the CPU core.
After that we can not set online the CPU core again.


1.  run the test.sh script:   test.sh 1  ( 1 is the logical CPU )
test.sh script:

#!/bin/bash

main(){

    typeset -i CPU=$1
    ./task.sh > /dev/null&
    PID=$!

    if [ `cat /sys/devices/system/cpu/cpu${CPU}/online` = "0" ]; then
        echo "1" > /sys/devices/system/cpu/cpu${CPU}/online
    fi

    MASK=$((1<<${CPU}))

    `taskset -p ${MASK} ${PID} > /dev/null 2>&1`

    echo "0" > /sys/devices/system/cpu/cpu${CPU}/online

    echo "1" > /sys/devices/system/cpu/cpu${CPU}/online

    kill -9 $PID > /dev/null 2>&1

    echo "PASS\n"

}

typeset -i TEST_CPU=$1
main $TEST_CPU

2. task.sh script as following

#!/bin/bash

while :
do
  NOOP=1
done

Actual Result:
The test.sh will block at set online the CPU ( echo "1" >
/sys/devices/system/cpu/cpu${CPU}/online ).

we check the test.sh has dead by 'ps -aux'.

