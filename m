Return-Path: <linux-kernel-owner+w=401wt.eu-S1753432Ab0AHCy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432Ab0AHCy2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 21:54:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753318Ab0AHCy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 21:54:27 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:58830 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939Ab0AHCy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 21:54:27 -0500
Message-Id: <201001080254.o082sOXB018423@www262.sakura.ne.jp>
Subject: [2.6.30 and later] file corruption on ext3 filesystem.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Fri, 08 Jan 2010 11:54:24 +0900
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 08012010 #3087878, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I'm experiencing file corruption problem.
Can somebody reproduce below result?

My environment:
  VMware Workstation 6.5.3 with 2CPUs / 512MB RAM.
  ext3 filesystem ( /dev/sda1 ) mounted on / .

  2.6.33-rc3 ( http://I-love.SAKURA.ne.jp/tmp/config-2.6.33-rc3-ext3 )
  2.6.32.3   ( http://I-love.SAKURA.ne.jp/tmp/config-2.6.32.3-ext3 )
  2.6.31.11  ( http://I-love.SAKURA.ne.jp/tmp/config-2.6.31.11-ext3 )
  2.6.30.10

  So far, I haven't succeeded to reproduce this problem for 2.6.29 and earlier.
  Maybe this problem exists in only 2.6.30 and later.

Steps to reproduce:

  Compile below program using "gcc -Wall -O3 -o a.out".

----------
#include <stdio.h>
#include <string.h>
#include <unistd.h>

int main(int argc, char *argv[])
{
	FILE *fp = fopen("/testfile", "a");
	char buffer[4096];
	memset(buffer, argc > 1 ? argv[1][0] : 0x20, sizeof(buffer));
	buffer[sizeof(buffer) - 1] = '\n';
	fwrite(buffer, 1, sizeof(buffer), fp);
	fflush(fp);
	sleep(5);
	fprintf(stderr, "Let power fail after a few seconds.\n");
	while (1) {
		sleep(1);
		fwrite(buffer, 1, sizeof(buffer), fp);
	}
	return 0;
}
----------

  Reboot the system by executing /sbin/reboot .

  Run ./a.out and let the power fail (i.e. unplug the electric cable
  or do equivalent) after more than 5 seconds (i.e. longer than kjournald's
  commit interval). Probably 2 or 3 seconds after
  "Let power fail after a few seconds.\n" was printed is the best.

  Restart the system (and fsck will be executed).

  Run "cat /testfile". It should contain only lines of 4095 spaces + '\n'
  (or the byte specified via argv[]). But it contains different data.

  This problem does not show up if the data written by ./a.out and the data in
  previously deleted files are identical. Therefore, you may want to try with
  different patterns like "./a.out 1" "./a.out 2" "./a.out 3" ...

Regards.
