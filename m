Return-Path: <linux-kernel-owner+w=401wt.eu-S1758441AbYEMMVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758441AbYEMMVX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 08:21:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754619AbYEMMVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 08:21:14 -0400
Received: from ns.miraclelinux.com ([219.118.163.66]:50273 "EHLO
	mail.miraclelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbYEMMVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 08:21:14 -0400
X-Greylist: delayed 1724 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 May 2008 08:21:13 EDT
Message-ID: <48297FD0.2090905@miraclelinux.com>
Date: Tue, 13 May 2008 20:47:28 +0900
From: Hirofumi Nakagawa <hnakagawa@miraclelinux.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org
Subject: [RFC][PATCH 0/1] MAZE: Mazed processes monitor
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-PMX-Version: 5.3.1.294258, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2008.5.13.43212
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all.

This patch provides the mazed process monitor,named MAZE.
MAZE's purpose is to notify or terminate registered processes when they are mazed.
The definition of mazed process is a process using excessive CPU cycles,
that is long time keeping TASK_RUNNING state.
MAZE detects mazed processes and sends specified signals to them.
This implements a CGL (Carrier Grade Linux) requirement (AVL.14.0).

Possible uses:
* High-Availability system
* system using many Real-Time processes such as embedded

Please any comments!

Hirofumi Nakagawa

--- Usage
Add monitoring process.

% echo "1234 10000 20000 24 9" > /proc/maze/entries

The numeric values are "pid","soft limit [msec]","hard limit [msec]",
"soft signal" and "hard signal".


Get monitoring process list.

% cat /proc/maze/entries

--- Example
As follows example express the feature of MAZE function.

--
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
    int state,i;
    char cmd[128];

    sprintf(cmd, "echo \"%d 10000 20000 24 9\" > /proc/maze/entries", getpid());
    system(cmd);

    if (!fork()) {
        printf("Mazed process start.\n");
        for(;;);
    }

    if (!fork()) {
        printf("Not mazed process start.\n");
        for(i = 0;i < 20; i++)
            sleep(1);
        printf("Not mazed process finish.\n");
        exit(0);
    }

    for (i = 0;i < 2; i++)
         wait(&state);

    return 0;
}
--
---





