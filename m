Return-Path: <linux-kernel-owner+w=401wt.eu-S1755942AbYKVDhS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942AbYKVDhS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 22:37:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbYKVDhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 22:37:04 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:59504 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944AbYKVDhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 22:37:03 -0500
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Zero-clearing all zero-clearable bytes.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <200811221236.FJE81778.LtMHOQFJFVFSOO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Sat, 22 Nov 2008 12:36:56 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I often create a Live CD.
When creating a Live CD, loopback mounted ext3 image files are used.
These image files are then compressed so that the ISO image will fit within
a CD-R's capacity (i.e. 700MB).

Compressing whole image files includes compressing deleted/unused bytes within
a block. This means that non-zero bytes in deleted/unused blocks affect
compression ratio.

I'm using the below program to improve compression ratio.

----------
#define _FILE_OFFSET_BITS 64
#define _LARGEFILE_SOURCE
#define _LARGEFILE64_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

int main(int argc, char *argv[]) {
    int fd;
    static char buffer[4096];
    memset(buffer, 0, sizeof(buffer));
    snprintf(buffer, sizeof(buffer) - 1, "%s/XXXXXX", argc > 1 ? argv[1] : "");
    if ((fd = mkstemp(buffer)) != EOF) {
        unlink(buffer);
        memset(buffer, 255, sizeof(buffer));
        while (write(fd, buffer, sizeof(buffer)) > 0);
        sync();
        close(fd);
    }
    return 0;
}
----------

But this program cannot clear some bytes within a block for file data (e.g.
offset from 1 to 511 of a data block used by a file with only 1 byte data)
and blocks for directory entries.

Any suggestions?

Regards.
