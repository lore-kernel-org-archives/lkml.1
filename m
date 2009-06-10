Return-Path: <linux-kernel-owner+w=401wt.eu-S1755882AbZFJEjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882AbZFJEjK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 00:39:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754230AbZFJEiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 00:38:52 -0400
Received: from wsip-70-184-212-11.om.om.cox.net ([70.184.212.11]:34164 "EHLO
	hachi.dashjr.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbZFJEiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 00:38:51 -0400
From: "Luke-Jr" <luke@dashjr.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: pty tcdrain() bug in 2.6.27 to 2.6.30/current
Date: Tue, 9 Jun 2009 23:38:31 -0500
User-Agent: KMail/1.11.3 (Linux/2.6.27-gentoo-r7; KDE/4.2.3; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906092338.42368.luke@dashjr.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tcdrain blocks on ptys since 2.6.27; at least 2.6.26 returns in a timely 
manner. The following test case reproduces the bug, and hangs only on affected 
kernels. Examination of 2.6.26 and 2.6.27 suggests the ioctl used by tcdrain 
underwent a rewrite for 2.6.27, and thus fixing this bug is beyond my 
capabilities at this time.

-------

#define _POSIX_C_SOURCE 200112L
#define _XOPEN_SOURCE

#include <assert.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>

int
main() {
	int masterfd, slavefd;
	char test[] = "test";
	
	masterfd = posix_openpt(O_RDWR | O_NOCTTY);
	assert(masterfd != -1);
	grantpt(masterfd);
	unlockpt(masterfd);
	
	slavefd = open(ptsname(masterfd), O_NOCTTY | O_RDWR);
	assert(slavefd != -1);
	
	assert(sizeof(test) == write(slavefd, test, sizeof(test)));
	assert(!tcdrain(slavefd));
}

