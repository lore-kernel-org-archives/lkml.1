Return-Path: <linux-kernel-owner+w=401wt.eu-S1757119AbZJPDle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757119AbZJPDle (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 23:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755039AbZJPDld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 23:41:33 -0400
Received: from aglcosbs04.cos.agilent.com ([192.25.218.38]:44690 "EHLO
	aglcosbs04.cos.agilent.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752865AbZJPDlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 23:41:32 -0400
Message-ID: <4AD7EB0E.7000309@agilent.com>
Date: Thu, 15 Oct 2009 20:39:58 -0700
From: Earl Chew <earl_chew@agilent.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
CC: linux-kernel@vger.kernel.org
Subject: Re: fs/pipe.c null pointer dereference
References: <4AD5D476.6010103@agilent.com> <200910141653.03611.elendil@planet.nl> <4AD655C0.2030202@agilent.com> <4AD7E928.9000701@agilent.com>
In-Reply-To: <4AD7E928.9000701@agilent.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Oct 2009 03:40:01.0658 (UTC) FILETIME=[576C65A0:01CA4E12]
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Earl Chew wrote:
> Is this possible via /proc/pid/fd/* ?

The window for failure is small. It's easiest to reproduce
this problem by stalling pipe_rdwr_open() to open up the
window:

--- pipe.c.orig 2009-10-15 20:33:53.000000000 -0700
+++ pipe.c      2009-10-15 20:17:40.000000000 -0700
@@ -736,2 +736,3 @@
  {
+       msleep(100);
         mutex_lock(&inode->i_mutex);


With the failure window widened, it's easy to reproduce
the failure with:

--------------------------------------------------------------
#!/bin/sh

while : ; do
   { echo y ; sleep 1 ; } | { while read ; do echo z$REPLY; done ; } &
   PID=$!
   OUT=$(ps -efl | grep 'sleep 1' | grep -v grep |
        { read PID REST ; echo $PID; } )
   OUT="${OUT%% *}"
   DELAY=$((RANDOM * 1000 / 32768))
   usleep $((DELAY * 1000 + RANDOM % 1000 ))
   echo n > /proc/$OUT/fd/1
done
--------------------------------------------------------------


